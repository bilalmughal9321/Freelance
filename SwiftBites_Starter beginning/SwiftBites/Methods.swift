////
////  SwiftData_functions.swift
////  SwiftBites
////
////  Created by Bilal Mughal on 26/09/2024.
////
//
import Foundation
import SwiftData
import SwiftUI
//
//final class StorageData {
//    enum StorageError: LocalizedError {
//        case ingredientExists
//        case categoryExists
//        case recipeExists
//        case noRecipe
//        case noCategory
//        
//        var errorDescription: String? {
//            switch self {
//            case .ingredientExists:
//                return "Ingredient with the same name exists"
//            case .categoryExists:
//                return "Category with the same name exists"
//            case .recipeExists:
//                return "Recipe with the same name exists"
//            case .noRecipe:
//                return "No recipe with given id found"
//            case .noCategory:
//                return "No category with given id found"
//            }
//        }
//    }
//    
//    private var context: ModelContext
//    
//    init(context: ModelContext) {
//        self.context = context
//    }
//    
//    // MARK: - Ingredients
//    
//    func findOrCreateIngredient(name: String) -> Ingredients {
//        // Create a fetch descriptor to look for an existing ingredient with the given name
//        let fetchDescriptor = FetchDescriptor<Ingredients>(
//            predicate: #Predicate { $0.name == name }
//        )
//        
//        // Attempt to fetch the ingredient
//        if let existingIngredient = try? context.fetch(fetchDescriptor).first {
//            return existingIngredient
//        } else {
//            // If no such ingredient exists, create and return a new one
//            let newIngredient = Ingredients(name: name)
//            context.insert(newIngredient)
//            return newIngredient
//        }
//    }
//    
//    func addIngredient(name: String) throws {
//        // Create a FetchDescriptor to check if the ingredient already exists
//        let fetchDescriptor = FetchDescriptor<Ingredients>(
//            predicate: #Predicate { $0.name == name }
//        )
//        
//        // Fetch ingredients with the given name
//        let existingIngredients = try? context.fetch(fetchDescriptor)
//        
//        // If an ingredient with the same name exists, throw an error
//        guard existingIngredients?.isEmpty ?? true else {
//            throw StorageError.ingredientExists
//        }
//        
//        // If no ingredient exists, insert the new one
//        let ingredient = Ingredients(name: name)
//        context.insert(ingredient)
//        
//        // Save the context
//        try context.save()
//    }
//
//    func deleteIngredient(id: UUID) throws {
//        // Create a FetchDescriptor to find the ingredient by its UUID
//        let fetchDescriptor = FetchDescriptor<Ingredients>(
//            predicate: #Predicate { $0.id == id }
//        )
//        
//        // Fetch the ingredient with the given ID
//        if let ingredientToDelete = try? context.fetch(fetchDescriptor).first {
//            // If the ingredient exists, delete it from the context
//            context.delete(ingredientToDelete)
//            
//            // Save the context to persist the deletion
//            try context.save()
//        }
//    }
//
//    func updateIngredient(id: UUID, newName: String) throws  {
//        // Fetch the ingredient by its UUID
//           let fetchByIdDescriptor = FetchDescriptor<Ingredients>(
//               predicate: #Predicate { $0.id == id }
//           )
//           
//           guard let ingredient = try? context.fetch(fetchByIdDescriptor).first else {
//               throw StorageError.ingredientExists// No ingredient with the given ID was found
//           }
//
//           // Check if an ingredient with the same new name already exists (excluding the current one)
//           let fetchByNameDescriptor = FetchDescriptor<Ingredients>(
//               predicate: #Predicate { $0.name == newName && $0.id != id }
//           )
//           
//           guard (try? context.fetch(fetchByNameDescriptor))?.isEmpty ?? true else {
//               throw StorageError.ingredientExists // Another ingredient with the same name exists
//           }
//
//           // Update the ingredient's name
//           ingredient.name = newName
//           
//           // Save the changes
//           try context.save()
//    }
//    
//    // MARK: - Recipe
//    
//    func addRecipe(Recipe: Recipes, name: String) throws {
//        
//        let fetchDescriptor = FetchDescriptor<Recipes>(
//            predicate: #Predicate { $0.name == name }
//        )
//        
//        // Fetch ingredients with the given name
//        let existingIngredients = try? context.fetch(fetchDescriptor)
//        
//        // If an ingredient with the same name exists, throw an error
//        guard existingIngredients?.isEmpty ?? true else {
//            throw StorageError.ingredientExists
//        }
//        
//        context.insert(Recipe)
//        
//        // Save the context
//        try context.save()
//        
//        
//    }
//    
//    func deleteRecipe(id: UUID) throws {
//        // Fetch the recipe by its ID
//        let fetchRecipeDescriptor = FetchDescriptor<Recipes>(
//            predicate: #Predicate { $0.id == id }
//        )
//        
//        // Fetch the recipe to delete
//        guard let recipeToDelete = try? context.fetch(fetchRecipeDescriptor).first else {
//            throw StorageError.noRecipe
//        }
//        
//        // Fetch all categories that contain this recipe
//        let fetchCategoriesDescriptor = FetchDescriptor<Categories>(
//            predicate: #Predicate { $0.ids == id }
//        )
//        
//        // Remove the recipe from all related categories
//        let categoriesToUpdate = try? context.fetch(fetchCategoriesDescriptor)
//        categoriesToUpdate?.forEach { category in
//            category.recipes?.removeAll(where: { $0.id == id })
//        }
//        
//        // Delete the recipe from the context
//        context.delete(recipeToDelete)
//        
//        // Save the context
//        try context.save()
//    }
//    
//    func updateRecipe(id: UUID,
//                      newName: String,
//                      newSummary: String,
//                      newCategory: Categories?,
//                      newServing: Int,
//                      newTime: Int,
//                      newIngredients: [RecipeIngredients],
//                      newInstructions: String,
//                      newImageData: Data?) throws {
//        
//        // Fetch the recipe by its UUID
//        let fetchByIdDescriptor = FetchDescriptor<Recipes>(
//            predicate: #Predicate { $0.id == id }
//        )
//        
//        // Check if the recipe exists
//        guard let recipeToUpdate = try? context.fetch(fetchByIdDescriptor).first else {
//            throw StorageError.noRecipe // No recipe with the given ID found
//        }
//        
//        // Check if another recipe with the same new name exists (excluding the current recipe)
//        let fetchByNameDescriptor = FetchDescriptor<Recipes>(
//            predicate: #Predicate { $0.name == newName && $0.id != id }
//        )
//        
//        guard (try? context.fetch(fetchByNameDescriptor))?.isEmpty ?? true else {
//            throw StorageError.recipeExists // Another recipe with the same name exists
//        }
//        
//        // Update the recipe's attributes
//        recipeToUpdate.name = newName
//        recipeToUpdate.summary = newSummary
//        recipeToUpdate.category = newCategory
//        recipeToUpdate.serving = newServing
//        recipeToUpdate.time = newTime
//        recipeToUpdate.ingredients = newIngredients
//        recipeToUpdate.instructions = newInstructions
//        recipeToUpdate.imageData = newImageData
//        
//        // Save the updated context
//        try context.save()
//    }
//    
//    
//    // MARK: - Category
//    
//    func addCategory(name: String) throws {
//        // Create a FetchDescriptor to check if the ingredient already exists
//        let fetchDescriptor = FetchDescriptor<Categories>(
//            predicate: #Predicate { $0.name == name }
//        )
//        
//        // Fetch ingredients with the given name
//        let existingCategory = try? context.fetch(fetchDescriptor)
//        
//        // If an ingredient with the same name exists, throw an error
//        guard existingCategory?.isEmpty ?? true else {
//            throw StorageError.ingredientExists
//        }
//        
//        // If no ingredient exists, insert the new one
//        let category = Categories(name: name)
//        context.insert(category)
//        
//        // Save the context
//        try context.save()
//    }
//    
//    func deleteCategoy(id: UUID) throws {
//        
//        // Create a FetchDescriptor to find the ingredient by its UUID
//        let fetchDescriptor = FetchDescriptor<Categories>(
//            predicate: #Predicate { $0.ids == id }
//        )
//        
//        // Fetch the ingredient with the given ID
//        if let ingredientToDelete = try? context.fetch(fetchDescriptor).first {
//            // If the ingredient exists, delete it from the context
//            context.delete(ingredientToDelete)
//            
//            // Save the context to persist the deletion
//            try context.save()
//        }
//        
//    }
//    
//    func updateCategory(id: UUID, newName: String) throws {
//        
//        // Fetch the ingredient by its UUID
//        let fetchByIdDescriptor = FetchDescriptor<Categories>(
//            predicate: #Predicate { $0.ids == id }
//        )
//        
//        guard let ingredient = try? context.fetch(fetchByIdDescriptor).first else {
//            throw StorageError.ingredientExists// No ingredient with the given ID was found
//        }
//        
//        // Check if an ingredient with the same new name already exists (excluding the current one)
//        let fetchByNameDescriptor = FetchDescriptor<Categories>(
//            predicate: #Predicate { $0.name == newName && $0.ids != id }
//        )
//        
//        guard (try? context.fetch(fetchByNameDescriptor))?.isEmpty ?? true else {
//            throw StorageError.ingredientExists // Another ingredient with the same name exists
//        }
//        
//        // Update the ingredient's name
//        ingredient.name = newName
//        
//        // Save the changes
//        try context.save()
//        
//    }
//    
//    func getCategoryById(id: UUID) -> Categories? {
//        let fetchDescriptor = FetchDescriptor<Categories>(
//            predicate: #Predicate { $0.ids == id }
//        )
//        if let category = try? context.fetch(fetchDescriptor).first {
//            return category
//        }
//        
//        return nil
//    }
//    
//    
//    func removeRecipeFromCategories(recipeId: UUID) throws {
//        // Fetch all categories
//        let fetchCategoriesDescriptor = FetchDescriptor<Categories>()
//        
//        // Fetch all categories from the context
//        let categories = try? context.fetch(fetchCategoriesDescriptor)
//        
//        // If there are no categories, just return (nothing to remove)
//        guard let allCategories = categories else {
//            throw StorageError.noCategory
//        }
//        
//        // Iterate through all categories to find where the recipe exists
//        for category in allCategories {
//            // Check if this category has any recipes
//            if let recipes = category.recipes {
//                // Find the recipe by its id and remove it
//                if let index = recipes.firstIndex(where: { $0.id == recipeId }) {
//                    category.recipes?.remove(at: index)
//                    
//                    // You could break here if you're sure the recipe exists in only one category
//                    // or continue if it might exist in multiple categories
//                }
//            }
//        }
//        
//        // Save the context to persist the changes
//        try context.save()
//    }
//    
//    func appendRecipeToCategory(categoryId: UUID, recipe: Recipes) throws {
//        // Fetch the category by its UUID
//        let fetchCategoryDescriptor = FetchDescriptor<Categories>(
//            predicate: #Predicate { $0.ids == categoryId }
//        )
//        
//        // Fetch the category with the given id
//        guard let category = try? context.fetch(fetchCategoryDescriptor).first else {
//            throw StorageError.noCategory // No category with the given ID was found
//        }
//        
//        // If the category doesn't have any recipes array, initialize it
//        if category.recipes == nil {
//            category.recipes = [Recipes]()
//        }
//        
//        // Append the new recipe to the category's recipes array
//        category.recipes?.append(recipe)
//        
//        // Save the changes
//        try context.save()
//    }
//
//    
//    func fetchOrCreateIngredientInCurrentContext(_ id: UUID, ingredient: RecipeIngredients) -> RecipeIngredients {
//        // Create the predicate to fetch the ingredient by its ID
//        let fetchDescriptor = FetchDescriptor<RecipeIngredients>(
//            predicate: #Predicate { $0.id == id } // Correct usage of Predicate
//        )
//
//        // Try fetching the ingredient in the current context
//        if let fetchedIngredient = try? context.fetch(fetchDescriptor).first {
//            return fetchedIngredient
//        } else {
//            // If not found, create a new ingredient in the current context
//            let newIngredient = RecipeIngredients(ingredient: ingredient.ingredient!, quantity: ingredient.quantity)
//            return newIngredient
//        }
//    }
//    
//}


