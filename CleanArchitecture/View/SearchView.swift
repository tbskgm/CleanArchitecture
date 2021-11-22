//
//  SearchView.swift
//  CleanArchitecture
//
//  Created by TsubasaKogoma on 2021/11/18.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: Presenter
    
    var body: some View {
        NavigationView {
            VStack {
                /// 検索バー
                SearchBar(text: $viewModel.text)
                
                /// 検索結果
                List {
                    ForEach($viewModel.repos) { repo in
                        ResultCell(
                            title: repo.name,
                            description: repo.description,
                            starCount: repo.stargazersCount
                        )
                        //self.title = $viewModel.repos[index].name
                        //let description = viewModel.repos[index].description
                        ////let language = $viewModel.repos[index].owner
                        //let starCount = viewModel.repos[index].stargazersCount
                        //ResultCell(title: title, description: description, starCount: starCount)
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
    @Binding var title: String
    @Binding var description: String?
    @Binding var starCount: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                
            HStack {
                Text(description ?? "")
                Spacer()
                Button(action: {
                    
                }, label: {
                    Image(systemName: "heart")
                })
            }
            HStack {
                Text("Swift")
                Button(action: {
                    
                }, label: {
                    Image(systemName: "star")
                })
                Text("\(starCount)")
            }
        }
    }
}
