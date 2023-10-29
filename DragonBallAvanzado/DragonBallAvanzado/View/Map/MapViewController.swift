//
//  MapViewController.swift
//  DragonBallAvanzado
//
//  Created by Natalia Hernandez on 29/10/23.
//

import UIKit
import MapKit

protocol MapViewControllerDelegate{
    var viewState: ((MapViewState) -> Void)? {get set}
    func onViewAppear()
}
enum MapViewState{
    case loading(_ isLoading: Bool)
    case update(locations: Locations)
}
class MapViewController: UIViewController {
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var mapa: MKMapView!
    
    var viewModel: MapViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initiViews()
        setObservers()
        viewModel?.onViewAppear()
        // Do any additional setup after loading the view.
    }
    
    private func initiViews(){
        mapa.delegate = self
    }
    
    private func setObservers(){
        viewModel?.viewState = {
            [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .loading(let isLoading):
                    self?.activityView.isHidden = !isLoading
                case .update(let locations):
                    self?.updateView(locations: locations)
                }
            }
        }
    }
    
    private func updateView(locations: Locations){
        locations.forEach{ location in
            mapa.addAnnotation(
            HeroAnnotation(
                title: "",
                photo: "",
                coordinate: .init(latitude: Double(location.latitude ?? "") ?? 0.0,
                                  longitude: Double(location.longitude ?? "") ?? 0.0)
            ))
        }
    }
    
    @IBAction func onClose(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension MapViewController: MKMapViewDelegate{
    
}
