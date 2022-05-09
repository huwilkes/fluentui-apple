//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

@objc public protocol MSFButtonsDividerState {
    var overrideTokens: ButtonsDividerTokens? { get set }
}

class MSFButtonsDividerStateImpl: NSObject, ObservableObject, ControlConfiguration, MSFButtonsDividerState {
    @Published var overrideTokens: ButtonsDividerTokens?
}

open class ButtonsDividerTokens: ControlTokens {
    var leadingButtonTokens: ButtonTokens = .init()
    var trailingButtonTokens: ButtonTokens = .init()
    var dividerTokens: DividerTokens = .init()
}

private class CustomLeadingButtonTokens: ButtonTokens {
    var buttonsDividerTokens: ButtonsDividerTokens = .init()
    init(buttonsDividerTokens: ButtonsDividerTokens) {
        self.buttonsDividerTokens = buttonsDividerTokens
        super.init()
    }
    required init() { }

    open override var borderRadius: CGFloat {
        buttonsDividerTokens.leadingButtonTokens.borderRadius
    }

    open override var borderSize: CGFloat {
        buttonsDividerTokens.leadingButtonTokens.borderSize
    }

    open override var iconSize: CGFloat {
        buttonsDividerTokens.leadingButtonTokens.iconSize
    }

    open override var interspace: CGFloat {
        buttonsDividerTokens.leadingButtonTokens.interspace
    }

    open override var horizontalPadding: CGFloat {
        buttonsDividerTokens.leadingButtonTokens.horizontalPadding
    }

    open override var textFont: FontInfo {
        buttonsDividerTokens.leadingButtonTokens.textFont
    }

    open override var textMinimumHeight: CGFloat {
        buttonsDividerTokens.leadingButtonTokens.textMinimumHeight
    }

    open override var textAdditionalHorizontalPadding: CGFloat {
        buttonsDividerTokens.leadingButtonTokens.textAdditionalHorizontalPadding
    }

    open override var textColor: ButtonDynamicColors {
        buttonsDividerTokens.leadingButtonTokens.textColor
    }

    open override var borderColor: ButtonDynamicColors {
        buttonsDividerTokens.leadingButtonTokens.borderColor
    }

    open override var backgroundColor: ButtonDynamicColors {
        buttonsDividerTokens.leadingButtonTokens.backgroundColor
    }

    open override var iconColor: ButtonDynamicColors {
        buttonsDividerTokens.leadingButtonTokens.iconColor
    }

    open override var restShadow: ShadowInfo {
        buttonsDividerTokens.leadingButtonTokens.restShadow
    }

    open override var pressedShadow: ShadowInfo {
        buttonsDividerTokens.leadingButtonTokens.pressedShadow
    }

    open override var minHeight: CGFloat {
        buttonsDividerTokens.leadingButtonTokens.minHeight
    }

    open override var minVerticalPadding: CGFloat {
        buttonsDividerTokens.leadingButtonTokens.minVerticalPadding
    }
}

private class CustomTrailingButtonTokens: ButtonTokens {
    var buttonsDividerTokens: ButtonsDividerTokens = .init()
    init(buttonsDividerTokens: ButtonsDividerTokens) {
        self.buttonsDividerTokens = buttonsDividerTokens
        super.init()
    }
    required init() { }

    open override var borderRadius: CGFloat {
        buttonsDividerTokens.trailingButtonTokens.borderRadius
    }

    open override var borderSize: CGFloat {
        buttonsDividerTokens.trailingButtonTokens.borderSize
    }

    open override var iconSize: CGFloat {
        buttonsDividerTokens.trailingButtonTokens.iconSize
    }

    open override var interspace: CGFloat {
        buttonsDividerTokens.trailingButtonTokens.interspace
    }

    open override var horizontalPadding: CGFloat {
        buttonsDividerTokens.trailingButtonTokens.horizontalPadding
    }

    open override var textFont: FontInfo {
        buttonsDividerTokens.trailingButtonTokens.textFont
    }

    open override var textMinimumHeight: CGFloat {
        buttonsDividerTokens.trailingButtonTokens.textMinimumHeight
    }

    open override var textAdditionalHorizontalPadding: CGFloat {
        buttonsDividerTokens.trailingButtonTokens.textAdditionalHorizontalPadding
    }

    open override var textColor: ButtonDynamicColors {
        buttonsDividerTokens.trailingButtonTokens.textColor
    }

    open override var borderColor: ButtonDynamicColors {
        buttonsDividerTokens.trailingButtonTokens.borderColor
    }

    open override var backgroundColor: ButtonDynamicColors {
        buttonsDividerTokens.trailingButtonTokens.backgroundColor
    }

    open override var iconColor: ButtonDynamicColors {
        buttonsDividerTokens.trailingButtonTokens.iconColor
    }

    open override var restShadow: ShadowInfo {
        buttonsDividerTokens.trailingButtonTokens.restShadow
    }

    open override var pressedShadow: ShadowInfo {
        buttonsDividerTokens.trailingButtonTokens.pressedShadow
    }

