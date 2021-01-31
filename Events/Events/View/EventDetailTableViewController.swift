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
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        setupView()
        eventDetailViewModel?.getEvent()
        bindToViewModel()
    }
    
    // MARK: - ViewModel binds
    func bindToViewModel() {
        guard let viewModel = eventDetailViewModel else {
            return
        }
        
        viewModel.title
            .bind(to: eventTitle.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.date
            .bind(to: eventDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.price
            .bind(to: eventPriceLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.description
            .bind(to: eventDescriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.image
            .bind(to: eventImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.description
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.coordinate
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] coordinate in
                self?.setMapData(coordinate: coordinate)
            }).disposed(by: disposeBag)

        viewModel.eventRequestStatus
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                self?.updateActivityIndicator(requestStatus: result)
                if result == .fail {
                    self?.requestError()
                }
        }).disposed(by: disposeBag)
        
        viewModel.checkInRequestStatus
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                self?.updateActivityIndicator(requestStatus: result)
                self?.checkInResult(result: result)
        }).disposed(by: disposeBag)
        
        checkinButton.rx.tap
            .bind(to: viewModel.checkinTap.asObserver())
            .disposed(by: disposeBag)
    }
    
    // MARK: - Helpers
    func setupView() {
        eventDescriptionLabel.sizeToFit()
        
        eventTitle.sizeToFit()
        eventTitle.font = .preferredFont(forTextStyle: .title2, weight: .semibold)
        
        checkinButton.layer.cornerRadius = 12
        checkinButton.layer.masksToBounds = true
        
        mapView.layer.cornerRadius = 12
        mapView.layer.masksToBounds = true
        
        eventImageView.layer.cornerRadius = 12
        eventImageView.layer.masksToBounds = true
        
        checkinButton.titleLabel?.font = .preferredFont(forTextStyle: .callout, weight: .semibold)
        
        activityIndicator.setupIndicatorView(view: self.view)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action:  #selector(shareTap))
    }
    
    func updateActivityIndicator(requestStatus : RequestResult) {
        if requestStatus == .waiting {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func requestError() {
        let alertController = UIAlertController(title: "Erro", message: "Erro ao obter os dados do evento.", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }

    func checkInResult(result: RequestResult) {
        if result == .none || result == .waiting {
            return
        }
        
        let message = result == .success ? "Check-in efetuado com sucesso!" : "Não foi possível efetuar seu check-in. Tente novamente mais tarde."
        let alertController = UIAlertController(title: "Check-in", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        present(alertController, animated: true)
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
        
        let activityViewController = UIActivityViewController(activityItems: [viewModel.eventImageBehaviorRelay.value, viewModel.eventBehaviorRelay.value.title], applicationActivities: [])
        
        if let popoverController = activityViewController.popoverPresentationController {
          popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
          popoverController.sourceView = self.view
          popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        
        present(activityViewController, animated: true)
    }
}
