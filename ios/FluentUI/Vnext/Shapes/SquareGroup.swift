//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

public protocol MSFSquareGroupSquareState {
    var overrideTokens: SquareGroupTokens? { get set }
    var hasBorder: Bool { get set }
    var hasRoundedCorners: Bool { get set }
}

class MSFSquareGroupSquareStateImpl: NSObject, ObservableObject, ControlConfiguration, MSFSquareGroupSquareState {
    @Published var overrideTokens: SquareGroupTokens?
    @Published var hasBorder: Bool
    @Published var hasRoundedCorners: Bool

    public init(hasBorder: Bool,
                hasRoundedCorners: Bool) {
        self.hasBorder = hasBorder
        self.hasRoundedCorners = hasRoundedCorners
        super.init()
    }
}

public struct FluentSquareGroupSquare: View {
    public init(hasBorder: Bool = false, hasRoundedCorners: Bool = false, groupTokens: SquareGroupTokens) {
        let state = MSFRectangleStateImpl(hasBorder: hasBorder,
                                          hasRoundedCorners: hasRoundedCorners)
        self.state = state
        self.tokens = groupTokens
    }

    public var body: some View {
        let side = tokens.squareSide
        let cornerRadius = state.hasRoundedCorners ? tokens.squareCornerRadius : 0.0
        return RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color(dynamicColor: tokens.squareBackgroundColor))
            .frame(width: side,
                   height: side)
            .modifyIf(state.hasBorder) { square in
                square.overlay(RoundedRectangle(cornerRadius: cornerRadius)
                                    .strokeBorder(lineWidth: tokens.squareBorderSize, antialiased: true)
                                    .foregroundColor(Color(dynamicColor: tokens.squareBorderColor))
                                    .frame(width: side,
                                           height: side))
            }
    }

    var tokens: SquareGroupTokens
    @ObservedObject var state: MSFRectangleStateImpl
}

public protocol MSFSquareGroupState {
    var overrideTokens: SquareGroupTokens? { get set }
    var squaresHaveBorders: Bool { get set }
    var squaresHaveRoundedCorners: Bool { get set }
    var rows: Int { get set }
    var cols: Int { get set }
}

class MSFSquareGroupStateImpl: NSObject, ObservableObject, ControlConfiguration, MSFSquareGroupState {
    @Published var overrideTokens: SquareGroupTokens?
    @Published var squaresHaveBorders: Bool
    @Published var squaresHaveRoundedCorners: Bool
    @Published var rows: Int
    @Published var cols: Int

    public init(squaresHaveBorders: Bool,
                squaresHaveRoundedCorners: Bool,
                rows: Int,
                cols: Int) {
        self.squaresHaveBorders = squaresHaveBorders
        self.squaresHaveRoundedCorners = squaresHaveRoundedCorners
        self.rows = rows
        self.cols = cols

        super.init()
    }
}

open class SquareGroupTokens: ControlTokens {
    open var backgroundColor: DynamicColor {
        aliasTokens.backgroundColors[.neutral5]
    }

    open var squareBackgroundColor: DynamicColor {
        aliasTokens.foregroundColors[.brandRest]
    }

    open var squareBorderColor: DynamicColor {
        aliasTokens.foregroundColors[.neutral1]
    }

    open var squareSide: CGFloat {
        globalTokens.iconSize[.large]
    }

    open var squareCornerRadius: CGFloat {
        globalTokens.borderRadius[.medium]
    }

    open var squareBorderSize: CGFloat {
        globalTokens.borderSize[.thick]
    }
}

public struct FluentSquareGroup: View, ConfigurableTokenizedControl {
    public init(squaresHaveBorders: Bool = false,
                squaresHaveRoundedCorners: Bool = false,
                rows: Int = 1,
                cols: Int = 1) {
        let rows = rows >= 1 ? rows : 1
        let cols = cols >= 1 ? cols : 1
        let state = MSFSquareGroupStateImpl(squaresHaveBorders: squaresHaveBorders,
                                            squaresHaveRoundedCorners: squaresHaveRoundedCorners,
                                            rows: rows,
                                            cols: cols)
        self.state = state
    }

    public var body: some View {
        VStack {
            ForEach( 1...state.rows, id: \.self) {_ in
                HStack {
                    ForEach(1...state.cols, id: \.self) {_ in
                        FluentSquareGroupSquare(hasBorder: state.squaresHaveBorders,
                                                hasRoundedCorners: state.squaresHaveRoundedCorners,
                                                groupTokens: tokens)
                    }
                }
            }
        }
        .padding()
        .background(Rectangle().fill(Color(dynamicColor: tokens.backgroundColor)))
    }

    let defaultTokens: SquareGroupTokens = .init()
    var tokens: SquareGroupTokens {
        return resolvedTokens
    }
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var state: MSFSquareGroupStateImpl
}

public extension FluentSquareGroup {
    func overrideTokens(_ tokens: SquareGroupTokens?) -> FluentSquareGroup {
        state.overrideTokens = tokens
        return self
    }
}
