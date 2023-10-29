//
//  Hero.swift
//  DragonBallAvanzado
//
//  Created by Natalia Hernandez on 28/10/23.
//

import Foundation

struct Hero: Codable{
    enum CodingKeys: String, CodingKey{
        case id
        case name
        case description
        case photo
        case isFavorite = "favorite"
    }
    let id: String?
    let name: String?
    let description: String?
    var photo: String?
    let isFavorite: Bool?
    
    
}
