//
//  ContentView.swift
//  ruswarlosses
//
//  Created by Vitaliy on 24.08.2023.
//

import SwiftUI

struct MenuItem: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var image: String
    var subMenuItems: [MenuItem]?
}


struct SplitViewContent: View {
    @State private var fullScreen = false

    var body: some View {
        NavigationView {
//            VStack {
//                Text("Fisrt")
//                Text("Second")
//                Button("Toggle Full Screen") {
//                    self.fullScreen.toggle()
//                }
//                .navigationTitle("Full Screen")
//            }
            NavigationLink(destination: EquipmentLosses()) {
                Text("Mil equipment losses")
            }
            .navigationTitle("Navigation")
//            .navigationBarHidden(fullScreen)
        }
        .background(.ultraThinMaterial)
//        .statusBar(hidden: fullScreen)
    }
}


struct MySidebar: View {
    var body: some View {
        VStack {
            Text("Fisrt")
            Text("Second")
        }
    }
}

struct SplitViewContent_Previews: PreviewProvider {
    static var previews: some View {
//        ContentView()
        SplitViewContent()
    }
}
