//
//  CreatorDetail.swift
//  games-catalogue
//
//  Created by Shyzago Nakamoto on 31/05/22.
//

import Foundation

struct CreatorDetailModel: Codable {
	let description: String
	let rating: String

	enum CodingKeys: String, CodingKey {
		case description
		case rating
	}
}
