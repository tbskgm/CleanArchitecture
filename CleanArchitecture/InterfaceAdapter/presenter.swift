//
//  presenter.swift
//  CleanArchitecture
//
//  Created by TsubasaKogoma on 2021/11/18.
//

import Foundation
import Combine

// TODO: 一旦お預け。後々Presenterを準拠させる。
// 資料: https://zenn.dev/st43/articles/faf32d5f69e96b
protocol PresenterInput {
    var text: String { get }
}

protocol APIPresenterOutput {
    func getWebData()
}

protocol DatabasePresenterOutput {
    
}

final class Presenter: ObservableObject, SearchLikesUseCaseOutput {
    private weak var useCase: SearchLikesUseCaseProtocol!
    
    private var cancellables = Set<AnyCancellable>()
    
    /// 検索バーに入力された値を受け取る
    @Published var text = String()
    @Published var repos = [Repo]()
    
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
                useCase.startFetch()
                //let keywords = self.text.split(separator: " ").map(String.init)
            }
            .store(in: &cancellables)
    }
    
    ///
    func getWebData(publisher: AnyPublisher<[Repo], Error>) {
        publisher
            .sink(receiveCompletion: { [weak self] completion in
                guard let _ = self else { return }
            }, receiveValue: { [weak self] repos in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.repos = repos
                }
            })
        
        
            //.handleEvents(receiveSubscription: { [weak self] _ in
            //    let _ = self
            //    //self?.repos = .loading
            //})
            //.receive(on: DispatchQueue.main)
            //.sink(receiveCompletion: { [weak self] completion in
            //    switch completion {
            //    case .failure(let error):
            //        print("Error: \(error)")
            //        //self?.repos = .failed(error)
            //    case .finished:
            //        print("Finished")
            //    }
            //}, receiveValue: { [weak self] repos in
            //    guard let self = self else { return }
            //
            //})
            .store(in: &cancellables)
    }
}

