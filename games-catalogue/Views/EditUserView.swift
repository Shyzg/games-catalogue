//
//  EditUserView.swift
//  games-catalogue
//
//  Created by Shyzago Nakamoto on 06/06/22.
//

import SwiftUI
import RealmSwift

struct EditUserView: View {
	@Environment(\.presentationMode) private var presentation

	@ObservedObject var userData = UserViewModel()

	@State var profileImageData: Data = Data()
	@State var fullname: String = ""
	@State var email: String = ""
	@State var noHP: String = ""
	@State var website: String = ""
	@State var githubLink: String = ""
	@State var isShowProfilePickerSheet = false
	@State var isGalleryPicker = false
	@State var isCameraPicker = false
	@State var isShowEditProfilePictureActionSheet = false

	var body: some View {

		NavigationView {

			VStack {
				HStack {
					Button(action: {
						self.isShowEditProfilePictureActionSheet = true
					}, label: {
						if !profileImageData.isEmpty {
							let decoded = (try? PropertyListDecoder().decode(Data.self, from: profileImageData)) ?? Data()

							Image(uiImage: UIImage(data: decoded)!)
								.resizable()
								.scaledToFill()
								.frame(width: 100, height: 100)
								.overlay(
									Rectangle()
										.opacity(0.6)

										.overlay(
											Text("EDIT")
												.foregroundColor(Color.white)
												.font(.caption)
												.bold()
												.padding(.top, -5)
										)
										.padding(.top, 70)
								)
								.clipShape(Circle())
						} else {
							Image("profile_dummy")
								.resizable()
								.scaledToFill()
								.frame(width: 100, height: 100)
								.overlay(
									Rectangle()
										.opacity(0.6)

										.overlay(
											Text("EDIT")
												.foregroundColor(Color.white)
												.font(.caption)
												.bold()
												.padding(.top, -5)
										)
										.padding(.top, 70)
								)
								.clipShape(Circle())
						}
					})

				}
				.actionSheet(isPresented: $isShowEditProfilePictureActionSheet) {
					ActionSheet(
						title: Text(""),
						buttons: [
							.cancel(),
							.default(Text("Take Photo")) {
								self.isShowProfilePickerSheet = true
								self.isCameraPicker = true
								self.isGalleryPicker = false
							},
							.default(Text("Choose Photo")) {
								self.isShowProfilePickerSheet = true
								self.isGalleryPicker = true
								self.isCameraPicker = false
							}
						]
					)
				}
				.padding(.top, 30)

				List {
					Section(header: Text("Profile Detail"), content: {
						TextField("Fullname", text: $fullname)
						TextField("Email", text: $email)
						TextField("No HP", text: $noHP)
							.textContentType(.oneTimeCode)
							.keyboardType(.numberPad)
						TextField("Website", text: $website)
					})

					Section(header: Text("Developer Only"), content: {
						TextField("GitHub Link", text: $githubLink)

					})
				}
				.padding(.top, 15)
				.listStyle(GroupedListStyle())

				List {
					Section(header: Text("Shyzago Profile"), content: {

					})
				}
			}
			.background(Color.init(.systemGray6))

			.navigationTitle("Edit profile")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar(content: {

				ToolbarItem(placement: .navigationBarLeading, content: {
					Button(action: {
						self.presentation.wrappedValue.dismiss()
					}, label: {
						Text("Cancel")
					})
				})

				ToolbarItem(placement: .navigationBarTrailing, content: {
					Button(action: {
						self.userData.addItem(data: UserModel(name: self.fullname, email: self.email, phoneNumber: self.noHP, website: self.website, githubUrl: self.githubLink, profilePicture: self.profileImageData))
						self.presentation.wrappedValue.dismiss()
					}, label: {
						Text("Done")
					})
				})

			})
		}
		.sheet(isPresented: $isShowProfilePickerSheet, onDismiss: {
		}) {
			if isCameraPicker {
				ImagePicker(sourceType: .camera, selectedImageData: self.$profileImageData)
			} else {
				ImagePicker(sourceType: .photoLibrary, selectedImageData: self.$profileImageData)
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
