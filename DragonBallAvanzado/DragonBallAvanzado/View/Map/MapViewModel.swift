//
//  MapViewModel.swift
//  DragonBallAvanzado
//
//  Created by Natalia Hernandez on 29/10/23.
//

import Foundation
import CoreData

class MapViewModel: MapViewControllerDelegate{
    var viewState: ((MapViewState) -> Void)?
    private let apiProvider: ApiProviderProtocol
    private let keychainProvider: KeychainProviderProtocol
    private var locations: Locations = []
    
    init(apiProvider: ApiProviderProtocol, keychainProvider: KeychainProviderProtocol) {
        self.apiProvider = apiProvider
        self.keychainProvider = keychainProvider
    }
    
    func onViewAppear() {
        viewState?(.loading(true))
        defer{ self.viewState?(.loading(false))}
        
        guard let token = self.keychainProvider.getToken() else{
            return
        }
        let moc = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<HeroEntity>(entityName: HeroEntity.entityName)
        do{
            let heroes = try moc.fetch(fetchRequest)
            if(heroes.count == 0){
                print("Lo sentimos, no hay heroes para mostrar!!")
            }else{
                let fetchRequestLocation = NSFetchRequest<HeroLocationEntity>(entityName: HeroLocationEntity.entityName)
                do{
                    let coreLocations = try moc.fetch(fetchRequestLocation)
                    if(coreLocations.count == 0){
                        //Saco los location de un llamado a la API y se guardan en el CoreData
                        DispatchQueue.main.async {
                            heroes.forEach{ hero in
                                self.apiProvider.getLocations(
                                    by: hero.id,
                                    with: token) { locations in
                                        self.locations = locations
                                        guard let locationEntity = NSEntityDescription.entity(forEntityName: HeroLocationEntity.entityName, in: moc) else {return}
                                        for var location in self.locations{
                                            let locationEntity = HeroLocationEntity(entity: locationEntity, insertInto: moc)
                                            locationEntity.setValue(location.date, forKey: "date")
                                            locationEntity.setValue(location.id, forKey: "id")
                                            locationEntity.setValue(location.latitude, forKey: "latitud")
                                            locationEntity.setValue(location.longitude, forKey: "longitud")
                                            location.hero?.photo = hero.photo
                                        }
                                        try? moc.save()
                                        //Finalmente actualizamos los datos
                                        self.viewState?(.update(locations: self.locations))
                                    }
                            }
                        }
                    }else{
                        //Saco las location del coreData
                        DispatchQueue.main.async {
                            for location in coreLocations{
                                let newLocation = Location(id: location.id,
                                                           date: location.date,
                                                           latitude: location.latitud, longitude: location.longitud, hero: nil)
                                self.locations.append(newLocation)
                                }
                            //Finalmente actualizamos los datos
                            self.viewState?(.update(locations: self.locations))
                        }
                    }
                    
                }
                catch{}
                
            }
            
        }
        catch let error as NSError{
            print("could not fetch data: \(error) \(error.userInfo)")
        }
    }
    
    
}
