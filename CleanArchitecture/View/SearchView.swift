//
//  SearchView.swift
//  CleanArchitecture
//
//  Created by TsubasaKogoma on 2021/11/18.
//

import SwiftUI
import Combine

struct SearchView: View {
    @ObservedObject var presenter: Presenter
    //let subject = PassthroughSubject<Bool, Never>()
    
    var body: some View {
        NavigationView {
            VStack {
                /// 検索バー
                SearchBar(text: $presenter.text)
                
                /// 検索結果
                List {
                    ForEach($presenter.viewDatas) { viewData in
                        ResultCell(
                            id: viewData.id,
                            title: viewData.fullName,
                            description: viewData.description,
                            starCount: viewData.stargazersCount,
                            isFavorite: viewData.isLiked,
                            presenter: presenter
                        )
                    }
                }
            }
            .navigationTitle("Search Repositories")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(presenter: Presenter())
    }
}

/// 検索窓
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("LightGray"))
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("", text: $text)
                    .foregroundColor(.black)
                    .modifier(ClearButton(text: $text))
            }
            .foregroundColor(.gray)
            .padding(.leading, 13)
        }
        .frame(height: 40)
        .cornerRadius(13)
        .padding()
    }
}

/// クリアボタン実装
struct ClearButton: ViewModifier {
    @Binding var text: String

    public func body(content: Content) -> some View {
        HStack {
            content
            Button(action: {
                self.text = ""
            }) {
                Image(systemName: "multiply.circle.fill")
                    .foregroundColor(.secondary)
                    .padding(5)
            }
        }
    }
}


/// 検索結果を表示するcellの定義
struct ResultCell: View {
    @Binding var id: String
    @Binding var title: String
    @Binding var description: String
    @Binding var starCount: Int
    @Binding var isFavorite: Bool
    
    @ObservedObject var presenter: Presenter
    
    @State var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                
            HStack {
                Text(description)
                    .foregroundColor(.gray)
                Spacer()
                Button(action: {
                    presenter.saveFavorite(id: id, isFavorite: !isFavorite)
                }, label: {
                    isFavorite ? Image(systemName: "heart.fill"): Image(systemName: "heart")
                })
            }
            HStack {
                Text("Swift")
                    .foregroundColor(.gray)
                Text("★ \(starCount)")
                    .foregroundColor(.gray)
            }
        }
    }
}
