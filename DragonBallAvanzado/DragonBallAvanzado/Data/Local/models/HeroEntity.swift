//
//  HeroEntity.swift
//  DragonBallAvanzado
//
//  Created by Natalia Hernandez on 27/10/23.
//

import Foundation
import CoreData

@objc(HeroEntity)
class HeroEntity: NSManagedObject{
    static let entityName = "HeroEntity"
    @NSManaged var name: String?
    @NSManaged var id: String?
    @NSManaged var heroDescription: String?
    @NSManaged var photo: String?
    @NSManaged var favorite: Bool
}
