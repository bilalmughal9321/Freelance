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
        case noCategory
        
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
            case .noCategory:
                return "No category with given id found"
            }
        }
    }
    
    private var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    // MARK: - Ingredients
    
    func findOrCreateIngredient(name: String) -> Ingredients {
        // Create a fetch descriptor to look for an existing ingredient with the given name
        let fetchDescriptor = FetchDescriptor<Ingredients>(
            predicate: #Predicate { $0.name == name }
        )
        
        // Attempt to fetch the ingredient
        if let existingIngredient = try? context.fetch(fetchDescriptor).first {
            return existingIngredient
        } else {
            // If no such ingredient exists, create and return a new one
            let newIngredient = Ingredients(name: name)
            context.insert(newIngredient)
            return newIngredient
        }
    }
    
    func addIngredient(name: String) throws {
        // Create a FetchDescriptor to check if the ingredient already exists
        let fetchDescriptor = FetchDescriptor<Ingredients>(
            predicate: #Predicate { $0.name == name }
        )
        
        // Fetch ingredients with the given name
        let existingIngredients = try? context.fetch(fetchDescriptor)
        
        // If an ingredient with the same name exists, throw an error
        guard existingIngredients?.isEmpty ?? true else {
            throw StorageError.ingredientExists
        }
        
        // If no ingredient exists, insert the new one
        let ingredient = Ingredients(name: name)
        context.insert(ingredient)
        
        // Save the context
        try context.save()
    }

    func deleteIngredient(id: UUID) throws {
        // Create a FetchDescriptor to find the ingredient by its UUID
        let fetchDescriptor = FetchDescriptor<Ingredients>(
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
           let fetchByIdDescriptor = FetchDescriptor<Ingredients>(
               predicate: #Predicate { $0.id == id }
           )
           
           guard let ingredient = try? context.fetch(fetchByIdDescriptor).first else {
               throw StorageError.ingredientExists// No ingredient with the given ID was found
           }

           // Check if an ingredient with the same new name already exists (excluding the current one)
           let fetchByNameDescriptor = FetchDescriptor<Ingredients>(
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
    
    func addRecipe(Recipe: Recipes, name: String) throws {
        
        let fetchDescriptor = FetchDescriptor<Recipes>(
            predicate: #Predicate { $0.name == name }
        )
        
        // Fetch ingredients with the given name
        let existingIngredients = try? context.fetch(fetchDescriptor)
        
        // If an ingredient with the same name exists, throw an error
        guard existingIngredients?.isEmpty ?? true else {
            throw StorageError.ingredientExists
        }
        
        context.insert(Recipe)
        
        // Save the context
        try context.save()
        
        
    }
    
    func deleteRecipe(id: UUID) throws {
        // Fetch the recipe by its ID
        let fetchRecipeDescriptor = FetchDescriptor<Recipes>(
            predicate: #Predicate { $0.id == id }
        )
        
        // Fetch the recipe to delete
        guard let recipeToDelete = try? context.fetch(fetchRecipeDescriptor).first else {
            throw StorageError.noRecipe
        }
        
        // Fetch all categories that contain this recipe
        let fetchCategoriesDescriptor = FetchDescriptor<Categories>(
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
                      newCategory: Categories?,
                      newServing: Int,
                      newTime: Int,
                      newIngredients: [RecipeIngredients],
                      newInstructions: String,
                      newImageData: Data?) throws {
        
        // Fetch the recipe by its UUID
        let fetchByIdDescriptor = FetchDescriptor<Recipes>(
            predicate: #Predicate { $0.id == id }
        )
        
        // Check if the recipe exists
        guard let recipeToUpdate = try? context.fetch(fetchByIdDescriptor).first else {
            throw StorageError.noRecipe // No recipe with the given ID found
        }
        
        // Check if another recipe with the same new name exists (excluding the current recipe)
        let fetchByNameDescriptor = FetchDescriptor<Recipes>(
            predicate: #Predicate { $0.name == newName && $0.id != id }
        )
        
        guard (try? context.fetch(fetchByNameDescriptor))?.isEmpty ?? true else {
            throw StorageError.recipeExists // Another recipe with the same name exists
        }
        
        // Update the recipe's attributes
        recipeToUpdate.name = newName
        recipeToUpdate.summary = newSummary
        recipeToUpdate.category = newCategory
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
        let fetchDescriptor = FetchDescriptor<Categories>(
            predicate: #Predicate { $0.name == name }
        )
        
        // Fetch ingredients with the given name
        let existingCategory = try? context.fetch(fetchDescriptor)
        
        // If an ingredient with the same name exists, throw an error
        guard existingCategory?.isEmpty ?? true else {
            throw StorageError.ingredientExists
        }
        
        // If no ingredient exists, insert the new one
        let category = Categories(name: name)
        context.insert(category)
        
        // Save the context
        try context.save()
    }
    
    func deleteCategoy(id: UUID) throws {
        
        // Create a FetchDescriptor to find the ingredient by its UUID
        let fetchDescriptor = FetchDescriptor<Categories>(
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
        let fetchByIdDescriptor = FetchDescriptor<Categories>(
            predicate: #Predicate { $0.ids == id }
        )
        
        guard let ingredient = try? context.fetch(fetchByIdDescriptor).first else {
            throw StorageError.ingredientExists// No ingredient with the given ID was found
        }
        
        // Check if an ingredient with the same new name already exists (excluding the current one)
        let fetchByNameDescriptor = FetchDescriptor<Categories>(
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
    
    func getCategoryById(id: UUID) -> Categories? {
        let fetchDescriptor = FetchDescriptor<Categories>(
            predicate: #Predicate { $0.ids == id }
        )
        if let category = try? context.fetch(fetchDescriptor).first {
            return category
        }
        
        return nil
    }
    
    
    func removeRecipeFromCategories(recipeId: UUID) throws {
        // Fetch all categories
        let fetchCategoriesDescriptor = FetchDescriptor<Categories>()
        
        // Fetch all categories from the context
        let categories = try? context.fetch(fetchCategoriesDescriptor)
        
        // If there are no categories, just return (nothing to remove)
        guard let allCategories = categories else {
            throw StorageError.noCategory
        }
        
        // Iterate through all categories to find where the recipe exists
        for category in allCategories {
            // Check if this category has any recipes
            if let recipes = category.recipes {
                // Find the recipe by its id and remove it
                if let index = recipes.firstIndex(where: { $0.id == recipeId }) {
                    category.recipes?.remove(at: index)
                    
                    // You could break here if you're sure the recipe exists in only one category
                    // or continue if it might exist in multiple categories
                }
            }
        }
        
        // Save the context to persist the changes
        try context.save()
    }
    
    func appendRecipeToCategory(categoryId: UUID, recipe: Recipes) throws {
        // Fetch the category by its UUID
        let fetchCategoryDescriptor = FetchDescriptor<Categories>(
            predicate: #Predicate { $0.ids == categoryId }
        )
        
        // Fetch the category with the given id
        guard let category = try? context.fetch(fetchCategoryDescriptor).first else {
            throw StorageError.noCategory // No category with the given ID was found
        }
        
        // If the category doesn't have any recipes array, initialize it
        if category.recipes == nil {
            category.recipes = [Recipes]()
        }
        
        // Append the new recipe to the category's recipes array
        category.recipes?.append(recipe)
        
        // Save the changes
        try context.save()
    }

    
    func fetchOrCreateIngredientInCurrentContext(_ id: UUID, ingredient: RecipeIngredients) -> RecipeIngredients {
        // Create the predicate to fetch the ingredient by its ID
        let fetchDescriptor = FetchDescriptor<RecipeIngredients>(
            predicate: #Predicate { $0.id == id } // Correct usage of Predicate
        )

        // Try fetching the ingredient in the current context
        if let fetchedIngredient = try? context.fetch(fetchDescriptor).first {
            return fetchedIngredient
        } else {
            // If not found, create a new ingredient in the current context
            let newIngredient = RecipeIngredients(ingredient: ingredient.ingredient!, quantity: ingredient.quantity)
            return newIngredient
        }
    }
    
}


//func recipeFromDBtoLocal(_ model: [Recipes]) -> [tempRecipe]{
//    
//    var models = [tempRecipe]()
//    var ingredients = [tempRecipeIngredient]()
//    
//    for recipe in model {
//        
//        for ingredient in recipe.ingredients {
//            ingredients.append(tempRecipeIngredient(ingredient: tempIngredient(name: ingredient.ingredient?.name ?? ""), quantity: ""))
//        }
//        
//        models.append(
//            tempRecipe(id: recipe.id,
//                       name: recipe.name,
//                       summary: recipe.summary,
//                       category: tempCategory(id: recipe.category?.ids ?? UUID(), name: recipe.category?.name ?? ""),
//                       serving: recipe.serving,
//                       time: recipe.time,
//                       ingredients: ingredients,
//                       instructions: recipe.instructions,
//                       imageData: recipe.imageData))
//        
//    }
//    
//    return models
//    
//}
//
//func recipeFromLocalToDB(_ model: [tempRecipe]) -> [Recipes] {
//    
//    var models = [Recipes]()
//    var ingredients = [RecipeIngredients]()
//    var ingredientsId = [UUID]()
//    
//    for recipe in model {
//        for ingredient in recipe.ingredients {
//            ingredients.append(RecipeIngredients(ingredient: Ingredients(name: ingredient.ingredient.name), quantity: ""))
//        }
//        
//        let mockCategory = Categories(id: recipe.category?.id ?? UUID(), name: recipe.name)
//        
////        models.append(Recipes(id: recipe.id, name: recipe.name, summary: recipe.summary, categoryId: recipe.category?.id ?? UUID(), serving: recipe.serving, time: recipe.time, ingredients: ingredients, instructions: recipe.instructions, imageData: recipe.imageData))
//    }
//    
//    return models
//    
//}
//
//func ingredientFromDBtoLocal(_ model: [Ingredients]) -> [tempIngredient] {
//    
//    var models: [tempIngredient] = []
//    
//    for _ingredient in model {
//        models.append(tempIngredient(id: _ingredient.id, name: _ingredient.name))
//    }
//    
//    return models
//    
//}

//func ingredientFromLocaltoDB(_ model: [tempIngredient]) -> [Ingredients] {
//    
//    var models: [Ingredients] = []
//    
//    for _ingredient in model {
//        models.append(Ingredients(name: _ingredient.name))
//    }
//    
//    return models
//    
//}
