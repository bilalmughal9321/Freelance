import SwiftUI

@main
struct SwiftBitesApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
//        .environment(\.storage, Storage())
        .modelContainer(for: [SwiftDataIngredient.self, SwiftDataCategory.self, SwiftDataRecipe.self, SwiftDataRecipeIngredient.self])
    }
  }
}
