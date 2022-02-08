//
//  HowToUseView.swift
//  NoSpoilerHelper
//
//  Created by Kenta Matsue on 2022/02/08.
//

import SwiftUI
import AVKit

struct HowToUseView: View {
    var body: some View {
        VideoPlayer(player: AVPlayer(url:  Bundle.main.url(forResource: "tutorial", withExtension: "mov")!))
            .frame(height: 400)
    }
}

struct HowToUseView_Previews: PreviewProvider {
    static var previews: some View {
        HowToUseView()
    }
}
