//
//  Event.swift
//  RestAPIEventos
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
