//
//  SwiftData_functions.swift
//  SwiftBites
//
//  Created by Bilal Mughal on 26/09/2024.
//

import Foundation
import SwiftData
import SwiftUI

final class StorageData {
    enum StorageError: LocalizedError {
        case ingredientExists
        case categoryExists
        case recipeExists
        case noRecipe
        
        var errorDescription: String? {
            switch self {
            case .ingredientExists:
                return "Ingredient with the same name exists"
            case .categoryExists:
                return "Category with the same name exists"
            case .recipeExists:
                return "Recipe with the same name exists"
            case .noRecipe:
                return "No recipe with given id found"
            }
        }
    }
    
    private var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    // MARK: - Ingredients
    
    func addIngredient(name: String) throws {
        // Create a FetchDescriptor to check if the ingredient already exists
        let fetchDescriptor = FetchDescriptor<SwiftDataIngredient>(
            predicate: #Predicate { $0.name == name }
        )
        
        // Fetch ingredients with the given name
        let existingIngredients = try? context.fetch(fetchDescriptor)
        
        // If an ingredient with the same name exists, throw an error
        guard existingIngredients?.isEmpty ?? true else {
            throw StorageError.ingredientExists
        }
        
        // If no ingredient exists, insert the new one
        let ingredient = SwiftDataIngredient(name: name)
        context.insert(ingredient)
        
        // Save the context
        try context.save()
    }

    func deleteIngredient(id: UUID) throws {
        // Create a FetchDescriptor to find the ingredient by its UUID
        let fetchDescriptor = FetchDescriptor<SwiftDataIngredient>(
            predicate: #Predicate { $0.id == id }
        )
        
        // Fetch the ingredient with the given ID
        if let ingredientToDelete = try? context.fetch(fetchDescriptor).first {
            // If the ingredient exists, delete it from the context
            context.delete(ingredientToDelete)
            
            // Save the context to persist the deletion
            try context.save()
        }
    }

    func updateIngredient(id: UUID, newName: String) throws  {
        // Fetch the ingredient by its UUID
           let fetchByIdDescriptor = FetchDescriptor<SwiftDataIngredient>(
               predicate: #Predicate { $0.id == id }
           )
           
           guard let ingredient = try? context.fetch(fetchByIdDescriptor).first else {
               throw StorageError.ingredientExists// No ingredient with the given ID was found
           }

           // Check if an ingredient with the same new name already exists (excluding the current one)
           let fetchByNameDescriptor = FetchDescriptor<SwiftDataIngredient>(
               predicate: #Predicate { $0.name == newName && $0.id != id }
           )
           
           guard (try? context.fetch(fetchByNameDescriptor))?.isEmpty ?? true else {
               throw StorageError.ingredientExists // Another ingredient with the same name exists
           }

           // Update the ingredient's name
           ingredient.name = newName
           
           // Save the changes
           try context.save()
    }
    
    // MARK: - Recipe
    
    func addRecipe(name: String,
                   summary: String,
                   categoryId: SwiftDataCategory?,
                   serving: Int,
                   time: Int,
                   ingredients: [SwiftDataRecipeIngredient],
                   instructions: String,
                   imageData: Data?) throws {
        
        let fetchDescriptor = FetchDescriptor<SwiftDataRecipe>(
            predicate: #Predicate { $0.name == name }
        )
        
        // Fetch ingredients with the given name
        let existingIngredients = try? context.fetch(fetchDescriptor)
        
        // If an ingredient with the same name exists, throw an error
        guard existingIngredients?.isEmpty ?? true else {
            throw StorageError.ingredientExists
        }
        
        // If no ingredient exists, insert the new one
        let ingredient = SwiftDataRecipe(name: name,
                                     summary: summary,
                                     categoryId: categoryId,
                                     serving: serving,
                                     time: time,
                                     ingredients: ingredients,
                                     instructions: instructions,
                                     imageData: imageData)
        context.insert(ingredient)
        
        // Save the context
        try context.save()
        
        
    }
    
    func deleteRecipe(id: UUID) throws {
        // Fetch the recipe by its ID
        let fetchRecipeDescriptor = FetchDescriptor<SwiftDataRecipe>(
            predicate: #Predicate { $0.id == id }
        )
        
        // Fetch the recipe to delete
        guard let recipeToDelete = try? context.fetch(fetchRecipeDescriptor).first else {
            throw StorageError.noRecipe
        }
        
        // Fetch all categories that contain this recipe
        let fetchCategoriesDescriptor = FetchDescriptor<SwiftDataCategory>(
            predicate: #Predicate { $0.ids == id }
        )
        
        // Remove the recipe from all related categories
        let categoriesToUpdate = try? context.fetch(fetchCategoriesDescriptor)
        categoriesToUpdate?.forEach { category in
            category.recipes?.removeAll(where: { $0.id == id })
        }
        
        // Delete the recipe from the context
        context.delete(recipeToDelete)
        
        // Save the context
        try context.save()
    }
    
