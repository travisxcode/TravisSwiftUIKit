import SwiftUI
import Combine

fileprivate enum Constant {
  static var padding: CGFloat = 8
}

final class PinterestViewModel: ObservableObject {
  enum Action {
    case fetchPins
    case fetchPinsIfNeeed((row: Int, col: Int))
    case fetchPinsSuccess([PinModel])
    case fetchPinsFailure(Subscribers.Completion<any Error>)
  }
  
  private var cancellables = Set<AnyCancellable>()
  @Published var models = [[PinModel]]()
  private let col: Int
  private var page = 0
  private var isLoading = false
  private let repository = DIContainer.shared.resolveCatRepository()
  private let waterfallBuilder: WaterfallViewModelBuilder
  
  init(col: Int) {
    self.col = col
    self.waterfallBuilder = DIContainer.shared.resolveWaterfallViewModelBuilder(col)
  }
  
  func perform(_ action: Action) {
    switch action {
    case .fetchPins:
      guard !isLoading else { return }
      isLoading = true
      repository.fetchCats(page: page)
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { [weak self] completion in
          self?.perform(.fetchPinsFailure(completion))
        }, receiveValue: { [weak self] catModels in
          guard let self else { return }
          let pinModels = catModels.map { catModel in
            PinModel(id: catModel.id, width: catModel.width, height: catModel.height, imageUrl: catModel.imageUrl)
          }
          self.perform(.fetchPinsSuccess(pinModels))
        })
        .store(in: &cancellables)
    case .fetchPinsIfNeeed((let row, let col)):
      guard col == self.col - 1 && row == models[col].count - 1 else { return }
      perform(.fetchPins)
    case .fetchPinsSuccess(let pinModels):
      let totalPadding = CGFloat(col) * Constant.padding
      let width = (UIScreen.main.bounds.width - totalPadding) / CGFloat(col)
      let pinModelsWithNomalizardHeight = pinModels.map {
        PinModel(id: $0.id, width: width, height: width * ($0.height / $0.width), imageUrl: $0.imageUrl)
      }
      self.models = waterfallBuilder.build(models: pinModelsWithNomalizardHeight)
      isLoading = false
      page += 1
    case .fetchPinsFailure(_): isLoading = false
    }
  }
}

struct PinterestView: View {
  @StateObject var viewModel: PinterestViewModel
  private let cache = DIContainer.shared.resolveImageCache()
  init(col: Int) {
    _viewModel = StateObject(wrappedValue: PinterestViewModel(col: col))
  }
                             
  var body: some View {
    ScrollView {
      HStack(alignment: .top, spacing: Constant.padding) {
        ForEach(0..<viewModel.models.count, id: \.self) { col in
          LazyVStack(spacing: Constant.padding) {
            ForEach(viewModel.models[col].indices, id: \.self) { row in
              PinView(pinModel: viewModel.models[col][row], cache: cache)
                .onAppear { viewModel.perform(.fetchPinsIfNeeed((row, col))) }
            }
          }
        }
      }
      .padding(.horizontal, Constant.padding)
    }
    .navigationTitle("Pinterest")
    .onAppear { viewModel.perform(.fetchPins) }
  }
}
