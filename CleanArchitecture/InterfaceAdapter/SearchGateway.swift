//
//  APIGateway.swift
//  CleanArchitecture
//
//  Created by TsubasaKogoma on 2021/11/18.
//

import Foundation
import Combine

/// WebClientのプロトコル
protocol WebClientProtocol {
    func getRepos(query: String) -> AnyPublisher<[Repo], Error>
}

class SearchGateway: SearchGatewayProtocol {
    var webClient: WebClientProtocol = WebAPIClient()
    //var database: DatabaseProtocol!


    func fetch(query: String) -> AnyPublisher<[Repo], Error> {
        webClient.getRepos(query: query)
    }
}
