//
//  SearchView.swift
//  CleanArchitecture
//
//  Created by TsubasaKogoma on 2021/11/18.
//

import SwiftUI


struct SearchView: View {
    @State var text: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                /// 検索バー
                SearchBar(text: $text)
                
                /// 検索結果
                List {
                    ForEach(0 ..< 5) { index in
                        ResultCell()
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
        SearchView()
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


struct ResultCell: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("タイトル")
                
            HStack {
                Text("説明文")
                Spacer()
                Button(action: {
                    
                }, label: {
                    Image(systemName: "heart")
                })
            }
            HStack {
                Text("言語名")
                Button(action: {
                    
                }, label: {
                    Image(systemName: "star")
                })
                Text("star数")
            }
        }
    }
}
