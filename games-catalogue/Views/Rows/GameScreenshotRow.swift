//
//  GameScreenshotRow.swift
//  games-catalogue
//
//  Created by Shyzago Nakamoto on 05/06/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct GameScreenshotRow: View {
	var screenshots: [Screenshots]

	@State private var isFullScreen = false
	@State var activePreview: String = ""
	
	var body: some View {
		VStack(alignment: .leading) {
			ScrollView(.horizontal, showsIndicators: false) {
				HStack(alignment: .top) {
					ForEach(self.screenshots, id: \.id) { screenshot in
						Spacer()
						Spacer()
						WebImage(url: URL(string: screenshot.image)!)
							.resizable()
							.renderingMode(.original)
							.aspectRatio(contentMode: .fill)
							.frame(width: 300, height: 150)
							.clipped()
							.cornerRadius(15)
							.onTapGesture {
								isFullScreen.toggle()
								activePreview = screenshot.image
							}
							.fullScreenCover(isPresented: $isFullScreen, content: {
								PreviewScreenshotView(screenshotPreview: self.$activePreview)
							})

						Spacer()
					}
				}
			}
		}
	}
}
