//
//  GenreView.swift
//  games-catalogue
//
//  Created by Shyzago Nakamoto on 05/06/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct GenreView: View {
	@ObservedObject var genreData = GenreViewModel()

	private let column = [
		GridItem(.flexible()),
		GridItem(.flexible())
	]

	var body: some View {
		NavigationView {
			if genreData.dataGenres.isEmpty {
				HStack(alignment: .center) {
					Spacer()

					VStack {
						Spacer()

						LoadingView().padding(.top, 10)

						Text("Loading").font(.caption).foregroundColor(.gray).padding(.top, 5)

						Spacer()
					}

					Spacer()

				}
				.frame(width: .infinity)
			} else {
				ScrollView {
					LazyVGrid(columns: column, spacing: 10) {
						ForEach(genreData.dataGenres, id: \.id) { genre in
							NavigationLink(destination: GameListView(navTitle: genre.name, games: genre.games)) {
								WebImage(url: URL(string: genre.imageBackground)!)
									.resizable()
									.aspectRatio(contentMode: .fill)
									.frame(width: (UIScreen.main.bounds.width - 45) / 2, height: (UIScreen.main.bounds.width - 45) / 2)
									.clipped()
									.cornerRadius(10)
									.overlay(
										Rectangle()
											.fill(
												LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black]), startPoint: .top, endPoint: .bottom))
											.opacity(0.5)
											.cornerRadius(10)
											.overlay(
												Text(genre.name)
													.foregroundColor(Color.white)
													.font(.title3)
													.bold()
											)
									)
							}
						}
					}
					.padding(15)

				}
				.navigationTitle("Genre")
				.navigationBarItems(trailing:
										NavigationLink(destination: UserView()) {
					ProfilePictureRow()
				})
				
			}
		}
	}
}
