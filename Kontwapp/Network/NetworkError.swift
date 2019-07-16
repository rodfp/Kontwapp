//
//  NetworkError.swift
//  Kontwapp
//
//  Created by Rodrigo Franco on 7/15/19.
//  Copyright © 2019 Rodrigo Franco. All rights reserved.
//

import Foundation

enum NetworkErrorType: Int {
  case wrongParameters = 0
  case wrongResponse = 1
  case noConnectivity = 2
  case serverError = 3
  case unableToDecode = 4
  case invalidURL = 5
  case outdated = 6
  case badRequest = 7
  case errorNotDefined = 8
  
  func errorDescription() -> String{
    switch self {
    case .wrongParameters:
      return "Wrong parameters sent"
    case .wrongResponse:
      return "Wrong response"
    case .noConnectivity:
      return "No connectivity"
    case .serverError:
      return "Server Error"
    case .unableToDecode:
      return "Unable to decode response"
    case .invalidURL:
      return "The URL for this endpoint couldn't be extracted"
    case .outdated:
      return "The url you requested is outdated."
    case .badRequest:
      return "Bad request"
    case .errorNotDefined:
      return "Error is not defined"
    }
  }
}

struct NetworkError{
  let error : NSError
  let type : NetworkErrorType
  
  init(type: NetworkErrorType) {
    self.error = NSError(domain: "NetworkErrorDomain", code: type.rawValue, userInfo: [NSLocalizedDescriptionKey : type.errorDescription()])
    self.type = type
  }
  
}
