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
        List{
            Text("Welcome to the settings page \(tampi.userInfo.tampiOwnerName)")
        }
        .scrollDisabled(true)
        List{
            
        }
        Spacer()
    }
}
