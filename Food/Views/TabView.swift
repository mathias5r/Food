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
    }
}

struct TabsView: View {
    var body: some View {
        GeometryReader { geometry in
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


