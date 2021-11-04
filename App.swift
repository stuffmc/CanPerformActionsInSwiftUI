import SwiftUI

@main
struct CanPerformActionsInSwiftUIApp: App {
    @State var text = "Lorem\nIpsum"
    private let responder = Responder()
    
    var body: some Scene {
        WindowGroup {
            Form {
                TextField("", text: $text)
                TextEditor(text: $text)
                    .frame(height: 100)
            }
        }
    }
}

class Responder {
    init() {
        let textFieldSelector = #selector(UITextField.canPerformAction(_:withSender:))
        let textFieldSwizzledSelector = #selector(Self.textFieldCanPerformAction(_:))
        
        let textViewSelector = #selector(UITextView.canPerformAction(_:withSender:))
        let textViewSwizzledSelector = #selector(Self.textViewCanPerformAction(_:))
        
        if let textFieldSwizzledMethod = class_getInstanceMethod(Self.self, textFieldSwizzledSelector),
           let textViewSwizzledMethod = class_getInstanceMethod(Self.self, textViewSwizzledSelector),
           let textFieldMethod = class_getInstanceMethod(UITextField.self, textFieldSelector),
           let textViewMethod = class_getInstanceMethod(UITextView.self, textViewSelector) {
            method_exchangeImplementations(textFieldMethod, textFieldSwizzledMethod)
            method_exchangeImplementations(textViewMethod, textViewSwizzledMethod)
        }
    }
    
    @objc func textFieldCanPerformAction(_ action: Selector) -> Bool {
        canPerformAction(action)
    }
    
    @objc func textViewCanPerformAction(_ action: Selector) -> Bool {
        canPerformAction(action)
    }
    
    private func canPerformAction(_ action: Selector) -> Bool {
        action == #selector(UIResponderStandardEditActions.copy(_:))
        || action == #selector(UIResponderStandardEditActions.cut(_:))
        || action == #selector(UIResponderStandardEditActions.paste(_:))
    }
}
