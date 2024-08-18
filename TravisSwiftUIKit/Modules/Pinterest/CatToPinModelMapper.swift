// @copyright TravisSwiftUIKit by Travis Suwanwigo

import Foundation

struct CatToPinModelMapper {
  static func map(_ catModel: CatModel) -> PinModel {
    PinModel(
      id: catModel.id,
      width: catModel.width,
      height: catModel.height,
      imageUrl: catModel.imageUrl
    )
  }
}
