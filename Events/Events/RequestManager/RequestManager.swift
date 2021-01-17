//
//  Request.swift
//  RestAPIEventos
//
//  Created by Luís Felipe Polo on 17/01/21.
//

import Foundation

class RequestManager {
    
    func request(address : String, requestMethod : RequestMethod, completion : @escaping (Data) -> Void) {
        
        guard let url = URL(string: address) else {
            print("URL inválida")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = requestMethod.rawValue
            
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
                if let requestData = data {
                    completion(requestData)
                }
            }
        ).resume()
    }
}

enum RequestMethod : String {
    case POST = "POST"
    case GET = "GET"
}
