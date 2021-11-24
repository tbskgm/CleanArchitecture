//
//  presenter.swift
//  CleanArchitecture
//
//  Created by TsubasaKogoma on 2021/11/18.
//

import Foundation
import Combine


// 画面表示用のデータ
struct ViewData: Identifiable {
    var id: String
    var fullName: String
    var description: String
    var stargazersCount: Int
    var isLiked: Bool
}

// TODO: 後々Presenterを準拠させる。
// 資料: https://zenn.dev/st43/articles/faf32d5f69e96b
protocol PresenterInput {
    var text: String { get }
}

protocol APIPresenterOutput {
    func getWebData()
}

protocol DatabasePresenterOutput {
    func toggle()
}

final class Presenter: ObservableObject, SearchLikesUseCaseOutput {
    // MARK: 通信
    private weak var useCase: SearchLikesUseCaseProtocol!
    
    private var cancellables = Set<AnyCancellable>()
    
    /// 検索バーに入力された値を受け取る
    @Published var text = String()
    
    /// 表示するデータを保持する
    @Published var repos = [Repo]()
    
    @Published var viewDatas = [ViewData]()
    
    // MARK: お気に入り
    @Published var subject = PassthroughSubject<(isFavorite: Bool, id: String), Never>()
    
    init(useCase: SearchLikesUseCaseProtocol = SearchLikesUseCase()) {
        self.useCase = useCase
        self.useCase.output = self
        
        /// テキストが入力されたら自動で検索を行う
        $text
            // 1秒待つ
            .debounce(for: 1.0, scheduler: DispatchQueue.main)
            // 重複を避ける
            .removeDuplicates()
            // TODO: filterに変更する
            .map { _ in
                guard !self.text.isEmpty else { return }
            }
            .sink{ _ in
                useCase.startFetch(query: self.text)
            }
            .store(in: &cancellables)
        
        $subject
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { [weak self] _ in
                guard let _ = self else { return }
            }, receiveValue: { value in
                
                
            })
            .store(in: &cancellables)
    }
    
    /// お気に入り登録する時に呼ばれる
    func saveFavorite(id: String, isFavorite: Bool) {
        useCase.set(id: id, isFavorite: isFavorite)
    }
    
    func useCaseDidUpdateLikesList(isFavorite: Bool, id: String) {
        for var viewData in viewDatas {
            if viewData.id == id {
                viewData.isLiked.toggle()
            }
        }
    }
    
    /// 取得した通信データを受け取る
    ///
    /// useCaseから呼ばれることで値を受け取る
    func getWebData(datas: (viewData: [ViewData], repos: [Repo])) {
        self.viewDatas = datas.viewData
        self.repos = datas.repos
    }
}

