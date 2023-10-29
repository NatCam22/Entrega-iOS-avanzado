//
//  Location.swift
//  DragonBallAvanzado
//
//  Created by Natalia Hernandez on 29/10/23.
//

import Foundation

typealias Locations = [Location]

struct Location: Codable{
    enum CodingKeys: String, CodingKey{
        case id
        case hero
        case latitude = "latitud"
        case longitude = "longitud"
        case date = "dateShow"
    }
    let id: String?
    let date: String?
    let latitude: String?
    let longitude: String?
    var hero: Hero?
}
