// @copyright TravisSwiftUIKit by Travis Suwanwigo

import SwiftUI
import Combine

final class CounterViewModel: ObservableObject {
  enum Action {
    case addButtonTapped
    case minusButtonTapped
    case resetButtonTapped
  }
  @Published var count = 0
  private var cancellables = Set<AnyCancellable>()
  let addButtonViewModel: AddButtonViewModel
  let minusButtonViewModel: MinusButtonViewModel
  let resetButtonViewModel: ResetButtonViewModel
  let childActionSubject = PassthroughSubject<Action, Never>()
  
  init() {
    addButtonViewModel = AddButtonViewModel(actionSubject: childActionSubject)
    minusButtonViewModel = MinusButtonViewModel(actionSubject: childActionSubject)
    resetButtonViewModel = ResetButtonViewModel(actionSubject: childActionSubject)
    childActionSubject
      .sink { [weak self] action in self?.perform(action) }
      .store(in: &cancellables)
  }
  
  func perform(_ action: Action) {
    switch action {
    case .addButtonTapped: count += 1
    case .minusButtonTapped: count = max(0, count - 1)
    case .resetButtonTapped: count = 0
    }
  }
}
struct CounterView: View {
  @StateObject var viewModel = CounterViewModel()
  var body: some View {
    VStack(spacing: 10) {
      CounterResultView(count: viewModel.count)
      HStack(spacing: 10) {
        MinusButton(viewModel: viewModel.minusButtonViewModel)
        AddButton(viewModel: viewModel.addButtonViewModel)
      }
      ResetButton(viewModel: viewModel.resetButtonViewModel)

      Spacer()
    }
    .navigationTitle("Counters")
    .padding()
  }
}

struct CounterResultView: View {
  var count: Int
  var body: some View {
    Text("\(count)")
      .font(.largeTitle)
      .bold()
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
        .frame(maxWidth: .infinity).frame(height: 60)
        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 2))
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
        .frame(maxWidth: .infinity).frame(height: 60)
        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 2))
    }
  }
}

struct ResetButtonViewModel {
  var actionSubject: PassthroughSubject<CounterViewModel.Action, Never>
}
struct ResetButton: View {
  var viewModel: ResetButtonViewModel
  
  var body: some View {
    Button(action: { viewModel.actionSubject.send(.resetButtonTapped) }) {
      Text("Reset")
        .font(.system(size: 20, weight: .bold))
        .foregroundColor(.black)
        .frame(maxWidth: .infinity).frame(height: 60)
        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 2))
    }
  }
}

#Preview {
  CounterView()
}
