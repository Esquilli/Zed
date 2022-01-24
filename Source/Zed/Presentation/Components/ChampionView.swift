//
//  ChampionView.swift
//  Zed
//
//  Created by Pedro Fernandez on 1/20/22.
//

import SwiftUI
import LeagueAPI

struct ChampionView: View {
    @Binding var champion: Champion
    
    var body: some View {
        HStack(alignment: .center) {
            Text(champion.name ?? "")
                .font(.system(size: 18, weight: .bold, design: .default))
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(champion.title?.capitalized ?? "")
                .font(.system(size: 14, weight: .regular, design: .default))
                .foregroundColor(.secondary)
        }
    }
}
