import SwiftUI
import PhotosUI
import Foundation
import SwiftData

struct RecipeForm: View {
    enum Mode: Hashable {
        case add
        case edit(Recipes)
    }
    
    var mode: Mode
    
    init(mode: Mode) {
        self.mode = mode
        switch mode {
        case .add:
            title = "Add Recipe"
            _name = .init(initialValue: "")
            _summary = .init(initialValue: "")
            _serving = .init(initialValue: 1)
            _time = .init(initialValue: 5)
            _instructions = .init(initialValue: "")
            _ingredients = .init(initialValue: [])
        case .edit(let recipe):
            title = "Edit \(recipe.name)"
            _name = .init(initialValue: recipe.name)
            _summary = .init(initialValue: recipe.summary)
            _serving = .init(initialValue: recipe.serving)
            _time = .init(initialValue: recipe.time)
            _instructions = .init(initialValue: recipe.instructions)
            _ingredients = .init(initialValue: recipe.ingredients)
//            _categoryId = .init(initialValue: recipe.category?.id)
            _imageData = .init(initialValue: recipe.imageData)
            
            selectedRecipe = recipe
            selectedRecipeIngredient = recipe.ingredients
            
        }
    }
    
    private let title: String
    @State private var name: String
    @State private var summary: String
    @State private var serving: Int
    @State private var time: Int
    @State private var instructions: String
    @State private var categoryId: tempCategory.ID?
    @State private var ingredients: [RecipeIngredients]
    @State private var imageItem: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var isIngredientsPickerPresented =  false
    @State private var error: Error?
    @Environment(\.dismiss) private var dismiss
//    @Environment(\.storage) private var storage
    
    @Environment(\.modelContext) private var context
    
    /// Swift Data variable
    @Query var category_db: [Categories] = []
    
