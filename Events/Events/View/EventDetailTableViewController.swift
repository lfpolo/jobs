//
//  EventDetailViewController.swift
//  Events
//
//  Created by Luís Felipe Polo on 18/01/21.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

class EventDetailTableViewController: UITableViewController {
    
    // MARK: - Properties
    var eventDetailViewModel : EventDetailViewModel? = nil
    var activityIndicator = UIActivityIndicatorView(style: .large)
    let disposeBag = DisposeBag()
    
    // MARK: - Outlets
    @IBOutlet var eventDescriptionLabel: UILabel!
    @IBOutlet var eventImageView: UIImageView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var eventTitle: UILabel!
    @IBOutlet var checkinButton: UIButton!
    @IBOutlet var eventDateLabel: UILabel!
    @IBOutlet var eventPriceLabel: UILabel!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        setupView()
        eventDetailViewModel?.delegate = self
        eventDetailViewModel?.getEvent()
        activityIndicator.startAnimating()
        
        bindToViewModel()
    }
    
    func bindToViewModel() {
        eventDetailViewModel?.title
            .bind(to: eventTitle.rx.text)
            .disposed(by: disposeBag)
        
        eventDetailViewModel?.date
            .bind(to: eventDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        eventDetailViewModel?.price
            .bind(to: eventPriceLabel.rx.text)
            .disposed(by: disposeBag)
        
        eventDetailViewModel?.description
            .bind(to: eventDescriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        eventDetailViewModel?.image
            .bind(to: eventImageView.rx.image)
            .disposed(by: disposeBag)
        
        eventDetailViewModel?.description.subscribe(onNext: { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }).disposed(by: disposeBag)
        
        eventDetailViewModel?.coordinate.subscribe(onNext: { [weak self] coordinate in
            DispatchQueue.main.async {
                self?.setMapData(coordinate: coordinate)
            }
        }).disposed(by: disposeBag)

        checkinButton.rx.tap
            .bind(to: eventDetailViewModel!.checkinTap.asObserver())
            .disposed(by: disposeBag)
    }
    
    func setupView() {
        title = "Detalhes do Evento"
        
        eventDescriptionLabel.sizeToFit()
        
        eventTitle.sizeToFit()
        eventTitle.font = .preferredFont(forTextStyle: .title2, weight: .semibold)
        
        checkinButton.layer.cornerRadius = 12
        checkinButton.layer.masksToBounds = true
        
        mapView.layer.cornerRadius = 12
        mapView.layer.masksToBounds = true
        
        eventImageView.layer.cornerRadius = 12
        eventImageView.layer.masksToBounds = true
        eventImageView.image = UIImage(named: "defaultImage")
        
        checkinButton.titleLabel?.font = .preferredFont(forTextStyle: .callout, weight: .semibold)
        
        activityIndicator.setupIndicatorView(view: self.view)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action:  #selector(shareTap))
    }
    
    // MARK: - Location
    func setMapData(coordinate : Coordinate) {

        let initialLocation = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        mapView.setCenter(initialLocation, animated: true)
                
        let annotation = MKPointAnnotation()
        annotation.coordinate = initialLocation
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(
            center: initialLocation,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: - Share
    @objc func shareTap() {
        
        guard let viewModel = eventDetailViewModel else {
            return
        }
        
        let vc = UIActivityViewController(activityItems: [viewModel.shareText], applicationActivities: [])
        
        if let popOver = vc.popoverPresentationController {
            popOver.sourceView = self.view
        }
        
        present(vc, animated: true)
    }
}

// MARK: - ViewModelDelegate
extension EventDetailTableViewController : EventDetailViewModelDelegate {
    func requestError() {
        activityIndicator.stopAnimating()
        let alertController = UIAlertController(title: "Erro", message: "Erro ao obter os dados do evento.", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }

    func checkInResult(result: RequestResult) {
        let message = result == .success ? "Check-in efetuado com sucesso!" : "Não foi possível efetuar seu check-in. Tente novamente mais tarde."
        let alertController = UIAlertController(title: "Check-in", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
}
