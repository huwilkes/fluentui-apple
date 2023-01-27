//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import Combine

@objc(MSFTextField)
public class FluentTextField: UIView, UITextFieldDelegate, TokenizedControlInternal {
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        tokenSet.update(fluentTheme)
        updateTokenizedValues()
    }

    public typealias TokenSetKeyType = TextFieldTokenSet.Tokens
    lazy public var tokenSet: TextFieldTokenSet = .init(state: { [weak self] in
        return self?.state ?? .placeholder
    })

    public var leadingImage: UIImage? {
        didSet {
            if let image = leadingImage {
                leadingImageView.image = image
                leadingImageView.isHidden = false
            } else {
                leadingImageView.isHidden = true
            }
        }
    }
    public var labelText: String? {
        didSet {
            if let text = labelText {
                label.text = text
                label.isHidden = false
            } else {
                label.isHidden = true
            }
        }
    }
    public var placeholder: String? {
        didSet {
            textfield.placeholder = placeholder
        }
    }
    public var assistiveText: String? {
        didSet {
            if let text = assistiveText {
                assistiveTextLabel.text = text
                assistiveTextLabel.isHidden = false
            } else {
                assistiveTextLabel.isHidden = true
            }
        }
    }

    public init() {
        super.init(frame: .zero)

        let textStack = UIStackView(arrangedSubviews: [label, textfield, separator, assistiveTextLabel])
        textStack.axis = .vertical
        textStack.alignment = .leading
        textStack.spacing = TextFieldTokenSet.labelInputTextSpacing()
        textStack.setCustomSpacing(4, after: separator)
        textStack.layoutMargins = UIEdgeInsets(top: TextFieldTokenSet.topPadding(),
                                               left: 0,
                                               bottom: TextFieldTokenSet.bottomPadding(),
                                               right: 0)
        textStack.isLayoutMarginsRelativeArrangement = true

        let imageTextStack = UIStackView(arrangedSubviews: [leadingImageView, textStack])
        imageTextStack.axis = .horizontal
        imageTextStack.spacing = TextFieldTokenSet.leadingIconInputTextSpacing()
        imageTextStack.distribution = .fill
        imageTextStack.translatesAutoresizingMaskIntoConstraints = false
        imageTextStack.alignment = .center

        let leftInset: CGFloat
        let rightInset: CGFloat
        if effectiveUserInterfaceLayoutDirection == .leftToRight {
            leftInset = TextFieldTokenSet.horizontalPadding()
            rightInset = 0
        } else {
            leftInset = 0
            rightInset = TextFieldTokenSet.horizontalPadding()
        }
        imageTextStack.layoutMargins = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
        imageTextStack.isLayoutMarginsRelativeArrangement = true

        addSubview(imageTextStack)

        let safeArea = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            separator.widthAnchor.constraint(equalTo: textStack.widthAnchor),
            textfield.leadingAnchor.constraint(equalTo: textStack.leadingAnchor),
            textfield.trailingAnchor.constraint(equalTo: textStack.trailingAnchor),
            imageTextStack.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            imageTextStack.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            imageTextStack.topAnchor.constraint(equalTo: safeArea.topAnchor),
            imageTextStack.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeDidChange),
                                               name: .didChangeTheme,
                                               object: nil)
        updateTokenizedValues()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let leadingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        imageView.isHidden = true
        return imageView
    }()

    let label: UILabel = {
        let label = UILabel()
        label.isHidden = true
        return label
    }()

    let textfield: FluentTextFieldInternal = {
        let field = FluentTextFieldInternal()
        field.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return field
    }()

    let separator: Separator = {
        let separator = Separator(style: .default, orientation: .horizontal)
        return separator
    }()

    let assistiveTextLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    @objc private func themeDidChange(_ notification: Notification) {
        guard let themeView = notification.object as? UIView, self.isDescendant(of: themeView) else {
            return
        }
        tokenSet.update(fluentTheme)
        updateTokenizedValues()
    }

    private func updateTokenizedValues() {
        leadingImageView.tintColor = UIColor(dynamicColor: tokenSet[.leadingIconColor].dynamicColor)

        label.font = UIFont.fluent(tokenSet[.labelFont].fontInfo)
        label.textColor = UIColor(dynamicColor: tokenSet[.labelColor].dynamicColor)
        assistiveTextLabel.font = UIFont.fluent(tokenSet[.assistiveTextFont].fontInfo)
        assistiveTextLabel.textColor = UIColor(dynamicColor: tokenSet[.assistiveTextColor].dynamicColor)

        separator.backgroundColor = UIColor(dynamicColor: tokenSet[.strokeColor].dynamicColor)

        textfield.font = UIFont.fluent(tokenSet[.inputTextFont].fontInfo)
        textfield.tintColor = UIColor(dynamicColor: tokenSet[.cursorColor].dynamicColor)
        textfield.textColor = UIColor(dynamicColor: tokenSet[.inputTextColor].dynamicColor)
        let buttonColor = tokenSet[.trailingIconColor]
        textfield.clearButton.tokenSet[.foregroundColor] = buttonColor
    }

    private var state: FluentTextFieldState = .placeholder {
        didSet {
            updateTokenizedValues()
        }
    }
    private var tokenSetSink: AnyCancellable?
}

