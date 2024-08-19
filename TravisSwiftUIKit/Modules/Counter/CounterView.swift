// @copyright TravisSwiftUIKit by Travis Suwanwigo

import SwiftUI
import Combine

final class CounterViewModel: ObservableObject {
  enum Action {
    case addButtonTapped
    case minusButtonTapped
  }
  @Published var count = 0
  private var cancellables = Set<AnyCancellable>()
  let addButtonViewModel: AddButtonViewModel
  let minusButtonViewModel: MinusButtonViewModel
  let childActionSubject = PassthroughSubject<Action, Never>()
  
  init() {
    addButtonViewModel = AddButtonViewModel(actionSubject: childActionSubject)
    minusButtonViewModel = MinusButtonViewModel(actionSubject: childActionSubject)
    childActionSubject
      .sink { [weak self] action in self?.perform(action) }
      .store(in: &cancellables)
  }
  
  func perform(_ action: Action) {
    switch action {
    case .addButtonTapped: count += 1
    case .minusButtonTapped: count = max(0, count - 1)
    }
  }
}
struct CounterView: View {
  @StateObject var viewModel = CounterViewModel()
  var body: some View {
    VStack {
      Text("\(viewModel.count)")
        .font(.largeTitle)
        .bold()
      HStack(spacing: 10) {
        MinusButton(viewModel: viewModel.minusButtonViewModel)
        AddButton(viewModel: viewModel.addButtonViewModel)
      }
      Spacer()
    }
    .navigationTitle("Counters")
    .padding()
  }
}

struct AddButtonViewModel {
  var actionSubject: PassthroughSubject<CounterViewModel.Action, Never>
}
struct AddButton: View {
  var viewModel: AddButtonViewModel
  var body: some View {
    Button(action: { viewModel.actionSubject.send(.addButtonTapped) }) {
      Image(systemName: "plus")
        .font(.system(size: 20, weight: .bold))
        .foregroundColor(.black)
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background(
          RoundedRectangle(cornerRadius: 12)
            .stroke(Color.gray, lineWidth: 2)
        )
    }
  }
}

struct MinusButtonViewModel {
  var actionSubject: PassthroughSubject<CounterViewModel.Action, Never>
}
struct MinusButton: View {
  var viewModel: MinusButtonViewModel
  var body: some View {
    Button(action: { viewModel.actionSubject.send(.minusButtonTapped) }) {
      Image(systemName: "minus")
        .font(.system(size: 20, weight: .bold))
        .foregroundColor(.black)
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background(
          RoundedRectangle(cornerRadius: 12)
            .stroke(Color.gray, lineWidth: 2)
        )
    }
  }
}

#Preview {
  CounterView()
}
