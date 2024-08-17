// @copyright TravisSwiftUIKit by Travis Suwanwigo

import SwiftUI

struct CatCardViewModel {
  var id: String
  var imageUrl: String
  
  init(catModel: CatModel) {
    id = catModel.id
    imageUrl = catModel.imageUrl
  }
}
struct CatCardView: View {
  var viewModel: CatCardViewModel
  var body: some View {
    VStack {
      CachedAsyncImage(url: URL(string: viewModel.imageUrl), id: viewModel.id)
        .aspectRatio(contentMode: .fill)
        .frame(height: 180)
        .clipped()
        .cornerRadius(20)
      Text(viewModel.id)
    }
  }
}
