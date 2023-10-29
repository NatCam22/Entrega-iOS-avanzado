//
//  CoreDataStack.swift
//  DragonBallAvanzado
//
//  Created by Natalia Hernandez on 27/10/23.
//

import Foundation
import CoreData

class CoreDataStack: NSObject{
    //Singleton
    static let shared: CoreDataStack = .init()
    // .init() es lo mismo que llamar al constructor de la clase.
    // En este caso sería equivalente a hacer CoreDataStack()
    //Hacer el init privado hace que sea un síngleton ya que solo se va a poder inicializar
    //la clase desde dentro de la propia clase y solo lo haremos desde el shared.
    private override init(){}
    //MARK: - CoreData Stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "DragonBallAvanzado")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    //Llamamos esta función desde el AppDelegate (al crearse el proyecto) y por default
    //Hace un llamado para guardar los datos del contexto
    func saveContext () {
        //Se define el MOC directamente cuadno se crea el proyecto con coreData.
        let context = persistentContainer.viewContext
        //Revisamos si tiene cambios
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
