// @copyright TravisSwiftUIKit by Travis Suwanwigo

import Foundation

protocol WaterfallViewModelBuilder {
  func build(models: [PinModel]) -> [[PinModel]]
}

final class WaterfallViewModelBuilderImpl: WaterfallViewModelBuilder {
  private var minHeap: [(i: Int, height: Double)]
  private var waterfallModels: [[PinModel]]
  
  init(col: Int) {
    minHeap = (0..<col).map { (i: $0, height: 0.0) }
    waterfallModels = Array(repeating: [PinModel](), count: col)
  }
  
  func build(models: [PinModel]) -> [[PinModel]] {
    for model in models {
      let minIndex = minHeap[0].i
      waterfallModels[minIndex].append(model)
      minHeap[0].height += model.height
      minHeap.sort { $0.height == $1.height ? $0.i < $1.i : $0.height < $1.height }
    }
    return waterfallModels
  }
}
