//
//  EventDetailViewModel.swift
//  Events
//
//  Created by Luís Felipe Polo on 18/01/21.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa

class EventDetailViewModel {
    var delegate : EventDetailViewModelDelegate?
    var event : Event
    var shareText : String {
        return event.title + " no dia " + event.date.toString + "! Descrição do evento: " + event.description
    }
    
    private var ev = BehaviorRelay<Event>(value: Event.empty)
    private var eventImage = BehaviorRelay<UIImage?>(value: nil)
    var title : Observable<String>
    var price : Observable<String>
    var date : Observable<String>
    var description : Observable<String>
    var image : Observable<UIImage?>
    var coordinate : Observable<Coordinate>
    
    let disposeBag = DisposeBag()
    
    init(event : Event) {
        
        self.event = event
        //ev = BehaviorRelay(value: event)
        
        title = ev.map { $0.title }
        price = ev.map { $0.price.currencyString }
        date = ev.map { $0.date.toString }
        description = ev.map { $0.description }
        coordinate = ev.map { Coordinate(latitude: $0.latitude, longitude: $0.longitude) }
        image = eventImage.map { $0 }
    }
    
    func getEvent() {
        URLRequest.loadObject(url: URL(string: Event.eventsEndpoint + event.id)!)
            .catchAndReturn(Event.empty)
            .subscribe(onNext: { [weak self] event in
                self?.ev.accept(event)
                self?.getImage()
            }).disposed(by: disposeBag)
    }
    
    func getImage() {
        if eventImage.value == nil {
            URLRequest.loadData(url: URL(string: ev.value.image)!)
                .catchAndReturn(Data())
                .subscribe(onNext: { [weak self] data in
                    self?.eventImage.accept(UIImage(data: data))
                }).disposed(by: disposeBag)
        }
    }
    
    func checkin() {
        
        let postData = ["eventId": ev.value.id, "name": "pessoa", "email": "emaildapessoa"]
        
        URLRequest.post(url: URL(string: Event.checkInEndpoint)!, httpBody: postData)
            .catchAndReturn(RequestResult.fail)
            .subscribe(onNext: { [weak self] requestResult in
                DispatchQueue.main.async() {
                    self?.delegate?.checkInResult(result: requestResult)
                }
            }).disposed(by: disposeBag)
    }
}

protocol EventDetailViewModelDelegate {
    func checkInResult(result: RequestResult)
    func requestError()
}

struct Coordinate {
    let latitude : Double
    let longitude : Double
}
