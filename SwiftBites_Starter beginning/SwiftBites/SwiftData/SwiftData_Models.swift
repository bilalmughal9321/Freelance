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
final class Categories {
    var ids: UUID
    @Attribute(.unique) var name: String
    var recipes: [Recipes]?

    init(id: UUID = UUID(), name: String) {
        self.ids = id
        self.name = name
    }
}

@Model
final class Ingredients {
    var id: UUID
    @Attribute(.unique) var name: String

    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}

@Model
final class RecipeIngredients {
    let id = UUID()
    var ingredient: Ingredients?
    var quantity: String
    
    init(ingredient: Ingredients? = nil, quantity: String) {
        self.ingredient = ingredient
        self.quantity = quantity
    }
    
}


@Model
final class Recipes {
    var id = UUID()
    @Attribute(.unique) var name: String
    var summary: String
    var category: Categories?
    var serving: Int
    var time: Int
    var ingredients: [RecipeIngredients]
    var instructions: String
    var imageData: Data?
    
    init(
        id: UUID = UUID(),
        name: String = "",
        summary: String = "",
        category: Categories? = nil,
        serving: Int = 1,
        time: Int = 5,
        ingredients: [RecipeIngredients] = [],
        instructions: String = "",
        imageData: Data? = nil
    ) {
        self.id = id
        self.name = name
        self.summary = summary
        self.category = category
        self.serving = serving
        self.time = time
        self.ingredients = ingredients
        self.instructions = instructions
        self.imageData = imageData
    }
}
    
