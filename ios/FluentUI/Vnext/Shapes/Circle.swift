//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

public protocol MSFCircleState {
    var overrideTokens: CircleTokens? { get set }
    var hasBorder: Bool { get set }
}

class MSFCircleStateImpl: NSObject, ObservableObject, ControlConfiguration, MSFCircleState {
    @Published var overrideTokens: CircleTokens?
    var hasBorder: Bool
    init(hasBorder: Bool) {
        self.hasBorder = hasBorder
        super.init()
    }
}

open class CircleTokens: ControlTokens {
    open var backgroundColor: DynamicColor {
        aliasTokens.backgroundColors[.brandRest]
    }

    open var borderColor: DynamicColor {
        aliasTokens.foregroundColors[.neutral1]
    }

    open var diameter: CGFloat {
        globalTokens.iconSize[.xxLarge]
    }

    open var borderThickness: CGFloat {
        globalTokens.borderSize[.thick]
    }
}

public struct FluentCircle: View, ConfigurableTokenizedControl {
    public init(hasBorder: Bool = false) {
        let state = MSFCircleStateImpl(hasBorder: hasBorder)
        self.state = state
    }

    public var body: some View {
        let diameter = tokens.diameter
        return Circle()
            .fill(Color(dynamicColor: tokens.backgroundColor))
            .frame(width: diameter,
                   height: diameter)
            .modifyIf(state.hasBorder) { circle in
                circle.overlay(Circle()
                                    .strokeBorder(lineWidth: tokens.borderThickness, antialiased: true)
                                    .foregroundColor(Color(dynamicColor: tokens.borderColor))
                                    .frame(width: diameter,
                                           height: diameter))
            }
    }

    let defaultTokens: CircleTokens = .init()
    var tokens: CircleTokens {
        return resolvedTokens
    }
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var state: MSFCircleStateImpl
}

public extension FluentCircle {
    func overrideTokens(_ tokens: CircleTokens?) -> FluentCircle {
        state.overrideTokens = tokens
        return self
    }
}
