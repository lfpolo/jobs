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

class EventsViewController: UIViewController, UITableViewDelegate {

    // MARK: - Properties
    var eventsViewModel = EventsViewModel()
    var selectedEvent : Event? = nil
    var activityIndicator = UIActivityIndicatorView(style: .large)
    let disposeBag = DisposeBag()
    
    // MARK: - Outlets
    @IBOutlet var eventsTableView: UITableView!
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.setupIndicatorView(view: view)
        eventsViewModel.getEvents()
        bindToViewModel()
    }
    
    // MARK: - ViewModel binds
    func bindToViewModel() {
        eventsTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
            
        eventsViewModel.eventsBehaviorRelay.asObservable()
            .bind(to: eventsTableView.rx.items(cellIdentifier: "EventCell", cellType: EventCell.self)) { [weak self] index, element, cell in
                cell.eventTitleLabel.text = element.title
                cell.eventDateLabel.text = element.date.toString
                cell.eventPriceLabel.text = element.price.currencyString
                
                if let image = self?.eventsViewModel.imagesBehaviorRelay.value[element.id] {
                    cell.backgroundView = UIImageView(image: image)
                }
                
                self?.updateLabelPosition(cell)
        }.disposed(by: disposeBag)
        
        eventsViewModel.imagesBehaviorRelay.asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.eventsTableView.reloadData()
        }).disposed(by: disposeBag)
        
        eventsTableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            do {
                self?.selectedEvent = try self?.eventsTableView.rx.model(at: indexPath)
                self?.performSegue(withIdentifier: "showDetail", sender: self)
            } catch {
                print("erro: nenhum evento selecionado")
            }
        }).disposed(by: disposeBag)
        
        eventsViewModel.eventsRequestStatus
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                self?.updateActivityIndicator(requestStatus: result)
                if result == .fail {
                    self?.requestError()
                }
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Segue to detail
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EventDetailTableViewController, let event = selectedEvent {
            vc.eventDetailViewModel = EventDetailViewModel(eventId: event.id)
        }
    }
    
    // MARK: - Helpers
    func updateActivityIndicator(requestStatus : RequestResult) {
        if requestStatus == .waiting {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func requestError() {
        let alertController = UIAlertController(title: "Erro", message: "Erro ao obter os dados dos eventos.", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
    
    // MARK: - Parallax
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
