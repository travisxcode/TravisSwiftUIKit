import SwiftUI
import Combine

final class PinterestViewModel: ObservableObject {
  enum Action {
    case fetchPins
    case fetchPinsIfNeeed((row: Int, col: Int))
    case fetchPinsSuccess([PinModel])
    case fetchPinsFailure(Subscribers.Completion<any Error>)
  }
  enum Constant {
    static var padding = 6
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
    self.waterfallBuilder = WaterfallViewModelBuilder(col: col)
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
      let totalPadding = CGFloat(col * Constant.padding)
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
      HStack(alignment: .top, spacing: 6) {
        ForEach(0..<viewModel.models.count, id: \.self) { col in
          LazyVStack(spacing: 6) {
            ForEach(viewModel.models[col].indices, id: \.self) { row in
              PinView(pinModel: viewModel.models[col][row], cache: cache)
                .onAppear { viewModel.perform(.fetchPinsIfNeeed((row, col))) }
            }
          }
        }
      }
      .padding(6)
    }
    .navigationTitle("Pinterest")
    .onAppear { viewModel.perform(.fetchPins) }
  }
}

class WaterfallViewModelBuilder {
  private var minHeap: [(i: Int, height: Double)]
  private var waterfallModels: [[PinModel]]
  
  init(col: Int) {
    minHeap = (0..<col).map { (i: $0, height: 0.0) }
    waterfallModels = Array(repeating: [PinModel](), count: col)
  }
  
  func build(models: [PinModel]) -> [[PinModel]] {
    for model in models {
      let minIndex = minHeap[0].i
      waterfallModels[minIndex].append(model)
      minHeap[0].height += model.height
      minHeap.sort { $0.height == $1.height ? $0.i < $1.i : $0.height < $1.height }
    }
    return waterfallModels
  }
}
