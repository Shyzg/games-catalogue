//
//  ProfilePictureRow.swift
//  games-catalogue
//
//  Created by Shyzago Nakamoto on 06/06/22.
//

import SwiftUI

struct ProfilePictureRow: View {
	@EnvironmentObject var userData: UserViewModel

	@State var profileImageData: Data = Data()

	var body: some View {
		VStack {
			if !profileImageData.isEmpty {
				let decoded = (try? PropertyListDecoder().decode(Data.self, from: profileImageData)) ??  Data()

				Image(uiImage: UIImage(data: decoded)!)
					.resizable()
					.renderingMode(.original)
					.frame(width: 37, height: 37)
					.clipShape(Circle())
			} else {
				Image("profile_dummy")
					.resizable()
					.renderingMode(.original)
					.frame(width: 37, height: 37)
					.clipShape(Circle())
			}
		}
		.onAppear {
			self.userData.fetchItem()
			self.profileImageData = userData.item?.profilePicture ?? Data()
		}
		
	}
}
