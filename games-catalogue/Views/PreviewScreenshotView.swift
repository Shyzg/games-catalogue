//
//  PreviewScreenshotView.swift
//  games-catalogue
//
//  Created by Shyzago Nakamoto on 05/06/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct PreviewScreenshotView: View {
	@Environment(\.presentationMode) private var presentation
	
	@Binding var screenshotPreview: String
	
	var body: some View {
		NavigationView {
			VStack {
				WebImage(url: URL(string: screenshotPreview))
					.resizable()
					.rotationEffect(Angle(degrees: -90))
					.aspectRatio(contentMode: .fill)
					.frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height - 150, alignment: .top)
					.clipped()
					.cornerRadius(40)
			}
			.frame(alignment: .top)
			.padding(.bottom, 50)
			.navigationBarItems(trailing: Button(action: {
				self.presentation.wrappedValue.dismiss()
			}, label: {
				Text("Done")
			}))
			
			HStack {
				WebImage(url: URL(string: screenshotPreview))
					.resizable()
					.rotationEffect(Angle(degrees: -90))
					.aspectRatio(contentMode: .fill)
				
			}
		}
	}
}
