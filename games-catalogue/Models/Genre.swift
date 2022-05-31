//
//  Genre.swift
//  games-catalogue
//
//  Created by Shyzago Nakamoto on 31/05/22.
//

import Foundation

struct GenreModel: Codable {
	var results: [GenreResults]

	enum CodingKeys: String, CodingKey {
		case results
	}
}

struct GenreResults: Codable {
	let id: Int
	let name: String
	let imageBackground: String
	let games: [Games]

	enum CodingKeys: String, CodingKey {
		case id
		case name
		case imageBackground = "image_background"
		case games
	}
}
