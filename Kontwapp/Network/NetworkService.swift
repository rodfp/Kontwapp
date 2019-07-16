//
//  NetworkService.swift
//  Kontwapp
//
//  Created by Rodrigo Franco on 7/15/19.
//  Copyright © 2019 Rodrigo Franco. All rights reserved.
//

import Foundation

struct NetworkService {
  
  static var baseURL: URL {
    let baseURL = Bundle.main.object(forInfoDictionaryKey: "KontwappAPIURL") as? String
    guard let url = URL(string: baseURL ?? "") else { fatalError("base URL could not be configured.") }
    return url
  }
  
  static func getAllCounters(callback: @escaping ([CounterNetworkData]?, NetworkError?) -> Void) {
    guard let url = URL(string: "\(baseURL)/api/v1/counters") else {
      callback(nil,NetworkError(type:.invalidURL))
      return
    }
    jsonRequest(url: url, method: .get, parameters: nil) { (response, error) in
      guard let response = response else {
        callback(nil,error ?? NetworkError(type: .wrongResponse))
        return
      }
      do {
        let counterNetworkData = try JSONDecoder().decode([CounterNetworkData].self, from: response)
        callback(counterNetworkData,nil)
      } catch _ {
        callback(nil,NetworkError(type: .unableToDecode))
      }
    }
  }
  
  static func createCounter(title: String, callback: @escaping ([CounterNetworkData]?, NetworkError?) -> Void) {
    guard let url = URL(string: "\(baseURL)/api/v1/counter") else {
      callback(nil,NetworkError(type:.invalidURL))
      return
    }
    jsonRequest(url: url, parameters: ["title" : title]) { (response, error) in
      guard let response = response else {
        callback(nil,error ?? NetworkError(type: .wrongResponse))
        return
      }
      do {
        let counterNetworkData = try JSONDecoder().decode([CounterNetworkData].self, from: response)
        callback(counterNetworkData,nil)
      } catch _ {
        callback(nil,NetworkError(type: .unableToDecode))
      }
    }
  }
  
  static func deleteCounter(counterId: String, callback: @escaping ([CounterNetworkData]?, NetworkError?) -> Void) {
    guard let url = URL(string: "\(baseURL)/api/v1/counter") else {
      callback(nil,NetworkError(type:.invalidURL))
      return
    }
    jsonRequest(url: url, method: .delete, parameters: ["id" : counterId]) { (response, error) in
      guard let response = response else {
        callback(nil,error ?? NetworkError(type: .wrongResponse))
        return
      }
      do {
        let counterNetworkData = try JSONDecoder().decode([CounterNetworkData].self, from: response)
        callback(counterNetworkData,nil)
      } catch _ {
        callback(nil,NetworkError(type: .unableToDecode))
      }
    }
  }
  
  static func increaseCounter(counterId: String, callback: @escaping ([CounterNetworkData]?, NetworkError?) -> Void) {
    guard let url = URL(string: "\(baseURL)/api/v1/counter/inc") else {
      callback(nil,NetworkError(type:.invalidURL))
      return
    }
    jsonRequest(url: url, parameters: ["id" : counterId]) { (response, error) in
      guard let response = response else {
        callback(nil,error ?? NetworkError(type: .wrongResponse))
        return
      }
      do {
        let counterNetworkData = try JSONDecoder().decode([CounterNetworkData].self, from: response)
        callback(counterNetworkData,nil)
      } catch _ {
        callback(nil,NetworkError(type: .unableToDecode))
      }
    }
  }
  
  static func decreaseCounter(counterId: String, callback: @escaping ([CounterNetworkData]?, NetworkError?) -> Void) {
    guard let url = URL(string: "\(baseURL)/api/v1/counter/dec") else {
      callback(nil,NetworkError(type:.invalidURL))
      return
    }
    jsonRequest(url: url, parameters: ["id" : counterId]) { (response, error) in
      guard let response = response else {
        callback(nil,error ?? NetworkError(type: .wrongResponse))
        return
      }
      do {
        let counterNetworkData = try JSONDecoder().decode([CounterNetworkData].self, from: response)
        callback(counterNetworkData,nil)
      } catch _ {
        callback(nil,NetworkError(type: .unableToDecode))
      }
    }
  }
  
  static private func getSession() -> URLSession {
    let config = URLSessionConfiguration.default
    config.timeoutIntervalForResource = 60
    if #available(iOS 11, *) {
      config.waitsForConnectivity = true
    }
    let session = URLSession(configuration: config)
    return session
  }
  
  static private func urlRequestFor(url: URL, method: HTTPMethod = .post, header: String? = nil, parameters: [String: Any]? = nil, body: Data? = nil) -> (urlRequest: URLRequest?, error: NetworkError?) {
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = method.rawValue
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    if parameters != nil {
      do {
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted)
      } catch {
        return (nil, NetworkError(type:.wrongParameters))
      }
    }
    
    if body != nil {
      urlRequest.httpBody = body!
    }
    return (urlRequest, nil)
  }
  
  static private func jsonRequest(url: URL, method: HTTPMethod = .post, header: String? = nil, parameters: [String: Any]? = nil, body: Data? = nil, callback: @escaping (Data?, NetworkError?)->Void) {
    let defaultSession = getSession()
    let requestContainer = urlRequestFor(url: url, method: method, header: header, parameters: parameters, body: body)
    guard requestContainer.urlRequest != nil else {
      callback(nil, requestContainer.error)
      return
    }
    
    let dataTask = defaultSession.dataTask(with: requestContainer.urlRequest!) { (data, response, error) in
      guard error == nil else {
        callback(nil, NetworkError(type:.noConnectivity))
        return
      }
      guard let data = data else {
        callback(nil, NetworkError(type:.wrongResponse))
        return
      }
      guard let response = response as? HTTPURLResponse else {
        callback(nil, NetworkError(type:.wrongResponse))
        return
      }
      switch response.statusCode {
      case 200...299:
        callback(data,nil)
      case 401...500:
        callback(data,NetworkError(type:.badRequest))
      case 501...599:
        callback(data,NetworkError(type:.serverError))
      case 600:
        callback(data,NetworkError(type:.outdated))
      default:
        callback(data,NetworkError(type:.errorNotDefined))
      }
      
    }
    dataTask.resume()
  }
}



