// @copyright TravisSwiftUIKit by Travis Suwanwigo

import SwiftUI
import Combine

final class CatFeedViewModel: ObservableObject {
  enum Action {
    case fetchCats
    case fetchCatsSuccess([CatModel])
    case fetchCatsFailure(Subscribers.Completion<any Error>)
  }
  
  // State
  @Published var catModels = [CatModel]()
  private var page = 0
  private var cancellables = Set<AnyCancellable>()
  private var isLoading = false
  
  // Dependency
  private let repository: CatRepository
  
  init(repository: CatRepository) {
    self.repository = repository
  }
  
  func perform(_ action: Action) {
    switch action {
    case .fetchCats: fetchCats()
    case .fetchCatsSuccess(let catModels): fetchCatsSuccess(catModels)
    case .fetchCatsFailure(_): break
    }
  }
  
  private func fetchCats() {
    guard !isLoading else { return }
    isLoading.toggle()
    
    repository.fetchCats(page: page)
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { [weak self] completion in
        self?.perform(.fetchCatsFailure(completion))
      }, receiveValue: { [weak self] catModels in
        self?.perform(.fetchCatsSuccess(catModels))
      })
      .store(in: &cancellables)
  }
  
  private func fetchCatsSuccess(_ catModels: [CatModel]) {
    self.catModels.append(contentsOf: catModels)
    isLoading = false
    page += 1
  }
  
  func catCardViewModelForIndex(_ index: Int) -> CatCardViewModel {
    CatCardViewModel(catModel: catModels[index])
  }
  
  func catDetailViewModelForIndex(_ index: Int) -> CatDetailViewModel {
    CatDetailViewModel(catModel: catModels[index])
  }
}

struct CatFeedView: View {
  @StateObject private var viewModel: CatFeedViewModel
  @State private var hasAppeared = false
  
  init() {
    _viewModel = StateObject(
      wrappedValue: CatFeedViewModel(repository: DIContainer.shared.resolveCatRepository())
    )
  }
  
  var body: some View {
    ScrollView {
      LazyVStack {
        ForEach(viewModel.catModels.indices, id: \.self) { index in
          NavigationLink(
            destination: CatDetailView(viewModel: viewModel.catDetailViewModelForIndex(index))
          ) {
            CatCardView(viewModel: viewModel.catCardViewModelForIndex(index))
              .onAppear {
                if index == viewModel.catModels.count - 1 {
                  viewModel.perform(.fetchCats)
                }
              }
          }
        }
      }.padding(.horizontal, 20)
    }
    
    .navigationTitle("Cats")
    .onAppear {
      if !hasAppeared {
        viewModel.perform(.fetchCats)
        hasAppeared.toggle()
      }
    }
  }
}
