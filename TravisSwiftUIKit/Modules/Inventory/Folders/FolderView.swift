// @copyright TravisSwiftUIKit by Travis Suwanwigo

import SwiftUI

struct FolderView: View {
  let folders: [Folder]
  
  var body: some View {
    List(folders, children: \.subFolders) { folder in
      Text(folder.value)
    }
  }
}

struct RootFolderView: View {
  let rootFolders: [Folder] = [
    Folder(value: "Root 1", subFolders: [
      Folder(value: "Sub 1", subFolders: [
        Folder(value: "Sub 1-1", subFolders: nil),
        Folder(value: "Sub 1-2", subFolders: nil)
      ]),
      Folder(value: "Sub 2", subFolders: nil)
    ]),
    Folder(value: "Root 2", subFolders: [
      Folder(value: "Sub 3", subFolders: nil)
    ])
  ]
  
  var body: some View {
    FolderView(folders: rootFolders)
      .navigationTitle("Folders")
  }
}


