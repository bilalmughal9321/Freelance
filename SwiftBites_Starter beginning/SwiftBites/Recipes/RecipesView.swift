import SwiftUI
import SwiftData

struct RecipesView: View {
//    @Environment(\.storage) private var storage
    @State private var query = ""
    @State private var sortOrder = SortDescriptor(\tempRecipe.name)
    
    @Query var cat:             [SwiftDataCategory]
    @Query var recipe_db:       [SwiftDataRecipe]
    @State var recipe:          [tempRecipe] = []
    
    @State private var filteredRecipes: [tempRecipe] = []
        
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Recipes")
                .toolbar {
                    if !filteredRecipes.isEmpty {
                        sortOptions
                        ToolbarItem(placement: .topBarTrailing) {
                            NavigationLink(value: RecipeForm.Mode.add) {
                                Label("Add", systemImage: "plus")
                            }
                        }
                    }
                }
                .searchable(text: $query)
                .navigationDestination(for: RecipeForm.Mode.self) { mode in
                    RecipeForm(mode: mode)
                }
                .onAppear {
                    applyFilter()
//                    filteredRecipes = recipe_db
//                    recipe = recipeFromDBtoLocal(recipe_db)
//                    print(recipe)
                }
                .onChange(of: query) {
                    applyFilter()
                }
        }
    }
    
    // MARK: - Views
    
    @ToolbarContentBuilder
    var sortOptions: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Menu("Sort", systemImage: "arrow.up.arrow.down") {
                Picker("Sort", selection: $sortOrder) {
                    Text("Name")
                        .tag(SortDescriptor(\tempRecipe.name))
                    
                    Text("Serving (low to high)")
                        .tag(SortDescriptor(\tempRecipe.serving, order: .forward))
                    
                    Text("Serving (high to low)")
                        .tag(SortDescriptor(\tempRecipe.serving, order: .reverse))
                    
                    Text("Time (short to long)")
                        .tag(SortDescriptor(\tempRecipe.time, order: .forward))
                    
                    Text("Time (long to short)")
                        .tag(SortDescriptor(\tempRecipe.time, order: .reverse))
                }
            }
            .pickerStyle(.inline)
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if filteredRecipes.isEmpty {
            empty
        } else {
            list(for: filteredRecipes.sorted(using: sortOrder))
        }
    }
    
    var empty: some View {
        ContentUnavailableView(
            label: {
                Label("No Recipes", systemImage: "list.clipboard")
            },
            description: {
                Text("Recipes you add will appear here.")
            },
            actions: {
                NavigationLink("Add Recipe", value: RecipeForm.Mode.add)
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
    
    private func list(for recipes: [tempRecipe]) -> some View {
        ScrollView(.vertical) {
            if recipes.isEmpty {
                noResults
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(recipes, content: RecipeCell.init)
                }
            }
        }
        
    }
    
//    // Function to apply filtering
//    private func applyFilter() {
//        if query.isEmpty {
//            filteredRecipes = recipe_db // If the query is empty, show all
//        } else {
//            // Filter the recipes based on the search query
//            filteredRecipes = recipe_db.filter {
//                $0.name.localizedStandardContains(query) || $0.summary.localizedStandardContains(query)
//            }
//        }
//        applySorting()
//    }
//    
//    // Function to apply sorting after filtering
//    private func applySorting() {
////        filteredRecipes.sort(using: [sortOrder])
//    }
    
    // Load initial recipes
    private func loadRecipes() {
        // Convert the database entries to local recipes
//        recipes = recipeFromDBtoLocal(recipe_db)
//        filteredRecipes = recipes // Initially set filteredRecipes to all recipes
    }
    
    // Function to apply filtering
//    private func applyFilter() {
//        if query.isEmpty {
//            filteredRecipes = recipes // Show all if query is empty
//        } else {
//            // Filter based on query
//            filteredRecipes = recipes.filter {
//                $0.name.localizedCaseInsensitiveContains(query) ||
//                $0.summary.localizedCaseInsensitiveContains(query)
//            }
//        }
//    }
    
    private func applyFilter() {
        // If query is empty, show all recipes
        if query.isEmpty {
            filteredRecipes = recipeFromDBtoLocal(recipe_db)
            return
        }

        // Create an NSPredicate to filter the SwiftDataRecipe
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@ OR summary CONTAINS[cd] %@", query, query)

        // Filter the original recipes using the predicate
        let filteredDBRecipes = recipe_db.filter { recipe in
            // Use only non-nil values for evaluation
            return predicate.evaluate(with: ["name": recipe.name, "summary": recipe.summary])
        }

        // Convert the filtered results to tempRecipe
        filteredRecipes = recipeFromDBtoLocal(filteredDBRecipes)
    }
    
}
