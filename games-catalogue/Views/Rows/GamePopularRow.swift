//
//  GamePopularRow.swift
//  games-catalogue
//
//  Created by Shyzago Nakamoto on 05/06/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct GamePopularRow: View {
	var popularGames: [ResultGamePopulars]
	var body: some View {
		VStack(alignment: .leading) {
			Text("Popular Game")
				.font(.title3)
				.bold()
				.padding(.leading, 15)

			ScrollView(.horizontal, showsIndicators: false) {
				HStack(alignment: .top) {
					ForEach(self.popularGames, id: \.id) { game in
						NavigationLink(destination: GameDetailView(id: game.id, title: game.name, rating: game.rating, backgroundImage: game.backgroundImage, genres: game.genres, screenshots: game.screenshots)) {
							Spacer()
							Spacer()
							VStack(alignment: .leading, spacing: 10) {
								WebImage(url: URL(string: game.backgroundImage)!)
									.resizable()
									.renderingMode(.original)
									.aspectRatio(contentMode: .fill)
									.frame(width: 220, height: 120)
									.clipped()
									.cornerRadius(5)

								VStack(alignment: .leading, spacing: 5) {
									Text(game.name)
										.foregroundColor(.primary)
										.font(.headline)
										.frame(maxWidth: 220, maxHeight: 20, alignment: .leading)

									HStack {
										Text(game.genres
											.map {
												$0.name
											}
											.joined(separator: ", "))
										.foregroundColor(.gray)
										.font(.subheadline)
										.frame(maxWidth: 220, maxHeight: 20, alignment: .leading)
									}

									HStack(spacing: 3) {
										ForEach(1...5, id: \.self) { index in
											Image(systemName: index > Int(round(game.rating)) ? "star" : "star.fill")
												.resizable()
												.foregroundColor(Color.gray)
												.frame(width: 12, height: 12)
										}

										Text("\(game.rating.clean)")
											.font(.caption)
											.foregroundColor(.gray)
											.padding(.leading, 3)
											.padding(.top, 2)

										HStack {
											Text(game.released.formatterDate(dateInString: game.released, inFormat: "yyy-MM-dd", toFormat: "dd MMM yyyy") ?? "")
												.font(.caption)
												.foregroundColor(.gray)
										}
										.frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)

									}
								}
							}
						}
					}
				}
			}
		}
	}
}
