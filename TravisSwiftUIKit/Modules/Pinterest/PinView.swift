// @copyright TravisSwiftUIKit by Travis Suwanwigo

import SwiftUI

struct PinView: View {
  let pinModel: PinModel
  let cache: ImageCache
  
  var body: some View {
    RemoteImageView(url: URL(string: pinModel.imageUrl)!, cache: cache)
      .aspectRatio(contentMode: .fill)
      .frame(width: pinModel.width, height: pinModel.height)
      .cornerRadius(12)
      .clipped()
  }
}
