//
//  FavoriteView.swift
//  CleanArchitecture
//
//  Created by TsubasaKogoma on 2021/11/18.
//

import SwiftUI


struct FavoriteView: View {
    var body: some View {
        NavigationView {
            List {
                ForEach(0 ..< 5) { index in
                    ResultCell()
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
    }
}