final class DataManager {
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
    
    // findOrCreateIngredient
    func fetchOrCreateIngredient(name: String) -> Ingredients {
        let fetchDescriptor = FetchDescriptor<Ingredients>(
            predicate: #Predicate { $0.name == name }
        )
        
        if let existingIngredient = try? context.fetch(fetchDescriptor).first {
            return existingIngredient
        } else {
            let newIngredient = Ingredients(name: name)
            context.insert(newIngredient)
            return newIngredient
        }
    }
    
    // addIngredient
    func insertIngredient(name: String) throws {
        let fetchDescriptor = FetchDescriptor<Ingredients>(
            predicate: #Predicate { $0.name == name }
        )
        
        let existingIngredients = try? context.fetch(fetchDescriptor)
        
        guard existingIngredients?.isEmpty ?? true else {
            throw StorageError.ingredientExists
        }
        
        let ingredient = Ingredients(name: name)
        context.insert(ingredient)
        
        try context.save()
    }

    // deleteIngredient
    func removeIngredient(id: UUID) throws {
        let fetchDescriptor = FetchDescriptor<Ingredients>(
            predicate: #Predicate { $0.id == id }
        )
        
        if let ingredientToDelete = try? context.fetch(fetchDescriptor).first {
            context.delete(ingredientToDelete)
            try context.save()
        }
    }

