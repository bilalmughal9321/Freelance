import SwiftUI

@main
struct SwiftBitesApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
//        .environment(\.storage, Storage())
        .modelContainer(for: [Ingredients.self, Categories.self, Recipes.self, RecipeIngredients.self])
    }
  }
}
