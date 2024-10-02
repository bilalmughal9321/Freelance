import SwiftUI
import SwiftData

struct RecipesView: View {
    @Environment(\.modelContext) private var context
    @State private var query = ""
    @State private var sortOrder = SortDescriptor(\Recipes.name)
    
    @Query var cat:             [Categories]
    @Query var recipe_db:       [Recipes]
    
    @State private var filteredRecipes: [Recipes] = []
        
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
                }
                .onChange(of: query) {
                    applyFilter()
                }
                .onChange(of: recipe_db) {
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
                        .tag(SortDescriptor(\Recipes.name))
                    
                    Text("Serving (low to high)")
                        .tag(SortDescriptor(\Recipes.serving, order: .forward))
                    
                    Text("Serving (high to low)")
                        .tag(SortDescriptor(\Recipes.serving, order: .reverse))
                    
                    Text("Time (short to long)")
                        .tag(SortDescriptor(\Recipes.time, order: .forward))
                    
                    Text("Time (long to short)")
                        .tag(SortDescriptor(\Recipes.time, order: .reverse))
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
    
    private func list(for recipes: [Recipes]) -> some View {
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
    
    private func applyFilter() {
        let predicate = #Predicate<Recipes> {
            $0.name.localizedStandardContains (query)
        }
        let descriptor = FetchDescriptor<Recipes>(predicate: query.isEmpty ? nil : predicate)
        do {
            let filteredRecipe = try context.fetch(descriptor)
            filteredRecipes = filteredRecipe
        }
        catch{
            filteredRecipes = []
        }
    }
    
}
