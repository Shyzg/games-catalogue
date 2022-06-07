//
//  ContentView.swift
//  Game-SwiftUI
//
//  Created by Shyzago Nakamoto on 19/05/22.
//

import SwiftUI

struct ContentView: View {
	@State private var isUserExist = UserDefaults.standard.bool(forKey: "User")
	@State private var isOnboardingPresent = true

	var body: some View {
		if isUserExist {
			TabView {
				HomeView()
					.tabItem {
						Image(systemName: "house")
						Text("Home")
					}

				GenreView()
					.tabItem {
						Image(systemName: "puzzlepiece")
						Text("Genre")
					}

				SearchView()
					.tabItem {
						Image(systemName: "magnifyingglass")
						Text("Search")
					}

				GameFavoriteView()
					.tabItem {
						Image(systemName: "text.badge.star")
						Text("Favorite")
					}
			}
		} else {
			VStack {
				
			}
			.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
			.background(Color.white)
			.edgesIgnoringSafeArea(.all)
			.fullScreenCover(isPresented: $isOnboardingPresent, content: {
				OnBoardingView(isUserExist: $isUserExist)
			})
		}
	}
}
