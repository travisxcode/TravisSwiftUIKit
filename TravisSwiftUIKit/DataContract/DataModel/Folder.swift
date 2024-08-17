// @copyright TravisSwiftUIKit by Travis Suwanwigo

import Foundation

struct Folder: Identifiable {
  let id = UUID()
  var value: String
  var subFolders: [Folder]?
}
