//
//  ParameterEncoding.swift
//  mapApp
//
//  Created by Vinova on 4/27/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//

import Foundation

public typealias Parameters = [String:Any]

public protocol ParameterEncoder {
 static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

public enum NetworkError : String, Error{
    case parametersNil = "Parameters were Nil."
    case enncodingFailed = "Parameters encoding failed."
    case missingURL = "URL is nil."
}
