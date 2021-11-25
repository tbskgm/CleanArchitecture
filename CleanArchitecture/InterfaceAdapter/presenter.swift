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

/// お気に入り表示用データ
struct LikesData: Identifiable {
    var id: String
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
    //@Published var repos = [Repo]()
    
    @Published var viewDatas = [ViewData]()
    
    @Published var allLikeData = [LikesData]()
    
    // MARK: お気に入り
    
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
    }
    
    /// お気に入り登録する時に呼ばれる
    func saveFavorite(id: String, isFavorite: Bool) {
        useCase.set(id: id, isFavorite: isFavorite)
    }
    
    /// お気に入り登録が完了したらUIに反映させる
    func useCaseDidUpdateLikesList(isFavorite: Bool, id: String) {
        var count = 0
        for viewData in viewDatas {
            if viewData.id == id {
                viewDatas[count].isLiked = isFavorite
                // 最新のお気に入り一覧を取得する
                fetchAllLikeData()
            } else {
                count += 1
            }
        }
    }
    
    /// 取得した通信データを受け取る
    ///
    /// useCaseから呼ばれることで値を受け取る
    func getWebData(datas: [ViewData]) {
        self.viewDatas = datas
    }
    
    ///　全てのお気に入りリポジトリを呼び出す
    func fetchAllLikeData() {
        useCase.allLikeData()
    }
    
    /// 全てのお気に入りリポジトリを受け取る
    func getAllLikesData(allLike: [String: Bool]) {
        self.allLikeData = allLike.map({ like in
            let likeData = LikesData(id: like.key, isLiked: like.value)
            print(like.key, like.value)
            return likeData
        })
    }
}

