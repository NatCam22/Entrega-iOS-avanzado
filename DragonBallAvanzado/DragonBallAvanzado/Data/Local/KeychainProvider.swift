//
//  KeychainProvider.swift
//  DragonBallAvanzado
//
//  Created by Natalia Hernandez on 27/10/23.
//

import Foundation
import KeychainSwift

protocol KeychainProviderProtocol{
    func save(token: String)
    func getToken() -> String?
    func deleteToken()
}

final class KeychainProvider:KeychainProviderProtocol {
    //Queremos guardar información de manera segura en el keychain
    
    private let keychain = KeychainSwift()
    
    private enum Key{
        static let token = "KEY_KEYCHAIN_TOKEN"
    }
    
    func save(token: String){
        keychain.set(token, forKey: Key.token)
    }
    
    func getToken() -> String?{
        keychain.get(Key.token)
    }
    func deleteToken() {
        keychain.set("", forKey: Key.token)
    }
}
