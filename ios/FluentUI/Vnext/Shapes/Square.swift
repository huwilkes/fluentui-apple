//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

public protocol MSFSquareState {
    var overrideTokens: SquareTokens? { get set }
    var hasBorder: Bool { get set }
    var hasRoundedCorners: Bool { get set }
}

class MSFSquareStateImpl: NSObject, ObservableObject, ControlConfiguration, MSFSquareState {
    @Published var overrideTokens: SquareTokens?
    @Published var hasBorder: Bool
    @Published var hasRoundedCorners: Bool

    public init(hasBorder: Bool,
                hasRoundedCorners: Bool) {
        self.hasBorder = hasBorder
        self.hasRoundedCorners = hasRoundedCorners
        super.init()
    }
}

open class SquareTokens: ControlTokens {
    var rectangleTokens: RectangleTokens = .init()

    open var side: CGFloat {
        rectangleTokens.height
    }
}

private class CustomSquareRectangleTokens: RectangleTokens {
    var squareTokens: SquareTokens
    init(_ squareTokens: SquareTokens) {
        self.squareTokens = squareTokens
    }

    required init() {
        self.squareTokens = .init()
    }

    open override var width: CGFloat {
        squareTokens.side
    }

    open override var height: CGFloat {
        squareTokens.side
    }
}

public struct FluentSquare: View, ConfigurableTokenizedControl {
    public init(hasBorder: Bool = false, hasRoundedCorners: Bool = false) {
        let state = MSFSquareStateImpl(hasBorder: hasBorder,
                                          hasRoundedCorners: hasRoundedCorners)
        self.state = state
    }

    public var body: some View {
        return FluentRectangle(hasBorder: state.hasBorder, hasRoundedCorners: state.hasRoundedCorners)
            .overrideTokens(CustomSquareRectangleTokens(tokens))
    }

    let defaultTokens: SquareTokens = .init()
    var tokens: SquareTokens {
        return resolvedTokens
    }
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var state: MSFSquareStateImpl
}

public extension FluentSquare {
    func overrideTokens(_ tokens: SquareTokens?) -> FluentSquare {
        state.overrideTokens = tokens
        return self
    }
}
