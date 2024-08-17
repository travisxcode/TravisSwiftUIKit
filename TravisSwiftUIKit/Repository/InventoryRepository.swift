// @copyright TravisSwiftUIKit by Travis Suwanwigo

import SwiftData
import SwiftUI

enum SortOption: String, CaseIterable, Identifiable {
  case alphabetical = "Alphabetical"
  case creationTime = "Creation Time"
  
  var id: Self { self }
}
protocol InventoryRepository {
  func fetchQuery() -> Query<InventoryItem, [InventoryItem]>
  func fetchQuery(sortOption: SortOption) -> Query<InventoryItem, [InventoryItem]>
  func add(item: InventoryItem)
  func delete(item: InventoryItem)
}

struct InventoryRepositoryImpl: InventoryRepository {
  var modelContext: ModelContext
  
  func fetchQuery() -> Query<InventoryItem, [InventoryItem]> {
    Query(filter: nil, sort: \.label, order: .forward)
  }
  
  func fetchQuery(sortOption: SortOption) -> Query<InventoryItem, [InventoryItem]> {
    return switch sortOption {
    case .alphabetical: Query(filter: nil, sort: \.label, order: .forward)
    case .creationTime: Query(filter: nil, sort: \.creationTime, order: .reverse)
    }
  }
  
  func add(item: InventoryItem) {
    modelContext.insert(item)
    do {
      try modelContext.save()
    } catch {
      print("Failed to delete items: \(error)")
    }
  }
  func delete(item: InventoryItem) {
    modelContext.delete(item)
    do {
      try modelContext.save()
    } catch {
      print("Failed to delete items: \(error)")
    }
  }
}
