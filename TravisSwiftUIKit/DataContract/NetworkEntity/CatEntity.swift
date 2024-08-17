// @copyright TravisSwiftUIKit by Travis Suwanwigo

import Foundation

struct CatEntity: Codable {
  var id: String
  var width: Double
  var height: Double
  var url: String
  var breeds: [BreedEntity]?
}

struct BreedEntity: Codable {
  var id: String
  var name: String
  var temperament: String
  var wikipediaUrl: String
}
