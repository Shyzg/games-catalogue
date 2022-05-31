//
//  GamePopular.swift
//  games-catalogue
//
//  Created by Shyzago Nakamoto on 31/05/22.
//

import Foundation

struct GamePopularModel: Codable {
	var results: [ResultGamePopulars]

	enum CodingKeys: String, CodingKey {
		case results
	}
}

struct ResultGamePopulars: Codable {
	let id: Int
	let name: String
	let released: String
	let backgroundImage: String
	let rating: Float
	var genres: [Genres]
	var screenshots: [Screenshots]

	enum CodingKeys: String, CodingKey {
		case id
		case name
		case released
		case backgroundImage = "background_image"
		case rating
		case genres
		case screenshots = "short_screenshots"
	}
}

struct Genres: Codable {
	let id: Int
	let name: String

	enum CodingKeys: String, CodingKey {
		case id
		case name
	}
}

struct Screenshots: Codable {
	let id: Int
	let image: String

	enum CodingKeys: String, CodingKey {
		case id
		case image
	}
}
