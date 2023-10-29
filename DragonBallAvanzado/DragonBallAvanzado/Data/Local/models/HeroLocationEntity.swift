//
//  HeroLocationEntity.swift
//  DragonBallAvanzado
//
//  Created by Natalia Hernandez on 27/10/23.
//

import Foundation
import CoreData

@objc(HeroLocationEntity)
class HeroLocationEntity: NSManagedObject{
    static let entityName = "HeroLocationEntity"
    @NSManaged var latitud: String?
    @NSManaged var longitud: String?
    @NSManaged var date: String?
    @NSManaged var id: String?
}
