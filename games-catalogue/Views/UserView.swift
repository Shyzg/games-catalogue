//
//  UserView.swift
//  games-catalogue
//
//  Created by Shyzago Nakamoto on 06/06/22.
//

import SwiftUI

struct UserView: View {
	@Environment(\.presentationMode) var presentation
	@Environment(\.openURL) var openURL
	@Environment(\.colorScheme) var colorScheme

	@State var isEditModalShow: Bool = false
	@State var profileImageData: Data = Data()
	@State var fullname: String = ""
	@State var email: String = ""
	@State var noHP: String = ""
	@State var website: String = ""
	@State var githubLink: String = ""

	@EnvironmentObject var userData: UserViewModel

	var body: some View {
		ScrollView(.vertical) {
			ZStack(alignment: .top) {
				VStack {
					VStack {
						if !profileImageData.isEmpty {
							let decoded = (try? PropertyListDecoder().decode(Data.self, from: userData.item!.profilePicture)) ?? Data()

							Image(uiImage: UIImage(data: decoded)!)
								.resizable()
								.scaledToFill()
								.frame(width: 100, height: 100)
								.clipShape(Circle())
						} else {
							Image("profile_dummy")
								.resizable()
								.scaledToFill()
								.frame(width: 100, height: 100)
								.clipShape(Circle())
						}

						Text(userData.item?.name ?? "")
							.font(.title2)
							.fontWeight(.bold)
							.padding(.top, 10)
					}
					.padding(.top, 20)

					Spacer().frame(height: 30)

					VStack(alignment: .leading, spacing: 12) {
						HStack {
							Image(systemName: "envelope")
							Text(userData.item?.email ?? "")
						}

						HStack {
							Image(systemName: "phone")
							Text(userData.item?.phoneNumber ?? "")
						}

						HStack {
							Image(systemName: "network")
							Text(userData.item?.website ?? "")
						}
					}

					Spacer().frame(height: 50)

					if userData.item?.githubUrl != "" {
						Button(action: {
							openURL(URL(string: userData.item?.githubUrl ?? "")!)
						}) {
							HStack {
								Spacer()
								HStack {
									Image(colorScheme == .light ? "icon_github_white" : "icon_github_black")
										.resizable()
										.frame(width: 25, height: 25)

									Text("View on GitHub")
										.font(.callout)
										.fontWeight(.bold)
										.padding()
								}

								Spacer()
							}
						}
						.frame(width: 230, height: 50)
						.background(colorScheme == .light ? Color.black : Color.white)
						.foregroundColor(colorScheme == .light ? Color.white : Color.black)
						.cornerRadius(15)
					}

				}
				.onAppear {
					/// fetch user data
					self.userData.fetchItem()

					/// fill state variable with data from environtment object after fetchItem()
					self.fullname = userData.item?.name ?? ""
					self.email = userData.item?.email ?? ""
					self.noHP = userData.item?.phoneNumber ?? ""
					self.website = userData.item?.website ?? ""
					self.githubLink = userData.item?.githubUrl ?? ""
					self.profileImageData = userData.item?.profilePicture ?? Data()

				}
			}
		}
		.navigationTitle("Profile").navigationBarTitleDisplayMode(.large)
		.navigationBarBackButtonHidden(true)
		.navigationBarItems(leading:
								Button(action: {
			self.presentation.wrappedValue.dismiss()
		}) {
			HStack {
				Image(systemName: "chevron.backward.circle.fill")
					.resizable()
					.frame(width: 30, height: 30)
					.foregroundColor(colorScheme == .light ? .black : .white)
			}
		},
							trailing:
								Button(action: {
			self.isEditModalShow = true
		}, label: {
			Text("Edit")
		})
									.sheet(isPresented: $isEditModalShow, onDismiss: {
										self.userData.fetchItem()

										/// fill state variable with data from environtment object after fetchItem()
										self.fullname = userData.item?.name ?? ""
										self.email = userData.item?.email ?? ""
										self.noHP = userData.item?.phoneNumber ?? ""
										self.website = userData.item?.website ?? ""
										self.githubLink = userData.item?.githubUrl ?? ""
										self.profileImageData = userData.item?.profilePicture ?? Data()
									}, content: {
										UserView()
									})
		)
	}
}
