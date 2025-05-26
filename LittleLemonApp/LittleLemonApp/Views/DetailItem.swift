/*
*  File: DetailItem.swift
*  Project: LittleLemonApp
*  Author: macitch.(@https://www.github.com/macitch)
*  Created: on 23.05.2025.
*  Copyright (C) 2025. macitch.
*/

import SwiftUI

struct DetailItem: View {
    @Environment(\.managedObjectContext) private var viewContext
    let dish: Dish

    var body: some View {
        ScrollView {
            AsyncImage(url: URL(string: dish.image ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(minHeight: 150)
                case .success(let img):
                    img
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(minHeight: 150)
                        .foregroundColor(.secondaryColor2)
                @unknown default:
                    EmptyView()
                }
            }
            .clipShape(Rectangle())

            Text(dish.title ?? "")
                .font(.subTitleFont())
                .foregroundColor(.primaryColor1)
                .padding(.top, 16)

            Text(dish.descriptionDish ?? "")
                .font(.regularText())
                .padding(.vertical, 8)

            Text("$\(dish.price ?? "0")")
                .font(.highlightText())
                .foregroundColor(.primaryColor1)
                .monospacedDigit()
                .padding(.bottom, 16)
        }
        .frame(maxWidth: .infinity)
    }
}

struct DetailItem_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let sampleDish = Dish(context: context)
        sampleDish.title = "Greek Salad"
        sampleDish.descriptionDish = "The famous Greek salad of crispy lettuce, peppers, olives, our Chicago twist."
        sampleDish.price = "10"
        sampleDish.category = "starters"
        sampleDish.image = "https://github.com/Meta-Mobile-Developer-PC/Working-With-Data-API/blob/main/images/greekSalad.jpg?raw=true"

        return DetailItem(dish: sampleDish)
            .environment(\.managedObjectContext, context)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
