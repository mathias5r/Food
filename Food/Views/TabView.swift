//
//  TabView.swift
//  Food
//
//  Created by Mathias da Rosa on 04/08/25.
//

import SwiftUI

struct HomeViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> HomeViewController {
        return HomeFactory.viewController() as! HomeViewController
    }
    func updateUIViewController(_ uiViewController: HomeViewController, context: Context) {
        // Handle updates from SwiftUI to UIKit if needed
    }
}

struct TabsView: View {
    var body: some View {
        TabView {
            HomeViewControllerWrapper()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            Text("Profile Tab")
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
    }
}
    
struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView()
    }
}


