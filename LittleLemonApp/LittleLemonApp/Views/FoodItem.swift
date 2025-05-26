/*
*  File: FoodItem.swift
*  Project: LittleLemonApp
*  Author: macitch.(@https://www.github.com/macitch)
*  Created: on 23.05.2025.
*  Copyright (C) 2025. macitch.
*/

import SwiftUI

struct FoodItem: View {
    let dish: Dish

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(dish.title ?? "")
                    .font(.custom("Karla-Bold", size: 16))
                    .fontWeight(.bold)
                    .foregroundColor(.primaryColor1)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(dish.descriptionDish ?? "")
                    .font(.paragraphText())
                    .foregroundColor(.highlightColor2)
                    .lineLimit(2)

                Text("$\(dish.price ?? "0")")
                    .font(.highlightText())
                    .foregroundColor(.primaryColor1)
                    .monospacedDigit()
            }

            AsyncImage(url: URL(string: dish.image ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 90, height: 90)
                case .success(let img):
                    img
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 90, height: 90)
                        .cornerRadius(8)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 90)
                        .foregroundColor(.secondaryColor2)
                @unknown default:
                    EmptyView()
                }
            }
        }
        .padding(8)
    }
}

struct FoodItem_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let sampleDish = Dish(context: context)
        sampleDish.title = "Greek Salad"
        sampleDish.descriptionDish = "The famous Greek salad of crispy lettuce, peppers, olives, our Chicago twist."
        sampleDish.price = "10"
        sampleDish.category = "starters"
        sampleDish.image = "https://github.com/Meta-Mobile-Developer-PC/Working-With-Data-API/blob/main/images/greekSalad.jpg?raw=true"

        return FoodItem(dish: sampleDish)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
