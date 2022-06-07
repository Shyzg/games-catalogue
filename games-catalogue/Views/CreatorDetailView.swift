//
//  CreatorDetailView.swift
//  games-catalogue
//
//  Created by Shyzago Nakamoto on 05/06/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct CreatorDetailView: View {
	@Environment(\.presentationMode) var presentation
	@Environment(\.openURL) var openURL
	@Environment(\.colorScheme) var colorScheme

	var id: Int
	var name: String
	var image: String
	var imageBackground: String
	var gamesCount: Int
	var positions: [Positions]
	var games: [Games]

	@ObservedObject var detailCreatorData = DetailCreatorViewModel()

	var body: some View {
		ScrollView(.vertical, showsIndicators: false) {
			GeometryReader { reader in
				WebImage(url: URL(string: imageBackground)!)
					.resizable()
					.aspectRatio(contentMode: .fill)
					.offset(y: -reader.frame(in: .global).minY)
					.scaledToFill()
					.frame(width: UIScreen.main.bounds.width, height: reader.frame(in: .global).minY + 480)
			}
			.frame(height: 480)

			VStack(alignment: .leading, spacing: 15) {
				VStack {
					HStack {
						Spacer()
						WebImage(url: URL(string: image)!)
							.resizable()
							.renderingMode(.original)
							.aspectRatio(contentMode: .fill)
							.frame(width: 140, height: 140)
							.clipShape(Circle())
						Spacer()
					}
					.padding(.top, 20)

					HStack {
						Spacer()
						Text(name)
							.font(.system(size: 24, weight: .bold))
							.foregroundColor(colorScheme == .light ? .black : .white)
						Spacer()
					}
					.padding(.top, 15)

					HStack {
						Spacer()
						Text(positions.map {
							$0.name.capitalizingFirstLetter()
						}.joined(separator: " | "))
						.font(.callout)
						.foregroundColor(Color.init(.systemGray))
						Spacer()
					}
					.padding(.top, 5)

					HStack {
						ForEach(1...5, id: \.self) { index in
							Image(systemName: index > Int(round(Double(detailCreatorData.detailCreator?.rating ?? "") ?? 0.0)) ? "star" : "star.fill")
								.resizable()
								.frame(width: 17, height: 17)
								.foregroundColor(Color.init(.systemGray))
						}
					}
					.padding(.top, 5)

				}

				Text("About Creator")
					.font(.system(size: 20, weight: .bold))
					.foregroundColor(colorScheme == .light ? .black : .white)
					.padding(.top, 25)

				Text(detailCreatorData.detailCreator?.description.stripped ?? "")
					.font(.subheadline)
					.foregroundColor(colorScheme == .light ? Color.black : Color.white)

				Text("Games Ever Made")
					.font(.system(size: 20, weight: .bold))
					.foregroundColor(colorScheme == .light ? .black : .white)
					.padding(.top, 5)
					.onAppear {
						print(games)
					}

				List {
					ForEach(games, id: \.id) { game in
						NavigationLink(destination: GameDetailView(id: game.id)) {
							HStack {
								Text(game.name)
									.font(.body)
							}
						}
					}
				}
				.listStyle(PlainListStyle())
				.padding(.leading, -10)
				.frame(width: .infinity, height: 400)
				.onAppear {
					UITableView.appearance().isScrollEnabled = false
				}

			}
			.padding(.top, 25)
			.padding(.horizontal)
			.background(colorScheme == .light ? Color.white : Color.black)
			.cornerRadius(22)
			.offset(y: -35)

		}
		.edgesIgnoringSafeArea(.all)
		.background(colorScheme == .light ? Color.white.edgesIgnoringSafeArea(.all) : Color.black.edgesIgnoringSafeArea(.all))
		.navigationBarBackButtonHidden(true)
		.navigationBarItems(leading:
								Button(action:
										{ self.presentation.wrappedValue.dismiss()
		})
							{
			HStack {
				Image(systemName: "chevron.backward.circle.fill")
					.resizable()
					.frame(width: 30, height: 30)
					.foregroundColor(colorScheme == .light ? Color.init(.systemGray) : .white)
			}
		})
		.onAppear {
			self.detailCreatorData.loadData(id: self.id)
		}
		
	}
}
