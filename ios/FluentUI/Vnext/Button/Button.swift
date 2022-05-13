//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import UIKit

/// Properties that can be used to customize the appearance of the Button.
@objc public protocol MSFButtonState {

    /// The string representing the accessibility label of the button.
    var accessibilityLabel: String? { get set }

    /// Defines the icon image of the button.
    var image: UIImage? { get set }

    /// Controls whether the button is available for user interaction, renders the control accordingly.
    var isDisabled: Bool { get set }

    /// Text used as the label of the button.
    var text: String? { get set }

    /// Defines the size of the button.
    var size: MSFButtonSize { get set }

    /// Defines the style of the button.
    var style: MSFButtonStyle { get set }

    /// Custom design token set for this control, to use in place of the control's default Fluent tokens.
    var overrideTokens: ButtonTokens? { get set }

    var customTokens: CustomButtonTokens { get set }
}

/// View that represents the button.
public struct FluentButton: View, ConfigurableTokenizedControl {
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var state: MSFButtonStateImpl
    let defaultTokens: ButtonTokens = .init()
    var tokens: ButtonTokens {
        let tokens = resolvedTokens
        tokens.size = state.size
        tokens.style = state.style
        return tokens
    }

    /// Creates a FluentButton.
    /// - Parameters:
    ///   - style: The MSFButtonStyle used by the button.
    ///   - size: The MSFButtonSize value used by the button.
    ///   - image: The image used as the leading icon of the button.
    ///   - text: The text used in the button label.
    ///   - action: Closure that handles the button tap event.
    public init(style: MSFButtonStyle,
                size: MSFButtonSize,
                image: UIImage? = nil,
                text: String? = nil,
                action: @escaping () -> Void) {
        let state = MSFButtonStateImpl(style: style,
                                       size: size,
                                       action: action)
        state.text = text
        state.image = image
        self.state = state
    }

    public var body: some View {
        Button(action: state.action, label: {})
            .buttonStyle(FluentButtonStyle(state: state,
                                           tokensLookup: { tokens }))
            .disabled(state.disabled ?? false)
            .frame(maxWidth: .infinity)
    }
}

class MSFButtonStateImpl: NSObject, ObservableObject, ControlConfiguration, MSFButtonState {
    var action: () -> Void
    @Published var image: UIImage?
    @Published var disabled: Bool?
    @Published var isFocused: Bool = false
    @Published var text: String?
    @Published var size: MSFButtonSize
    @Published var style: MSFButtonStyle
    @Published var customTokens: CustomButtonTokens = .init()

    @Published var overrideTokens: ButtonTokens?

    var isDisabled: Bool {
        get {
            return disabled ?? false
        }
        set {
            disabled = newValue
        }
    }

    init(style: MSFButtonStyle,
         size: MSFButtonSize,
         action: @escaping () -> Void) {
        self.size = size
        self.style = style
        self.action = action

        super.init()
    }
}

/// Body of the button adjusted for pressed or rest state
struct FluentButtonBody: View {
    @Environment(\.isEnabled) var isEnabled: Bool
    @ObservedObject var state: MSFButtonStateImpl
    var tokens: ButtonTokens { tokensLookup() }
    let tokensLookup: (() -> ButtonTokens)
    let isPressed: Bool

