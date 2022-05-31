//
//  GameFavoriteViewModel.swift
//  games-catalogue
//
//  Created by Shyzago Nakamoto on 31/05/22.
//

import Foundation
import RealmSwift

class GameFavoriteViewModel: ObservableObject {
	@Published var items: [GameFavoriteModel] = []

	init() {
		fetchItems()
	}

	func fetchItems() {
		guard let localDatabase = try? Realm() else {
			return
		}

		let results = localDatabase.objects(GameFavoriteModel.self)

		self.items = results.compactMap({ (item) -> GameFavoriteModel? in
			return item
		})
	}

	func addItem(id: Int, name: String, released: String, backgroundImage: String, rating: Float) {
		let item = GameFavoriteModel()
		
		item.id = id
		item.name = name
		item.released = released
		item.backgroundImage = backgroundImage
		item.rating = rating

		guard let localDatabase = try? Realm() else {
			return
		}

		try? localDatabase.write {
			localDatabase.add(item)

			fetchItems()
		}
	}

	func deleteItem(id: Int) {
		guard let localDatabase = try? Realm() else {
			return
		}

		let object = localDatabase.objects(GameFavoriteModel.self).filter("id == %@", id).first

		try? localDatabase.write {
			localDatabase.delete(object!)

			fetchItems()
		}
	}

	func deinitObject() {
		self.items = []
	}
}
