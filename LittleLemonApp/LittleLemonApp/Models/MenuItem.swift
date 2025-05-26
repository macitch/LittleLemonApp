/*
*  File: MenuItem.swift
*  Project: LittleLemonApp
*  Author: macitch.(@https://www.github.com/macitch)
*  Created: on 23.05.2025.
*  Copyright (C) 2025. macitch.
*/

import Foundation

struct MenuItem: Codable, Identifiable {
    var id = UUID()
    let title : String
    let descriptionDish: String
    let price: String
    let image: String
    let category: String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case descriptionDish = "description"
        case price = "price"
        case image = "image"
        case category = "category"
    }
}
