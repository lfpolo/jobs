//
//  EventsViewModel.swift
//  Events
//
//  Created by Luís Felipe Polo on 18/01/21.
//

import RxSwift
import RxCocoa

class EventsViewModel {
    
    var imagesBehaviorRelay = BehaviorRelay<[String: UIImage]>(value: [:])
    var eventsBehaviorRelay = BehaviorRelay<[Event]>(value: [])
    let eventsRequestStatus = BehaviorRelay<RequestResult>(value: .none)
    let disposeBag = DisposeBag()
    
    func getEvents() {
        guard let url = URL(string: Event.eventsEndpoint) else {
            eventsRequestStatus.accept(.fail)
            return
        }
        
        eventsRequestStatus.accept(.waiting)
        let resource : Resource<[Event]> = Resource(url: url)
        URLRequest.loadObject(resource: resource)
            .subscribe(onNext: { response in
                self.eventsRequestStatus.accept(.success)
                self.eventsBehaviorRelay.accept(response)
                self.getImages()
            }, onError: { error in
                self.eventsRequestStatus.accept(.fail)
            }).disposed(by: disposeBag)
    }
    
    func getImages() {
        for event in eventsBehaviorRelay.value {
            if let url = URL(string: event.image), imagesBehaviorRelay.value[event.id] == nil {
                URLRequest.loadData(url: url)
                    .subscribe(onNext: { data in
                        var images = self.imagesBehaviorRelay.value
                        images[event.id] = UIImage(data: data)
                        self.imagesBehaviorRelay.accept(images)
                    }).disposed(by: disposeBag)
            }
        }
    }
}
