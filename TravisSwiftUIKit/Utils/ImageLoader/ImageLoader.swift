// @copyright TravisSwiftUIKit by Travis Suwanwigo

import Foundation
import UIKit
import Combine

final class ImageLoader: ObservableObject {
  @Published var image: UIImage?
  private var cache: ImageCache?
  private var cancellable: AnyCancellable?
  private static let imageProcessingQueue = DispatchQueue(label: "image-processing")

  init(url: URL, cache: ImageCache? = nil) {
    self.cache = cache
    loadImage(from: url)
  }

  private func loadImage(from url: URL) {
    if let cachedImage = cache?[url] {
      self.image = cachedImage
      return
    }

    cancellable = URLSession.shared.dataTaskPublisher(for: url)
      .map { UIImage(data: $0.data) }
      .replaceError(with: nil)
      .handleEvents(receiveOutput: { [weak self] image in
        guard let self = self, let image = image else { return }
        self.cache?[url] = image
      })
      .receive(on: DispatchQueue.main)
      .assign(to: \.image, on: self)
  }

  deinit {
    cancellable?.cancel()
  }
}
