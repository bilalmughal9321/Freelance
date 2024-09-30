import SwiftUI
import SwiftData

struct CategoriesView: View {
    //  @Environment(\.storage) private var storage
    @State private var query = ""
    
    
    /// Swift data variable
    @Query var category_db: [SwiftDataCategory]
    @Query var recipe_db: [SwiftDataRecipe]
    
    /// @State
    @State var category_local: [tempCategory] = []
    @State var recipe_local: [tempRecipe] = []
    
    @State private var filteredCategory: [tempCategory] = []
    
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Categories")
                .toolbar {
                    if !filteredCategory.isEmpty {
                        NavigationLink(value: CategoryForm.Mode.add) {
                            Label("Add", systemImage: "plus")
                        }
                    }
                }
                .navigationDestination(for: CategoryForm.Mode.self) { mode in
                    CategoryForm(mode: mode)
                }
                .navigationDestination(for: RecipeForm.Mode.self) { mode in
                    RecipeForm(mode: mode)
                }
                .searchable(text: $query)
                .onAppear {
//                    category_local = loadData(category_db)
                    applyFilter()
                }
                .onChange(of: query) {
                    applyFilter()
                }
        }
        
    }
    
    // MARK: - Views
    
    @ViewBuilder
    private var content: some View {
        if filteredCategory.isEmpty {
            empty
        } else {
            list(for: filteredCategory)
        }
    }
    
    private var empty: some View {
        ContentUnavailableView(
            label: {
                Label("No Categories", systemImage: "list.clipboard")
            },
            description: {
                Text("Categories you add will appear here.")
            },
            actions: {
                NavigationLink("Add Category", value: CategoryForm.Mode.add)
                    .buttonBorderShape(.roundedRectangle)
                    .buttonStyle(.borderedProminent)
            }
        )
    }
    
    private var noResults: some View {
        ContentUnavailableView(
            label: {
                Text("Couldn't find \"\(query)\"")
            }
        )
    }
    
    private func list(for categories: [tempCategory]) -> some View {
        ScrollView(.vertical) {
            if categories.isEmpty {
                noResults
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(categories, content: CategorySection.init)
                }
            }
        }
        
    }
    
    private func loadData(_ category: [SwiftDataCategory]) -> [tempCategory]{
        var catObj = [tempCategory]()
        
        var ingredients = [tempRecipeIngredient]()
        
        for catego in category {
            
            var RecipeObj = [tempRecipe]()
            
            for recipe2 in recipe_db {
                
                if catego.ids == recipe2.categoryId?.ids {
                    
                    for recipe_ingredient in recipe2.ingredients {
                        
                        ingredients.append(tempRecipeIngredient(id: recipe_ingredient.id, ingredient: tempIngredient(name: recipe_ingredient.ingredient?.name ?? ""), quantity: ""))
                        
                    }
                    
                    RecipeObj.append(
                        tempRecipe(id: recipe2.id,
                                   name: recipe2.name,
                                   summary: recipe2.summary,
                                   category: recipe2.categoryId == nil ? nil : tempCategory(id: recipe2.categoryId?.ids ?? UUID(), name: recipe2.categoryId?.name ?? ""),
                                   serving: recipe2.serving,
                                   time: recipe2.time,
                                   ingredients: ingredients,
                                   instructions: recipe2.instructions,
                                   imageData: recipe2.imageData))
                    
                    
                }
            }
            if !RecipeObj.isEmpty {
                catObj.append( tempCategory(id: catego.ids, name: catego.name, recipes: RecipeObj) )
            }
            else {
                catObj.append( tempCategory(id: catego.ids, name: catego.name, recipes: []) )
            }
        }
        
        return catObj
    }
    
    private func applyFilter() {
        // If query is empty, show all recipes
        if query.isEmpty {
            filteredCategory = loadData(category_db)
            return
        }

        // Create an NSPredicate to filter the SwiftDataRecipe
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", query, query)

        // Filter the original recipes using the predicate
        let filteredDBRecipes = category_db.filter { recipe in
            // Use only non-nil values for evaluation
            return predicate.evaluate(with: ["name": recipe.name])
        }

        // Convert the filtered results to tempRecipe
        filteredCategory = loadData(filteredDBRecipes)
    }
}
