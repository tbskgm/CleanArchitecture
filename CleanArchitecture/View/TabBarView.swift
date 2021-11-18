//
//  TabBarView.swift
//  CleanArchitecture
//
//  Created by TsubasaKogoma on 2021/11/18.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView{
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            FavoriteView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorite")
                }
                
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
