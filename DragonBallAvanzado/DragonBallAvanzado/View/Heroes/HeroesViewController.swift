//
//  HeroesViewController.swift
//  DragonBallAvanzado
//
//  Created by Natalia Hernandez on 27/10/23.
//

import UIKit

protocol HeroesViewControllerDelegate{
    var loginViewModel: LoginViewControllerDelegate {get}
    var mapViewModel: MapViewControllerDelegate {get}
    var viewState: ((HeroesViewState) -> Void)? {get set}
    var heroesCount: Int {get}
    func heroBy(index: Int) -> Hero?
    func onViewAppear()
    func detailViewModel(index: Int) -> DetailHeroViewControllerDelegate?
    func deleteData() -> String?
}

enum HeroesViewState{
    case loading(_ isLoading: Bool)
    case updateData
}

class HeroesViewController: UIViewController {
    //MARK: - outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var tabBar: UITabBar!
    //MARK: - atributos
    var viewModel: HeroesViewControllerDelegate?
    //MARK: - Funciones heredadas
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setObservers()
        viewModel?.onViewAppear()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "HeroToDetail"){
            guard let index = sender as? Int,
                  let detailViewController = segue.destination as? DetailHeroViewController,
                  let detailViewmodel = viewModel?.detailViewModel(index: index) else{
                return
            }
            detailViewController.viewModel = detailViewmodel
        }
        else if(segue.identifier == "HeroToLogin") {
            guard let loginViewController = segue.destination as? LoginViewController else{ return }
            loginViewController.viewModel = viewModel?.loginViewModel
        }
        else if(segue.identifier == "HeroToMap"){
            guard let mapViewController = segue.destination as? MapViewController else{ return }
            mapViewController.viewModel = viewModel?.mapViewModel
        }
    }
    
    //MARK: Funciones privadas
    private func initViews(){
        collectionView.register(
            UINib(nibName: HeroCollectionViewCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: HeroCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        tabBar.delegate = self
    }
    
    private func setObservers(){
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state{
                case .loading(let isLoading):
                    self?.activityView.isHidden = !isLoading
                case .updateData:
                    self?.collectionView.reloadData()
                }
            }
            
        }
    }
    
}
//MARK: - Extension
extension HeroesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UITabBarDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.heroesCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroCollectionViewCell.identifier, for: indexPath) as? HeroCollectionViewCell else{
            return UICollectionViewCell()
        }
        if let hero = viewModel?.heroBy(index: indexPath.row){
            cell.updateView(
                name: hero.name,
                photo: hero.photo)
        }
        
        return cell
    }
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
        // Navegar a página detalle de héroe
            performSegue(
                withIdentifier: "HeroToDetail",
                sender: indexPath.row)
    }
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //Logout
        if item == tabBar.items?[0]{
            //decirle al modelo de borrar la info del keychain y del CoreData
            let response  = viewModel?.deleteData()
            print(response ?? "Hubo un error eliminando la informacion desde el logout")
            performSegue(
                withIdentifier: "HeroToLogin", sender: nil)
        }
        //Mapa
        else if item == tabBar.items?[1]{
            performSegue(
                withIdentifier: "HeroToMap", sender: nil)
        }
        // Limpiar
        else if item == tabBar.items?[2]{
            print(viewModel?.deleteData() ?? "Hubo un error eliminando la informacion")
        }
    }
}
