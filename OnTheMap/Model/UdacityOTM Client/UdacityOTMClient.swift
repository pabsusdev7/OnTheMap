//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Pablo Albuja on 7/14/19.
//  Copyright © 2019 Ingenuity Applications. All rights reserved.
//

import Foundation

class UdacityOTMClient {
    
    static let apiKey = "144125bc982ce6f6aa64e29bd78d3a3e"
    
    struct Auth {
        static var accountId = 0
        static var requestToken = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        static let apiKeyParam = "?api_key=\(UdacityOTMClient.apiKey)"
        
        case getStudentLocations(Int,String,Bool)
        case getWatchlist
        case getFavoriteList
        case getRequestToken
        case login
        case logout
        case getSession
        case webLogin
        case search(String)
        case markWatchList
        case markFavorite
        case posterImageURL(String)
        
        var stringValue: String {
            switch self {
            case .getStudentLocations(let limit, let orderBy, let asc): return Endpoints.base + "/StudentLocation?limit=\(limit)&order=\(!asc ? "-" : "")\(orderBy)"
            case .getWatchlist: return Endpoints.base + "/account/\(Auth.accountId)/watchlist/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            case .getFavoriteList: return Endpoints.base + "/account/\(Auth.accountId)/favorite/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            case .getRequestToken: return Endpoints.base + "/authentication/token/new" + Endpoints.apiKeyParam
            case .login: return Endpoints.base + "/authentication/token/validate_with_login" + Endpoints.apiKeyParam
            case .getSession: return Endpoints.base + "/authentication/session/new" + Endpoints.apiKeyParam
            case .webLogin: return "https://www.themoviedb.org/authenticate/" + Auth.requestToken + "?redirect_to=themoviemanager:authenticate"
            case .logout: return Endpoints.base + "/authentication/session" + Endpoints.apiKeyParam
            case .search(let query): return Endpoints.base + "/search/movie" + Endpoints.apiKeyParam + "&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
            case .markWatchList: return Endpoints.base + "/account/\(Auth.accountId)/watchlist" + Endpoints.apiKeyParam + "&session_id="+Auth.sessionId
            case .markFavorite: return Endpoints.base + "/account/\(Auth.accountId)/favorite" + Endpoints.apiKeyParam + "&session_id="+Auth.sessionId
            case .posterImageURL(let posterPath): return "https://image.tmdb.org/t/p/w500" + posterPath
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask{
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
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
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
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
    
    class func downloadPosterImage(posterPath: String, completion: @escaping (Data?,Error?)->Void){
        let task = URLSession.shared.dataTask(with: Endpoints.posterImageURL(posterPath).url){ (data, response, error) in
            guard let data=data else {
                completion(nil,error)
                return
                
            }
            let dowloadedImage = data
            completion(dowloadedImage,nil)
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
    
    
    
}
