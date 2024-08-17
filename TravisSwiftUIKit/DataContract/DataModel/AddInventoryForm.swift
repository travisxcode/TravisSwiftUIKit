// @copyright TravisSwiftUIKit by Travis Suwanwigo

import Foundation

struct AddInventoryForm {
  var label: String = ""
}

enum AddInventoryAlertState: Equatable {
  case invalidForm(AddInventoryFormState.InvalidReason)
  case invalidModelContext
  case none
}

enum AddInventoryFormState: Equatable {
  case valid
  case invalid(InvalidReason)
  
  enum InvalidReason {
    case labelEmpty
  }
}

