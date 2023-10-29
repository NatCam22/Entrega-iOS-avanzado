//
//  ApiProvider.swift
//  DragonBallAvanzado
//
//  Created by Natalia Hernandez on 27/10/23.
//
import Foundation

extension NotificationCenter{
    static let apiLoginNotification = Notification.Name("NOTIFICATION_API_LOGIN")
    static let apiToken = "KEY_TOKEN"
}
protocol ApiProviderProtocol{
    func login(for user: String, with password: String)
    func getHeroes(by name: String?, with token: String, completion: (([Hero]) -> Void)?)
    func getLocations(by heroId: String?, with token: String, completion: ((Locations) -> Void)?)
}

class ApiProvider: ApiProviderProtocol{
    
    static private let apiBaseURL = "https://dragonball.keepcoding.education/api"
    private enum Endpoint {
        static let login = "/auth/login"
        static let getHeroes = "/heros/all"
        static let getLocations = "/heros/locations"
    }
    
   //MARK: - Funciones públicas heredadas del protocolo
    func login(for user: String, with password: String){
        guard let url = URL(string: "\(ApiProvider.apiBaseURL)\(Endpoint.login)") else {
            return
        }
        guard let loginData = String(format: "%@:%@", user, password).data(using: .utf8)?.base64EncodedString() else{
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Basic \(loginData)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlRequest){
            (data, response, error) in
            guard error == nil else{
                //TODO: enviar notificacion con error.
                return
            }
            //guard let data ===== guard let data = data
            guard let data, (response as? HTTPURLResponse)?.statusCode == 200 else{
                //TODO: enviar notificacion con error de respuesta
                return
            }
            guard let responseData = String(data: data, encoding: .utf8) else{
                //TODO: Enviar notificacion indicando response vacio
                return
            }
            NotificationCenter.default.post(
                name: NotificationCenter.apiLoginNotification, 
                object: nil, 
                userInfo: [NotificationCenter.apiToken : responseData])
            
        }.resume()
    }
    
    func getHeroes(by name: String?, with token: String, completion: (([Hero]) -> Void)?) {
        guard let url = URL(string: "\(ApiProvider.apiBaseURL)\(Endpoint.getHeroes)") else {
            return
        }
        let inputData: [String: Any] = ["name": name ?? ""]
        let inputToJson = try? JSONSerialization.data(withJSONObject: inputData)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json; charset=utf-8",
                            forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = inputToJson
        
        URLSession.shared.dataTask(with: urlRequest){
            (data, response, error) in
            guard error == nil else{
                //TODO: enviar notificacion con error.
                completion?([])
                return
            }
            //guard let data ===== guard let data = data
            guard let data, (response as? HTTPURLResponse)?.statusCode == 200 else{
                //TODO: enviar notificacion con error de respuesta
                completion?([])
                return
            }
            guard let heroes = try? JSONDecoder().decode([Hero].self, from: data) else{
                completion?([])
                return
            }
            completion?(heroes)
            
            
        }.resume()
    }
    
    func getLocations(by heroId: String?, with token: String, completion: ((Locations) -> Void)?) {
        guard let url = URL(string: "\(ApiProvider.apiBaseURL)\(Endpoint.getLocations)") else {
            return
        }
        let inputData: [String: Any] = ["id": heroId ?? ""]
        let inputToJson = try? JSONSerialization.data(withJSONObject: inputData)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json; charset=utf-8",
                            forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = inputToJson
        
        URLSession.shared.dataTask(with: urlRequest){
            (data, response, error) in
            guard error == nil else{
                //TODO: enviar notificacion con error.
                completion?([])
                return
            }
            //guard let data ===== guard let data = data
            guard let data, (response as? HTTPURLResponse)?.statusCode == 200 else{
                //TODO: enviar notificacion con error de respuesta
                completion?([])
                return
            }
            guard let locations = try? JSONDecoder().decode(Locations.self, from: data) else{
                completion?([])
                return
            }
            print("API RESPONSE LOCATIONS: \(locations)")
            completion?(locations)

        }.resume()
    }
    
    //MARK: funciones privadas

    
}
