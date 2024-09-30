import SwiftUI
import PhotosUI
import Foundation
import SwiftData

struct RecipeForm: View {
    enum Mode: Hashable {
        case add
        case edit(tempRecipe)
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
            _categoryId = .init(initialValue: recipe.category?.id)
            _imageData = .init(initialValue: recipe.imageData)
            
            selectedRecipe = recipe
            
        }
    }
    
    private let title: String
    @State private var name: String
    @State private var summary: String
    @State private var serving: Int
    @State private var time: Int
    @State private var instructions: String
    @State private var categoryId: tempCategory.ID?
    @State private var ingredients: [tempRecipeIngredient]
    @State private var imageItem: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var isIngredientsPickerPresented =  false
    @State private var error: Error?
    @Environment(\.dismiss) private var dismiss
//    @Environment(\.storage) private var storage
    
    @Environment(\.modelContext) private var context
    
    /// Swift Data variable
    @Query var category_db: [SwiftDataCategory] = []
    
    /// State variable
    @State var category: [tempCategory] = []
    @State var selectedCategry: tempCategory? = nil
    var selectedRecipe: tempRecipe? = nil
    
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
            category = categoryDBtoLocal(category_db)
            if mode != .add {
                selectedCategry = getCategoryFromId(selectedRecipe?.category?.id)
            }
        }
    }
        
    
    // MARK: - Views
    
    private func ingredientPicker() -> some View {
        IngredientsView { selectedIngredient in
            let recipeIngredient = tempRecipeIngredient(ingredient: selectedIngredient, quantity: "")
            ingredients.append(recipeIngredient)
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
                Text("None").tag(tempCategory?.none)
                ForEach(category) { category in
                    Text(category.name).tag(category as tempCategory?)
                }
            }
            .onChange(of: selectedCategry, perform: { value in
                print(value)
            })
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
            if ingredients.isEmpty {
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
                ForEach(ingredients) { ingredient in
                    HStack(alignment: .center) {
                        Text(ingredient.ingredient.name)
                            .bold()
                            .layoutPriority(2)
                        Spacer()
                        TextField("Quantity", text: .init(
                            get: {
                                ingredient.quantity
                            },
                            set: { quantity in
                                if let index = ingredients.firstIndex(where: { $0.id == ingredient.id }) {
                                    ingredients[index].quantity = quantity
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
    
    func delete(recipe: tempRecipe) {
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
            ingredients.remove(atOffsets: offsets)
        }
    }
    
    func save() {
        
        let db_storage = StorageData(context: context)
        
//        let category = storage.categories.first(where: { $0.id == categoryId })
        var ingredients_temp: [SwiftDataRecipeIngredient] = []
        
        var category_temp: SwiftDataCategory? = nil
        
        for _recipe in ingredients {
            let existingIngredient = db_storage.findOrCreateIngredient(name: _recipe.ingredient.name)
            ingredients_temp.append(SwiftDataRecipeIngredient(ingredient: existingIngredient, quantity: _recipe.quantity))
        }
        
        for value in category_db {
            if selectedCategry?.id == value.ids {
                category_temp = value
            }
        }
        
        
        
        
            switch mode {
            case .add:
                
                do{
                    try db_storage.addRecipe(
                        name: name,
                        summary: summary,
                        categoryId: category_temp,
                        serving: serving,
                        time: time,
                        ingredients: ingredients_temp,
                        instructions: instructions,
                        imageData: imageData)
                }
                catch {
                    self.error = error
                }
            case .edit(let recipe):
                
                do {
                    try db_storage.updateRecipe(
                        id: recipe.id,
                        newName: name,
                        newSummary: summary,
                        newCategory: category_temp,
                        newServing: serving,
                        newTime: time,
                        newIngredients: ingredients_temp,
                        newInstructions: instructions,
                        newImageData: imageData
                    )
                }
                catch {
                    self.error = error
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                dismiss()
            })
            
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
    
    private func categoryDBtoLocal(_ model: [SwiftDataCategory]) -> [tempCategory]{
        var array = [tempCategory]()
        for value in model {
            array.append(tempCategory(id: value.ids, name: value.name))
        }
        return array
    }
    
    private func convertDBtoLocal(_ model: [SwiftDataRecipeIngredient])  -> [tempRecipeIngredient]{
        var array = [tempRecipeIngredient]()
        
        for value in model {
            array.append(tempRecipeIngredient(ingredient: tempIngredient(name: value.ingredient?.name ?? ""), quantity: ""))
        }
        
        return array
    }
    
}
