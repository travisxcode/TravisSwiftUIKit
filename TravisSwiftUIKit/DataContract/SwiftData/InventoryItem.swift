// @copyright TravisSwiftUIKit by Travis Suwanwigo

import Foundation
import SwiftData

@Model
final class InventoryItem {
  var label: String
  var creationTime: Date
  
  init(label: String, creationTime: Date) {
    self.label = label
    self.creationTime = creationTime
  }
}
