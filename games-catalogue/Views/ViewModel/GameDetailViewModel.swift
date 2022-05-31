//
//  GameDetailViewModel.swift
//  games-catalogue
//
//  Created by Shyzago Nakamoto on 31/05/22.
//

import Foundation
import SwiftUI
import Combine

class GameDetailViewModel: ObservableObject {
	@Published var isLoading = true
	@Published var errorMessage: String = ""
	@Published var detailGame: GameDetailModel?

	func loadData(id: Int) {
		guard let url = URL(string: "\(Constant.api)games/\(id)?key=\(Constant.apiKey)") else {
			fatalError("Error while get url")
		}

		URLSession.shared.dataTask(with: url) { (data, _, error) in
			guard let data = data, error == nil else {
				print("Error : \(error!.localizedDescription)")

				self.errorMessage = "Gagal memuat data : \(error!.localizedDescription)"

				return
			}

			do {
				let result = try JSONDecoder().decode(GameDetailModel.self, from: data)

				self.isLoading = false

				DispatchQueue.main.async {
					self.detailGame = result
				}

			} catch let error {
				self.errorMessage = "Gagal memuat data : \(error.localizedDescription)"

				print("Error : \(error.localizedDescription)")
			}
		}
		.resume()
	}
}
