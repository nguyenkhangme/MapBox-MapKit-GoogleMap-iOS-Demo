//
//  HTTPTask.swift
//  mapApp
//
//  Created by Vinova on 4/27/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String:String]

public enum HTTPTask {
    case request
    
    case requestParameters(bodyParameters: Parameters?, urlParameters: Parameters?)
    case requestParametersAndHeaders(bodyParameters: Parameters?, urlParameters: Parameters?, additionHeaders: HTTPHeaders?)
}
