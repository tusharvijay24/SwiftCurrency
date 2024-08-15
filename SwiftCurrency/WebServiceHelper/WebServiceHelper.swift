//
//  WebServiceHelper.swift
//  SwiftCurrency
//
//  Created by Tushar on 14/08/24.
//

import Foundation
import Alamofire
import Reachability

class WebServiceHelper {
    
    static let shared = WebServiceHelper()
    
     init() { }
    
    func get<T: Decodable>(url: String, parameters: Parameters?, headers: HTTPHeaders?, completion: @escaping (Result<T, Error>) -> Void) {
        request(url: url, method: .get, parameters: parameters, headers: headers, completion: completion)
    }
    
    func getString<T: Decodable>(url: String, parameters: Parameters?, headers: HTTPHeaders?, completion: @escaping (Result<T, Error>) -> Void) {
        requestString(url: url, method: .get, parameters: parameters, headers: headers, completion: completion)
    }
    
    func post<T: Decodable>(url: String, parameters: Parameters?, headers: HTTPHeaders?, completion: @escaping (Result<T, Error>) -> Void) {
        request(url: url, method: .post, parameters: parameters, headers: headers, completion: completion)
    }
    
    func put<T: Decodable>(url: String, parameters: Parameters?, headers: HTTPHeaders?, completion: @escaping (Result<T, Error>) -> Void) {
        request(url: url, method: .put, parameters: parameters, headers: headers, completion: completion)
    }
    
    func delete<T: Decodable>(url: String, parameters: Parameters?, headers: HTTPHeaders?, completion: @escaping (Result<T, Error>) -> Void) {
        request(url: url, method: .delete, parameters: parameters, headers: headers, completion: completion)
    }
    
    private func request<T: Decodable>(url: String, method: HTTPMethod, parameters: [String: Any]?, headers: HTTPHeaders?, completion: @escaping (Result<T, Error>) -> Void) {
        if NetworkManager.shared.isReachable {
            let encoding: ParameterEncoding = method == .get ? URLEncoding.default : JSONEncoding.default
            AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
                .validate(statusCode: 200..<300) 
                .responseData { response in
                    print(response.request?.url as Any)
                    switch response.result {
                    case .success(let data):
                        print("Response Data: \(String(data: data, encoding: .utf8) ?? "Unable to decode data as UTF-8 string.")")
                        
                        do {
                            let decoder = JSONDecoder()
                            let decodedObject = try decoder.decode(T.self, from: data)
                            completion(.success(decodedObject))
                        } catch {
                            print("Decoding error: \(error)")
                            completion(.failure(error))
                        }
                    case .failure(let error):
                        print("Request failed with error: \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                }
        } else {
            let notConnectedError = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
            print("Network not reachable: \(notConnectedError.localizedDescription)")
            completion(.failure(AFError.sessionTaskFailed(error: notConnectedError)))
        }
    }
    
    
    func requestString<T: Decodable>(url: String, method: HTTPMethod, parameters: [String: Any]?, headers: HTTPHeaders?, completion: @escaping (Result<T, Error>) -> Void) {
        if NetworkManager.shared.isReachable {
            let encoding: ParameterEncoding = method == .get ? URLEncoding.default : JSONEncoding.default
            AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseData { response in
                print("Request URL: \(response.request?.url?.absoluteString ?? "No URL")")
                print("Response Data: \(String(data: response.data ?? Data(), encoding: .utf8) ?? "Unable to decode data as UTF-8 string.")")
                
                switch response.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let decodedObject = try decoder.decode(T.self, from: data)
                        completion(.success(decodedObject))
                    } catch let decodingError {
                        print("Decoding error: \(decodingError)")
                        completion(.failure(decodingError))
                    }
                case .failure(let error):
                    print("Request failed with error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        } else {
            let notConnectedError = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
            print("Network not reachable. Error: \(notConnectedError.localizedDescription)")
            completion(.failure(AFError.sessionTaskFailed(error: notConnectedError)))
        }
    }
}
