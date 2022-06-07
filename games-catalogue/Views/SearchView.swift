//
//  SearchView.swift
//  games-catalogue
//
//  Created by Shyzago Nakamoto on 05/06/22.
//

import SwiftUI
import Combine

struct SearchView: View {
	@State private var keyword = ""
	@State private var isEditing = false
	@State private var suggesstionGames = [
		GameSuggestion(title: "Cyberpunk 2077"),
		GameSuggestion(title: "Final Fantasy VII Remake Intergrade"),
		GameSuggestion(title: "Hitman 3"),
		GameSuggestion(title: "Watch Dogs 2"),
		GameSuggestion(title: "Assassin's Creed Valhalla")
	]

	@ObservedObject var dataResult = GameSearchViewModel()

	var body: some View {
		NavigationView {
			GeometryReader { geometry in
				ScrollView(showsIndicators: false) {
					VStack(alignment: .leading) {
						HStack {
							TextField("Search game", text: Binding<String>(get: {
								self.keyword
							}, set: {
								self.keyword = $0
								// do whatever you want here

								self.dataResult.loadData(keyword: keyword)
							}))
							.padding(7)
							.padding(.horizontal, 25)
							.background(Color(.systemGray6))
							.cornerRadius(8)
							.overlay(
								HStack {
									Image(systemName: "magnifyingglass")
										.foregroundColor(.gray)
										.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
										.padding(.leading, 8)

									if isEditing {
										Button(action: {
											self.keyword = ""
											dataResult.resultSearching = []
										}) {
											Image(systemName: "multiply.circle.fill")
												.foregroundColor(.gray)
												.padding(.trailing, 8)
										}
									}
								}
							)
							.onTapGesture {
								self.isEditing = true
							}
							.keyboardType(.webSearch)

							if isEditing {
								Button(action: {
									self.isEditing = false
									self.keyword = ""
									dataResult.resultSearching = []

									// Dismiss the keyboard
									UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
								}) {
									Text("Cancel")
								}
								.padding(.trailing, 10)
								.transition(.move(edge: .trailing))
							}
						}

						if self.keyword == "" {
							VStack(alignment: .leading) {
								Text("Top rate game")
									.font(.title2)
									.bold()
									.padding(.top, 40)
									.padding(.leading, 15)

								List {
									ForEach(suggesstionGames, id: \.id) { game in
										HStack {
											Text(game.title)
												.foregroundColor(.accentColor)
											Spacer()

										}
										.contentShape(Rectangle())
										.onTapGesture {
											self.isEditing = true
											self.keyword = game.title
											self.dataResult.loadData(keyword: game.title)
										}
									}
								}
								.listStyle(PlainListStyle())

							}
							.frame(height: geometry.size.height)
							.padding(.leading, -20)
						} else {
							if dataResult.isLoading {
								HStack(alignment: .center) {
									Spacer()
									VStack {
										Spacer()
										LoadingView().padding(.top, 10)
										Text("LOADING").font(.caption).foregroundColor(.gray).padding(.top, 5)
										Spacer()
									}
									Spacer()
								}.frame(width: .infinity, height: UIScreen.main.bounds.height / 2, alignment: .center)
							} else {
								if dataResult.resultSearching.isEmpty {
									HStack(alignment: .center) {
										VStack(alignment: .center) {
											Spacer()
											Image(systemName: "questionmark.folder")
												.resizable()
												.frame(width: 36, height: 30)
												.foregroundColor(.gray)
											Text("Data tidak ditemukan").font(.callout).foregroundColor(.gray).padding(.top, 5)
											Spacer()
										}
										.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2, alignment: .center)
									}.frame(width: UIScreen.main.bounds.width)
								} else {
									GameSearchRow(resultSearching: dataResult.resultSearching)
										.padding(.top, 10)
								}
							}
						}
					}
					.padding(.leading, 18)
					.padding(.trailing, 18)
				}
				.padding(.bottom, 10)
				.navigationTitle("Search")
				.navigationBarItems(trailing:
										NavigationLink(destination: UserView()) {
					ProfilePictureRow()
				})
			}
		}
		.navigationViewStyle(StackNavigationViewStyle())
	}
}

/// loading indicator
struct LoadingView: UIViewRepresentable {
	func makeUIView(context: UIViewRepresentableContext<LoadingView>) -> UIActivityIndicatorView {
		let indi = UIActivityIndicatorView(style: .medium)
		indi.color = UIColor.gray
		return indi
	}

	func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<LoadingView>) {
		uiView.startAnimating()
	}
}
