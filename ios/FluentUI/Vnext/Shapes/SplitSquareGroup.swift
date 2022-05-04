//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

public protocol MSFSplitSquareGroupSquareState {
    var overrideTokens: SplitSquareGroupTokens? { get set }
    var hasBorder: Bool { get set }
    var hasRoundedCorners: Bool { get set }
}

class MSFSplitSquareGroupSquareStateImpl: NSObject, ObservableObject, ControlConfiguration, MSFSplitSquareGroupSquareState {
    @Published var overrideTokens: SplitSquareGroupTokens?
    @Published var hasBorder: Bool
    @Published var hasRoundedCorners: Bool

    public init(hasBorder: Bool,
                hasRoundedCorners: Bool) {
        self.hasBorder = hasBorder
        self.hasRoundedCorners = hasRoundedCorners
        super.init()
    }
}

public struct FluentSplitSquareGroupTopSquare: View {
    public init(hasBorder: Bool = false, hasRoundedCorners: Bool = false, groupTokens: SplitSquareGroupTokens) {
        let state = MSFRectangleStateImpl(hasBorder: hasBorder,
                                          hasRoundedCorners: hasRoundedCorners)
        self.state = state
        self.tokens = groupTokens
    }

    public var body: some View {
        let side = tokens.topSquareSide
        let cornerRadius = state.hasRoundedCorners ? tokens.topSquareCornerRadius : 0.0
        return RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color(dynamicColor: tokens.squareBackgroundColor))
            .frame(width: side,
                   height: side)
            .modifyIf(state.hasBorder) { square in
                square.overlay(RoundedRectangle(cornerRadius: cornerRadius)
                                    .strokeBorder(lineWidth: tokens.topSquareBorderSize, antialiased: true)
                                    .foregroundColor(Color(dynamicColor: tokens.squareBorderColor))
                                    .frame(width: side,
                                           height: side))
            }
    }

    var tokens: SplitSquareGroupTokens
    @ObservedObject var state: MSFRectangleStateImpl
}

public struct FluentSplitSquareGroupBottomSquare: View {
    public init(hasBorder: Bool = false, hasRoundedCorners: Bool = false, groupTokens: SplitSquareGroupTokens) {
        let state = MSFRectangleStateImpl(hasBorder: hasBorder,
                                          hasRoundedCorners: hasRoundedCorners)
        self.state = state
        self.tokens = groupTokens
    }

    public var body: some View {
        let side = tokens.bottomSquareSide
        let cornerRadius = state.hasRoundedCorners ? tokens.bottomSquareCornerRadius : 0.0
        return RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color(dynamicColor: tokens.squareBackgroundColor))
            .frame(width: side,
                   height: side)
            .modifyIf(state.hasBorder) { square in
                square.overlay(RoundedRectangle(cornerRadius: cornerRadius)
                                    .strokeBorder(lineWidth: tokens.bottomSquareBorderSize, antialiased: true)
                                    .foregroundColor(Color(dynamicColor: tokens.squareBorderColor))
                                    .frame(width: side,
                                           height: side))
            }
    }

    var tokens: SplitSquareGroupTokens
    @ObservedObject var state: MSFRectangleStateImpl
}

public protocol MSFSplitSquareGroupState {
    var overrideTokens: SplitSquareGroupTokens? { get set }
    var squaresHaveBorders: Bool { get set }
    var squaresHaveRoundedCorners: Bool { get set }
    var topRows: Int { get set }
    var bottomRows: Int { get set }
    var cols: Int { get set }
}

class MSFSplitSquareGroupStateImpl: NSObject, ObservableObject, ControlConfiguration, MSFSplitSquareGroupState {
    @Published var overrideTokens: SplitSquareGroupTokens?
    @Published var squaresHaveBorders: Bool
    @Published var squaresHaveRoundedCorners: Bool
    @Published var topRows: Int
    @Published var bottomRows: Int
    @Published var cols: Int

    public init(squaresHaveBorders: Bool,
                squaresHaveRoundedCorners: Bool,
                topRows: Int,
                bottomRows: Int,
                cols: Int) {
        self.squaresHaveBorders = squaresHaveBorders
        self.squaresHaveRoundedCorners = squaresHaveRoundedCorners
        self.topRows = topRows
        self.bottomRows = bottomRows
        self.cols = cols

        super.init()
    }
}

open class SplitSquareGroupTokens: ControlTokens {
    open var backgroundColor: DynamicColor {
        aliasTokens.backgroundColors[.neutral5]
    }

    open var squareBackgroundColor: DynamicColor {
        aliasTokens.foregroundColors[.brandRest]
    }

    open var squareBorderColor: DynamicColor {
        aliasTokens.foregroundColors[.neutral1]
    }

    open var topSquareSide: CGFloat {
        globalTokens.iconSize[.large]
    }

    open var topSquareCornerRadius: CGFloat {
        globalTokens.borderRadius[.medium]
    }

    open var topSquareBorderSize: CGFloat {
        globalTokens.borderSize[.thick]
    }

    open var bottomSquareSide: CGFloat {
        globalTokens.iconSize[.large]
    }

    open var bottomSquareCornerRadius: CGFloat {
        globalTokens.borderRadius[.medium]
    }

    open var bottomSquareBorderSize: CGFloat {
        globalTokens.borderSize[.thick]
    }
}

public struct FluentSplitSquareGroup: View, ConfigurableTokenizedControl {
    public init(squaresHaveBorders: Bool = false,
                squaresHaveRoundedCorners: Bool = false,
                topRows: Int = 1,
                bottomRows: Int = 1,
                cols: Int = 1) {
        let topRows = topRows >= 1 ? topRows : 1
        let bottomRows = bottomRows >= 1 ? bottomRows : 1
        let cols = cols >= 1 ? cols : 1
        let state = MSFSplitSquareGroupStateImpl(squaresHaveBorders: squaresHaveBorders,
                                                 squaresHaveRoundedCorners: squaresHaveRoundedCorners,
                                                 topRows: topRows,
                                                 bottomRows: bottomRows,
                                                 cols: cols)
        self.state = state
    }

    public var body: some View {
        let cols = state.cols
        VStack {
            ForEach( 1...state.topRows, id: \.self) {_ in
                HStack {
                    ForEach(1...cols, id: \.self) {_ in
                        FluentSplitSquareGroupTopSquare(hasBorder: state.squaresHaveBorders,
                                                        hasRoundedCorners: state.squaresHaveRoundedCorners,
                                                        groupTokens: tokens)
                    }
                }
            }
            ForEach( 1...state.bottomRows, id: \.self) {_ in
                HStack {
                    ForEach(1...cols, id: \.self) {_ in
                        FluentSplitSquareGroupBottomSquare(hasBorder: state.squaresHaveBorders,
                                                           hasRoundedCorners: state.squaresHaveRoundedCorners,
                                                           groupTokens: tokens)
                    }
                }
            }
        }
        .padding()
        .background(Rectangle().fill(Color(dynamicColor: tokens.backgroundColor)))
    }

    let defaultTokens: SplitSquareGroupTokens = .init()
    var tokens: SplitSquareGroupTokens {
        return resolvedTokens
    }
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var state: MSFSplitSquareGroupStateImpl
}

public extension FluentSplitSquareGroup {
    func overrideTokens(_ tokens: SplitSquareGroupTokens?) -> FluentSplitSquareGroup {
        state.overrideTokens = tokens
        return self
    }
}
