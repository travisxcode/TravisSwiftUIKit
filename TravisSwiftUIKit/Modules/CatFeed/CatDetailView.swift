// @copyright TravisSwiftUIKit by Travis Suwanwigo

import SwiftUI

struct CatDetailViewModel {
  var id: String
  var imageUrl: String
  
  init(catModel: CatModel) {
    id = catModel.id
    imageUrl = catModel.imageUrl
  }
}
struct CatDetailView: View {
  var viewModel: CatDetailViewModel
  var body: some View {
    VStack {
      CachedAsyncImage(url: URL(string: viewModel.imageUrl), id: viewModel.id)
        .aspectRatio(contentMode: .fill)
        .frame(height: 180)
        .clipped()
        .cornerRadius(20)
      Spacer()
    }
    .padding()
    .navigationTitle("\(viewModel.id)")
  }
}
