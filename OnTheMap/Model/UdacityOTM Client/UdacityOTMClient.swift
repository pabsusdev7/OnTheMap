//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Pablo Albuja on 7/14/19.
//  Copyright © 2019 Ingenuity Applications. All rights reserved.
//

import Foundation

class UdacityOTMClient {
    
    struct Auth {
        static var accountId = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case getStudentLocations(Int,String,Bool)
        case getUserInfo
        case postStudentLocation
        case login
        case signUp
        
        var stringValue: String {
            switch self {
            case .getStudentLocations(let limit, let orderBy, let asc): return Endpoints.base + "/StudentLocation?limit=\(limit)&order=\(!asc ? "-" : "")\(orderBy)"
            case .postStudentLocation: return Endpoints.base + "/StudentLocation"
            case .login: return Endpoints.base + "/session"
            case .signUp: return "https://auth.udacity.com/signup"
            case .getUserInfo: return Endpoints.base + "/users/\(Auth.accountId)"
                
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask{
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard var data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            if url == Endpoints.getUserInfo.url {
                let range = 5..<data.count
                data = data.subdata(in: range)
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                        completion(nil, error)
                }
                
            }
        }
        task.resume()
        
        return task
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void){
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try! JSONEncoder().encode(body)
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard var data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            if url == Endpoints.login.url {
                let range = 5..<data.count
                data = data.subdata(in: range)
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func taskForDELETERequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void){
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard var data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            if url == Endpoints.login.url {
                let range = 5..<data.count
                data = data.subdata(in: range)
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func getStudentLocations(limit: Int, orderBy: String, asc: Bool,completion: @escaping ([StudentLocation], Error?) -> Void) {
        
        taskForGETRequest(url: Endpoints.getStudentLocations(limit, orderBy, asc).url, responseType: StudentLocationResults.self, completion: {(response, error)
            in
            if let response=response{
                print(response.results)
                completion(response.results,nil)
            }else{
                completion([], error)
            }
        })
    }
    
    class func getUserInfo(completion: @escaping (UserInfoResponse?, Error?) -> Void) {
        
        taskForGETRequest(url: Endpoints.getUserInfo.url, responseType: UserInfoResponse.self, completion: {(response, error)
            in
            if let response=response{
                print(response)
                completion(response,nil)
            }else{
                completion(nil, error)
            }
        })
    }
    
    class func postLocation(studentLocation: StudentLocation, completion: @escaping (Bool?, Error?) -> Void){
        
        let body = studentLocation
        taskForPOSTRequest(url: Endpoints.postStudentLocation.url, responseType: StudentLocationResponse.self, body: body, completion: {(response, error)
            in
            if let response = response {
                StudentLocationModel.selectedStudentLocation.objectId = response.objectId
                StudentLocationModel.selectedStudentLocation.createdAt = response.createdAt
                completion(true, nil)
            } else{
                completion(false, error)
            }
            
        })
        
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        
        let body = LoginRequest(udacity: Credentials(username: username, password: password))
        taskForPOSTRequest(url: Endpoints.login.url, responseType: LoginResponse.self, body: body, completion: {(response, error)
            in
            if let response = response{
                Auth.sessionId = response.session.id
                Auth.accountId = response.account.key
                completion(true ,nil)
            }else{
                completion(false, error)
            }
        })
    }
    
    class func logout(completion: @escaping (Bool, Error?) -> Void) {
        
        taskForDELETERequest(url: Endpoints.login.url, responseType: LogoutResponse.self, completion: {(response, error)
            in
            if response != nil{
                Auth.sessionId = ""
                completion(true ,nil)
            }else{
                completion(false, error)
            }
        })
    }
    
    
    
}
