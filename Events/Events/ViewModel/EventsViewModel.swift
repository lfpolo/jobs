//
//  EventsViewModel.swift
//  Events
//
//  Created by Luís Felipe Polo on 18/01/21.
//

import Foundation
import UIKit

class EventsViewModel {
    
    var delegate : EventsViewModelDelegate?
    var events : [Event] = []
    var images : [String: UIImage] = [:]
    
    func getEvents() {
        EventsAPI().getEventList() { [weak self] data, result  in
            if result == .success {
                self?.events = data
                self?.getImages()
                
                DispatchQueue.main.async {
                    self?.delegate?.eventsLoaded()
                }
            } else {
                DispatchQueue.main.async {
                    self?.delegate?.requestError()
                }
            }
        }
    }
    
    func getImages() {
        for event in events {
            if images[event.id] == nil {
                RequestManager().request(address: event.image, requestMethod: .GET) { [weak self] data, result in
                    if let data = data {
                        self?.images[event.id] = UIImage(data: data)
                        DispatchQueue.main.async() {
                            self?.delegate?.imageLoaded()
                        }
                    }
                }
            }
        }
    }
}

protocol EventsViewModelDelegate {
    func eventsLoaded()
    func imageLoaded()
    func requestError()
}
