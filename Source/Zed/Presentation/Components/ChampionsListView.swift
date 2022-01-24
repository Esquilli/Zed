//
//  ChampionsListView.swift
//  Zed
//
//  Created by Pedro Fernandez on 1/20/22.
//

import SwiftUI
import LeagueAPI

struct ChampionsListView: View {
    @Binding var champions: [Champion]
    
    var body: some View {
        List {
            ForEach($champions, id: \.id) { champion in
                ChampionView(champion: champion)
            }
        }
    }
}

struct ChampionsListView_Previews: PreviewProvider {
    static var previews: some View {
        ChampionsListView(champions: .constant([]))
    }
}
