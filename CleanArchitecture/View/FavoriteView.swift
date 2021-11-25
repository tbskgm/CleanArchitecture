//
//  FavoriteView.swift
//  CleanArchitecture
//
//  Created by TsubasaKogoma on 2021/11/18.
//

import SwiftUI


struct FavoriteView: View {
    @ObservedObject var presenter = Presenter()
    
    var body: some View {
        NavigationView {
            List {
                ForEach($presenter.allLikeData) { viewData in
                    VStack {
                        Text(viewData.id)
                    }
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear(perform: {
            presenter.fetchAllLikeData()
        })
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
    }
}
