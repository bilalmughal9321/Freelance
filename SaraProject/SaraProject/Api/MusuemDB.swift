//
//  MusuemDB.swift
//  SaraProject
//
//  Created by Bilal Mughal on 26/11/2024.
//

import Foundation

struct Museum: Codable {
    let id: Int
    let name: String
    let location: String
    let established: Int
    let entryFee: String
    let highlights: [String]

    // Coding Keys for Custom Key Mapping
    enum CodingKeys: String, CodingKey {
        case id, name, location, established
        case entryFee = "entry_fee"
        case highlights
    }
}
