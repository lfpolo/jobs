//
//  Request.swift
//  Events
//
//  Created by Luís Felipe Polo on 17/01/21.
//

import Foundation

class RequestManager {
    
    func request(address : String, requestMethod : RequestMethod, httpBody : [String: String] = [:], completion : @escaping (Data?, RequestResult) -> Void) {
        
        guard let url = URL(string: address) else {
            print("URL inválida")
            completion(nil, .fail)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = requestMethod.rawValue
        
        if requestMethod == .POST {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: httpBody)
        }
            
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            if let error = error {
                print("DataTask error: " + error.localizedDescription)
                completion(nil, .fail)
            } else if let requestResponse = response as? HTTPURLResponse, requestResponse.statusCode == 200 || requestResponse.statusCode == 201 {
                    completion(data, .success)
            } else {
                completion(nil, .fail)
            }
        }).resume()
    }
}

enum RequestMethod : String {
    case POST = "POST"
    case GET = "GET"
}

enum RequestResult {
    case success, fail
}
