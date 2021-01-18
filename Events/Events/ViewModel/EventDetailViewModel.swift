//
//  EventDetailViewModel.swift
//  Events
//
//  Created by Luís Felipe Polo on 18/01/21.
//

import UIKit
import Foundation

class EventDetailViewModel {
    var delegate : EventDetailViewModelDelegate?
    var event : Event
    var eventImage : UIImage? = nil
    
    init(event : Event) {
        self.event = event
    }
    
    func getEvent() {
        EventsAPI().getEvent(eventId: event.id) { [weak self] data, result in
            if result == .success, let event = data {
                self?.event = event
                self?.getImage()
                
                DispatchQueue.main.async {
                    self?.delegate?.eventLoaded()
                }
            } else {
                DispatchQueue.main.async {
                    self?.delegate?.requestError()
                }
            }
        }
    }
    
    func getImage() {
        if eventImage == nil {
            RequestManager().request(address: event.image, requestMethod: .GET) { [weak self] data, result  in
                if let data = data {
                    self?.eventImage = UIImage(data: data)
                    
                    DispatchQueue.main.async() {
                        self?.delegate?.imageLoaded()
                    }
                }
            }
        }
    }
    
    func checkin() {
        EventsAPI().checkIn(eventId: event.id) { result in
            DispatchQueue.main.async() {
                self.delegate?.checkInResult(result: result)
            }
        }
    }
}

protocol EventDetailViewModelDelegate {
    func eventLoaded()
    func imageLoaded()
    func checkInResult(result: RequestResult)
    func requestError()
}
