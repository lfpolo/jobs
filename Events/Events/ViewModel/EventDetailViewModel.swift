//
//  EventDetailViewModel.swift
//  Events
//
//  Created by Luís Felipe Polo on 18/01/21.
//

import RxSwift
import RxCocoa

class EventDetailViewModel {
    let eventId : String
    
    let eventBehaviorRelay = BehaviorRelay<Event>(value: Event.empty)
    let eventImageBehaviorRelay = BehaviorRelay<UIImage?>(value: nil)
    let eventRequestStatus = BehaviorRelay<RequestResult>(value: .none)
    let checkInRequestStatus = BehaviorRelay<RequestResult>(value: .none)
    
    var title : Observable<String>
    var price : Observable<String>
    var date : Observable<String>
    var description : Observable<String>
    var image : Observable<UIImage?>
    var coordinate : Observable<Coordinate>
    let checkinTap = PublishSubject<Void>()
    
    let disposeBag = DisposeBag()
    
    init(eventId : String) {
        self.eventId = eventId
        
        title = eventBehaviorRelay.map { $0.title }
        price = eventBehaviorRelay.map { $0.price.currencyString }
        date = eventBehaviorRelay.map { $0.date.toString }
        description = eventBehaviorRelay.map { $0.description }
        coordinate = eventBehaviorRelay.map { Coordinate(latitude: $0.latitude, longitude: $0.longitude) }
        image = eventImageBehaviorRelay.map { $0 }

        checkinTap.asObservable().subscribe(onNext: { [weak self] in
            self?.checkin()
        }).disposed(by: disposeBag)
    }
    
    func getEvent() {
        guard let url = URL(string: Event.eventsEndpoint + eventId) else {
            eventRequestStatus.accept(.fail)
            return
        }
        
        eventRequestStatus.accept(.waiting)
        let resource : Resource<Event> = Resource(url: url)
        URLRequest.loadObject(resource: resource)
            .subscribe(onNext: { event in
                self.eventRequestStatus.accept(.success)
                self.eventBehaviorRelay.accept(event)
                self.getImage()
            }, onError: { error in
                self.eventRequestStatus.accept(.fail)
            }).disposed(by: disposeBag)
    }
    
    func getImage() {
        if let imageUrl = URL(string: eventBehaviorRelay.value.image), eventImageBehaviorRelay.value == nil {
            URLRequest.loadData(url: imageUrl)
                //.catchAndReturn(Data())
                .subscribe(onNext: { data in
                    self.eventImageBehaviorRelay.accept(UIImage(data: data))
                }, onError: { _ in
                    self.eventImageBehaviorRelay.accept(UIImage(named: "defaultImage"))
                }).disposed(by: disposeBag)
        }
    }
    
    func checkin() {
        guard let url = URL(string: Event.checkInEndpoint) else {
            checkInRequestStatus.accept(.fail)
            return
        }
        
        checkInRequestStatus.accept(.waiting)
        let postData = ["eventId": eventBehaviorRelay.value.id, "name": "pessoa", "email": "emaildapessoa"]
        URLRequest.post(url: url, httpBody: postData)
            .catchAndReturn(RequestResult.fail)
            .subscribe(onNext: { requestResult in
                self.checkInRequestStatus.accept(requestResult)
            }).disposed(by: disposeBag)
    }
}

struct Coordinate {
    let latitude : Double
    let longitude : Double
}
