//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class TextFieldDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textField1 = FluentTextField()
        textField1.placeholder = "Hint text"
        textField1.leadingImage = UIImage(named: "Placeholder_24")
        textField1.labelText = "Label"
        textField1.assistiveText = "Validates text on each input character"
        textField1.validateInputText = validateText

        let textField2 = FluentTextField()
        textField2.placeholder = "Hint text"
        textField2.leadingImage = UIImage(named: "Placeholder_24")
        textField2.labelText = "Label"
        textField2.assistiveText = "Validates text on end of editing"
        textField2.onDidEndEditing = validateText

        let textField3 = FluentTextField()
        textField3.placeholder = "Hint text"
        textField3.leadingImage = UIImage(named: "Placeholder_24")
        textField3.labelText = "Label"
        textField3.assistiveText = "Validates on press of return key"
        textField3.onReturn = onReturn

        let stack = UIStackView(arrangedSubviews: [textField1, textField2, textField3])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            safeArea.topAnchor.constraint(equalTo: stack.topAnchor),
            safeArea.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            safeArea.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
        ])
    }

    func validateText(_ textfield: FluentTextField) -> FluentTextInputError? {
        guard let text = textfield.text else {
            return FluentTextInputError(localizedDescription: "Input text must exist?")
        }
        if text.contains("/") {
            return FluentTextInputError(localizedDescription: "Input text cannot contain the following characters: /")
        }
        return nil
    }

    func onReturn(_ textfield: FluentTextField) -> Bool {
        guard let text = textfield.text else {
            textfield.error = FluentTextInputError(localizedDescription: "Input text must exist?")
            return false
        }
        if text.contains("/") {
            textfield.error = FluentTextInputError(localizedDescription: "Input text cannot contain the following characters: /")
            return false
        }
        textfield.error = nil
        return true
    }
}