    // updateIngredient
    func modifyIngredient(id: UUID, newName: String) throws  {
        let fetchByIdDescriptor = FetchDescriptor<Ingredients>(
            predicate: #Predicate { $0.id == id }
        )
        
        guard let ingredient = try? context.fetch(fetchByIdDescriptor).first else {
            throw StorageError.ingredientExists
        }

        let fetchByNameDescriptor = FetchDescriptor<Ingredients>(
            predicate: #Predicate { $0.name == newName && $0.id != id }
        )
        
        guard (try? context.fetch(fetchByNameDescriptor))?.isEmpty ?? true else {
            throw StorageError.ingredientExists
        }

        ingredient.name = newName
        try context.save()
    }
    
    // MARK: - Recipe
    
    // addRecipe
    func insertRecipe(recipe: Recipes, name: String) throws {
        let fetchDescriptor = FetchDescriptor<Recipes>(
            predicate: #Predicate { $0.name == name }
        )
        
        let existingRecipes = try? context.fetch(fetchDescriptor)
        
        guard existingRecipes?.isEmpty ?? true else {
            throw StorageError.recipeExists
        }
        
        context.insert(recipe)
        try context.save()
    }
    
    // deleteRecipe
    func removeRecipe(id: UUID) throws {
        let fetchRecipeDescriptor = FetchDescriptor<Recipes>(
            predicate: #Predicate { $0.id == id }
        )
        
        guard let recipeToDelete = try? context.fetch(fetchRecipeDescriptor).first else {
            throw StorageError.noRecipe
        }
        
        let fetchCategoriesDescriptor = FetchDescriptor<Categories>(
            predicate: #Predicate { $0.ids == id }
        )
        
        let categoriesToUpdate = try? context.fetch(fetchCategoriesDescriptor)
        categoriesToUpdate?.forEach { category in
            category.recipes?.removeAll(where: { $0.id == id })
        }
        
        context.delete(recipeToDelete)
        try context.save()
    }
    
