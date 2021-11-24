//
//  DataStore.swift
//  CleanArchitecture
//
//  Created by TsubasaKogoma on 2021/11/22.
//

import Foundation


class UserDefaultsDataStore: DataStoreProtocol {
    private let userDefaults = UserDefaults.standard
    
    func fetch(ids: [String], completion: @escaping ([String : Bool]) -> Void) {
        let all = allLikes()
        let result = all.filter { (k, v) -> Bool in
            ids.contains{ $0 == k }
        }
        completion(result)
    }
    
    func save(liked: Bool, for id: String, completion: @escaping (Bool) -> Void) {
        var all = allLikes()
        all[id] = liked
        userDefaults.set(all, forKey: "likes")
        //let pairs = all.map { (k, v) in (k, v) }
        //let newAll = Dictionary(uniqueKeysWithValues: pairs)
        //userDefaults.set(newAll, forKey: "likes")
        completion(liked)
    }
    
    func allLikes(completion: @escaping ([String : Bool]) -> Void) {
        completion(allLikes())
    }
    
    private func allLikes() -> [String: Bool] {
        if let dictionary = userDefaults.dictionary(forKey: "likes") as? [String: Bool] {
            let pair = dictionary.map { (k, v) in (k, v) }
            let likes = Dictionary(uniqueKeysWithValues: pair)
            return likes
        } else {
            return [:]
        }
    }
}
