//
//  Decoder.swift
//  RestAPIEventos
//
//  Created by Luís Felipe Polo on 18/01/21.
//

import Foundation

class Decoder {

    func decode<T : Decodable>(data : Data?, type : T.Type) -> T? {
        if let data = data {
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .secondsSince1970
                return try jsonDecoder.decode(T.self, from: data)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        return nil
    }
}
