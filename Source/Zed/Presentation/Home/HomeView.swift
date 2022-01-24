//
//  HomeView.swift
//  Stripy
//
//  Created by Pedro Fernandez on 1/18/22.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel(riotRepository: RiotRepository(), championsRepository: ChampionsRepository())
    @State private var isShowingDeleteAlert = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach($viewModel.champions, id: \.id) { champion in
                    ChampionView(champion: champion)
                }
                .onDelete(perform: viewModel.deleteChampion)
            }
            .emptyState($viewModel.champions.isEmpty) {
                StateView(title: "Add new champions", subtitle: "Press the \"+\" button at the top")
            }
            .navigationTitle("Champions")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        print("Add")
                        viewModel.getRandomChampion()
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                    
                    Button {
                        isShowingDeleteAlert = true
                    } label: {
                        Label("Delete All", systemImage: "trash")
                    }
                    .alert(isPresented: $isShowingDeleteAlert) {
                        Alert(
                            title: Text("Zed"),
                            message: Text("Are you sure you want to delete all champions?"),
                            primaryButton: .destructive(Text("Yes"), action: {
                                viewModel.clearList()
                            }),
                            secondaryButton: .cancel(Text("Cancel"), action: {
                                // No-op
                            })
                        )
                    }
                }
            }
        }
        .onAppear(perform: viewModel.load)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
