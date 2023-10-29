//
//  LoginViewModel.swift
//  DragonBallAvanzado
//
//  Created by Natalia Hernandez on 24/10/23.
//
import Foundation

class LoginViewModel: LoginViewControllerDelegate
{
    // MARK: - Dependencias
    private let apiProvider: ApiProviderProtocol
    private let keychainProvider: KeychainProviderProtocol
    // MARK: - Atributos
    var viewState: ((LoginViewState) -> Void)?
    var heroesViewModel: HeroesViewControllerDelegate{
        HeroesViewModel(
            apiProvider: apiProvider,
            keychainProvider: keychainProvider)
    }
    //MARK: - Inicializadores
    init(
        apiProvider: ApiProviderProtocol,
        keychainProvider: KeychainProviderProtocol
    ){  self.apiProvider = apiProvider
        self.keychainProvider = keychainProvider
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onLoginResponse),
            name: NotificationCenter.apiLoginNotification,
            object: nil)
    }
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    //MARK: - Selectores
    @objc func onLoginResponse(_ notification: Notification){
        // Parsear resultado del userInfo de la notif
        print("LoginViewModel onLoginResponse: \(notification)")
        guard let token = notification.userInfo?[NotificationCenter.apiToken] as? String,
              !token.isEmpty else{
            return
        }
        keychainProvider.save(token: token)
        viewState?(.loading(false))
        viewState?(.navigateToNext)
    }
    // MARK: - Funciones publicas:
    // todas aquellas que sean del protocolo.
    func onLoginPressed(email: String?, password: String?){
        viewState?(.loading(true))
        
        DispatchQueue.global().async {
            guard self.isValid(email: email) else{
                self.viewState?(.loading(false))
                self.viewState?(.showErrorEmail("Indique un email válido"))
                return
            }
            
            guard self.isValid(password: password) else{
                self.viewState?(.loading(false))
                self.viewState?(.showErrorPassword("Su contraseña no es correcta"))
                return
            }
            
            self.doLoginWith(
                email: email ?? "",
                password: password ?? "")
        }
    }
    //MARK: - Private funcs
    private func isValid(email: String?) -> Bool{
        email?.isEmpty == false && email?.contains("@") ?? false
    }
    
    private func isValid(password: String?) -> Bool{
        password?.isEmpty == false && (password?.count ?? 0) >= 4
    }
    private func doLoginWith(email: String, password: String){
        print(email)
        print(password)
        apiProvider.login(for: email, with: password)
    }
}
