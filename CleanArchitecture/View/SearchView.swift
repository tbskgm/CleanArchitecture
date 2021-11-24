//
//  SearchView.swift
//  CleanArchitecture
//
//  Created by TsubasaKogoma on 2021/11/18.
//

import SwiftUI
import Combine

struct SearchView: View {
    @ObservedObject var viewModel: Presenter
    //let subject = PassthroughSubject<Bool, Never>()
    
    var body: some View {
        NavigationView {
            VStack {
                /// 検索バー
                SearchBar(text: $viewModel.text)
                
                /// 検索結果
                List {
                    ForEach($viewModel.viewDatas) { viewData in
                        ResultCell(
                            id: viewData.id,
                            title: viewData.fullName,
                            description: viewData.description,
                            starCount: viewData.stargazersCount,
                            isFavorite: viewData.isLiked,
                            subject: viewModel.subject,
                            presenter: viewModel
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
        SearchView(viewModel: Presenter())
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
    
    var subject: PassthroughSubject<(isFavorite: Bool, id: String), Never>
    @ObservedObject var presenter: Presenter
    
    @State var cancellables = Set<AnyCancellable>()
    /*
    init(id: Binding<String>, title: Binding<String>, description: Binding<String>, starCount: Binding<Int>, isFavorite: Binding<Bool>, viewModel: ) {
        
    }*/
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                
            HStack {
                Text(description)
                    .foregroundColor(.gray)
                Spacer()
                Button(action: {
                    //subject.send(isFavorite)
                    presenter.saveFavorite(id: id, isFavorite: isFavorite)
                    //isFavorite.toggle()
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
        .onAppear {
            subject
                .sink(receiveValue: { value in
                    if id == value.id {
                        isFavorite = value.isFavorite
                        print("value: \(value)")
                    }
                })
                .store(in: &self.cancellables)
        }
    }
}
