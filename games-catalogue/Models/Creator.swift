//
//  Creator.swift
//  games-catalogue
//
//  Created by Shyzago Nakamoto on 31/05/22.
//

import Foundation

struct CreatorModel: Codable {
	var results: [Results]

	enum CodingKeys: String, CodingKey {
		case results
	}
}

struct Results: Codable {
	let id: Int
	let name: String
	let image: String
	let imageBackground: String
	let gamesCount: Int
	var positions: [Positions]
	var games: [Games]

	enum CodingKeys: String, CodingKey {
		case id
		case name
		case image
		case imageBackground = "image_background"
		case gamesCount = "games_count"
		case positions
		case games
	}
}

struct Positions: Codable {

	let id: Int
	let name: String

	enum CodingKeys: String, CodingKey {
		case id
		case name
	}
}

struct Games: Codable {
	let id: Int
	let name: String

	enum CodingKeys: String, CodingKey {
		case id
		case name
	}
}
