//
//  DataStore.swift
//  CleanArchitecture
//
//  Created by TsubasaKogoma on 2021/11/22.
//

import Foundation


class UserDefaultsDataStore: DataStoreProtocol {
    private let userDefaults = UserDefaults.standard
    
    /// 値を取ってくる
    func fetch(ids: [String], completion: @escaping ([String : Bool]) -> Void) {
        let all = allLikes()
        let result = all.filter { (k, v) -> Bool in
            ids.contains{ $0 == k }
        }
        completion(result)
    }
    
    /// お気に入りに保存する
    func save(liked: Bool, for id: String, completion: @escaping (Bool) -> Void) {
        var all = allLikes()
        all[id] = liked
        /// trueが来たら保存し、falseが来たら除外する
        all = all.filter { $0.value == true }
        userDefaults.set(all, forKey: "likes")
        completion(liked)
    }
    
    /// 全てのお気に入りを返す
    func getAllLike(completion: @escaping ([String : Bool]) -> Void) {
        completion(allLikes())
    }
    
    /// 保存されている全ての値を取り出す
    private func allLikes() -> [String: Bool] {
        if let dictionarys = userDefaults.dictionary(forKey: "likes") as? [String: Bool] {
            return dictionarys
        } else {
            return [:]
        }
    }
}
