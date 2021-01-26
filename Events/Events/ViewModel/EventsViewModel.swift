//
//  EventsViewModel.swift
//  Events
//
//  Created by Luís Felipe Polo on 18/01/21.
//

import Foundation
import UIKit
import RxSwift

class EventsViewModel {
    
    var delegate : EventsViewModelDelegate?
    var events : [Event] = []
    var images : [String: UIImage] = [:]
    
    let disposeBag = DisposeBag()
    
    func getEvents() {
        URLRequest.loadObject(url: URL(string: Event.eventsEndpoint)!)
            .catchAndReturn([Event]())
            .subscribe(onNext: { [weak self] response in
                self?.events = response
                self?.getImages()
                DispatchQueue.main.async {
                    self?.delegate?.eventsLoaded()
                }
            }).disposed(by: disposeBag)
    }
    
    func getImages() {
        for event in events {
            if images[event.id] == nil {
                URLRequest.loadData(url: URL(string: event.image)!)
                    .catchAndReturn(Data())
                    .subscribe(onNext: { [weak self] data in
                        self?.images[event.id] = UIImage(data: data)
                        DispatchQueue.main.async() {
                            self?.delegate?.imageLoaded()
                        }
                    }).disposed(by: disposeBag)
            }
        }
    }
}

protocol EventsViewModelDelegate {
    func eventsLoaded()
    func imageLoaded()
    func requestError()
}
