//
//  UserDefaultsGateway.swift
//  CleanArchitecture
//
//  Created by TsubasaKogoma on 2021/11/18.
//

import Foundation


protocol DataStoreProtocol: AnyObject {
    // お気に入り情報を検索・保存する
    func fetch(ids: [String], completion: @escaping ([String: Bool]) -> Void)
   
    func save(liked: Bool, for id: String, completion: @escaping (Bool) -> Void)
    
    func getAllLike(completion: @escaping ([String: Bool]) -> Void)

    // リポジトリ情報を保存・検索する
    //func save(repos: [GitHubRepo], completion: @escaping (Result<[GitHubRepo]>) -> Void)
    //func fetch(using ids: [GitHubRepo.ID], completion: @escaping (Result<[GitHubRepo]>) -> Void)
}

class LikesGateway: LikesGatewayProtocol {
    let dataStore: DataStoreProtocol = UserDefaultsDataStore()
    
    func fetch(ids: [String], completion: @escaping ([String : Bool]) -> Void) {
        dataStore.fetch(ids: ids, completion: completion)
    }

    func save(liked: Bool, for id: String, completion: @escaping (Bool) -> Void) {
        dataStore.save(liked: liked, for: id, completion: completion)
    }

    func allLike(completion: @escaping ([String : Bool]) -> Void) {
        dataStore.getAllLike(completion: completion)
    }
}
