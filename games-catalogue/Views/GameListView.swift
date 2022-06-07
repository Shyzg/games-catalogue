//
//  GameListView.swift
//  games-catalogue
//
//  Created by Shyzago Nakamoto on 05/06/22.
//

import SwiftUI

struct GameListView: View {
	let navTitle: String
	let games: [Games]

	var body: some View {
		VStack {
			List {
				ForEach(games, id: \.id) { game in
					NavigationLink(destination: GameDetailView(id: game.id)) {
						Text(game.name)
					}
				}
			}
			.navigationTitle(navTitle)
			.navigationBarTitleDisplayMode(.inline)
			
		}
	}
}
