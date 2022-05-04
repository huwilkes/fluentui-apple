//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

public protocol MSFShapesState {
    var circleHasBorder: Bool { get set }
    var rectangleHasBorder: Bool { get set }
    var rectangleHasRoundedCorners: Bool { get set }
    var squareHasBorder: Bool { get set }
    var squareHasRoundedCorners: Bool { get set }
}

class MSFShapesStateImpl: NSObject, ObservableObject, ControlConfiguration, MSFShapesState {
    @Published var overrideTokens: ShapesTokens?
    @Published var circleHasBorder: Bool
    @Published var squareHasBorder: Bool
    @Published var squareHasRoundedCorners: Bool
    @Published var rectangleHasBorder: Bool
    @Published var rectangleHasRoundedCorners: Bool

    public init(circleHasBorder: Bool,
                rectangleHasBorder: Bool,
                rectangleHasRoundedCorners: Bool,
                squareHasBorder: Bool,
                squareHasRoundedCorners: Bool) {
        self.circleHasBorder = circleHasBorder
        self.rectangleHasBorder = rectangleHasBorder
        self.rectangleHasRoundedCorners = rectangleHasRoundedCorners
        self.squareHasBorder = squareHasBorder
        self.squareHasRoundedCorners = squareHasRoundedCorners
        super.init()
    }
}

open class ShapesTokens: ControlTokens {
    private var circleTokens: CircleTokens = .init()
    private var rectangleTokens: RectangleTokens = .init()
    private var squareTokens: SquareTokens = .init()

    open var backgroundColor: DynamicColor {
        aliasTokens.backgroundColors[.neutral5]
    }

    open var circleBackgroundColor: DynamicColor {
        circleTokens.backgroundColor
    }

    open var circleBorderColor: DynamicColor {
        circleTokens.borderColor
    }

    open var circleDiameter: CGFloat {
        circleTokens.diameter
    }

    open var circleBorderThickness: CGFloat {
        circleTokens.borderThickness
    }

    open var rectangleBackgroundColor: DynamicColor {
        rectangleTokens.backgroundColor
    }

    open var rectangleBorderColor: DynamicColor {
        rectangleTokens.borderColor
    }

    open var rectangleCorerRadius: CGFloat {
        rectangleTokens.cornerRadius
    }

    open var squareSide: CGFloat {
        squareTokens.side
    }
}

private class CustomCircleTokens: CircleTokens {
    private var shapesTokens: ShapesTokens
    init(_ shapesTokens: ShapesTokens) {
        self.shapesTokens = shapesTokens
    }

    required init() {
        shapesTokens = .init()
    }

    open override var backgroundColor: DynamicColor {
        shapesTokens.circleBackgroundColor
    }

    open override var borderColor: DynamicColor {
        shapesTokens.circleBorderColor
    }

    open override var diameter: CGFloat {
        shapesTokens.circleDiameter
    }

    open override var borderThickness: CGFloat {
        shapesTokens.circleBorderThickness
    }
}

private class CustomRectangleTokens: RectangleTokens {
    private var shapesTokens: ShapesTokens
    init(_ shapesTokens: ShapesTokens) {
        self.shapesTokens = shapesTokens
    }

    required init() {
        shapesTokens = .init()
    }

    open override var backgroundColor: DynamicColor {
        shapesTokens.rectangleBackgroundColor
    }

    open override var borderColor: DynamicColor {
        shapesTokens.rectangleBorderColor
    }

    open override var cornerRadius: CGFloat {
        shapesTokens.rectangleCorerRadius
    }
}

private class CustomSquareTokens: SquareTokens {
    private var shapesTokens: ShapesTokens
    init(_ shapesTokens: ShapesTokens) {
        self.shapesTokens = shapesTokens
    }

    required init() {
        shapesTokens = .init()
    }

    open override var side: CGFloat {
        shapesTokens.squareSide
    }
}

public struct Shapes: View, ConfigurableTokenizedControl {
    public init(circleHasBorder: Bool = false,
                rectangleHasBorder: Bool = false,
                rectangleHasRoundedCorners: Bool = false,
                squareHasBorder: Bool = false,
                squareHasRoundedCorners: Bool = false) {
        let state = MSFShapesStateImpl(circleHasBorder: circleHasBorder,
                                       rectangleHasBorder: rectangleHasBorder,
                                       rectangleHasRoundedCorners: rectangleHasRoundedCorners,
                                       squareHasBorder: squareHasBorder,
                                       squareHasRoundedCorners: squareHasRoundedCorners)
        self.state = state
    }

    public var body: some View {
        VStack {
            FluentCircle(hasBorder: state.circleHasBorder)
                .overrideTokens(CustomCircleTokens(tokens))
            FluentRectangle(hasBorder: state.rectangleHasBorder, hasRoundedCorners: state.rectangleHasRoundedCorners)
                .overrideTokens(CustomRectangleTokens(tokens))
            FluentSquare(hasBorder: state.squareHasBorder, hasRoundedCorners: state.squareHasRoundedCorners)
                .overrideTokens(CustomSquareTokens(tokens))
        }
        .padding()
        .background(Rectangle().fill(Color(dynamicColor: tokens.backgroundColor)))
    }

    let defaultTokens: ShapesTokens = .init()
    var tokens: ShapesTokens {
        return resolvedTokens
    }
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var state: MSFShapesStateImpl
}

public extension Shapes {
    func overrideTokens(_ tokens: ShapesTokens?) -> Shapes {
        state.overrideTokens = tokens
        return self
    }
}
