//
//  EventDetailViewController.swift
//  Events
//
//  Created by Luís Felipe Polo on 18/01/21.
//

import UIKit
import MapKit

class EventDetailTableViewController: UITableViewController {
    
    // MARK: - Properties
    var eventDetailViewModel : EventDetailViewModel? = nil
    var activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Outlets
    @IBOutlet var eventDescription: UILabel!
    @IBOutlet var eventImageView: UIImageView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var eventTitle: UILabel!
    @IBOutlet var checkin: UIButton!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        setupView()
        eventDetailViewModel?.delegate = self
        eventDetailViewModel?.getEvent()
        activityIndicator.startAnimating()
    }
    
    func setupView() {
        title = "Detalhes do Evento"
        eventImageView.image = UIImage(named: "defaultImage")
        eventDescription.sizeToFit()
        eventTitle.sizeToFit()
        checkin.layer.cornerRadius = 15
        checkin.layer.masksToBounds = true
        mapView.layer.cornerRadius = 10
        mapView.layer.masksToBounds = true
        eventImageView.layer.cornerRadius = 10
        eventImageView.layer.masksToBounds = true
        activityIndicator.setupIndicatorView(view: self.view)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action:  #selector(shareTap))
    }
    
    // MARK: - Location
    func setmap() {
        guard let evento = eventDetailViewModel?.event else {
            return
        }
        let initialLocation = CLLocationCoordinate2D(latitude: evento.latitude, longitude: evento.longitude)
        mapView.setCenter(initialLocation, animated: true)
        
        //let annotation = MKPlacemark(coordinate: initialLocation)
        let region = MKCoordinateRegion(
            center: initialLocation,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        
        //mapView.addAnnotation(annotation)
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
    
    // MARK: - Checkin
    @IBAction func checkIn(_ sender: Any) {
        eventDetailViewModel?.checkin()
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
    
    func imageLoaded() {
        eventImageView.image = eventDetailViewModel?.eventImage
    }
    
    func eventLoaded() {
        activityIndicator.stopAnimating()
        setmap()
        eventDescription.text = eventDetailViewModel?.event.description
        eventTitle.text = eventDetailViewModel?.event.title
        tableView.reloadData()
    }
    
    func checkInResult(result: RequestResult) {
        let message = result == .success ? "Check-in efetuado com sucesso!" : "Não foi possível efetuar seu check-in. Tente novamente mais tarde."
        let alertController = UIAlertController(title: "Check-in", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
}
