//
//  EventsAPI.swift
//  RestAPIEventos
//
//  Created by Luís Felipe Polo on 17/01/21.
//

import Foundation

class EventsAPI {
    
    let url = "http://5f5a8f24d44d640016169133.mockapi.io/api/events"
    
    func getEventList(completion : @escaping ([Event]) -> Void) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
            
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if let reqData = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.dateDecodingStrategy = .secondsSince1970
                    let eve = try jsonDecoder.decode([Event].self, from: reqData)
                    completion(eve)
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
            }
        }).resume()
    }
    
    func getEvent(eventId : String, completion : @escaping (Event) -> Void) {
        var request = URLRequest(url: URL(string: url + "/" + eventId)!)
        request.httpMethod = "GET"
            
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if let reqData = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.dateDecodingStrategy = .secondsSince1970
                    let eve = try jsonDecoder.decode(Event.self, from: reqData)
                    completion(eve)
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
            }
        }).resume()
    }
}

