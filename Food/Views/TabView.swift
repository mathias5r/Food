//
//  TabView.swift
//  Food
//
//  Created by Mathias da Rosa on 04/08/25.
//

import SwiftUI

struct HomeViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context _: Context) -> HomeViewController {
        HomeFactory.viewController() as! HomeViewController
    }

    func updateUIViewController(_: HomeViewController, context _: Context) {}
}

struct TabsView: View {
    var body: some View {
        GeometryReader { _ in
            TabView {
                HomeViewControllerWrapper()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }.ignoresSafeArea(.all)
                ProfileFactory.view()
                    .tabItem {
                        Label("Profile", systemImage: "person.circle")
                    }
            }
        }
    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView()
    }
}