    // updateRecipe
    func modifyRecipe(id: UUID,
                      newName: String,
                      newSummary: String,
                      newCategory: Categories?,
                      newServing: Int,
                      newTime: Int,
                      newIngredients: [RecipeIngredients],
                      newInstructions: String,
                      newImageData: Data?) throws {
        
        let fetchByIdDescriptor = FetchDescriptor<Recipes>(
            predicate: #Predicate { $0.id == id }
        )
        
        guard let recipeToUpdate = try? context.fetch(fetchByIdDescriptor).first else {
            throw StorageError.noRecipe
        }
        
        let fetchByNameDescriptor = FetchDescriptor<Recipes>(
            predicate: #Predicate { $0.name == newName && $0.id != id }
        )
        
        guard (try? context.fetch(fetchByNameDescriptor))?.isEmpty ?? true else {
            throw StorageError.recipeExists
        }
        
        recipeToUpdate.name = newName
        recipeToUpdate.summary = newSummary
        recipeToUpdate.category = newCategory
        recipeToUpdate.serving = newServing
        recipeToUpdate.time = newTime
        recipeToUpdate.ingredients = newIngredients
        recipeToUpdate.instructions = newInstructions
        recipeToUpdate.imageData = newImageData
        
        try context.save()
    }
    
    // MARK: - Category
    
