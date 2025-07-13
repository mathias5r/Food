//
//  DetailsViewController+SwiftUI.swift
//  Food
//
//  Created by Mathias da Rosa on 12/07/25.
//

import SwiftUI

struct DetailsViewControllerSwiftUI: View {
    @Environment(\.dismiss) var dismiss
    
    var restaurant: RestaurantModel?
    
    var body: some View {
        if let item = restaurant {
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    ZStack(alignment: .top) {
                        AsyncImage(url: URL(string: item.image)) { phase in
                            switch phase {
                            case .failure:
                                Image(systemName: "photo").font(.largeTitle)
                            case .success(let image):
                                image.resizable()
                            default:
                                ProgressView()
                            }
                        }
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.3)
                        .clipped()
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                        }.tint(.white).frame(minWidth: geometry.size.width - 32, maxHeight: geometry.safeAreaInsets.top + 64, alignment: .trailing)
                    }
                    VStack(alignment: .leading) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name).font(.system(size: 24, weight: .bold)).foregroundStyle(.black).padding([.top, .leading], 16)
                                Text(item.address.toString()).font(.system(size: 18, weight: .regular)).foregroundStyle(.black).padding(.leading, 16)
                            }
                            Text(item.cuisine).font(.system(size: 16, weight: .semibold)).foregroundStyle(.black).padding(.leading, 16).padding(.trailing, 16).frame(maxWidth: 100, alignment: .trailing)
                        }
                        SeparatorView()
                        HStack {
                            Text("Rating:").font(.system(size: 16, weight: .regular)).padding(.leading, 16).padding(.top, 4)
                            StarRatingView(rating: 4).padding(.top, 4)
                        }
                        HStack {
                            let phone = Phone.format(item.phone)
                            Text("Phone: \(phone))").font(.system(size: 16, weight: .regular)).padding(.leading, 16).padding(.top, 4)
                            Spacer()
                            Button(action: {
                                Phone.openDialler(phone)
                            }) {
                                Image(systemName: "phone.fill")
                            }.padding(.trailing, 16)
                        }
                        
                    }
                }.ignoresSafeArea()
            }
        }
    }
}

struct DetailsViewControllerSwiftUI_Preview: PreviewProvider {
    static var previews: some View {
        let location: LocationModel = LocationModel(lat: 37.3401, long: -122.0155);
        let address: AddressModel = AddressModel(country: "USA", street: "123 Main St", city: "Cupertino", state: "CA", zipCode: "95014")
        let restaurant: RestaurantModel = RestaurantModel(name: "Pizza Palace", location: location, address: address, image: "https://images.unsplash.com/photo-1544455667-66f30d0412cd?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", phone: "+1-418-543-8090", rating: 1.0, cuisine: "Italian")
        DetailsViewControllerSwiftUI(restaurant: restaurant)
    }
}
