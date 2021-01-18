//
//  EventsAPI.swift
//  Events
//
//  Created by Luís Felipe Polo on 17/01/21.
//

import Foundation

class EventsAPI {
    
    let urlEventsAPI = "http://5f5a8f24d44d640016169133.mockapi.io/api/"
    let eventsEnpoint = "events/"
    let checkinEndpoint = "checkin"

    func getEventList(completion : @escaping ([Event], RequestResult) -> Void) {
        RequestManager().request(address: urlEventsAPI + eventsEnpoint, requestMethod: .GET) { data, result in
            completion(Decoder().decode(data: data, type: [Event].self) ?? [], result)
        }
    }
    
    func getEvent(eventId : String, completion : @escaping (Event?, RequestResult) -> Void) {
        RequestManager().request(address: urlEventsAPI + eventsEnpoint + eventId, requestMethod: .GET) { data, result in
            completion(Decoder().decode(data: data, type: Event.self), result)
        }
    }
    
    func checkIn(eventId : String, completion : @escaping (RequestResult) -> Void) {
        
        let postData = ["eventId": eventId, "name": "pessoa", "email": "emaildapessoa"]
        
        RequestManager().request(address: urlEventsAPI + checkinEndpoint, requestMethod: .POST, httpBody: postData) { data, result in

            do {
                if let data = data {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                }
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
            
            completion(result)
        }
    }
}
