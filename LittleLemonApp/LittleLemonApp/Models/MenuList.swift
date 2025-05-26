/*
*  File: MenuList.swift
*  Project: LittleLemonApp
*  Author: macitch.(@https://www.github.com/macitch)
*  Created: on 23.05.2025.
*  Copyright (C) 2025. macitch.
*/

import Foundation
import CoreData

struct MenuList: Codable {
    let menu: [MenuItem]
}

extension MenuList {
    static func fetchAndStore(into context: NSManagedObjectContext) async throws {

        guard let url = URL(string: "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        let fullMenu = try decoder.decode(MenuList.self, from: data)

        await context.perform {
            do {
                try PersistenceController.shared.clear(entityName: "Dish")

                fullMenu.menu.forEach { item in
                    let dish = Dish(context: context)
                    dish.title = item.title
                    dish.descriptionDish = item.descriptionDish
                    dish.price = item.price
                    dish.category = item.category
                    dish.image = item.image
                }

                if context.hasChanges {
                    try context.save()
                }
            } catch {

                NSLog("Failed to update menu in Core Data: \(error)")
            }
        }
    }
}
