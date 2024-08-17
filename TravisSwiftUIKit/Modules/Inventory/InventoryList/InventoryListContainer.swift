// @copyright TravisSwiftUIKit by Travis Suwanwigo

import SwiftUI
import SwiftData
import Combine

final class InventoryListContainerViewModel: ObservableObject {
  enum Action {
    case viewDidLoad(ModelContext)
    case addButtonTapped
    case sortOptionDidChange
    case delete(IndexSet, [InventoryItem])
  }
  
  @Published var isPresentingAddView = false
  @Published var sortOption: SortOption = .alphabetical {
    didSet { perform(.sortOptionDidChange) }
  }
  @Published private(set) var items: Query<InventoryItem, [InventoryItem]> = Query(
    filter: nil, sort: \.label, order: .forward
  )
  
  var repository: InventoryRepository?
  private var cancellables = Set<AnyCancellable>()
  
  let childActionSubject = PassthroughSubject<Action, Never>()
  
  init() {
    childActionSubject
      .sink { [weak self] action in self?.perform(action) }
      .store(in: &cancellables)
  }
  
  func perform(_ action: Action) {
    switch action {
    case .viewDidLoad(let modelContext):
      setupViewDependency(modelContext: modelContext)
      fetchQuery()
    case .sortOptionDidChange:
      fetchQuery()
    case .addButtonTapped:
      isPresentingAddView = true
    case .delete(let indexSet, let items):
      deleteItems(at: indexSet, from: items)
    }
  }
  
  private func fetchQuery() {
    guard let repository else { return }
    items = repository.fetchQuery(sortOption: sortOption)
  }
  
  private func setupViewDependency(modelContext: ModelContext) {
    repository = DIContainer.shared.resolveInventoryRepository(modelContext)
  }
  
  private func deleteItems(at indexSet: IndexSet, from items: [InventoryItem]) {
    guard let repository else { return }
    indexSet.forEach { index in
      repository.delete(item: items[index])
    }
  }
}

struct InventoryListContainer: View {
  @Environment(\.modelContext) private var modelContext
  @StateObject private var viewModel = InventoryListContainerViewModel()
  
  var body: some View {
    VStack(spacing: .zero) {
      sortSegmentedControl
      Divider()
      InventoryListView(
        _items: viewModel.items,
        actionSubject: viewModel.childActionSubject
      )
    }
    .navigationTitle("Inventory")
    .navigationBarItems(trailing: addButton)
    .fullScreenCover(isPresented: $viewModel.isPresentingAddView) {
      AddInventoryView()
    }
    .onAppear { viewModel.perform(.viewDidLoad(modelContext)) }
  }
  
  private var addButton: some View {
    Button(action: { viewModel.perform(.addButtonTapped) }) {
      Image(systemName: "plus")
    }
  }
  
  private var sortSegmentedControl: some View {
    Picker(selection: $viewModel.sortOption, label: EmptyView()) {
      ForEach(SortOption.allCases) { option in
        Text(option.rawValue).tag(option)
      }
    }
    .pickerStyle(SegmentedPickerStyle())
    .padding()
  }
}
