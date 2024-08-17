// @copyright TravisSwiftUIKit by Travis Suwanwigo

import Foundation

protocol CatEntityToModelMapper {
  func map(entity: CatEntity) -> CatModel
}
struct CatEntityToModelMapperImpl: CatEntityToModelMapper {
  func map(entity: CatEntity) -> CatModel {
    return CatModel(
      id: entity.id,
      width: entity.width,
      height: entity.height,
      imageUrl: entity.url,
      breeds: entity.breeds?.map { breedEntity in
        BreedModel(
          id: breedEntity.id,
          name: breedEntity.name,
          wikipediaUrl: breedEntity.wikipediaUrl
        )
      }
    )
  }
}
