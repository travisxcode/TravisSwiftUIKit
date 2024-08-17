// @copyright TravisSwiftUIKit by Travis Suwanwigo

import SwiftUI

struct RemoteImageView: View {
  @StateObject private var loader: ImageLoader
  
  init(url: URL, cache: ImageCache) {
    _loader = StateObject(wrappedValue: ImageLoader(url: url, cache: cache))
  }

  var body: some View {
    image.resizable()
  }

  private var image: Image {
    if let uiImage = loader.image {
      return Image(uiImage: uiImage)
    } else {
      return Image(systemName: "photo")
    }
  }
}
