//
//  GameDetailView.swift
//  games-catalogue
//
//  Created by Shyzago Nakamoto on 05/06/22.
//

import SwiftUI
import SDWebImageSwiftUI
import Foundation

struct GameDetailView: View {
	@Environment(\.presentationMode) var presentation
	@Environment(\.openURL) var openURL
	@Environment(\.colorScheme) var colorScheme

	var id: Int = 0
	var title: String = ""
	var rating: Float = 0.0
	var backgroundImage: String = ""
	var genres: [Genres] = []
	var screenshots: [Screenshots] = []
	var indexArrayOfGameBookmark: Int = 0
	var indexArrayOfHistories: Int = 0

	@ObservedObject var detailGameData = GameDetailViewModel()
	@StateObject var gameFavoriteData = GameFavoriteViewModel()
	@ObservedObject var gameLikedData = GameLikedViewModel()

	@State var isBookmarked: Bool?

	let hapticFeebackMedium = UIImpactFeedbackGenerator(style: .medium)

	var body: some View {
		if detailGameData.errorMessage != "" {
			HStack(alignment: .center) {
				Spacer()
				
				VStack {
					Spacer()

					Image(systemName: "exclamationmark.icloud")
						.resizable()
						.frame(width: 42, height: 30)
						.foregroundColor(.gray)
					Text("Terjadi kesalahan pada server").font(.body).foregroundColor(.gray).padding(.top, 5)

					Spacer()
				}

				Spacer()

			}
			.frame(width: UIScreen.main.bounds.width)

		} else {
			ScrollView(.vertical, showsIndicators: false) {
				GeometryReader { reader in
					WebImage(url: URL(string: backgroundImage == "" ? (detailGameData.detailGame?.backgroundImage ?? "") : backgroundImage))
						.resizable()
						.aspectRatio(contentMode: .fill)
						.offset(y: -reader.frame(in: .global).minY)
						.scaledToFill()
						.frame(width: UIScreen.main.bounds.width, height: reader.frame(in: .global).minY + 480)
				}
				.frame(height: 480)

				VStack(alignment: .leading, spacing: 15) {
					Text(title == "" ? (detailGameData.detailGame?.name ?? ""): title)
						.font(.system(size: 24, weight: .bold))
						.foregroundColor(colorScheme == .light ? .black : .white)
						.padding(.top, 5)

					Text(genres.isEmpty ? (detailGameData.detailGame?.genres.map { $0.name }.joined(separator: ", ") ?? "") : genres.map { $0.name }.joined(separator: ", "))
						.font(.callout)
						.foregroundColor(Color.init(.systemGray))
						.padding(.top, -10)

					HStack(spacing: 15) {
						if gameFavoriteData.items.filter { $0.id == self.id }.count > 0 {
							Button(action: {
								removeBookmarkButtonTap()
							}) {
								HStack {
									Text("Remove")
										.font(.body)
										.fontWeight(.bold)
									Image(systemName: "star.fill")
								}
							}.buttonStyle(RemoveBookmarkButtonStyle())
						} else {
							Button(action: {
								addBookmarkButtonTap()
								hapticFeebackMedium.impactOccurred()
							}) {
								HStack {
									Text("Favorite")
										.font(.body)
										.fontWeight(.bold)
									Image(systemName: "star")
								}
							}.buttonStyle(AddBookmarkButtonStyle())
						}

						if gameLikedData.items.contains(self.id) {
							Button(action: {
								unlikeTap()
							}, label: {
								Image(systemName: "heart.fill")
									.resizable()
									.frame(width: 33, height: 30)
									.foregroundColor(.red)
							})
							.frame(width: 40, height: 60)
						} else {
							Button(action: {
								likeTap()
								hapticFeebackMedium.impactOccurred()
							}, label: {
								Image(systemName: "heart")
									.resizable()
									.frame(width: 33, height: 30)
									.foregroundColor(Color.init(.systemGray2))
							})
							.frame(width: 40, height: 60)
						}
					}
					.padding(.top, 10)
					.padding(.bottom, -20)

					if screenshots.isEmpty == false {
						Text("Preview")
							.font(.system(size: 20, weight: .bold))
							.foregroundColor(colorScheme == .light ? .black : .white)
							.padding(.top, 20)

						GameScreenshotRow(screenshots: screenshots)
							.padding(.top, 0)
							.padding(.leading, -15)
							.padding(.trailing, -15)
					}

					Text("Rating")
						.font(.system(size: 20, weight: .bold))
						.foregroundColor(colorScheme == .light ? .black : .white)
						.padding(.top, 20)

					HStack(spacing: 3) {
						ForEach(1...5, id: \.self) { index in
							Image(systemName: index > Int(round((rating == 0 ? detailGameData.detailGame?.rating ?? 0.0 : rating))) ? "star" : "star.fill")
								.foregroundColor(Color.init(.systemYellow))
						}
					}
					.padding(.top, 0)

					Text("Description")
						.font(.system(size: 20, weight: .bold))
						.foregroundColor(colorScheme == .light ? .black : .white)
						.padding(.top, 5)

					Text(detailGameData.detailGame?.descriptionRaw ?? "")
						.font(.subheadline)
						.foregroundColor(colorScheme == .light ? Color.black : Color.white)

					Text("Information")
						.font(.system(size: 20, weight: .bold))
						.foregroundColor(colorScheme == .light ? .black : .white)
						.padding(.top, 5)

					List {
						HStack {
							Text("Relased Date")
								.foregroundColor(.gray)
								.font(.subheadline)
							Spacer()
							Text(detailGameData.detailGame?.released.formatterDate(dateInString: detailGameData.detailGame?.released ?? "", inFormat: "yyy-MM-dd", toFormat: "dd MMM yyyy") ?? "")
								.font(.subheadline)
						}

						HStack {
							Text("Age Rating")
								.foregroundColor(.gray)
								.font(.subheadline)
							Spacer()
							Text(detailGameData.detailGame?.ageRating.name ?? "")
								.font(.subheadline)
						}

						HStack {
							Text("Platform")
								.foregroundColor(.gray)
								.font(.subheadline)
							Spacer()
							Text(detailGameData.detailGame?.parentPlatforms.map { $0.childPlatform.name }.joined(separator: ", ") ?? "")
								.font(.subheadline)
						}

						HStack {
							Text("Playtime")
								.foregroundColor(.gray)
								.font(.subheadline)
							Spacer()
							Text("\(detailGameData.detailGame?.playtime ?? 0) Hour")
								.font(.subheadline)
						}

						HStack {
							Text("Developer Website")
								.foregroundColor(.accentColor)
								.font(.subheadline)
								.onTapGesture {
									openURL(URL(string: detailGameData.detailGame?.website ?? "")!)
								}
							Spacer()
							Text(Image(systemName: "safari"))
								.font(.subheadline)
								.foregroundColor(.accentColor)
								.onTapGesture {
									openURL(URL(string: detailGameData.detailGame?.website ?? "")!)
								}
						}

						HStack {
							Text("View all reviews")
								.foregroundColor(.accentColor)
								.font(.subheadline)
								.onTapGesture {
									openURL(URL(string: detailGameData.detailGame?.metacriticURL ?? "")!)
								}
							Spacer()
							Text(Image(systemName: "quote.bubble"))
								.font(.subheadline)
								.foregroundColor(.accentColor)
								.onTapGesture {
									openURL(URL(string: detailGameData.detailGame?.metacriticURL ?? "")!)
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
									Button(action: {
				self.presentation.wrappedValue.dismiss()
			}) {
				HStack {
					Image(systemName: "chevron.backward.circle.fill")
						.resizable()
						.frame(width: 30, height: 30)
						.foregroundColor(colorScheme == .light ? Color.init(.systemGray) : .white)
				}
			})
			.onAppear {
				// kirim data ke model
				self.detailGameData.loadData(id: self.id)
				// fetch data
				gameFavoriteData.fetchItems()
				gameLikedData.fetchItems()
			}
			.onDisappear {
				gameFavoriteData.deinitObject()
			}
		}
	}

	func addBookmarkButtonTap() {
		gameFavoriteData.addItem(id: id, name: title == "" ? (detailGameData.detailGame?.name ?? ""): title, released: detailGameData.detailGame?.released ?? "", backgroundImage: backgroundImage == "" ? (detailGameData.detailGame?.backgroundImage ?? "") : backgroundImage, rating: Float(rating == 0 ? detailGameData.detailGame?.rating ?? 0.0 : rating))
	}

	func removeBookmarkButtonTap() {
		gameFavoriteData.deleteItem(id: self.id)
	}

	func likeTap() {
		gameLikedData.addItem(id: self.id)
	}

	func unlikeTap() {
		let likedIndexInData = gameLikedData.items.firstIndex(of: self.id)
		gameLikedData.deleteItem(index: likedIndexInData!)
	}

}

struct AddBookmarkButtonStyle: ButtonStyle {
	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.font(.headline)
			.frame(maxWidth: .infinity, maxHeight: 45, alignment: .center)
			.contentShape(Rectangle())
			.foregroundColor(configuration.isPressed ? Color.white.opacity(0.5) : Color.white)
			.listRowBackground(configuration.isPressed ? Color.blue.opacity(0.5) : Color.blue)
			.background(Color.accentColor)
			.cornerRadius(10)
	}
}

struct RemoveBookmarkButtonStyle: ButtonStyle {
	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.font(.headline)
			.frame(maxWidth: .infinity, maxHeight: 45, alignment: .center)
			.contentShape(Rectangle())
			.foregroundColor(configuration.isPressed ? Color.accentColor.opacity(0.5) : Color.accentColor)
			.listRowBackground(configuration.isPressed ? Color.accentColor.opacity(0.5) : Color.accentColor)
			.background(Color.init(.systemGray6))
			.cornerRadius(10)
	}
}
