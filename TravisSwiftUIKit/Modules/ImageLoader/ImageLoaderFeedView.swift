// @copyright TravisSwiftUIKit by Travis Suwanwigo

import SwiftUI
import Combine

final class ImageLoaderFeedViewModel: ObservableObject {
  enum Action {
    case fetchImages
    case fetchImagesSuccess([URL])
    case fetchImagesFailure(Subscribers.Completion<any Error>)
  }
  
  @Published var imageURLs = [URL]()
  private var cancellables = Set<AnyCancellable>()
  let imageCache = DIContainer.shared.resolveImageCache()
  private let repository = DIContainer.shared.resolveCatRepository()
  
  func perform(_ action: Action) {
    switch action {
    case .fetchImages: fetchImages()
    case .fetchImagesSuccess(let imageURLs): self.imageURLs.append(contentsOf: imageURLs)
    case .fetchImagesFailure: break
    }
  }
  
  private func fetchImages() {
    repository.fetchCats(page: 0)
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { [weak self] completion in
        self?.perform(.fetchImagesFailure(completion))
      }, receiveValue: { [weak self] catModels in
        let imageURLs = catModels.compactMap { URL(string: $0.imageUrl) }
        self?.perform(.fetchImagesSuccess(imageURLs))
      })
      .store(in: &cancellables)
  }
}

struct ImageLoaderFeedView: View {
  @StateObject var viewModel = ImageLoaderFeedViewModel()
  
  let columns = [GridItem(.flexible()), GridItem(.flexible())]
  var body: some View {
    ScrollView {
      LazyVGrid(columns: columns, spacing: 10) {
        ForEach(viewModel.imageURLs, id: \.self) { url in
          NavigationLink(destination: ImageLoaderDetailView(url: url, imageCache: viewModel.imageCache)) {
            RemoteImageView(url: url, cache: viewModel.imageCache)
              .aspectRatio(contentMode: .fill)
              .frame(width: UIScreen.main.bounds.width / 2 - 20, height: UIScreen.main.bounds.width / 2 - 20)
              .clipped()
          }
        }
      }
      .padding(10)
    }
    .navigationTitle("Feed")
    .onAppear { viewModel.perform(.fetchImages) }
  }
}

struct ImageLoaderDetailView: View {
  var url: URL
  var imageCache: ImageCache
  
  var body: some View {
    VStack {
      RemoteImageView(url: url, cache: imageCache)
        .scaledToFit()
        .clipped()
      Spacer()
    }
    .navigationTitle("Detail (Cache)")
    .padding()
  }
}
