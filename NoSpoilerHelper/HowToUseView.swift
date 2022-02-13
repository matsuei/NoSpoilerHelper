//
//  HowToUseView.swift
//  NoSpoilerHelper
//
//  Created by Kenta Matsue on 2022/02/08.
//

import SwiftUI
import AVKit

struct HowToUseView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                VideoPlayer(player: AVPlayer(url:  Bundle.main.url(forResource: "tutorial", withExtension: "mov")!))
                    .frame(width: 200, height: 420, alignment: .center)
                Text("Settings > Safari > Extension \nturn on NoSpolierHelper")
                    .font(.title3)
                    .lineSpacing(10)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }, label: {
                        Text("Close")
                    })
                }
            }
        }
    }
}

struct HowToUseView_Previews: PreviewProvider {
    static var previews: some View {
        HowToUseView()
    }
}
