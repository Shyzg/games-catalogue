//
//  CreatorDetailViewModel.swift
//  games-catalogue
//
//  Created by Shyzago Nakamoto on 31/05/22.
//

import Foundation
import SwiftUI
import Combine

class DetailCreatorViewModel: ObservableObject {
	@Published var isLoading = true
	@Published var errorMessage: String = ""
	@Published var detailCreator: CreatorDetailModel?

	func loadData(id: Int) {
		guard let url = URL(string: "\(Constant.api)creators/\(id)?key=\(Constant.apiKey)") else {
			fatalError("Error while get url")
		}

		URLSession.shared.dataTask(with: url) { (data, _, error) in
			guard let data = data, error == nil else {
				print("Error : \(error!.localizedDescription)")

				self.errorMessage = "Gagal memuat data : \(error!.localizedDescription)"

				return
			}

			do {
				let result = try JSONDecoder().decode(CreatorDetailModel.self, from: data)

				self.isLoading = false
				
				DispatchQueue.main.async {
					self.detailCreator = result
				}

			} catch let error {
				self.errorMessage = "Gagal memuat data : \(error.localizedDescription)"

				print("Error : \(error.localizedDescription)")
			}
		}
		.resume()

	}
}
