// @copyright TravisSwiftUIKit by Travis Suwanwigo

import SwiftData
import SwiftUI
import Combine

final class InventoryListViewModel: ObservableObject {
  enum Action {
    case delete(IndexSet, [InventoryItem])
  }
  var repository: InventoryRepository
  
  init(repository: InventoryRepository) {
    self.repository = repository
  }
  
  func perform(_ action: Action) {
    switch action {
    case .delete(let indexSet, let items):
      indexSet.forEach { index in
        repository.delete(item: items[index])
      }
    }
  }
}

struct InventoryListView: View {
  @Query(sort: \InventoryItem.label, order: .forward) var items: [InventoryItem]
  var actionSubject: PassthroughSubject<InventoryListContainerViewModel.Action, Never>
  
  var body: some View {
    List {
      ForEach(items) { item in
        HStack {
          Text(item.label)
          Spacer()
          Text(item.creationTime, format: Date.FormatStyle(date: .omitted, time: .shortened))
        }
      }
      .onDelete { indexSet in
        actionSubject.send(.delete(indexSet, items))
      }
    }
  }
}
//struct InventoryListView: View {
//  @Query(sort: \InventoryItem.label, order: .forward) var items: [InventoryItem]
//  var viewModel: InventoryListViewModel
//  
//  var body: some View {
//    List {
//      ForEach(items) { item in
//        HStack {
//          Text(item.label)
//          Spacer()
//          Text(item.creationTime, format: Date.FormatStyle(date: .omitted, time: .shortened))
//        }
//      }
//      .onDelete { indexSet in viewModel.perform(.delete(indexSet, items)) }
//    }
//  }
//}

