//
//  SwiftData_Models.swift
//  SwiftBites
//
//  Created by Bilal Mughal on 26/09/2024.
//

import Foundation
import SwiftData
import SwiftUI


@Model
final class SwiftDataCategory {
    var ids: UUID
    @Attribute(.unique) var name: String
    var recipes: [SwiftDataRecipe]?

    init(id: UUID = UUID(), name: String) {
        self.ids = id
        self.name = name
    }
}

@Model
final class SwiftDataIngredient {
    var id: UUID
    @Attribute(.unique) var name: String

    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}

@Model
final class SwiftDataRecipeIngredient {
    let id = UUID()
    var ingredient: SwiftDataIngredient?
    var quantity: String
    
    init(ingredient: SwiftDataIngredient? = nil, quantity: String) {
        self.ingredient = ingredient
        self.quantity = quantity
    }
    
}


@Model
final class SwiftDataRecipe {
    var id = UUID()
    @Attribute(.unique) var name: String
    var summary: String
    var categoryId: SwiftDataCategory? // Ensure MockCategory is also a Swift Data model
    var serving: Int
    var time: Int
    var ingredients: [SwiftDataRecipeIngredient] // Assuming RecipeIngredient is also a Swift Data model
    var instructions: String
    var imageData: Data?
    
    init(
        id: UUID = UUID(),
        name: String = "",
        summary: String = "",
        categoryId: SwiftDataCategory? = nil,
        serving: Int = 1,
        time: Int = 5,
        ingredients: [SwiftDataRecipeIngredient] = [],
        instructions: String = "",
        imageData: Data? = nil
    ) {
        self.id = id
        self.name = name
        self.summary = summary
        self.categoryId = categoryId
        self.serving = serving
        self.time = time
        self.ingredients = ingredients
        self.instructions = instructions
        self.imageData = imageData
    }
}
    
