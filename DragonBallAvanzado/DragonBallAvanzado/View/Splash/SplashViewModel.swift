//
//  SplashViewModel.swift
//  DragonBallAvanzado
//
//  Created by Natalia Hernandez on 28/10/23.
//

import Foundation

class SplashViewModel: SplashViewControllerDelegate{
    
    //MARK: - Dependencias
    private let apiProvider: ApiProviderProtocol
    private let keychainProvider: KeychainProviderProtocol
    //MARK: - Atributos
    var viewState: ((SplashViewState) -> Void)?
    var heroesViewModel: HeroesViewControllerDelegate{
        HeroesViewModel(
            apiProvider: apiProvider,
            keychainProvider: keychainProvider)
    }
    var loginViewModel: LoginViewControllerDelegate{
        LoginViewModel(
            apiProvider: apiProvider,
            keychainProvider: keychainProvider)
    }
    
    //MARK: - Inicializadores
    init(
        apiProvider: ApiProviderProtocol,
        keychainProvider: KeychainProviderProtocol){
            self.apiProvider = apiProvider
            self.keychainProvider = keychainProvider
        }
    //MARK: - Funciones publicas:
    func onViewAppear(){
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)){
            //Check if token has some value
            let token = self.keychainProvider.getToken()
            guard token != nil &&
            (token?.isEmpty)! else{
                self.viewState?(.navigateToHeroes)
                return
            }
            self.viewState?(.navigateToLogin)
        }
        
    }
    
    
}
