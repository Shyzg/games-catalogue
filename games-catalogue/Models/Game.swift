//
//  Game.swift
//  games-catalogue
//
//  Created by Shyzago Nakamoto on 25/05/22.
//

import Foundation

struct GameResponse: Decodable {
	let results: [Game]
}

struct Game: Decodable, Hashable, Identifiable {
	let id: Int?
	let name: String?
	let released: Date?
	let backgroundImage: String?
	let rating: Double?
	let metaScore: Int?
	let playtime: Int?
	
	enum CodingKeys: String, CodingKey {
		case id
		case name
		case released
		case backgroundImage = "background_image"
		case rating
		case metaScore = "metacritic"
		case playtime
	}
	
	init(id: Int?, name: String?, released: Date?, backgroundImage: String?, rating: Double?, metaScore: Int?, playtime: Int?) {
		self.id = id
		self.name = name
		self.released = released
		self.backgroundImage = backgroundImage
		self.rating = rating
		self.metaScore = metaScore
		self.playtime = playtime
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let dateGet = try? container.decode(String.self, forKey: .released)
		
		id = try? container.decode(Int.self, forKey: .id)
		name = try? container.decode(String.self, forKey: .name)
		backgroundImage = try? container.decode(String.self, forKey: .backgroundImage)
		rating = try? container.decode(Double.self, forKey: .rating)
		metaScore = try? container.decode(Int.self, forKey: .metaScore)
		playtime = try? container.decode(Int.self, forKey: .playtime)
		
		released = dateGet?.convertToDate()
	}
}
