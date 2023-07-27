//
//  BaseNetworkService.swift
//  pmf-engine-swift
//
//  Created by Nataliia Kozlovska on 26.07.2023.
//

import Foundation

// MARK: - NetworkError

enum NetworkError: LocalizedError {
  case invalidRequest
  case empty
  case networkError(Error)
  case error(status: Int, data: Data?)
}

// MARK: - onMainThread Function

func onMainThread(after: Double = 0.0, completion: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + after) {
        completion()
    }
}

// MARK: - Type Aliases

typealias EmptyNetworkCompletion = (Result<Bool, NetworkError>) -> Void
typealias DataNetworkCompletion = (Result<Data, NetworkError>) -> Void
typealias StringNetworkCompletion = (Result<String, NetworkError>) -> Void
typealias ArrayOfStringNetworkCompletion = (Result<[String], NetworkError>) -> Void

// MARK: - NetworkRequestsManagable

protocol NetworkRequestsManagable {
  @discardableResult
  func dataRequest(
    urlRequest request: URLRequest,
    completion: @escaping DataNetworkCompletion
  ) -> URLSessionDataTask
}

// MARK: - BaseNetworkService

class BaseNetworkService: NetworkRequestsManagable {
  lazy var configuration: URLSessionConfiguration = {
    let config = URLSessionConfiguration.default
    return config
  }()

  private lazy var session: URLSession = {
    let session = URLSession(configuration: configuration)
    return session
  }()

  @discardableResult
  func dataRequest(
    urlRequest request: URLRequest,
    completion: @escaping DataNetworkCompletion
  ) -> URLSessionDataTask {
    let task = session.dataTask(with: request) { data, response, error in
      if let error = error {
        onMainThread {
          completion(.failure(.networkError(error)))
        }
      } else {
        let response = response as! HTTPURLResponse
        let status = response.statusCode
        guard (200...299).contains(status) else {
          onMainThread {
            completion(.failure(
              .error(
                status: status,
                data: data
              )
            ))
          }
          return
        }
        guard let data = data else {
          onMainThread {
            completion(.failure(.empty))
          }
          return
        }
        onMainThread {
          completion(.success(data))
        }
      }
    }
    task.resume()
    return task
  }
}
