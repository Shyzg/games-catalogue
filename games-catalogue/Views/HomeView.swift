//
//  HomeView.swift
//  games-catalogue
//
//  Created by Shyzago Nakamoto on 05/06/22.
//

import SwiftUI

struct HomeView: View {
	@State var carouselIndex: Int = 0
	@ObservedObject var creatorsData = CreatorViewModel()
	@ObservedObject var popularGames = GamePopularViewModel()

	private let carouselShow = [
		CarouselModel(id: 41494, title: "Cyberpunk 2077", image: "carousel"),
		CarouselModel(id: 10061, title: "Watch Dogs 2", image: "carousel4"),
		CarouselModel(id: 2828, title: "Naruto Ultimate Ninja Storm 4", image: "carousel3"),
		CarouselModel(id: 452645, title: "Hitman 3", image: "carousel2"),
		CarouselModel(id: 437059, title: "Assassin's Creed Valhalla", image: "carousel5")
	]

	var body: some View {
		NavigationView {
			ZStack {
				ScrollView(.vertical, showsIndicators: false) {
					VStack(alignment: .leading) {

						TabView(selection: self.$carouselIndex) {
							ForEach(carouselShow, id: \.id) { carousel in
								NavigationLink(destination: GameDetailView(id: carousel.id)) {
									Image(carousel.image)
										.resizable()
										.frame(height: 200)
										.cornerRadius(10)
										.padding(.horizontal)
										.tag(carouselIndex)
								}
							}
						}
						.frame(height: 200)
						.tabViewStyle(PageTabViewStyle())

						if popularGames.isLoading && creatorsData.isLoading {
							HStack(alignment: .center) {
								Spacer()
								VStack {
									Spacer()
									LoadingView().padding(.top, 10)
									Text("LOADING").font(.caption).foregroundColor(.gray).padding(.top, 5)
									Spacer()
								}
								Spacer()
							}.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2, alignment: .center)
						} else {
							GamePopularRow(popularGames: popularGames.dataPopularGame)
								.padding(.top, 20)

							CreatorRow(creators: creatorsData.dataCreators)
								.padding(.top, 20)

						}
					}
					.padding(.bottom, 10)

				}
				.navigationTitle("Home")
				.navigationBarItems(trailing:
										NavigationLink(destination: UserView()) {
					ProfilePictureRow()
				})
				
			}
		}
	}
}
