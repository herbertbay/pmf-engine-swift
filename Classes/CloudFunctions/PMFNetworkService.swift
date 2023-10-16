//
//  PMFNetworkService.swift
//  pmf-engine-swift
//
//  Created by Nataliia Kozlovska on 26.07.2023.
//

import Foundation

// MARK: - PMFNetworkProtocol

internal protocol PMFNetworkProtocol {
  func trackEvent(accountId: String, userId: String, eventName: String)
  func getFormActions(forceShow: Bool, accountId: String, userId: String, for eventName: String?, completion: @escaping PMFNetworkService.CommandsResponseAction)
  func trackFormShowing(accountId: String, userId: String)
}

// MARK: - PMFNetworkService

final class PMFNetworkService: BaseNetworkService, PMFNetworkProtocol {
  
  enum APIConfig {
    static let baseUrl = URL(string: "https://us-central1-pmf-engine.cloudfunctions.net")!
  }

  // MARK: - HTTP Methods

  enum HTTPMethod: String {
    case POST
  }

  // MARK: - API Paths

  enum APIPath: String {
    case eventRecord = "/eventRecord"
    case userGetCommand = "/userGetCommand"
  }

  // MARK: - EventData

  struct EventData: Codable {
    let userId: String
    let accountId: String
    let eventName: String?
  }

  // MARK: - UserData

  struct UserData: Codable {
    let userId: String
    let accountId: String
    let userAgent: String
    let forceShow: Bool
    let eventName: String?
  }

  // MARK: - CommandResponse

  struct CommandResponse: Codable {
    let result: CommandResponseResult
  }

  // MARK: - CommandResponseResult

  struct CommandResponseResult: Codable {
    let success: Bool
    let commands: [CommandEntity]?
  }

  // MARK: - ComandEntity

  struct CommandEntity: Codable {
    let type: String
    let url: String
  }

  typealias CommandsResponseAction = ([CommandEntity]?) -> Void

  func trackEvent(accountId: String, userId: String, eventName: String) {
    struct Response: Codable {
      let result: Result
    }

    struct Result: Codable {
      let success: Bool
    }

    let eventData = EventData(userId: userId, accountId: accountId, eventName: eventName)

    guard let request = try? configureRequest(with: .eventRecord, body: eventData) else { return }

    dataRequest(urlRequest: request) { result in
      switch result {
      case .success(let data):
        guard let response = try? JSONDecoder().decode(Response.self, from: data), response.result.success else {
          return
        }
        print("[pmf-engine-swift]: Successfully tracked event\(eventName.isEmpty ? "" : ": " + eventName)")
      case .failure(let error):
        print("[pmf-engine-swift]: Failure in tracking event: \(error)")
      }
    }
  }

  func getFormActions(forceShow: Bool, accountId: String, userId: String, for eventName: String?, completion: @escaping CommandsResponseAction) {
    let userData = UserData(userId: userId, accountId: accountId, userAgent: "ios", forceShow: forceShow, eventName: eventName)

    guard let request = try? configureRequest(with: .userGetCommand, body: userData) else {
      completion(nil)
      return
    }

    dataRequest(urlRequest: request) { result in
      switch result {
      case .success(let data):
        guard let response = try? JSONDecoder().decode(CommandResponse.self, from: data), response.result.success else {
          return
        }
        completion(response.result.commands)
      case .failure:
        completion(nil)
      }
    }
  }

  func trackFormShowing(accountId: String, userId: String) {
    trackEvent(accountId: accountId, userId: userId, eventName: "feedback-form-shown")
  }

  private func configureRequest<T: Encodable>(with endpoint: APIPath, body: T) throws -> URLRequest {
    var request = URLRequest(url: APIConfig.baseUrl.appendingPathComponent(endpoint.rawValue))
    request.httpMethod = HTTPMethod.POST.rawValue
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try JSONEncoder().encode(["data": body])
    return request
  }
}
