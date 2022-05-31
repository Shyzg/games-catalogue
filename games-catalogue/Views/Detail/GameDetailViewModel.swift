//
//  GameDetailViewModel.swift
//  games-catalogue
//
//  Created by Shyzago Nakamoto on 25/05/22.
//

import Foundation

class GameDetailViewModel: ObservableObject {
	private let gameService = GameService()
	private let gameProvider = GameProvider()

	@Published var detail: GameDetail?
	@Published var isLoading = false
	@Published var isSuccess = true
	@Published var isFavorite: Bool = false

	func fetchGameDetail(id: Int) {
		self.isLoading = true
		self.gameService.getGameDetail(id: id, completion: { [weak self] (result) in
			var gameDetail: GameDetail?
			var success = true

			switch result {
				case .success(let detailOf):
					gameDetail = detailOf
				case .failure(let error):
					success = false
					print("Error processinng json data: \(error)")
			}

			DispatchQueue.main.async {
				self?.isLoading = false
				self?.isSuccess = success
				self?.detail = gameDetail
			}

			self?.checkIsExist(id: gameDetail?.id ?? 1)
		})
	}

	func addToFavorite(game: Game) {
		self.gameProvider.addFavorite(game: game, completion: {
			DispatchQueue.main.async {
				self.isFavorite = true
			}
		})
	}

	func checkIsExist(id: Int) {
		return self.gameProvider.someEntityExists(id: id, completion: { (isExist) in
			DispatchQueue.main.async {
				self.isFavorite = isExist
			}
		})
	}

	func deleteFromFavorite(id: Int) {
		self.gameProvider.deleteFavoriteGame(id, completion: {
			DispatchQueue.main.async {
				self.isFavorite = false
			}
		})
	}
}
