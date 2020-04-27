//
//  File.swift
//  mapApp
//
//  Created by Vinova on 4/27/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//

import Foundation

protocol EndPointType {
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
