/*
*  File: Menu.swift
*  Project: LittleLemonApp
*  Author: macitch.(@https://www.github.com/macitch)
*  Created: on 23.05.2025.
*  Copyright (C) 2025. macitch.
*/

import SwiftUI
import CoreData

struct MenuView: View {
    @Environment(\.managedObjectContext) private var viewContext

    private let categories = ["starters", "mains", "desserts", "drinks"]
    @State private var selectedCategory: String? = nil

    @State private var showVeganOnly = false

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Dish.title, ascending: true)],
        animation: .default
    ) private var allDishes: FetchedResults<Dish>

    private var filteredDishes: [Dish] {
        allDishes.filter { dish in
            let matchesCategory = selectedCategory == nil
                || dish.category?.lowercased() == selectedCategory

            let matchesVegan = !showVeganOnly
                || (dish.category?.lowercased() == "vegan")

            return matchesCategory && matchesVegan
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            Hero()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(categories, id: \.self) { cat in
                        let isSelected = selectedCategory == cat
                        Text(cat.capitalized)
                            .font(.sectionCategories())
                            .foregroundColor(isSelected ? .white : .primaryColor1)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(isSelected
                                ? Color.primaryColor1
                                : Color.highlightColor1
                            )
                            .cornerRadius(16)
                            .onTapGesture {
                                selectedCategory = (isSelected ? nil : cat)
                            }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }

            HStack {
                Spacer()
                Toggle("Show Vegan Only", isOn: $showVeganOnly)
            }
            .padding(.horizontal)
            .padding(.bottom, 4)

            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(filteredDishes, id: \.objectID) { dish in
                        FoodItem(dish: dish)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .background(Color.highlightColor1.ignoresSafeArea(edges: .bottom))
        }
        .navigationTitle("Menu")
        .navigationBarHidden(true)
        .task {
            do {
                try await MenuList.fetchAndStore(into: viewContext)
            } catch {
                print("❌ menu load failed:", error)
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MenuView()
                .environment(\.managedObjectContext,
                             PersistenceController.preview.container.viewContext)
        }
    }
}
