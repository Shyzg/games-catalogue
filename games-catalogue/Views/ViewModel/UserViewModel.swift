//
//  UserViewModel.swift
//  games-catalogue
//
//  Created by Shyzago Nakamoto on 06/06/22.
//

import Foundation
import SwiftUI
import Combine

class UserViewModel: ObservableObject {
	private let key: String = "User"

	@Published var item: UserModel? {
		didSet {
			saveItem()
		}
	}

	init() {
		fetchItem()
	}

	func fetchItem() {
		guard
			let data = UserDefaults.standard.data(forKey: key),
			let savedItem = try? JSONDecoder().decode(UserModel.self, from: data)
		else {
			return
		}

		self.item = savedItem
	}

	func addItem(data: UserModel) {
		let newItem = UserModel(name: data.name, email: data.email, phoneNumber: data.phoneNumber, website: data.website, githubUrl: data.githubUrl, profilePicture: data.profilePicture)
		item = newItem
	}

	func saveItem() {
		if let encodedData = try? JSONEncoder().encode(item) {
			UserDefaults.standard.set(encodedData, forKey: key)
		}
	}
}
