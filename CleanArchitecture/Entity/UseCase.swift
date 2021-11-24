//
//  UseCase.swift
//  CleanArchitecture
//
//  Created by TsubasaKogoma on 2021/11/19.
//

import Foundation
import Combine

/// Use Caseが外側(Interface Adapters)に公開するインターフェイス
protocol SearchLikesUseCaseProtocol: AnyObject {
    var output: SearchLikesUseCaseOutput! { get set }
    
    func startFetch(query: String)
    
    func set(id: String, isFavorite: Bool)
}

protocol SearchLikesUseCaseOutput {
    func getWebData(datas: (viewData: [ViewData], repos: [Repo]))
    
    func useCaseDidUpdateLikesList(isFavorite: Bool, id: String)
}

protocol SearchGatewayProtocol {
    func fetch(query: String) -> AnyPublisher<[Repo], Error>
}

protocol LikesGatewayProtocol {
    func fetch(ids: [String], completion: @escaping ([String: Bool]) -> Void)
    
    func save(liked: Bool, for id: String, completion: @escaping (Bool) -> Void)
}

/// UseCase実装
final class SearchLikesUseCase: SearchLikesUseCaseProtocol {
    var output: SearchLikesUseCaseOutput!
    
    var searchGateway: SearchGatewayProtocol
    var likesGateway: LikesGatewayProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(searchGateway: SearchGatewayProtocol = SearchGateway(), likesGateway: LikesGatewayProtocol = LikesGateway()) {
        self.searchGateway = searchGateway
        self.likesGateway = likesGateway
    }
    
    /// キーワードでリポジトリを検索し、結果とお気に入り状態を組み合わせた結果をOutputに通知する
    func startFetch(query: String) {
        var viewDatas = [ViewData]()
        let publisher = searchGateway.fetch(query: query)
        publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let _ = self else { return }
            }, receiveValue: { [weak self] repos in
                guard let self = self else { return }
                guard repos.count != 0 else { return }
                
                let ids: [String] = repos.map { String($0.id) }
                self.likesGateway.fetch(ids: ids) { [weak self] likesResult in
                    guard let self = self else { return }
                    
                    for repo in repos {
                        if likesResult.count == 0 {
                            let viewData = ViewData(
                                id: String(repo.id),
                                fullName: repo.name,
                                description: repo.description ?? "",
                                stargazersCount: repo.stargazersCount,
                                isLiked: false
                            )
                            viewDatas.append(viewData)
                        } else {
                            for result in likesResult {
                                if String(repo.id) == result.key {
                                    let viewData = ViewData(
                                        id: String(repo.id),
                                        fullName: repo.name,
                                        description: repo.description ?? "",
                                        stargazersCount: repo.stargazersCount,
                                        isLiked: result.value
                                    )
                                    viewDatas.append(viewData)
                                } else {
                                    let viewData = ViewData(
                                        id: String(repo.id),
                                        fullName: repo.name,
                                        description: repo.description ?? "",
                                        stargazersCount: repo.stargazersCount,
                                        isLiked: false
                                    )
                                    viewDatas.append(viewData)
                                }
                            }
                        }
                    }
                    self.output.getWebData(datas: (viewDatas, repos))
                }
            })
            .store(in: &cancellables)
    }
    
    /// お気に入りに登録する
    func set(id: String, isFavorite: Bool) {
        likesGateway.save(liked: isFavorite, for: id) { [weak self] liked in
            guard let self = self else { return }
            self.output.useCaseDidUpdateLikesList(isFavorite: liked, id: id)
        }
    }
}