    var body: some View {
        let isDisabled = !isEnabled
        let isFocused = state.isFocused
        let customTokens = state.customTokens
        let isFloatingStyle = tokens.style.isFloatingStyle
        let shouldUsePressedShadow = isDisabled || isPressed
        let verticalPadding = customTokens.minVerticalPadding ?? tokens.minVerticalPadding
        let horizontalPadding = customTokens.horizontalPadding ?? tokens.horizontalPadding
        let iconColors = customTokens.iconColor ?? tokens.iconColor
        let textColors = customTokens.textColor ?? tokens.textColor
        let borderColors = customTokens.borderColor ?? tokens.borderColor
        let backgroundColors = customTokens.backgroundColor ?? tokens.backgroundColor
        let iconColor: DynamicColor
        let textColor: DynamicColor
        let borderColor: DynamicColor
        let backgroundColor: DynamicColor
        if isDisabled {
            iconColor = iconColors.disabled
            textColor = textColors.disabled
            borderColor = borderColors.disabled
            backgroundColor = backgroundColors.disabled
        } else if isPressed || isFocused {
            iconColor = iconColors.pressed
            textColor = textColors.pressed
            borderColor = borderColors.pressed
            backgroundColor = backgroundColors.pressed
        } else {
            iconColor = iconColors.rest
            textColor = textColors.rest
            borderColor = borderColors.rest
            backgroundColor = backgroundColors.rest
        }

        @ViewBuilder
        var buttonContent: some View {
            let iconSize = customTokens.iconSize ?? tokens.iconSize
            HStack(spacing: customTokens.interspace ?? tokens.interspace) {
                if let image = state.image {
                    Image(uiImage: image)
                        .resizable()
                        .foregroundColor(Color(dynamicColor: iconColor))
                        .frame(width: iconSize, height: iconSize, alignment: .center)
                }
                if let text = state.text {
                    Text(text)
                        .multilineTextAlignment(.center)
                        .font(.fluent(customTokens.textFont ?? tokens.textFont, shouldScale: !isFloatingStyle))
                        .modifyIf(isFloatingStyle, { view in
                            view.frame(minHeight: customTokens.textMinimumHeight ?? tokens.textMinimumHeight)
                        })
                }
            }
            .padding(EdgeInsets(top: verticalPadding,
                                leading: horizontalPadding,
                                bottom: verticalPadding,
                                trailing: horizontalPadding))
            .modifyIf(isFloatingStyle && !(state.text?.isEmpty ?? true), { view in
                view.padding(.horizontal, customTokens.textAdditionalHorizontalPadding ?? tokens.textAdditionalHorizontalPadding )
            })
            .frame(maxWidth: .infinity, minHeight: customTokens.minHeight ?? tokens.minHeight, maxHeight: .infinity)
            .foregroundColor(Color(dynamicColor: textColor))
        }

        @ViewBuilder
        var buttonBackground: some View {
            let borderSize = customTokens.borderSize ?? tokens.borderSize
            if borderSize > 0 {
                buttonContent.background(
                    RoundedRectangle(cornerRadius: customTokens.borderRadius ?? tokens.borderRadius)
                        .strokeBorder(lineWidth: borderSize, antialiased: false)
                        .foregroundColor(Color(dynamicColor: borderColor))
                        .contentShape(Rectangle()))
            } else {
                buttonContent.background(
                    RoundedRectangle(cornerRadius: customTokens.borderRadius ?? tokens.borderRadius)
                        .fill(Color(dynamicColor: backgroundColor)))
            }
        }

        let shadowInfo = shouldUsePressedShadow ? customTokens.pressedShadow ?? tokens.pressedShadow : customTokens.restShadow ?? tokens.restShadow

        @ViewBuilder
        var button: some View {
            if isFloatingStyle {
                buttonBackground
                    .clipShape(Capsule())
                    .shadow(color: Color(dynamicColor: shadowInfo.colorOne),
                            radius: shadowInfo.blurOne,
                            x: shadowInfo.xOne,
                            y: shadowInfo.yOne)
                    .shadow(color: Color(dynamicColor: shadowInfo.colorTwo),
                            radius: shadowInfo.blurTwo,
                            x: shadowInfo.xTwo,
                            y: shadowInfo.yTwo)
                    .contentShape(Capsule())
            } else {
                buttonBackground
                    .contentShape(RoundedRectangle(cornerRadius: customTokens.borderRadius ?? tokens.borderRadius))
            }
        }

        return button
            .pointerInteraction(isEnabled)
    }
}

/// ButtonStyle which configures the Button View according to its state and design tokens.
struct FluentButtonStyle: ButtonStyle {
    @ObservedObject var state: MSFButtonStateImpl
    let tokensLookup: () -> ButtonTokens

    func makeBody(configuration: Self.Configuration) -> some View {
        FluentButtonBody(state: state,
                         tokensLookup: tokensLookup,
                         isPressed: configuration.isPressed)
    }
}
