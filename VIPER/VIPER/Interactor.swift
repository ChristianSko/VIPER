//
//  Interactor.swift
//  VIPER
//
//  Created by Christian Skorobogatow on 5/5/21.
//

import Foundation


// Object
// Protocol
// reference to presenter

//  API CALL

// https://jsonplaceholder.typicode.com/users


protocol AnyInteractor {
    var presenter: AnyPresenter? { get set }
    
    func getUsers()
}


class UserInteractor: AnyInteractor {
    var presenter: AnyPresenter?
    
    func getUsers() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self]data, _, error in
            guard let data = data, error == nil else {
                self?.presenter?.interactorDidFetchUser(with: .failure(FetchError.failed))
                return
            }
            do {
                let entities = try JSONDecoder().decode([User].self, from: data)
                self?.presenter?.interactorDidFetchUser(with: .success(entities))
            }
            catch {
                self?.presenter?.interactorDidFetchUser(with: .failure(error))
            }
        }
        task.resume()
    }
}
