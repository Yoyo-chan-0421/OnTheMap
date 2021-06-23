//
//  Client.swift
//  On the Map
//
//  Created by YoYo on 2021-06-10.
//

import Foundation
class Client{
    struct Auth {
        static var uniqueKey = ""
        static var sessionId = ""
        static var objectId = ""
        static var firstName = ""
        static var lastName = ""
    }

    
    class func taskForGetRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completionHandler: @escaping(ResponseType?, Error?) -> Void){
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else{
                completionHandler(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do{
                let response = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(response, nil)
                }
            }catch{
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func taskForPostRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, response: ResponseType.Type, body: RequestType, completionHandler: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        request.httpBody = try! encoder.encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(response, nil)
                }
            } catch {
                let range = 5..<data.count
                let newData = data.subdata(in: range)
                do {
                    let newResponseObject = try decoder.decode(ResponseType.self, from: newData)
                    DispatchQueue.main.async {
                        completionHandler(newResponseObject, nil)
                    }
                } catch {
                    do {
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: newData)
                        DispatchQueue.main.async {
                            completionHandler(nil, errorResponse)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completionHandler(nil, error)
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    class func getStudentLocation(completionHandler: @escaping ([StudentLocation], Error?) -> Void){
        taskForGetRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updatedAt")!, response: StudenLocationFinal.self) { response, error in
            if let response = response{
                DispatchQueue.main.async {
                    completionHandler(response.results, nil)
                }
            }else{
                DispatchQueue.main.async {
                    completionHandler([], error)
                }
            }
        }
    }
    
    class func postStudentLocation(firstName: String, lastName: String, mapString: String, mediaURL: String, completionHandler: @escaping (Bool, Error?) -> Void){
        let body = PostStudentLocation(uniqueKey: Auth.uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: LatAndLong.lat, longitude: LatAndLong.long)
        taskForPostRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!, response: PostStudentLocationResponse.self, body: body) { response, error in
            if let response = response{
                print(response.createdAt)
                DispatchQueue.main.async {
                    completionHandler(true, nil)
                }
            }else{
                DispatchQueue.main.async {
                    completionHandler(false, error)
                }
               
            }
        }
    }
  
    class func postSession(username: String, password: String, completionHandler: @escaping (Bool, Error?) -> Void){
        let body = LoginRequest(udacity: ["username" : "\(username)", "password": "\(password)"])
        taskForPostRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!, response: PostSession.self, body: body) { response, error in
            if let response = response{
                Auth.sessionId = response.session.id
                Auth.objectId = response.account.key
                DispatchQueue.main.async {
                    completionHandler(true, nil)
                }
            }else{
                DispatchQueue.main.async {
                    completionHandler(false, error)
                }
            }
        }
    }
    
    class func logout(completionHandler: @escaping () -> Void){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies!{
            if cookie.name == "XSRF-TOKEN" {xsrfCookie = cookie}
        }
        if let xsrfCookie = xsrfCookie{
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil{
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            print(String(data: newData!, encoding: .utf8)!)
            Auth.sessionId = ""
            Auth.objectId = ""
            completionHandler()
        }
        task.resume()
    }
    
    class func getPublicData(completionHandler: @escaping (String?, String?, Error?) -> Void){
        taskForGetRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/\(Auth.objectId)")!, response: PublicUserDataResponse.self ) { response, error in
            if let response = response{
                Auth.firstName = response.firstName
                Auth.lastName = response.lastName
                Auth.uniqueKey = response.key
                DispatchQueue.main.async {
                    completionHandler(response.firstName,response.lastName, nil)
                }
                print(response)
            }else{
                DispatchQueue.main.async {
                    completionHandler(nil, nil, error)
                }
            }
        }
    }
}
