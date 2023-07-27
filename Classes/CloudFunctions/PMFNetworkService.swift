//
//  PMFNetworkService.swift
//  pmf-engine-swift
//
//  Created by Nataliia Kozlovska on 26.07.2023.
//

import Foundation

// MARK: - PMFNetworkProtocol

protocol PMFNetworkProtocol {
  func trackEvent(accountId: String, userId: String, eventName: String)
}

// MARK: - PMFNetworkService

final class PMFNetworkService: BaseNetworkService, PMFNetworkProtocol {
  
  enum APIConfig {
    static let baseUrl = "https://us-central1-pmf-engine.cloudfunctions.net"
  }

  struct EventData: Codable {
    let userId: String
    let accountId: String
    let eventName: String
  }

  func trackEvent(accountId: String, userId: String, eventName: String) {
    let eventData = EventData(userId: userId, accountId: accountId, eventName: eventName)

    guard let url = URL(string: "\(APIConfig.baseUrl)/eventRecord") else {
      print("Invalid URL")
      return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    do {
      request.httpBody = try JSONEncoder().encode(["data": eventData])
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")

      dataRequest(urlRequest: request) { result in
        switch result {
        case .success:
          print("Success")
        case .failure(let error):
          print("Failure: \(error)")
        }
      }
    } catch {
      print("Error encoding data: \(error)")
    }
  }
}
