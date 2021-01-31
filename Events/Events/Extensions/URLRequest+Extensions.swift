//
//  URLRequest+Extensions.swift
//  Events
//
//  Created by Luís Felipe Polo on 25/01/21.
//

import RxSwift
import RxCocoa

struct Resource<T: Decodable> {
    let url: URL
}

extension URLRequest {
    static func loadObject<T: Decodable>(resource : Resource<T>) -> Observable<T> {
        return Observable.just(resource.url)
            .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
                return URLSession.shared.rx.response(request: URLRequest(url: url))
            }.map { response, data -> T in
                if 200..<300 ~= response.statusCode {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.dateDecodingStrategy = .secondsSince1970
                    return try jsonDecoder.decode(T.self, from: data)
                } else {
                    throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
                }
            }.asObservable()
    }
    
    static func loadData(url : URL) -> Observable<Data> {
        return Observable.just(url)
            .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
                return URLSession.shared.rx.response(request: URLRequest(url: url))
            }.map { response, data -> Data in
                if 200..<300 ~= response.statusCode {
                    return data
                } else {
                    throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
                }
            }.asObservable()
    }
    
    static func post(url : URL, httpBody : [String: String]) -> Observable<RequestResult> {
        return Observable.just(url)
            .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = try? JSONSerialization.data(withJSONObject: httpBody)
                return URLSession.shared.rx.response(request: URLRequest(url: url))
            }.map { response, data -> RequestResult in
                if 200..<300 ~= response.statusCode {
                    return RequestResult.success
                } else {
                    throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
                }
            }.asObservable()
    }
}

enum RequestResult {
    case success, fail, waiting, none
}
