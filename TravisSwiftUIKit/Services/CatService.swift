// @copyright TravisSwiftUIKit by Travis Suwanwigo

import Combine
import Foundation

protocol CatService {
  func fetchCats(page: Int) -> AnyPublisher<[CatEntity], Error>
}
class CatServiceImpl: CatService {
  func fetchCats(page: Int) -> AnyPublisher<[CatEntity], Error> {
    let url = URL(string: "https://api.thecatapi.com/v1/images/search?limit=10&page=\(page)")!
    return URLSession.shared.dataTaskPublisher(for: url)
      .map { $0.data }
      .decode(type: [CatEntity].self, decoder: JSONDecoder())
      .eraseToAnyPublisher()
  }
}
