// @copyright TravisSwiftUIKit by Travis Suwanwigo

import Foundation

protocol AddInventoryFormValidator {
  func validate(_ form: AddInventoryForm) -> AddInventoryFormState
}
struct AddInventoryFormValidatorImpl: AddInventoryFormValidator {
  func validate(_ form: AddInventoryForm) -> AddInventoryFormState {
    if form.label.isEmpty {
      return .invalid(.labelEmpty)
    } else {
      return .valid
    }
  }
  
}
