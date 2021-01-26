//
//  Event.swift
//  Events
//
//  Created by Luís Felipe Polo on 17/01/21.
//

import Foundation

struct Event : Decodable {
    var id : String
    var title : String
    var price : Double
    var date : Date
    var description : String
    var latitude : Double
    var longitude : Double
    var image : String
    var people : [Participant]
}

extension Event {
    static var empty : Event {
        return Event(id: "", title: "", price: 0, date: Date(), description: "", latitude: 0, longitude: 0, image: "", people: [])
    }
    
    static var eventsEndpoint : String {
        return "http://5f5a8f24d44d640016169133.mockapi.io/api/events/"
    }
    
    static var checkInEndpoint : String {
        return "http://5f5a8f24d44d640016169133.mockapi.io/api/checkin/"
    }
}
