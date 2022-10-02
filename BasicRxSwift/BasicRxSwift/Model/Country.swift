//
//  Country.swift
//  BasicRxSwift
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 8/5/22.
//

import Foundation

class CountryModel: Codable {
    let code: Int?
    let result: [CountryListModel]?

    private enum CodingKeys: String, CodingKey {
        case code
        case result
    }
}

class CountryListModel: Codable {
    let code: String
    let name: String

    private enum CodingKeys: String, CodingKey {
        case code
        case name
    }
}
