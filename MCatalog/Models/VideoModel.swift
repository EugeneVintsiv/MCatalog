//
//  VideoModel.swift
//  MCatalog
//
//  Created by Eugene on 4/3/19.
//  Copyright © 2019 Eugene. All rights reserved.
//

import Foundation

public struct VideoModel: Codable {
    public let id: Int
    public let results: [VideoResult]

    enum CodingKeys: String, CodingKey {
        case id
        case results
    }

    public init(id: Int, results: [VideoResult]) {
        self.id = id
        self.results = results
    }
}

public struct VideoResult: Codable {
    public let id: String
    public let key: String
    public let name: String
    public let site: String
    public let size: Int
    public let type: String

    enum CodingKeys: String, CodingKey {
        case id
        case key
        case name
        case site
        case size
        case type
    }

    public init(id: String, key: String, name: String, site: String, size: Int, type: String) {
        self.id = id
        self.key = key
        self.name = name
        self.site = site
        self.size = size
        self.type = type
    }
}
