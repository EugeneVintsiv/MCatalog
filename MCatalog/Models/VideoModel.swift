//
//  VideoModel.swift
//  MCatalog
//
//  Created by Eugene on 4/3/19.
//  Copyright © 2019 Eugene. All rights reserved.
//

import Foundation

struct VideoResults: Decodable {
    public let details: [VideoKey]

    private enum CodingKeys: String, CodingKey {
        case details = "results"
    }

    public init(details: [VideoKey]) {
        self.details = details
    }
}

struct VideoKey: Decodable {
    public let key: String
    public let site: String
    public let type: String

    enum CodingKeys: String, CodingKey {
        case key = "key"
        case site = "site"
        case type = "type"
    }

    public init(key: String, site: String, type: String) {
        self.key = key
        self.site = site
        self.type = type
    }
}
