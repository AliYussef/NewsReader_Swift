//
//  LaunchScreenView.swift
//  NewsReader611252
//
//  Created by Ali Yussef on 11/10/2020.
//

import SwiftUI

struct LaunchScreenView: View {
    @State var isActive:Bool = false
    
    var body: some View {
        ZStack{
        // 2.
        if self.isActive {
            // 3.
            ContentView()
        } else {
            // 4.
            Text("Awesome Splash Screen!")
                .font(Font.largeTitle)
        }
        // 5.
        }.onAppear {
            // 6.
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                // 7.
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
