// @copyright TravisSwiftUIKit by Travis Suwanwigo

import Foundation
import SwiftData

final class DIContainer {
  static let shared = DIContainer()
  
  private init() {}
  
  func resolveCatRepository() -> CatRepository {
    CatRepositoryImpl(catService: resolveCatService(), mapper: resolveCatEntityToModelMapper())
  }
  func resolveCatService() -> CatService {
    CatServiceImpl()
  }
  func resolveCatEntityToModelMapper() -> CatEntityToModelMapper {
    CatEntityToModelMapperImpl()
  }
  
  func resolveAddInventoryFormValidator() -> AddInventoryFormValidator {
    AddInventoryFormValidatorImpl()
  }
  func resolveInventoryRepository(_ modelContext: ModelContext) -> InventoryRepository {
    InventoryRepositoryImpl(modelContext: modelContext)
  }
  func resolveAddInventoryAlertViewBuilder() -> AddInventoryAlertViewBuilder {
    AddInventoryAlertViewBuilderImpl(mapper: resolveAddInventoryAlertModelMapper())
  }
  func resolveAddInventoryAlertModelMapper() -> AddInventoryAlertModelMapper {
    AddInventoryAlertModelMapperImpl()
  }
}
