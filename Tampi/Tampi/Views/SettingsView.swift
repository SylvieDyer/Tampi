//
//  SettingsView.swift
//  Tampi
//
//  Created by Sylvie Dyer on 4/4/23.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var tampi: Tampi
    var body: some View {
        List {
            Text("Welcome to the Settings Page, \(tampi.userInfo.tampiOwnerName)!").bold().font(.title2)
        }.scrollDisabled(true).padding(.bottom, 0).frame(height: 150)
       
        // tbd what settings we're changing
        List{
            Text("Change Tampi Owner-Name")
            Text("Change Cycle Owner-Name")
            Text("Change Color Scheme")
            Text("Change Presets")
        }.bold()
        Spacer()
    }
}
