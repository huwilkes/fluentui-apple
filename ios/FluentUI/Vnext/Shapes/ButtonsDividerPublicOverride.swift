//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

@objc public protocol MSFButtonsDividerPublicOverrideState {
    var overrideTokens: ButtonsDividerPublicOverrideTokens? { get set }
    var leadingButtonOverrideTokens: ButtonTokens? { get set }
    var dividerOverrideTokens: DividerTokens? { get set }
    var trailingButtonOverrideTokens: ButtonTokens? { get set }
}

class MSFButtonsDividerPublicOverrideStateImpl: NSObject, ObservableObject, ControlConfiguration, MSFButtonsDividerPublicOverrideState {
    @Published var overrideTokens: ButtonsDividerPublicOverrideTokens?
    @Published var leadingButtonOverrideTokens: ButtonTokens?
    @Published var dividerOverrideTokens: DividerTokens?
    @Published var trailingButtonOverrideTokens: ButtonTokens?
}

open class ButtonsDividerPublicOverrideTokens: ControlTokens {
}

public struct ButtonsDividerPublicOverride: View, ConfigurableTokenizedControl {
    public init() {
        self.state = MSFButtonsDividerPublicOverrideStateImpl()
    }

    public var body: some View {
        let leadingButtonStyle: MSFButtonStyle = .primary
        let leadingButtonSize: MSFButtonSize = .large
        let trailingButtonStyle: MSFButtonStyle = .secondary
        let trailingButtonSize: MSFButtonSize = .small

        return HStack (spacing: 0) {
            FluentButton(style: leadingButtonStyle, size: leadingButtonSize, text: "Primary", action: {})
                .overrideTokens(state.leadingButtonOverrideTokens)
                .fixedSize()
            FluentDivider(orientation: .vertical, spacing: .medium)
                .overrideTokens(state.dividerOverrideTokens)
            FluentButton(style: trailingButtonStyle, size: trailingButtonSize, text: "Secondary", action: {})
                .overrideTokens(state.trailingButtonOverrideTokens)
                .fixedSize()
        }
    }

    let defaultTokens: ButtonsDividerPublicOverrideTokens = .init()
    var tokens: ButtonsDividerPublicOverrideTokens {
        return resolvedTokens
    }
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var state: MSFButtonsDividerPublicOverrideStateImpl
}

public extension ButtonsDividerPublicOverride {
    func overrideTokens(_ tokens: ButtonsDividerPublicOverrideTokens?) -> ButtonsDividerPublicOverride {
        state.overrideTokens = tokens
        return self
    }
}

@objc open class MSFButtonsDividerPublicOverride: ControlHostingView {
    @objc public init() {
        let buttonsDivider = ButtonsDividerPublicOverride()
        state = buttonsDivider.state
        super.init(AnyView(buttonsDivider))
    }

    required public init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @objc public let state: MSFButtonsDividerPublicOverrideState
}
