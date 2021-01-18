//
//  ViewController.swift
//  Events
//
//  Created by Luís Felipe Polo on 18/01/21.
//

import Foundation
import UIKit

class EventsViewController: UIViewController {

    // MARK: - Properties
    var eventsViewModel = EventsViewModel()
    var selectedEvent : Event? = nil
    
    // MARK: - Outlets
    @IBOutlet var eventsTableView: UITableView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
        title = "Eventos"
        
        eventsViewModel.delegate = self
        eventsViewModel.getEvents()
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
            eventCell.eventTitle.text = event.title
            eventCell.eventDate.text = event.date.toString
            eventCell.eventPrice.text = event.price.currencyString
            
            if let image = eventsViewModel.images[event.id] {
                eventCell.eventImageView.image = image
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
        eventsTableView.reloadData()
    }

    func imageLoaded() {
        eventsTableView.reloadData()
    }
    
    func requestError() {
        let alertController = UIAlertController(title: "Erro", message: "Erro ao obter os dados dos eventos.", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
}