class FluentTextFieldInternal: UITextField {
    init() {
        super.init(frame: .zero)

        clearButton.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        rightView = clearButton

        rightViewMode = .whileEditing
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let origin = super.rightViewRect(forBounds: bounds).origin
        return CGRect(x: origin.x - trailingViewSpacing, y: origin.y, width: trailingViewSize, height: trailingViewSize)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        let origin = rect.origin
        let size = rect.size
        return CGRect(x: origin.x, y: origin.y, width: size.width - (trailingViewSpacing + inputTextTrailingIconSpacing), height: size.height)
    }

    let trailingViewSpacing: CGFloat = TextFieldTokenSet.horizontalPadding()
    let inputTextTrailingIconSpacing: CGFloat = TextFieldTokenSet.inputTextTrailingIconSpacing()
    let trailingViewSize: CGFloat = TextFieldTokenSet.iconSize()
    var clearButton: Button = {
        let button = Button(style: .borderless)
        // TODO: get the right image
        button.image = UIImage(named: "Dismiss_24")
        button.edgeInsets = .zero
        return button
    }()

    @objc private func clearText() {
        text = nil
    }
}

// TODO: Better, less confusing name. Since this is nothing like the other state objects
public enum FluentTextFieldState: Int, CaseIterable {
    case placeholder
    case focused
    case typing
    case error
    case filled
}

public class TextFieldTokenSet: ControlTokenSet<TextFieldTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        case assistiveTextColor
        case assistiveTextFont
        case backgroundColor
        case cursorColor
        case inputTextColor
        case inputTextFont
        case labelColor
        case labelFont
        case leadingIconColor
        case strokeColor
        case trailingIconColor
    }

    init(state: @escaping () -> FluentTextFieldState) {
        self.state = state
        super.init { [state] token, theme in
            switch token {
            case .assistiveTextColor:
                return .dynamicColor {
                    switch state() {
                    case .placeholder, .focused, .typing, .filled:
                        return theme.aliasTokens.foregroundColors[.neutral2]
                    case .error:
                        // dangerTint20
                        return DynamicColor(light: ColorValue(0xE87979),
                                            dark: ColorValue(0x8B2323))
                    }
                }
            case .assistiveTextFont:
                return .fontInfo { theme.aliasTokens.typography[.caption2] }
            case .backgroundColor:
                return .dynamicColor { theme.aliasTokens.backgroundColors[.neutral1] }
            case .cursorColor:
                return .dynamicColor { theme.aliasTokens.foregroundColors[.neutral3] }
            case .inputTextColor:
                return .dynamicColor { theme.aliasTokens.foregroundColors[.neutral1] }
            case .inputTextFont:
                return .fontInfo { theme.aliasTokens.typography[.body1] }
            case .labelColor:
                return .dynamicColor {
                    switch state() {
                    case .placeholder, .filled:
                        return theme.aliasTokens.foregroundColors[.neutral2]
                    case .focused, .typing:
                        return theme.aliasTokens.brandColors[.primary]
                    case .error:
                        // dangerTint20
                        return DynamicColor(light: ColorValue(0xE87979),
                                            dark: ColorValue(0x8B2323))
                    }
                }
            case .labelFont:
                return .fontInfo { theme.aliasTokens.typography[.caption2] }
            case .leadingIconColor:
                return .dynamicColor {
                    switch state() {
                    case .placeholder, .filled, .error:
                        return theme.aliasTokens.foregroundColors[.neutral2]
                    case .focused, .typing:
                        return theme.aliasTokens.brandColors[.primary]
                    }
                }
            case .strokeColor:
                return .dynamicColor {
                    switch state() {
                    case .placeholder, .filled:
                        return theme.aliasTokens.strokeColors[.neutral1]
                    case .focused, .typing:
                        return theme.aliasTokens.brandColors[.primary]
                    case .error:
                        // dangerTint20
                        return DynamicColor(light: ColorValue(0xE87979),
                                            dark: ColorValue(0x8B2323))
                    }
                }
            case .trailingIconColor:
                return .dynamicColor { theme.aliasTokens.foregroundColors[.neutral2] }
            }
        }
    }

    var state: () -> FluentTextFieldState
}

extension TextFieldTokenSet {
    static func iconSize() -> CGFloat {
        return GlobalTokens.iconSize(.medium)
    }

    static func horizontalPadding() -> CGFloat {
        return GlobalTokens.spacing(.medium)
    }

    static func topPadding() -> CGFloat {
        return GlobalTokens.spacing(.small)
    }

    static func bottomPadding() -> CGFloat {
        return GlobalTokens.spacing(.xxSmall)
    }

    static func labelInputTextSpacing() -> CGFloat {
        return GlobalTokens.spacing(.small)
    }

    static func leadingIconInputTextSpacing() -> CGFloat {
        return GlobalTokens.spacing(.medium)
    }

    static func inputTextTrailingIconSpacing() -> CGFloat {
        return GlobalTokens.spacing(.xSmall)
    }

    static func inputTextStrokeSpacing() -> CGFloat {
        return GlobalTokens.spacing(.small)
    }

    static func strokeAssistiveTextSpacing() -> CGFloat {
        return GlobalTokens.spacing(.xxSmall)
    }
}
