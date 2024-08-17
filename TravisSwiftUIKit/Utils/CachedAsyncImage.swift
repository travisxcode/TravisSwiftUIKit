// @copyright TravisSwiftUIKit by Travis Suwanwigo

import SwiftUI

final class ImageCacheRepository {
  static let shared = ImageCacheRepository()
  private var cache: [String: Image] = [:]
  private init() {}
  
  func setImage(_ image: Image, forKey key: String) {
    cache[key] = image
  }
  func getImage(forKey key: String) -> Image? { cache[key] }
  func reset() { cache = [:] }
}

struct CachedAsyncImage: View {
  let url: URL?
  let id: String
  
  var body: some View {
    if let image = ImageCacheRepository.shared.getImage(forKey: id) {
      image.resizable()
    } else {
      AsyncImage(url: url) { phase in
        switch phase {
        case .success(let image):
          image.resizable()
            .scaledToFill()
            .onAppear {
              ImageCacheRepository.shared.setImage(image, forKey: id)
            }
        case .empty: ProgressView()
        case .failure(_): Image(systemName: "photo")
        @unknown default: EmptyView()
        }
      }
    }
  }
}
