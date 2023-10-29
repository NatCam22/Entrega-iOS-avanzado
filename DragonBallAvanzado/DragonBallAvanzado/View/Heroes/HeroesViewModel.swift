//
//  HeroesViewModel.swift
//  DragonBallAvanzado
//
//  Created by Natalia Hernandez on 27/10/23.
//

import Foundation
import CoreData

class HeroesViewModel: HeroesViewControllerDelegate{
    
    var viewState: ((HeroesViewState) -> Void)?
    var heroesCount: Int{
        heroes.count
    }
    
    private let apiProvider: ApiProviderProtocol
    private let keychainProvider: KeychainProviderProtocol
    
    private var heroes: [Hero] = []
    
    var mapViewModel: MapViewControllerDelegate{
        MapViewModel(
            apiProvider: apiProvider,
            keychainProvider: keychainProvider)
    }
    var loginViewModel: LoginViewControllerDelegate{
        LoginViewModel(
            apiProvider: apiProvider,
            keychainProvider: keychainProvider)
    }
    
    
    init(apiProvider: ApiProviderProtocol,
         keychainProvider: KeychainProviderProtocol) {
        self.apiProvider = apiProvider
        self.keychainProvider = keychainProvider
    }
    
    func onViewAppear(){
        viewState?(.loading(true))
        defer{ self.viewState?(.loading(false))}
         // Nos aseguramos que el token exista.
        // *Note que no lo pusimos opcional cuando se utiliza en el ApiProvider
        guard let token = self.keychainProvider.getToken() else{
            return
        }
        // Traer los datos que estan en el CoreData
        let moc = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<HeroEntity>(entityName: HeroEntity.entityName)
        do{
            let heroes = try moc.fetch(fetchRequest)
            if(heroes.count == 0){
                //En caso de que no haya datos en el CoreData entonces los traemos de la API. (En ese caso ademas guardamos los heroes en el coreData).
                DispatchQueue.main.async {
                    self.apiProvider.getHeroes(
                        by: nil,
                        with: token) { apiHeroes in
                            self.heroes = apiHeroes
                            guard let entityHero = NSEntityDescription.entity(forEntityName: HeroEntity.entityName, in: moc) else {return}
                            for hero in self.heroes{
                                let heroEntity = HeroEntity(entity: entityHero, insertInto: moc)
                                heroEntity.setValue(hero.name, forKey: "name")
                                heroEntity.setValue(hero.photo, forKey: "photo")
                                heroEntity.setValue(hero.id, forKey: "id")
                                heroEntity.setValue(hero.description, forKey: "heroDescription")
                                heroEntity.setValue(hero.isFavorite, forKey: "favorite")
                            }
                            try? moc.save()
                            //Finalmente actualizamos los datos
                            self.viewState?(.updateData)
                        }
                }
            }
            else {
                DispatchQueue.main.async {
                    for hero in heroes{
                        let newHero = Hero(id: hero.id,
                                name: hero.name,
                                description: hero.heroDescription,
                                photo: hero.photo,
                                isFavorite: hero.favorite)
                        self.heroes.append(newHero)
                        }
                    //Finalmente actualizamos los datos
                    self.viewState?(.updateData)
                }
                }
            
        }
        catch let error as NSError{
            print("could not fetch data: \(error) \(error.userInfo)")
        }
      
}
    
    func deleteData() -> String?{
        keychainProvider.deleteToken()
        let moc = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<HeroEntity>(entityName: HeroEntity.entityName)
        do{
            let heroes = try moc.fetch(fetchRequest)
            if(heroes.count == 0){
                return "ya no hay datos"
            }
            else {
                // En caso de que si haya datos los transformamos a Hero y agregamos a la lista.
                heroes.forEach{hero in moc.delete(hero)}
                try? moc.save()
                }
                //Finalmente actualizamos los datos
                self.viewState?(.updateData)
            let fetchRequestLocation = NSFetchRequest<HeroLocationEntity>(entityName: HeroLocationEntity.entityName)
            do{
                let locations = try moc.fetch(fetchRequestLocation)
                if(locations.count == 0){
                    return "ya no hay datos"
                }
                else {
                    // En caso de que si haya datos los transformamos a Hero y agregamos a la lista.
                    locations.forEach{location in moc.delete(location)}
                    try? moc.save()
                    }
                    //Finalmente actualizamos los datos
                    self.viewState?(.updateData)
                    return("La informacion fue eliminada")
            }
            catch let error as NSError{
                    print("could not fetch data: \(error) \(error.userInfo)")
                    return "fallo la eliminacion de las localizaciones en el core data"
                }
            }
        catch let error as NSError{
                print("could not fetch data: \(error) \(error.userInfo)")
                return "fallo la eliminacion de los heroes en el core data"
            }
        
        
    }
    
    func heroBy(index: Int) -> Hero? {
        guard index >= 0 && index < heroesCount else{
            return nil
        }
        return heroes[index]
    }
    func detailViewModel(index: Int) -> DetailHeroViewControllerDelegate?{
        guard let selectedHero = heroBy(index: index) else{return nil}
        return DetailHeroViewModel(
            hero: selectedHero,
            apiProvider: apiProvider,
            keychainProvider: keychainProvider)
    }
}
