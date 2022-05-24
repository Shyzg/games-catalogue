//
//  GameService.swift
//  games-catalogue
//
//  Created by Shyzago Nakamoto on 25/05/22.
//

import Foundation

class GameService {
	private let urlSession = URLSession.shared
	private let baseUrl = "https://api.rawg.io/api/"

	func getGameList(query: String?, completion: @escaping (Result<GameResponse, Error>) -> Void) {
		var components: URLComponents = URLComponents(string: self.baseUrl + "games")!

		if let searchQuery = query, !searchQuery.isEmpty {
			components.queryItems = [
				URLQueryItem(name: "search", value: query)
			]
		}

		let request = URLRequest(url: components.url!)

		self.urlSession.dataTask(with: request) { (data, response, error) in

			if let error = error {
				completion(.failure(error))
				print("DataTask Error: \(error.localizedDescription)")
			}

			guard let data = data, response != nil else {
				print("Empty Data")
				return
			}

			do {
				let decoder = JSONDecoder()
				let gameList = try decoder.decode(GameResponse.self, from: data)

				DispatchQueue.main.async {
					completion(.success(gameList))
				}
			} catch {
				completion(.failure(error))
			}
		}.resume()
	}

	func getGameDetail(id: Int, completion: @escaping (Result<GameDetail, Error>) -> Void) {
		let components: URLComponents = URLComponents(string: self.baseUrl + "games/\(id)")!

		let request = URLRequest(url: components.url!)
		self.urlSession.dataTask(with: request) { (data, response, error) in
			if let error = error {
				completion(.failure(error))
				print("DataTask Error: \(error.localizedDescription)")
			}

			guard let data = data, response != nil else {
				print("Empty Data")
				return
			}

			do {
				let decoder = JSONDecoder()
				let gameDetail = try decoder.decode(GameDetail.self, from: data)

				DispatchQueue.main.async {
					completion(.success(gameDetail))
				}
			} catch {
				completion(.failure(error))
			}
		}.resume()
	}

}
