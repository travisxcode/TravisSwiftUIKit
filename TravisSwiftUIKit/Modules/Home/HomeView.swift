// @copyright TravisSwiftUIKit by Travis Suwanwigo

import SwiftUI

enum Page: String, CaseIterable {
  case catFeed = "🐈 Cat Feed"
  case inventory = "📦 Inventory (SwiftData)"
  case folders = "🗂️ Folders (Tree)"
}

final class HomeViewModel: ObservableObject {
  @Published var pages: [Page] = Page.allCases
  func view(for page: Page) -> some View {
    return switch page {
    case .catFeed: AnyView(CatFeedView())
    case .inventory: AnyView(InventoryListContainer())
    case .folders: AnyView(RootFolderView())
    }
  }
}
struct HomeView: View {
  @StateObject private var viewModel = HomeViewModel()
  var body: some View {
    List(viewModel.pages, id: \.self) { page in
      NavigationLink(destination: viewModel.view(for: page)) {
        Text(page.rawValue)
      }
    }.navigationTitle("TravisXcode")
  }
}

#Preview {
  HomeView()
}
