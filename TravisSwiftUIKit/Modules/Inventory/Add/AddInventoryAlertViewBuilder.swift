// @copyright LuluGarment by Travis Suwanwigo

import SwiftUI

protocol AddInventoryAlertViewBuilder {
  func build(_ alertState: AddInventoryAlertState) -> Alert
}
protocol AddInventoryAlertModelMapper {
  func map(_ alertState: AddInventoryAlertState) -> AlertModel
}

struct AddInventoryAlertViewBuilderImpl: AddInventoryAlertViewBuilder {
  var mapper: AddInventoryAlertModelMapper
  
  func build(_ alertState: AddInventoryAlertState) -> Alert {
    let alertModel = mapper.map(alertState)
    return Alert(
      title: Text(alertModel.title),
      message: Text(alertModel.message),
      dismissButton: .default(Text(alertModel.dismissButtonTitle))
    )
  }
}

struct AddInventoryAlertModelMapperImpl: AddInventoryAlertModelMapper {
  func map(_ alertState: AddInventoryAlertState) -> AlertModel {
    AlertModel(
      title: buildTitle(),
      message: buildMessage(alertState),
      dismissButtonTitle: buildDismissButtonTitle()
    )
  }
  
  private func buildMessage(_ alertState: AddInventoryAlertState) -> String {
    return switch alertState {
    case .invalidForm(let reason):
      switch reason {
      case .labelEmpty:
        "Garment name cannot be empty"
      }
    case .invalidModelContext:
      "There was an issue with the system. Please try again."
    case .none:
      ""
    }
  }
  private func buildTitle() -> String { "Error" }
  private func buildDismissButtonTitle() -> String { "OK" }
}
