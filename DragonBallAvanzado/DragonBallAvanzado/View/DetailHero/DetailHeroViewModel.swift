//
//  DetailHeroViewModel.swift
//  DragonBallAvanzado
//
//  Created by Natalia Hernandez on 29/10/23.
//

import Foundation

class DetailHeroViewModel: DetailHeroViewControllerDelegate{
    //MARK: - Dependencias
    private let apiProvider: ApiProviderProtocol
    private let keychainProvider: KeychainProviderProtocol
    private var hero: Hero
    
    var viewState: ((DetailHeroViewState) -> Void)?
    
    init(hero: Hero,
         apiProvider: ApiProviderProtocol, keychainProvider: KeychainProviderProtocol) {
        self.hero = hero
        self.apiProvider = apiProvider
        self.keychainProvider = keychainProvider
    }
    
    func onViewAppear() {
        viewState?(.loading(true))
        DispatchQueue.global().async{
            defer{ self.viewState?(.loading(false))}
            self.viewState?(.update(hero: self.hero))
        }
    }
    
    
}