    /// State variable
//    @State var category: [tempCategory] = []
    @State var selectedCategry: Categories? = nil
    var selectedRecipe: Recipes? = nil
    @State var selectedRecipeIngredient: [RecipeIngredients] = []
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            Form {
                imageSection(width: geometry.size.width)
                nameSection
                summarySection
                categorySection
                servingAndTimeSection
                ingredientsSection
                instructionsSection
                deleteButton
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .alert(error: $error)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save", action: save)
//                    .disabled(name.isEmpty || instructions.isEmpty)
            }
        }
        .onChange(of: imageItem) { _, _ in
            Task {
                self.imageData = try? await imageItem?.loadTransferable(type: Data.self)
            }
        }
        .sheet(isPresented: $isIngredientsPickerPresented, content: ingredientPicker)
        .onAppear {
            let storage_db = StorageData(context: context)
//            category = categoryDBtoLocal(category_db)
            if mode != .add {
                selectedCategry = storage_db.getCategoryById(id: selectedRecipe?.category?.ids ?? UUID())
            }
        }
    }
        
    
    // MARK: - Views
    
    private func ingredientPicker() -> some View {
        IngredientsView { selectedIngredient in
            let storage = StorageData(context: context)
            let existingIngredient = storage.findOrCreateIngredient(name: selectedIngredient.name)
            if selectedRecipe?.ingredients.count == 0 {
                selectedRecipe?.ingredients.append(RecipeIngredients(ingredient: existingIngredient, quantity: ""))
            }
            else {
                if selectedRecipe?.ingredients.first(where: { $0.ingredient?.name == existingIngredient.name }) == nil {
                    selectedRecipe?.ingredients.append(RecipeIngredients(ingredient: existingIngredient, quantity: ""))
                }
            }
        }
    }
    
    @ViewBuilder
    private func imageSection(width: CGFloat) -> some View {
        Section {
            imagePicker(width: width)
            removeImage
        }
    }
    
    @ViewBuilder
    private func imagePicker(width: CGFloat) -> some View {
        PhotosPicker(selection: $imageItem, matching: .images) {
            if let imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: width)
                    .clipped()
                    .listRowInsets(EdgeInsets())
                    .frame(maxWidth: .infinity, minHeight: 200, idealHeight: 200, maxHeight: 200, alignment: .center)
            } else {
                Label("Select Image", systemImage: "photo")
            }
        }
    }
    
    @ViewBuilder
    private var removeImage: some View {
        if imageData != nil {
            Button(
                role: .destructive,
                action: {
                    imageData = nil
                },
                label: {
                    Text("Remove Image")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            )
        }
    }
    
    @ViewBuilder
    private var nameSection: some View {
        Section("Name") {
            TextField("Margherita Pizza", text: $name)
        }
    }
    
    @ViewBuilder
    private var summarySection: some View {
        Section("Summary") {
            TextField(
                "Delicious blend of fresh basil, mozzarella, and tomato on a crispy crust.",
                text: $summary,
                axis: .vertical
            )
            .lineLimit(3...5)
        }
    }
    
    @ViewBuilder
    private var categorySection: some View {
        Section {
            Picker("Category", selection: $selectedCategry) {
                Text("None").tag(Categories?.none)
                ForEach(category_db) { category in
                    Text(category.name).tag(category as Categories?)
                }
            }
            .onChange(of: selectedCategry){
                print(selectedCategry)
            }
        }
    }
    
    @ViewBuilder
    private var servingAndTimeSection: some View {
        Section {
            Stepper("Servings: \(serving)p", value: $serving, in: 1...100)
            Stepper("Time: \(time)m", value: $time, in: 5...300, step: 5)
        }
        .monospacedDigit()
    }
    
    @ViewBuilder
    private var ingredientsSection: some View {
        Section("Ingredients") {
            if selectedRecipe?.ingredients.count == 0 {
                ContentUnavailableView(
                    label: {
                        Label("No Ingredients", systemImage: "list.clipboard")
                    },
                    description: {
                        Text("Recipe ingredients will appear here.")
                    },
                    actions: {
                        Button("Add Ingredient") {
                            isIngredientsPickerPresented = true
                        }
                    }
                )
            } else {
                ForEach(selectedRecipe?.ingredients ?? []) { ingredient in
                    HStack(alignment: .center) {
                        Text(ingredient.ingredient?.name ?? "")
                            .bold()
                            .layoutPriority(2)
                        Spacer()
                        TextField("Quantity", text: .init(
                            get: {
                                ingredient.quantity
                            },
                            set: { quantity in
                                if let index = selectedRecipe?.ingredients.firstIndex(where: { $0.id == ingredient.id }) {
                                    selectedRecipe?.ingredients[index].quantity = quantity
                                }
                            }
                        ))
                        .layoutPriority(1)
                    }
                }
               
                .onDelete(perform: deleteIngredients)
                
                Button("Add Ingredient") {
                    isIngredientsPickerPresented = true
                }
            }
        }
    }
    
    @ViewBuilder
    private var instructionsSection: some View {
        Section("Instructions") {
            TextField(
        """
        1. Preheat the oven to 475°F (245°C).
        2. Roll out the dough on a floured surface.
        3. ...
        """,
        text: $instructions,
        axis: .vertical
            )
            .lineLimit(8...12)
        }
    }
    
    @ViewBuilder
    private var deleteButton: some View {
        if case .edit(let recipe) = mode {
            Button(
                role: .destructive,
                action: {
                    delete(recipe: recipe)
                },
                label: {
                    Text("Delete Recipe")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            )
        }
    }
    
    // MARK: - Data
    
    func delete(recipe: Recipes) {
        let storage_db = StorageData(context: context)
        guard case .edit(let recipe) = mode else {
            fatalError("Delete unavailable in add mode")
        }
        do {
            try storage_db.deleteRecipe(id: recipe.id)
        }
        catch {
            print("Error in deleting recipe")
        }
//        storage.deleteRecipe(id: recipe.id)
        dismiss()
    }
    
    func deleteIngredients(offsets: IndexSet) {
        withAnimation {
            selectedRecipe?.ingredients.remove(atOffsets: offsets)
        }
    }
    
    func save() {
        
        let db_storage = StorageData(context: context)
        
        
            switch mode {
            case .add:
                
                let recipe = Recipes(name: name,
                                     summary: summary,
                                     category: selectedCategry,
                                     serving: serving,
                                     time: time,
                                     ingredients: selectedRecipe?.ingredients ?? [],
                                     instructions: instructions,
                                     imageData: imageData)
                
                do{
                    try db_storage.addRecipe(Recipe: recipe, name: name)
                    
                    if selectedCategry != nil {
                        // add recipe into category
                        try db_storage.appendRecipeToCategory(categoryId: selectedCategry?.ids ?? UUID(), recipe: recipe)
                    }
                    
                    
                }
                catch {
                    self.error = error
                }
            case .edit(let recipe):
                
                print(selectedRecipeIngredient)
                
                do {
                    try db_storage.updateRecipe(
                        id: recipe.id,
                        newName: name,
                        newSummary: summary,
                        newCategory: selectedCategry,
                        newServing: serving,
                        newTime: time,
                        newIngredients: selectedRecipe?.ingredients ?? [],
                        newInstructions: instructions,
                        newImageData: imageData
                    )
                    
                    // remove this recipe from all the categories first
                    try db_storage.removeRecipeFromCategories(recipeId: recipe.id)
                    
                    // add recipe into category
                    if selectedCategry != nil {
                        
                        let ingredientsInCorrectContext = selectedRecipe?.ingredients.map { ingredient in
                            db_storage.fetchOrCreateIngredientInCurrentContext(ingredient.id, ingredient: ingredient)
                        } ?? []
                        
                        
                        try db_storage.appendRecipeToCategory(categoryId: selectedCategry?.ids ?? UUID(),
                                                              recipe: Recipes(id: recipe.id,
                                                                              name: name,
                                                                              summary: summary,
                                                                              category: selectedCategry,
                                                                              serving: serving,
                                                                              time: time,
                                                                              ingredients: [],
                                                                              instructions: instructions,
                                                                              imageData: imageData))
                    }
                    
                }
                catch {
                    self.error = error
                }
            }
//            DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                dismiss()
//            })
            
//        }
//        catch {
//            self.error = error
//        }
    }
    
   
}

// MARK: Extensions

extension RecipeForm {
    
    private func getCategoryFromId(_ id: UUID?) -> tempCategory{
        
        var category = tempCategory()
        
        for _category in category_db {
            if id == _category.ids {
                category = tempCategory(id: _category.ids, name: _category.name)
            }
        }
        
//        if let value = category_db.first(where: { $0.id == id }) {
//            category = MockCategory(id: value.id, name: value.name)
//        }
        
        return category
    }
    
    private func categoryDBtoLocal(_ model: [Categories]) -> [tempCategory]{
        var array = [tempCategory]()
        for value in model {
            array.append(tempCategory(id: value.ids, name: value.name))
        }
        return array
    }
    
    private func convertDBtoLocal(_ model: [RecipeIngredients])  -> [tempRecipeIngredient]{
        var array = [tempRecipeIngredient]()
        
        for value in model {
            array.append(tempRecipeIngredient(ingredient: tempIngredient(name: value.ingredient?.name ?? ""), quantity: ""))
        }
        
        return array
    }
    
}
