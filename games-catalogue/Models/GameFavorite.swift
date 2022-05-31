//
//  GameFavorite.swift
//  games-catalogue
//
//  Created by Shyzago Nakamoto on 31/05/22.
//

import Foundation
import RealmSwift

class GameFavoriteModel: Object, Identifiable {
	@objc dynamic var id: Int = 0
	@objc dynamic var name: String = ""
	@objc dynamic var released: String = ""
	@objc dynamic var backgroundImage: String = ""
	@objc dynamic var rating: Float = 0.0
}
