// @copyright TravisSwiftUIKit by Travis Suwanwigo

import Foundation

struct CatModel {
  var id: String
  var width: Double
  var height: Double
  var imageUrl: String
  var breeds: [BreedModel]?
}

struct BreedModel {
  var id: String
  var name: String
  var wikipediaUrl: String
}
