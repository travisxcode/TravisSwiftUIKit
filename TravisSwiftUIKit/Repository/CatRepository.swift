// @copyright TravisSwiftUIKit by Travis Suwanwigo

import Combine
import Foundation

protocol CatRepository {
  func fetchCats(page: Int) -> AnyPublisher<[CatModel], Error>
}
class CatRepositoryImpl: CatRepository {
  private let catService: CatService
  private let mapper: CatEntityToModelMapper
  
  init(catService: CatService, mapper: CatEntityToModelMapper) {
    self.catService = catService
    self.mapper = mapper
  }
  
  func fetchCats(page: Int) -> AnyPublisher<[CatModel], Error> {
    return catService.fetchCats(page: page)
      .map { catEntities in
        catEntities.map { entity in
          self.mapper.map(entity: entity)
        }
      }
      .eraseToAnyPublisher()
  }
}
