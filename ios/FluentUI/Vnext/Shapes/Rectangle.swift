//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

public protocol MSFRectangleState {
    var overrideTokens: RectangleTokens? { get set }
    var hasBorder: Bool { get set }
    var hasRoundedCorners: Bool { get set }
}

class MSFRectangleStateImpl: NSObject, ObservableObject, ControlConfiguration, MSFRectangleState {
    @Published var overrideTokens: RectangleTokens?
    @Published var hasBorder: Bool
    @Published var hasRoundedCorners: Bool

    public init(hasBorder: Bool,
                hasRoundedCorners: Bool) {
        self.hasBorder = hasBorder
        self.hasRoundedCorners = hasRoundedCorners
        super.init()
    }
}

open class RectangleTokens: ControlTokens {
    open var backgroundColor: DynamicColor {
        aliasTokens.backgroundColors[.brandRest]
    }

    open var borderColor: DynamicColor {
        aliasTokens.foregroundColors[.neutral1]
    }

    open var width: CGFloat {
        globalTokens.iconSize[.xxLarge]
    }

    open var height: CGFloat {
        globalTokens.iconSize[.medium]
    }

    open var borderThickness: CGFloat {
        globalTokens.borderSize[.thick]
    }

    open var cornerRadius: CGFloat {
        globalTokens.borderRadius[.medium]
    }
}

public struct FluentRectangle: View, ConfigurableTokenizedControl {
    public init(hasBorder: Bool = false, hasRoundedCorners: Bool = false) {
        let state = MSFRectangleStateImpl(hasBorder: hasBorder,
                                          hasRoundedCorners: hasRoundedCorners)
        self.state = state
    }

    public var body: some View {
        let width = tokens.width
        let height = tokens.height
        let cornerRadius = state.hasRoundedCorners ? tokens.cornerRadius : 0.0
        return RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color(dynamicColor: tokens.backgroundColor))
            .frame(width: width,
                   height: height)
            .modifyIf(state.hasBorder) { rectangle in
                rectangle.overlay(RoundedRectangle(cornerRadius: cornerRadius)
                                    .strokeBorder(lineWidth: tokens.borderThickness, antialiased: true)
                                    .foregroundColor(Color(dynamicColor: tokens.borderColor))
                                    .frame(width: width,
                                           height: height))
            }
    }

    let defaultTokens: RectangleTokens = .init()
    var tokens: RectangleTokens {
        return resolvedTokens
    }
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var state: MSFRectangleStateImpl
}

public extension FluentRectangle {
    func overrideTokens(_ tokens: RectangleTokens?) -> FluentRectangle {
        state.overrideTokens = tokens
        return self
    }
}
