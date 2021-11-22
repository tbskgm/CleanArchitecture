//
//  GithubRepo.swift
//  CleanArchitecture
//
//  Created by TsubasaKogoma on 2021/11/19.
//

import Foundation

struct GitHubRepo: Equatable, Codable {
    struct ID: RawRepresentable, Hashable, Codable {
        let rawValue: String
    }
    let id: ID
    let fullName: String
    let description: String
    let language: String
    let stargazersCount: Int

    public static func == (lhs: GitHubRepo, rhs: GitHubRepo) -> Bool {
        return lhs.id == rhs.id
    }
}
