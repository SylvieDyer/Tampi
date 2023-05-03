//
//  TampiApp.swift
//  Tampi
//
//  Created by Sylvie Dyer on 4/3/23.
//

import SwiftUI
import UIKit

@main
struct TampiApp: App {
    let DEVICE_NAME = "LAMPI b827ebdb1727"
    let persistenceController = PersistenceController.shared


    var body: some Scene {
        WindowGroup {
            TampiView(tampi: Tampi(name: DEVICE_NAME))
            // .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
