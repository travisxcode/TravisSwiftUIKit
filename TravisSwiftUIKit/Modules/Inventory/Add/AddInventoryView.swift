// @copyright TravisSwiftUIKit by Travis Suwanwigo

import SwiftUI
import SwiftData

final class AddInventoryViewModel: ObservableObject {
  enum Action {
    case viewDidLoad(ModelContext, DismissAction)
    case saveButtonDidTap
    case closeButtonDidTap
  }
  @Published var form = AddInventoryForm()
  @Published var showAlert = false
  var alertState = AddInventoryAlertState.none
  var dismissAction: DismissAction?
  var formValidator: AddInventoryFormValidator
  var repository: InventoryRepository?
  
  init() {
    formValidator = DIContainer.shared.resolveAddInventoryFormValidator()
  }
  
  func perform(_ action: Action) {
    switch action {
    case .viewDidLoad(let modelContext, let dismissAction): setupViewDependency(modelContext, dismissAction)
    case .saveButtonDidTap: performSave()
    case .closeButtonDidTap: dismissAction?()
    }
  }
  
  private func setupViewDependency(_ modelContext: ModelContext, _ dismissAction: DismissAction) {
    self.dismissAction = dismissAction
    self.repository = DIContainer.shared.resolveInventoryRepository(modelContext)
  }
  private func performSave() {
    switch formValidator.validate(form) {
    case .valid:
      guard let repository else {
        alertState = .invalidModelContext
        showAlert = true
        return
      }
      
      let newItem = InventoryItem(label: form.label, creationTime: Date())
      repository.add(item: newItem)
      dismissAction?()
    case .invalid(let invalidReason):
      switch invalidReason {
      case .labelEmpty:
        alertState = .invalidForm(.labelEmpty)
        showAlert = true
      }
    }
  }
}

struct AddInventoryView: View {
  @Environment(\.dismiss) var dismiss
  @Environment(\.modelContext) private var modelContext
  @StateObject private var viewModel = AddInventoryViewModel()

  var alertBuilder: AddInventoryAlertViewBuilder
  init() {
    self.alertBuilder = DIContainer.shared.resolveAddInventoryAlertViewBuilder()
  }
  
  var body: some View {
    NavigationView {
      VStack {
        itemLabelTextField
        Spacer()
        saveButton
      }
      .padding()
      .navigationTitle("Add Inventory")
      .navigationBarItems(leading: closeButton)
      .alert(isPresented: $viewModel.showAlert) {
        alertBuilder.build(viewModel.alertState)
      }
    }.onAppear { viewModel.perform(.viewDidLoad(modelContext, dismiss)) }
  }
  
  private var itemLabelTextField: some View {
    VStack(alignment: .leading) {
      Text("Item Label")
        .font(.title3)
        .bold()
      TextField("Lamp, Desk, Closet, ...", text: $viewModel.form.label)
        .textFieldStyle(PlainTextFieldStyle())
      Divider()
    }
  }
  private var saveButton: some View {
    Button(action: { viewModel.perform(.saveButtonDidTap )}) {
      Text("Save").frame(maxWidth: .infinity)
        .fontWeight(.medium)
        .padding(.vertical, 12).padding(.horizontal, 24)
        .background(.black).foregroundColor(.white)
        .cornerRadius(8)
    }
  }
  private var closeButton: some View {
    Button(action: { viewModel.perform(.closeButtonDidTap) }) {
      Image(systemName: "xmark").foregroundColor(.black)
    }
  }
}
