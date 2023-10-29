//
//  DetailHeroViewController.swift
//  DragonBallAvanzado
//
//  Created by Natalia Hernandez on 29/10/23.
//

import UIKit
import Kingfisher

protocol DetailHeroViewControllerDelegate{
    var viewState: ((DetailHeroViewState) -> Void)? {get set}
    func onViewAppear()
}

enum DetailHeroViewState{
    case loading(_ isLoading: Bool)
    case update(hero: Hero?)
}
class DetailHeroViewController: UIViewController {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var heroDescription: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var activityView: UIView!
    
    var viewModel: DetailHeroViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setObservers()
        onViewAppear()
    }
    
    private func initViews(){
        
    }
    private func setObservers(){
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state{
                case .loading(let isLoading):
                    self?.activityView.isHidden = !isLoading
                case .update(let hero):
                    self?.updateView(hero: hero)
                }
            }
        }
    }
    private func onViewAppear(){
        viewModel?.onViewAppear()
    }
    
    private func updateView(hero: Hero?){
        photo.kf.setImage(with: URL(string: hero?.photo ?? ""))
        name.text = hero?.name
        heroDescription.text = hero?.description
    }
    
    @IBAction func onClose(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
