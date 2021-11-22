//
//  APIGateway.swift
//  CleanArchitecture
//
//  Created by TsubasaKogoma on 2021/11/18.
//

import Foundation
import Combine


protocol WebClientProtocol {
    func getRepos() -> AnyPublisher<[Repo], Error>
}

class SearchGateway: SearchGatewayProtocol {
    var webClient: WebClientProtocol = WebAPIClient()
    //var database: DatabaseProtocol!


    func fetch() -> AnyPublisher<[Repo], Error> {
        webClient.getRepos()
    }
}
