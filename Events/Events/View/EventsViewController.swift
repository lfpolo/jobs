//
//  ViewController.swift
//  Events
//
//  Created by Luís Felipe Polo on 18/01/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class EventsViewController: UIViewController {

    // MARK: - Properties
    var eventsViewModel = EventsViewModel()
    var selectedEvent : Event? = nil
    var activityIndicator = UIActivityIndicatorView(style: .large)
    let disposeBag = DisposeBag()
    
    // MARK: - Outlets
    @IBOutlet var eventsTableView: UITableView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
        title = "Eventos"
        
        activityIndicator.setupIndicatorView(view: self.view)
        
        eventsViewModel.delegate = self
        eventsViewModel.getEvents()
        activityIndicator.startAnimating()
        
    }
    
    // MARK: - Segue to detail
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EventDetailTableViewController, let event = selectedEvent {
            vc.eventDetailViewModel = EventDetailViewModel(event: event)
        }
    }
}

// MARK: - TableViewDataSource, UITableViewDelegate
extension EventsViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsViewModel.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let eventCell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as? EventCell {
            let event = eventsViewModel.events[indexPath.row]
            eventCell.eventTitleLabel.text = event.title
            eventCell.eventDateLabel.text = event.date.toString
            eventCell.eventPriceLabel.text = event.price.currencyString
            
            if let image = eventsViewModel.images[event.id] {
                eventCell.backgroundView = UIImageView(image: image)
            } else {
                eventCell.backgroundView = UIImageView(image: UIImage(named: "defaultImage"))
            }
            
            return eventCell
        }
        
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEvent = eventsViewModel.events[indexPath.row]
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
}

// MARK: - ViewModelDelegate
extension EventsViewController : EventsViewModelDelegate {
    func eventsLoaded() {
        activityIndicator.stopAnimating()
        eventsTableView.reloadData()
        updateVisibleLabelPositions()
    }

    func imageLoaded() {
        eventsTableView.reloadData()
    }
    
    func requestError() {
        activityIndicator.stopAnimating()
        let alertController = UIAlertController(title: "Erro", message: "Erro ao obter os dados dos eventos.", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
}

// MARK: - Parallax
extension EventsViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateVisibleLabelPositions()
    }
    
    private func updateVisibleLabelPositions() {
        for cell in eventsTableView.visibleCells {
            if let eventCell = cell as? EventCell {
                updateLabelPosition(eventCell)
            }
        }
    }
    
    private func updateLabelPosition(_ cell: EventCell) {
        let point = view.convert(cell.titleView.frame.origin, from: cell.contentView)
        let ratio = point.y / view.frame.height
        let updatedConstraint = (ratio * 180)
        cell.titleViewTopConstraint.constant = updatedConstraint
    }
}
