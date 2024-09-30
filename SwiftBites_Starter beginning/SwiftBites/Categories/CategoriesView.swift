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
    
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Categories")
                .toolbar {
                    if !category_local.isEmpty {
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
                .onAppear {
                    var catObj = [tempCategory]()
                    
                    var ingredients = [tempRecipeIngredient]()
                    
                    for catego in category_db {
                        
                        var RecipeObj = [tempRecipe]()
                        
                        for recipe2 in recipe_db {
                            
                            //                    if catego.id == recipe2.categoryId.id {
                            
                            for recipe_ingredient in recipe2.ingredients {
                                
                                ingredients.append(tempRecipeIngredient(id: recipe_ingredient.id, ingredient: tempIngredient(name: recipe_ingredient.ingredient?.name ?? ""), quantity: ""))
                                
                            }
                            
                            RecipeObj.append(
                                tempRecipe(id: recipe2.id,
                                           name: recipe2.name,
                                           summary: recipe2.summary,
                                           category: recipe2.categoryId == nil ? nil : tempCategory(id: recipe2.categoryId?.id ?? UUID(), name: recipe2.categoryId?.name ?? ""),
                                           serving: recipe2.serving,
                                           time: recipe2.time,
                                           ingredients: ingredients,
                                           instructions: recipe2.instructions,
                                           imageData: recipe2.imageData))
                            
                            
                            //                    }
                        }
                        if !RecipeObj.isEmpty {
                            catObj.append( tempCategory(id: catego.id, name: catego.name, recipes: RecipeObj) )
                        }
                        else {
                            catObj.append( tempCategory(id: catego.id, name: catego.name, recipes: []) )
                        }
                    }
                    
                    category_local = catObj
                    
                }
        }
        
    }
    
    // MARK: - Views
    
    @ViewBuilder
    private var content: some View {
        if category_local.isEmpty {
            empty
        } else {
            list(for: category_local.filter {
                if query.isEmpty {
                    return true
                } else {
                    return $0.name.localizedStandardContains(query)
                }
            })
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
        .searchable(text: $query)
    }
}