    // addCategory
    func insertCategory(name: String) throws {
        let fetchDescriptor = FetchDescriptor<Categories>(
            predicate: #Predicate { $0.name == name }
        )
        
        let existingCategory = try? context.fetch(fetchDescriptor)
        
        guard existingCategory?.isEmpty ?? true else {
            throw StorageError.categoryExists
        }
        
        let category = Categories(name: name)
        context.insert(category)
        try context.save()
    }
    
    // deleteCategoy
    func removeCategory(id: UUID) throws {
        let fetchDescriptor = FetchDescriptor<Categories>(
            predicate: #Predicate { $0.ids == id }
        )
        
        if let categoryToDelete = try? context.fetch(fetchDescriptor).first {
            context.delete(categoryToDelete)
            try context.save()
        }
    }
    
    // updateCategory
    func modifyCategory(id: UUID, newName: String) throws {
        let fetchByIdDescriptor = FetchDescriptor<Categories>(
            predicate: #Predicate { $0.ids == id }
        )
        
        guard let category = try? context.fetch(fetchByIdDescriptor).first else {
            throw StorageError.categoryExists
        }
        
        let fetchByNameDescriptor = FetchDescriptor<Categories>(
            predicate: #Predicate { $0.name == newName && $0.ids != id }
        )
        
        guard (try? context.fetch(fetchByNameDescriptor))?.isEmpty ?? true else {
            throw StorageError.categoryExists
        }
        
        category.name = newName
        try context.save()
    }
    
    // getCategoryById
    func fetchCategoryById(id: UUID) -> Categories? {
        let fetchDescriptor = FetchDescriptor<Categories>(
            predicate: #Predicate { $0.ids == id }
        )
        return try? context.fetch(fetchDescriptor).first
    }
    
    // removeRecipeFromCategories
    func detachRecipeFromCategories(recipeId: UUID) throws {
        let fetchCategoriesDescriptor = FetchDescriptor<Categories>()
        let categories = try? context.fetch(fetchCategoriesDescriptor)
        
        guard let allCategories = categories else {
            throw StorageError.noCategory
        }
        
        for category in allCategories {
            if let recipes = category.recipes {
                if let index = recipes.firstIndex(where: { $0.id == recipeId }) {
                    category.recipes?.remove(at: index)
                }
            }
        }
        
        try context.save()
    }
    
    // appendRecipeToCategory
    func addRecipeToCategory(categoryId: UUID, recipe: Recipes) throws {
        let fetchCategoryDescriptor = FetchDescriptor<Categories>(
            predicate: #Predicate { $0.ids == categoryId }
        )
        
        guard let category = try? context.fetch(fetchCategoryDescriptor).first else {
            throw StorageError.noCategory
        }
        
        if category.recipes == nil {
            category.recipes = [Recipes]()
        }
        
        category.recipes?.append(recipe)
        try context.save()
    }

    // fetchOrCreateIngredientInCurrentContext
    func fetchOrCreateIngredientInContext(_ id: UUID, ingredient: RecipeIngredients) -> RecipeIngredients {
        let fetchDescriptor = FetchDescriptor<RecipeIngredients>(
            predicate: #Predicate { $0.id == id }
        )

        if let fetchedIngredient = try? context.fetch(fetchDescriptor).first {
            return fetchedIngredient
        } else {
            let newIngredient = RecipeIngredients(ingredient: ingredient.ingredient!, quantity: ingredient.quantity)
            return newIngredient
        }
    }
}
