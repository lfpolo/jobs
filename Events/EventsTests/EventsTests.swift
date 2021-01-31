//
//  EventsTests.swift
//  EventsTests
//
//  Created by Luís Felipe Polo on 16/01/21.
//

import XCTest
@testable import Events

class EventsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testEventDecoder() throws {
        // Given
        let json = #"""
        {"people":[{"name":"Luis Felipe Polo","email":"lfpolo@inf.ufrgs.br"}, {"name":"John Doe","email":"email@email.com.br"}],"date":1534784400,"description":"O Patas Dadas estará na Redenção, nesse domingo, com cães para adoção e produtos à venda!\n\nNa ocasião, teremos bottons, bloquinhos e camisetas!\n\nTraga seu Pet, os amigos e o chima, e venha aproveitar esse dia de sol com a gente e com alguns de nossos peludinhos - que estarão prontinhos para ganhar o ♥ de um humano bem legal pra chamar de seu. \n\nAceitaremos todos os tipos de doação:\n- guias e coleiras em bom estado\n- ração (as que mais precisamos no momento são sênior e filhote)\n- roupinhas \n- cobertas \n- remédios dentro do prazo de validade","image":"http://lproweb.procempa.com.br/pmpa/prefpoa/seda_news/usu_img/Papel%20de%20Parede.png","longitude":-51.2146267,"latitude":-30.0392981,"price":29.99,"title":"Feira de adoção de animais na Redenção","id":"1"}
        """#
        let data = json.data(using: .utf8)!

        // When
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .secondsSince1970
        let event = try jsonDecoder.decode(Event.self, from: data)
     
        // Then
        XCTAssertTrue(event.people[0].name == "Luis Felipe Polo")
        XCTAssertTrue(event.people[0].email == "lfpolo@inf.ufrgs.br")
        XCTAssertTrue(event.people[1].name == "John Doe")
        XCTAssertTrue(event.people[1].email == "email@email.com.br")
        XCTAssertTrue(event.date == Date(timeIntervalSince1970: 1534784400))
        XCTAssertTrue(event.description == "O Patas Dadas estará na Redenção, nesse domingo, com cães para adoção e produtos à venda!\n\nNa ocasião, teremos bottons, bloquinhos e camisetas!\n\nTraga seu Pet, os amigos e o chima, e venha aproveitar esse dia de sol com a gente e com alguns de nossos peludinhos - que estarão prontinhos para ganhar o ♥ de um humano bem legal pra chamar de seu. \n\nAceitaremos todos os tipos de doação:\n- guias e coleiras em bom estado\n- ração (as que mais precisamos no momento são sênior e filhote)\n- roupinhas \n- cobertas \n- remédios dentro do prazo de validade")
        XCTAssertTrue(event.image == "http://lproweb.procempa.com.br/pmpa/prefpoa/seda_news/usu_img/Papel%20de%20Parede.png")
        XCTAssertTrue(event.longitude == -51.2146267)
        XCTAssertTrue(event.latitude == -30.0392981)
        XCTAssertTrue(event.price == 29.99)
        XCTAssertTrue(event.id == "1")
    }
    
    func testEventListDecoder() throws {
        // Given
        let json = #"""
        [{"people":[{"name":"Luis Felipe Polo","email":"lfpolo@inf.ufrgs.br"}, {"name":"John Doe","email":"email@email.com.br"}],"date":1534784400,"description":"O Patas Dadas estará na Redenção, nesse domingo, com cães para adoção e produtos à venda!\n\nNa ocasião, teremos bottons, bloquinhos e camisetas!\n\nTraga seu Pet, os amigos e o chima, e venha aproveitar esse dia de sol com a gente e com alguns de nossos peludinhos - que estarão prontinhos para ganhar o ♥ de um humano bem legal pra chamar de seu. \n\nAceitaremos todos os tipos de doação:\n- guias e coleiras em bom estado\n- ração (as que mais precisamos no momento são sênior e filhote)\n- roupinhas \n- cobertas \n- remédios dentro do prazo de validade","image":"http://lproweb.procempa.com.br/pmpa/prefpoa/seda_news/usu_img/Papel%20de%20Parede.png","longitude":-51.2146267,"latitude":-30.0392981,"price":29.99,"title":"Feira de adoção de animais na Redenção","id":"1"},{"people":[],"date":1534784400,"description":"descriçao","image":"imageUrl","longitude":-52,"latitude":-87,"price":55,"title":"titulo","id":"2"}]
        """#
        let data = json.data(using: .utf8)!
        
        // When
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .secondsSince1970
        let events = try jsonDecoder.decode([Event].self, from: data)
     
        // Then
        XCTAssertTrue(events[0].people[0].name == "Luis Felipe Polo")
        XCTAssertTrue(events[0].people[0].email == "lfpolo@inf.ufrgs.br")
        XCTAssertTrue(events[0].people[1].name == "John Doe")
        XCTAssertTrue(events[0].people[1].email == "email@email.com.br")
        XCTAssertTrue(events[0].date == Date(timeIntervalSince1970: 1534784400))
        XCTAssertTrue(events[0].description == "O Patas Dadas estará na Redenção, nesse domingo, com cães para adoção e produtos à venda!\n\nNa ocasião, teremos bottons, bloquinhos e camisetas!\n\nTraga seu Pet, os amigos e o chima, e venha aproveitar esse dia de sol com a gente e com alguns de nossos peludinhos - que estarão prontinhos para ganhar o ♥ de um humano bem legal pra chamar de seu. \n\nAceitaremos todos os tipos de doação:\n- guias e coleiras em bom estado\n- ração (as que mais precisamos no momento são sênior e filhote)\n- roupinhas \n- cobertas \n- remédios dentro do prazo de validade")
        XCTAssertTrue(events[0].image == "http://lproweb.procempa.com.br/pmpa/prefpoa/seda_news/usu_img/Papel%20de%20Parede.png")
        XCTAssertTrue(events[0].longitude == -51.2146267)
        XCTAssertTrue(events[0].latitude == -30.0392981)
        XCTAssertTrue(events[0].price == 29.99)
        XCTAssertTrue(events[0].id == "1")
        
        XCTAssertTrue(events[1].people.count == 0)
        XCTAssertTrue(events[1].date == Date(timeIntervalSince1970: 1534784400))
        XCTAssertTrue(events[1].description == "descriçao")
        XCTAssertTrue(events[1].image == "imageUrl")
        XCTAssertTrue(events[1].longitude == -52)
        XCTAssertTrue(events[1].latitude == -87)
        XCTAssertTrue(events[1].price == 55)
        XCTAssertTrue(events[1].id == "2")
    }
    
    func testDateString() throws {
        // Given
        let date = Date(timeIntervalSince1970: 1534784400) //10/08/2018
        
        // Then
        XCTAssertTrue(date.toString == "20/08/2018")
    }
    
    func testCurrencyString() throws {
        // Given
        let n : Double = 7.8
        
        // Then
        XCTAssertTrue(n.currencyString == "R$7.80")
    }

}
