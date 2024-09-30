import Foundation

/**
 * This file contains temporary models that should be replaced when adding SwiftData.
 * It is essential to remove this file before the final project submission.
 */

struct tempCategory: Identifiable, Hashable, Codable {
  let id: UUID
  var name: String
  var recipes: [tempRecipe]

  init(id: UUID = UUID(), name: String = "", recipes: [tempRecipe] = []) {
    self.id = id
    self.name = name
    self.recipes = recipes
  }
}

struct tempIngredient: Identifiable, Hashable, Codable {
  let id: UUID
  var name: String

  init(id: UUID = UUID(), name: String = "") {
    self.id = id
    self.name = name
  }
}

struct tempRecipeIngredient: Identifiable, Hashable, Codable {
  let id: UUID
  var ingredient: tempIngredient
  var quantity: String

  init(id: UUID = UUID(), ingredient: tempIngredient = tempIngredient(), quantity: String = "") {
    self.id = id
    self.ingredient = ingredient
    self.quantity = quantity
  }
}

struct tempRecipe: Identifiable, Hashable, Codable {
  let id: UUID
  var name: String
  var summary: String
  var category: tempCategory?
  var serving: Int
  var time: Int
  var ingredients: [tempRecipeIngredient]
  var instructions: String
  var imageData: Data?

  init(
    id: UUID = UUID(),
    name: String = "",
    summary: String = "",
    category: tempCategory? = nil,
    serving: Int = 1,
    time: Int = 5,
    ingredients: [tempRecipeIngredient] = [],
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