    open override var minHeight: CGFloat {
        buttonsDividerTokens.trailingButtonTokens.minHeight
    }

    open override var minVerticalPadding: CGFloat {
        buttonsDividerTokens.trailingButtonTokens.minVerticalPadding
    }
}

private class CustomDividerTokens: DividerTokens {
    var buttonsDividerTokens: ButtonsDividerTokens = .init()
    public init (buttonsDividerTokens: ButtonsDividerTokens) {
        self.buttonsDividerTokens = buttonsDividerTokens
    }
    required init() { }

    open override var color: DynamicColor {
        buttonsDividerTokens.dividerTokens.color
    }

    open override var padding: CGFloat {
        buttonsDividerTokens.dividerTokens.padding
    }
}

public struct ButtonsDivider: View, ConfigurableTokenizedControl {
    public init() {
        self.state = MSFButtonsDividerStateImpl()
    }

    public var body: some View {
        let leadingButtonStyle: MSFButtonStyle = .primary
        let leadingButtonSize: MSFButtonSize = .large
        let trailingButtonStyle: MSFButtonStyle = .secondary
        let trailingButtonSize: MSFButtonSize = .small
        @ViewBuilder
        var leadingButton: FluentButton {
            FluentButton(style: leadingButtonStyle, size: leadingButtonSize, text: "Primary", action: {})
        }
        /**
         In order to get theme override tokens, we need an actual instance of
         the control. So if we ask the control for its resolved tokens, we'll
         get the theme or default tokens - assuming there's no override. This
         isn't an issue if we aren't initializing the control from a state,
         but if we did (like with the AvatarGroup's Avatars) then we could end
         up just recursively feeding the control its own tokens.
         */
//        let leadingButtonTokens = leadingButton.resolvedTokens
//        leadingButtonTokens.style = leadingButtonStyle
//        leadingButtonTokens.size = leadingButtonSize
//        tokens.leadingButtonTokens = leadingButtonTokens

        /**
         This approach skips around the override issue, but instead leads to
         a bunch of copied code for setting the theme and other properties of
         the control's tokens.
         */
        let leadingButtonTokens = fluentTheme.tokens(for: leadingButton) ?? .init()
        leadingButtonTokens.fluentTheme = fluentTheme
        leadingButtonTokens.style = leadingButtonStyle
        leadingButtonTokens.size = leadingButtonSize
        tokens.leadingButtonTokens = leadingButtonTokens

        /**
         Probably the best option - Uses the button to properly configure the
         tokens while not risking a long recursive list of override tokens
         */
//        leadingButton.state.overrideTokens = nil
//        tokens.leadingButtonTokens = leadingButton.tokens

        @ViewBuilder
        var divider: FluentDivider {
            FluentDivider(orientation: .vertical, spacing: .medium)
        }
//        divider.state.overrideTokens = nil
//        tokens.dividerTokens = divider.tokens
        let dividerTokens = fluentTheme.tokens(for: divider) ?? .init()
        dividerTokens.fluentTheme = fluentTheme
        dividerTokens.spacing = .medium
        tokens.dividerTokens = dividerTokens

        @ViewBuilder
        var trailingButton: FluentButton {
            FluentButton(style: leadingButtonStyle, size: leadingButtonSize, text: "Secondary", action: {})
        }
//        trailingButton.state.overrideTokens = nil
//        let trailingButtonTokens = trailingButton.tokens
//        trailingButtonTokens.style = trailingButtonStyle
//        trailingButtonTokens.size = trailingButtonSize
//        tokens.trailingButtonTokens = trailingButtonTokens
        let trailingButtonTokens = fluentTheme.tokens(for: trailingButton) ?? .init()
        trailingButtonTokens.fluentTheme = fluentTheme
        trailingButtonTokens.style = trailingButtonStyle
        trailingButtonTokens.size = trailingButtonSize
        tokens.trailingButtonTokens = trailingButtonTokens

        return HStack (spacing: 0) {
            leadingButton
                .overrideTokens(CustomLeadingButtonTokens(buttonsDividerTokens: tokens))
                .fixedSize()
            divider
                .overrideTokens(CustomDividerTokens(buttonsDividerTokens: tokens))
            trailingButton
                .overrideTokens(CustomTrailingButtonTokens(buttonsDividerTokens: tokens))
                .fixedSize()
        }
    }

    let defaultTokens: ButtonsDividerTokens = .init()
    var tokens: ButtonsDividerTokens {
        return resolvedTokens
    }
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var state: MSFButtonsDividerStateImpl
}

public extension ButtonsDivider {
    func overrideTokens(_ tokens: ButtonsDividerTokens?) -> ButtonsDivider {
        state.overrideTokens = tokens
        return self
    }
}

@objc open class MSFButtonsDivider: ControlHostingView {
    @objc public init() {
        let buttonsDivider = ButtonsDivider()
        state = buttonsDivider.state
        super.init(AnyView(buttonsDivider))
    }

    required public init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @objc public let state: MSFButtonsDividerState
}
