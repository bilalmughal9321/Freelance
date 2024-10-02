import SwiftUI
import SwiftData

struct CategoriesView: View {
      @Environment(\.modelContext) private var context
    @State private var query = ""
    
    
    /// Swift data variable
    @Query var category_db: [Categories]
    @Query var recipe_db: [Recipes]
    
    @State var filteredCategory: [Categories] = []
    
    
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
                    applyFilter()
                }
                .onChange(of: query) {
                    applyFilter()
                }
                .onChange(of: category_db) {
                    applyFilter() // Apply filter whenever category_db changes
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
    
    private func list(for categories: [Categories]) -> some View {
        ScrollView(.vertical) {
            if categories.isEmpty {
                noResults
            } else {
                LazyVStack(spacing: 10) {
//                    ForEach(categories) { cat in
//                        Text("Category: \(cat.name)")
//                        Text("")
//                        ForEach(cat.recipes ?? []) { rec in
//                            Text("recipe: \(rec.name)")
//                        }
//                        
//                    }
//                    ForEach(categories, content: CategorySection.init)
                    ForEach(categories) { cat in
                        
                        Section(
                            content: {
                                if (cat.recipes?.count == 0) {
                                   
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
                                                .buttonStyle(.bordered)
                                        }
                                    )
                                    
                                } else {
                                    ScrollView(.horizontal) {
                                        LazyHStack(spacing: 0) {
                                            ForEach(cat.recipes ?? [], id: \.name) { recipe in
                                                RecipeCell(recipe: recipe)
                                                    .containerRelativeFrame(.horizontal, count: 12, span: 11, spacing: 0)
                                            }
                                        }
                                        .scrollTargetLayout()
                                    }
                                    .scrollTargetBehavior(.viewAligned)
                                    .scrollIndicators(.hidden)
                                }
                            },
                            header: {
                                HStack(alignment: .center) {
                                    Text(cat.name)
                                        .font(.title)
                                        .bold()
                                    Spacer()
                                    NavigationLink("Edit", value: CategoryForm.Mode.edit(cat))
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                            }
                        )
                        
                        
                    }
                }
            }
        }
        
    }
    
    private func applyFilter() {
        let predicate = #Predicate<Categories> {
            $0.name.localizedStandardContains (query)
        }
        let descriptor = FetchDescriptor<Categories>(predicate: query.isEmpty ? nil : predicate)
        do {
            let filteredRecipes = try context.fetch(descriptor)
            filteredCategory = filteredRecipes
            
            print("filtered category: \(filteredRecipes.first?.recipes)")
        }
        catch{
            filteredCategory = []
        }
        
    }
}
