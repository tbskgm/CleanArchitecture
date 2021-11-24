//
//  GitHubRepoStatusList.swift
//  CleanArchitecture
//
//  Created by TsubasaKogoma on 2021/11/19.
//

import Foundation

/*
struct GitHubRepoStatus: Equatable {
    let repo: Repo
    let isLiked: Bool

    static func == (lhs: GitHubRepoStatus, rhs: GitHubRepoStatus) -> Bool {
        return lhs.repo == rhs.repo
    }
}

extension Array where Element == GitHubRepoStatus {
    init(repos: [Repo], likes: [Int: Bool]) {
        self = repos.map { repo in
            GitHubRepoStatus(
                repo: repo,
                isLiked: likes[repo.id] ?? false
            )
        }
    }
}

struct GitHubRepoStatusList {
    enum Error: Swift.Error {
        case notFoundRepo(ofID: Int)
    }
    private(set) var statuses: [GitHubRepoStatus]

    init(repos: [Repo], likes: [Repo.ID: Bool], trimmed: Bool = false) {
        statuses = Array(repos: repos, likes: likes).unique(resolve: { _, _ in .ignoreNewOne })
        if trimmed {
            statuses = statuses.filter{ $0.isLiked }
        }
    }
    mutating func append(repos: [Repo], likes: [Int: Bool]) {
        let newStatusesMayNotUnique = statuses + Array(repos: repos, likes: likes)
        statuses = newStatusesMayNotUnique.unique { _, _ in .removeOldOne }
    }
    mutating func set(isLiked: Bool, for id: Int) throws {
        guard let index = statuses.firstIndex(where: { $0.repo.id == id }) else {
            throw Error.notFoundRepo(ofID: id)
        }
        let currentStatus = statuses[index]
        statuses[index] = GitHubRepoStatus(
            repo: currentStatus.repo,
            isLiked: isLiked
        )
    }
    subscript(id: Int) -> GitHubRepoStatus? {
        return statuses.first(where: { $0.repo.id == id })
    }
}
*/
