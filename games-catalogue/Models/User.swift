//
//  User.swift
//  games-catalogue
//
//  Created by Shyzago Nakamoto on 06/06/22.
//

import Foundation

struct UserModel: Codable {
	let name: String
	let email: String
	let phoneNumber: String
	let website: String
	let githubUrl: String
	let profilePicture: Data
}
