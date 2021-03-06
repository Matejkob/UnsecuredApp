//
//  AuthenticationManager.swift
//  Secured App
//
//  Created by Mateusz Bąk on 24/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import Foundation

protocol AuthenticationManagerProtocol {
    func createSessionWith(username: String, password: String, completion: @escaping (Error?) -> Void)
    func getSessionToken() -> String?
    func removeSessionToken()
}

final class AuthenticationManager: AuthenticationManagerProtocol {
    
    static let shared = AuthenticationManager()
        
    private let requestTokenNetworkManager = NetworkManager<AuthenticationService, RequestToken>()
    private let sessionNetworkManager = NetworkManager<AuthenticationService, Session>()
    private let keychainWrapper: KeychainWrapperProtocol = KeychainWrapper(keychainOperations: KeychainOperations())
    
    private var sessionToken: String?
    
}

extension AuthenticationManager {
    func createSessionWith(username: String, password: String, completion: @escaping (Error?) -> Void) {
        createRequestToken(username: username, password: password, completion: completion)
    }
    
    func getSessionToken() -> String? {
        if let sessionToken = sessionToken { return sessionToken }
        
        do {
            guard let data = try keychainWrapper.get(account: Configurator.sessionIdDatabaseKey) else { return nil }
            let sessionToken = String(data: data, encoding: .utf8)
            self.sessionToken = sessionToken
            return sessionToken
        } catch {
            return nil
        }
    }
    
    func removeSessionToken() {
        do {
            try keychainWrapper.delete(account: Configurator.sessionIdDatabaseKey)
            self.sessionToken = nil
        } catch {
            
        }
    }
}

private extension AuthenticationManager {
    func createRequestToken(username: String, password: String, completion: @escaping (Error?) -> Void) {
        requestTokenNetworkManager.request(from: .createRequestToken) { [weak self] result in
            switch result {
            case .success(let requestToken):
                self?.createSessionWithLogin(username: username, password: password, requestToken: requestToken.requestToken, completion: completion)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func createSessionWithLogin(username: String, password: String, requestToken: String, completion: @escaping (Error?) -> Void) {
        requestTokenNetworkManager.request(from: .createSessionWithLogin(username: username, password: password, requestToken: requestToken)) { [weak self] result in
            switch result {
            case .success(let requestToken):
                self?.createSession(requestToken: requestToken.requestToken, completion: completion)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func createSession(requestToken: String, completion: @escaping (Error?) -> Void) {
        sessionNetworkManager.request(from: .createSession(requestToken: requestToken)) { [weak self] result in
            guard let self = self else { completion(nil); return }
            
            switch result {
            case .success(let session):
                do {
                    guard let sessionData = session.sessionID.data(using: .utf8) else {
                        completion(nil)
                        return
                    }
                    try self.keychainWrapper.set(value: sessionData, account: Configurator.sessionIdDatabaseKey)
                    self.sessionToken = session.sessionID
                    
                    completion(nil)
                } catch {
                    completion(error)
                }
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
}
