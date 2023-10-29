//
//  LoginViewController.swift
//  DragonBallAvanzado
//
//  Created by Natalia Hernandez on 24/10/23.
//

import UIKit

protocol LoginViewControllerDelegate{
    var heroesViewModel: HeroesViewControllerDelegate {get}
    var viewState: ((LoginViewState) -> Void)?{get set}
    func onLoginPressed(email: String?, password: String?)
}

enum LoginViewState{
    case loading(_ isLoading: Bool)
    case showErrorEmail(_ error: String?)
    case showErrorPassword(_ error: String?)
    case navigateToNext
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var emailError: UILabel!
    @IBOutlet weak var passwordError: UILabel!
    @IBOutlet weak var activityView: UIView!
    
    //Variables
    var viewModel: LoginViewControllerDelegate?
    
    @IBAction func onLoginPressed(){
        //TODO: Obtener el mail y password, introducirlos y hacerle post al servicio de dragonball (esta lógica debe ir en el ViewModel).
        viewModel?.onLoginPressed(
            email: email.text,
            password: password.text
        )
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setObservers()
    }
    
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?) {
            guard segue.identifier == "LoginToHeroes",
                  let heroesViewController = segue.destination as? HeroesViewController else{
                return
            }
            heroesViewController.viewModel = viewModel?.heroesViewModel
            
    }
    private func initViews(){
        email.delegate = self
        password.delegate = self
        
        view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(dismissKeyboard)))
    }
    @objc func dismissKeyboard(){
        //Le digo a la vista que deje de estar modo edición. Esto hace que el teclado automáticamente se quite de la pantalla.
        view.endEditing(true)
    }
    
    private func setObservers(){
        viewModel?.viewState = {[weak self] state in
            DispatchQueue.main.async {
                switch state {
                    case .loading(let isLoading):
                        self?.activityView.isHidden = !isLoading
                        
                    case .showErrorEmail(let error):
                        self?.emailError.text = error
                        self?.emailError.isHidden = (error == nil || error?.isEmpty == true)
                        
                    case .showErrorPassword(let error):
                        self?.passwordError.text = error
                        self?.passwordError.isHidden = (error == nil || error?.isEmpty == true)
                        
                    case .navigateToNext:
                        self?.performSegue(
                            withIdentifier: "LoginToHeroes",
                            sender: nil)
                        // Navegar a la siguiente vista.
                    }
            }
        
        }
    }

}
extension LoginViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if email == textField{
            emailError.isHidden = true
        }
        else if password == textField{
            passwordError.isHidden = true
        }
    }
}

