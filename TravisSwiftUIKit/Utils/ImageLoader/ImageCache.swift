// @copyright TravisSwiftUIKit by Travis Suwanwigo

import UIKit

protocol ImageCache: AnyObject {
  func image(for url: URL) -> UIImage?
  func insertImage(_ image: UIImage?, for url: URL)
  func removeImage(for url: URL)
  subscript(_ url: URL) -> UIImage? { get set }
}

final class ImageCacheImpl: ImageCache {
  private lazy var cache: NSCache<NSURL, UIImage> = {
    let cache = NSCache<NSURL, UIImage>()
    cache.countLimit = 100
    cache.totalCostLimit = 50 * 1024 * 1024
    return cache
  }()
  func image(for url: URL) -> UIImage? {
    cache.object(forKey: url as NSURL)
  }
  func insertImage(_ image: UIImage?, for url: URL) {
    guard let image = image else {
      removeImage(for: url)
      return
    }
    cache.setObject(image, forKey: url as NSURL)
  }
  func removeImage(for url: URL) {
    cache.removeObject(forKey: url as NSURL)
  }
  subscript(_ url: URL) -> UIImage? {
    get { image(for: url) }
    set { insertImage(newValue, for: url) }
  }
}
