//
//  GameDetail.swift
//  games-catalogue
//
//  Created by Shyzago Nakamoto on 25/05/22.
//

import Foundation

struct GameDetail: Decodable, Identifiable {
	let id: Int?
	let name: String?
	let description: String?
	let released: Date?
	let backgroundImage: String?
	let rating: Double?
	let metaScore: Int?
	let playtime: Int?
	let genres: [Genre]?

	enum CodingKeys: String, CodingKey {
		case id
		case name
		case description = "description_raw"
		case released
		case backgroundImage = "background_image"
		case rating
		case metaScore = "metacritic"
		case playtime
		case genres
	}

	init(id: Int?, name: String?, description: String?, released: Date?, backgroundImage: String?, rating: Double?, metaScore: Int?, playtime: Int?, genres: [Genre]?) {
		self.id = id
		self.name = name
		self.description = description
		self.released = released
		self.backgroundImage = backgroundImage
		self.rating = rating
		self.metaScore = metaScore
		self.playtime = playtime
		self.genres = genres
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let dateGet = try? container.decode(String.self, forKey: .released)

		id = try? container.decode(Int.self, forKey: .id)
		name = try? container.decode(String.self, forKey: .name)
		description = try? container.decode(String.self, forKey: .description)
		backgroundImage = try? container.decode(String.self, forKey: .backgroundImage)
		rating = try? container.decode(Double.self, forKey: .rating)
		metaScore = try? container.decode(Int.self, forKey: .metaScore)
		playtime = try? container.decode(Int.self, forKey: .playtime)
		genres = try? container.decode([Genre].self, forKey: .genres)
		
		released = dateGet?.convertToDate()
	}
}

struct Genre: Decodable, Identifiable {
	let id: Int
	let name: String
}
