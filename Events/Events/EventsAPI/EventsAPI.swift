//
//  EventsAPI.swift
//  RestAPIEventos
//
//  Created by Luís Felipe Polo on 17/01/21.
//

import Foundation

class EventsAPI {
    
    let urlEventsAPI = "http://5f5a8f24d44d640016169133.mockapi.io/api/events"

    func getEventList(completion : @escaping ([Event]) -> Void) {
        RequestManager().request(address: urlEventsAPI, requestMethod: .GET) { data in
            completion(self.decode(data: data, type: [Event].self) ?? [])
        }
    }
    
    func getEvent(eventId : String, completion : @escaping (Event) -> Void) {
        RequestManager().request(address: urlEventsAPI + "/" + eventId, requestMethod: .GET) { data in
            if let event = self.decode(data: data, type: Event.self) {
                completion(event)
            }
        }
    }
    
    func checkIn() {
        
    }
    
    func decode<T : Decodable>(data : Data, type : T.Type) -> T? {
        do {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .secondsSince1970
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            print("JSON error: \(error.localizedDescription)")
        }
        
        return nil
    }
}

