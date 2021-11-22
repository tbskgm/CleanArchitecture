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
    
    func startFetch()
}

protocol SearchLikesUseCaseOutput {
    func getWebData(publisher: AnyPublisher<[Repo], Error>)
}

protocol SearchGatewayProtocol {
    func fetch() -> AnyPublisher<[Repo], Error>
}

protocol LikesGatewayProtocol {
    
}

/// UseCase実装
final class SearchLikesUseCase: SearchLikesUseCaseProtocol {
    var output: SearchLikesUseCaseOutput!
    
    var searchGateway: SearchGatewayProtocol
    var likesGateway: LikesGatewayProtocol!
    
    init(searchGateway: SearchGatewayProtocol = SearchGateway()) {
        self.searchGateway = searchGateway
    }
    
    // キーワードでリポジトリを検索し、結果とお気に入り状態を組み合わせた結果をOutputに通知する
    func startFetch() {
        let publisher = searchGateway.fetch()
        output.getWebData(publisher: publisher)
    }
}