    func updateRecipe(id: UUID,
                      newName: String,
                      newSummary: String,
                      newCategory: SwiftDataCategory?,
                      newServing: Int,
                      newTime: Int,
                      newIngredients: [SwiftDataRecipeIngredient],
                      newInstructions: String,
                      newImageData: Data?) throws {
        
        // Fetch the recipe by its UUID
        let fetchByIdDescriptor = FetchDescriptor<SwiftDataRecipe>(
            predicate: #Predicate { $0.id == id }
        )
        
        // Check if the recipe exists
        guard let recipeToUpdate = try? context.fetch(fetchByIdDescriptor).first else {
            throw StorageError.noRecipe // No recipe with the given ID found
        }
        
        // Check if another recipe with the same new name exists (excluding the current recipe)
        let fetchByNameDescriptor = FetchDescriptor<SwiftDataRecipe>(
            predicate: #Predicate { $0.name == newName && $0.id != id }
        )
        
        guard (try? context.fetch(fetchByNameDescriptor))?.isEmpty ?? true else {
            throw StorageError.recipeExists // Another recipe with the same name exists
        }
        
        // Update the recipe's attributes
        recipeToUpdate.name = newName
        recipeToUpdate.summary = newSummary
        recipeToUpdate.categoryId = newCategory
        recipeToUpdate.serving = newServing
        recipeToUpdate.time = newTime
        recipeToUpdate.ingredients = newIngredients
        recipeToUpdate.instructions = newInstructions
        recipeToUpdate.imageData = newImageData
        
        // Save the updated context
        try context.save()
    }
    
    
    // MARK: - Category
    
    func addCategory(name: String) throws {
        // Create a FetchDescriptor to check if the ingredient already exists
        let fetchDescriptor = FetchDescriptor<SwiftDataCategory>(
            predicate: #Predicate { $0.name == name }
        )
        
        // Fetch ingredients with the given name
        let existingCategory = try? context.fetch(fetchDescriptor)
        
        // If an ingredient with the same name exists, throw an error
        guard existingCategory?.isEmpty ?? true else {
            throw StorageError.ingredientExists
        }
        
        // If no ingredient exists, insert the new one
        let category = SwiftDataCategory(name: name)
        context.insert(category)
        
        // Save the context
        try context.save()
    }
    
    func deleteCategoy(id: UUID) throws {
        
        // Create a FetchDescriptor to find the ingredient by its UUID
        let fetchDescriptor = FetchDescriptor<SwiftDataCategory>(
            predicate: #Predicate { $0.ids == id }
        )
        
        // Fetch the ingredient with the given ID
        if let ingredientToDelete = try? context.fetch(fetchDescriptor).first {
            // If the ingredient exists, delete it from the context
            context.delete(ingredientToDelete)
            
            // Save the context to persist the deletion
            try context.save()
        }
        
    }
    
    func updateCategory(id: UUID, newName: String) throws {
        
        // Fetch the ingredient by its UUID
        let fetchByIdDescriptor = FetchDescriptor<SwiftDataCategory>(
            predicate: #Predicate { $0.ids == id }
        )
        
        guard let ingredient = try? context.fetch(fetchByIdDescriptor).first else {
            throw StorageError.ingredientExists// No ingredient with the given ID was found
        }
        
        // Check if an ingredient with the same new name already exists (excluding the current one)
        let fetchByNameDescriptor = FetchDescriptor<SwiftDataCategory>(
            predicate: #Predicate { $0.name == newName && $0.ids != id }
        )
        
        guard (try? context.fetch(fetchByNameDescriptor))?.isEmpty ?? true else {
            throw StorageError.ingredientExists // Another ingredient with the same name exists
        }
        
        // Update the ingredient's name
        ingredient.name = newName
        
        // Save the changes
        try context.save()
        
    }
    
}


func recipeFromDBtoLocal(_ model: [SwiftDataRecipe]) -> [tempRecipe]{
    
    var models = [tempRecipe]()
    var ingredients = [tempRecipeIngredient]()
    
    for recipe in model {
        
        for ingredient in recipe.ingredients {
            ingredients.append(tempRecipeIngredient(ingredient: tempIngredient(name: ingredient.ingredient?.name ?? ""), quantity: ""))
        }
        
        models.append(
            tempRecipe(id: recipe.id,
                       name: recipe.name,
                       summary: recipe.summary,
                       category: tempCategory(id: recipe.categoryId?.ids ?? UUID(), name: recipe.categoryId?.name ?? ""),
                       serving: recipe.serving,
                       time: recipe.time,
                       ingredients: ingredients,
                       instructions: recipe.instructions,
                       imageData: recipe.imageData))
        
    }
    
    return models
    
}

func recipeFromLocalToDB(_ model: [tempRecipe]) -> [SwiftDataRecipe] {
    
    var models = [SwiftDataRecipe]()
    var ingredients = [SwiftDataRecipeIngredient]()
    var ingredientsId = [UUID]()
    
    for recipe in model {
        for ingredient in recipe.ingredients {
            ingredients.append(SwiftDataRecipeIngredient(ingredient: SwiftDataIngredient(name: ingredient.ingredient.name), quantity: ""))
        }
        
        let mockCategory = SwiftDataCategory(id: recipe.category?.id ?? UUID(), name: recipe.name)
        
//        models.append(SwiftDataRecipe(id: recipe.id, name: recipe.name, summary: recipe.summary, categoryId: recipe.category?.id ?? UUID(), serving: recipe.serving, time: recipe.time, ingredients: ingredients, instructions: recipe.instructions, imageData: recipe.imageData))
    }
    
    return models
    
}

func ingredientFromDBtoLocal(_ model: [SwiftDataIngredient]) -> [tempIngredient] {
    
    var models: [tempIngredient] = []
    
    for _ingredient in model {
        models.append(tempIngredient(id: _ingredient.id, name: _ingredient.name))
    }
    
    return models
    
}

func ingredientFromLocaltoDB(_ model: [tempIngredient]) -> [SwiftDataIngredient] {
    
    var models: [SwiftDataIngredient] = []
    
    for _ingredient in model {
        models.append(SwiftDataIngredient(name: _ingredient.name))
    }
    
    return models
    
}
