//
//  StartView.swift
//  MelbGameKeeper
//
//  Created by D K on 06.03.2025.
//

import SwiftUI

struct StartView: View {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some View {
        HomeView()
            .onAppear {
                AppDelegate.orientationLock = .portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                UINavigationController.attemptRotationToDeviceOrientation()
            }
    }
}

#Preview {
    StartView()
}
