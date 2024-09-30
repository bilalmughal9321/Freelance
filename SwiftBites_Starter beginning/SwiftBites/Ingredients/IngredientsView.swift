import SwiftUI
import SwiftData

struct IngredientsView: View {
    typealias Selection = (tempIngredient) -> Void
    
    let selection: Selection?
    
    init(selection: Selection? = nil) {
        self.selection = selection
    }
    
//    @Environment(\.storage) private var storage
    @Environment(\.dismiss) private var dismiss
    @State private var query = ""
    
    @Environment(\.modelContext) private var context
    
    @Query var ingredient_db: [SwiftDataIngredient]
    @Query var recipe_ingredient_db: [SwiftDataRecipeIngredient]
    @State var ingredient: [tempIngredient] = []
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Ingredients")
                .toolbar {
                    if !ingredient.isEmpty {
                        NavigationLink(value: IngredientForm.Mode.add) {
                            Label("Add", systemImage: "plus")
                        }
                    }
                }
                .navigationDestination(for: IngredientForm.Mode.self) { mode in
                    IngredientForm(mode: mode)
                }
                .onAppear {
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
        if ingredient.isEmpty {
            empty
        } else {
            list(for: ingredient)
        }
    }
    
    private var empty: some View {
        ContentUnavailableView(
            label: {
                Label("No Ingredients", systemImage: "list.clipboard")
            },
            description: {
                Text("Ingredients you add will appear here.")
            },
            actions: {
                NavigationLink("Add Ingredient", value: IngredientForm.Mode.add)
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
        .listRowSeparator(.hidden)
    }
    
    private func list(for ingredients: [tempIngredient]) -> some View {
        List {
            if ingredients.isEmpty {
                noResults
            } else {
                ForEach(ingredients) { ingredient in
                    row(for: ingredient)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button("Delete", systemImage: "trash", role: .destructive) {
                                delete(ingredient: ingredient)
                            }
                        }
                }
            }
        }
        .searchable(text: $query)
        .listStyle(.plain)
    }
    
    @ViewBuilder
    private func row(for ingredient: tempIngredient) -> some View {
        if let selection {
            Button(
                action: {
                    selection(ingredient)
                    dismiss()
                },
                label: {
                    title(for: ingredient)
                }
            )
        } else {
            NavigationLink(value: IngredientForm.Mode.edit(ingredient)) {
                title(for: ingredient)
            }
        }
    }
    
    private func title(for ingredient: tempIngredient) -> some View {
        Text(ingredient.name)
            .font(.title3)
    }
    
    // MARK: - Data
    
    private func delete(ingredient: tempIngredient) {
        let storage_db = StorageData(context: context)
        do {
            try storage_db.deleteIngredient(id: ingredient.id)
        }
        catch {
            print("Error in deleting ingredient")
        }
//        storage.deleteIngredient(id: ingredient.id)
    }
    
    private func applyFilter() {
        // If query is empty, show all recipes
        if query.isEmpty {
            ingredient = ingredientFromDBtoLocal(ingredient_db)
            return
        }

        // Create an NSPredicate to filter the SwiftDataRecipe
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@ OR summary CONTAINS[cd] %@", query, query)

        // Filter the original recipes using the predicate
        let filteredDBRecipes = ingredient_db.filter { recipe in
            // Use only non-nil values for evaluation
            return predicate.evaluate(with: ["name": recipe.name])
        }

        // Convert the filtered results to tempRecipe
        ingredient = ingredientFromDBtoLocal(filteredDBRecipes)
    }
}
