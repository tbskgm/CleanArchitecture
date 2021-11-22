//
//  GithubSearch.swift
//  CleanArchitecture
//
//  Created by TsubasaKogoma on 2021/11/19.
//

import Foundation
import Combine


class WebAPIClient: WebClientProtocol {
    /// github検索を行う
    func getRepos(query: String) -> AnyPublisher<[Repo], Error> {
        let url = URL(string: "https://api.github.com/search/repositories?q=\(query)")!
        
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { try JSONDecoder().decode(Repos.self, from: $0.data).items }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct Repos: Codable {
    let items: [Repo]
}

struct Repo: Identifiable, Codable {
    var id: Int
    var name: String
    var owner: User
    var description: String?
    var stargazersCount: Int

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case owner
        case description
        case stargazersCount = "stargazers_count"
    }
}

struct User: Codable {
    var name: String

    private enum CodingKeys: String, CodingKey {
        case name = "login"
    }
}
