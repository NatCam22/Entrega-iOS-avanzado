//
//  SplashViewController.swift
//  DragonBallAvanzado
//
//  Created by Natalia Hernandez on 28/10/23.
//

import UIKit
import Kingfisher
//MARK: - Protocolo Delegado
protocol SplashViewControllerDelegate{
    var heroesViewModel: HeroesViewControllerDelegate {get}
    var loginViewModel: LoginViewControllerDelegate {get}
    var viewState: ((SplashViewState) -> Void)?{get set}
    func onViewAppear()
}

enum SplashViewState{
    case navigateToHeroes
    case navigateToLogin
}
class SplashViewController: UIViewController {
    //MARK: -Constantes
    private static let IMAGE_URL = "https://static.wikia.nocookie.net/doblaje/images/7/7c/Dragon-Ball-Z.png/revision/latest?cb=20200911193425&path-prefix=es"
    //MARK: -Outlets
    @IBOutlet weak var splashImage: UIImageView!
    //MARK: -Variables
    var viewModel: SplashViewControllerDelegate?
    //MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setObservers()
        onViewAppear()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    //MARK: Funciones privadas
    private func initViews(){
        self.splashImage.kf.setImage(with: URL(string: SplashViewController.IMAGE_URL))
    }
    private func setObservers(){
        viewModel?.viewState = {
            [weak self] state in
            DispatchQueue.main.async {
                print("Entra al state")
                switch state{
                    case .navigateToHeroes:
                        self?.performSegue(
                            withIdentifier: "SplashToHeroes",
                            sender: nil)
                    case .navigateToLogin:
                        self?.performSegue(
                            withIdentifier: "SplashToLogin",
                            sender: nil)
                }
            }
        }
    }
    private func onViewAppear(){
        viewModel?.onViewAppear()
    }
    
    //MARK: - Funciones heredadas
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SplashToHeroes") && (segue.destination as? HeroesViewController) != nil{
            let heroesViewController = segue.destination as? HeroesViewController
            heroesViewController?.viewModel = viewModel?.heroesViewModel
        }
        else if(segue.identifier == "SplashToLogin") && (segue.destination as? LoginViewController) != nil{
            let loginViewController = segue.destination as? LoginViewController
            loginViewController?.viewModel = viewModel?.loginViewModel
        }
    }


}
