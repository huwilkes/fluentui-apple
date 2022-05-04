//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI
import UIKit

class ShapesDemoControllerSwiftUI: UIHostingController<ShapesDemoView> {
    override init?(coder aDecoder: NSCoder, rootView: ShapesDemoView) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    init() {
        super.init(rootView: ShapesDemoView())
        self.title = "Shapes (SwiftUI)"
    }
}

struct ShapesDemoView: View {
    @State var circleHasBorder: Bool = false
    @State var circleBackgroundColor: Color = .green
    @State var circleBorderColor: Color = .black
    @State var circleDiameter: String = ""
    @State var circleBorderThickness: String = ""
    @State var rectangleHasBorder: Bool = false
    @State var rectangleHasRoundedCorners: Bool = false
    @State var rectangleBackgroundColor: Color = .red
    @State var rectangleBorderColor: Color = .white
    @State var rectangleCornerRadius: String = ""
    @State var squareHasBorder: Bool = false
    @State var squareHasRoundedCorners: Bool = false
    @State var squareSide: String = ""

    public var body: some View {
        VStack {
            Shapes(circleHasBorder: circleHasBorder,
                   rectangleHasBorder: rectangleHasBorder,
                   rectangleHasRoundedCorners: rectangleHasRoundedCorners,
                   squareHasBorder: squareHasBorder,
                   squareHasRoundedCorners: squareHasRoundedCorners)
                .overrideTokens(CustomShapesTokens(customCircleBackgroundColor: circleBackgroundColor,
                                                   customCircleBorderColor: circleBorderColor,
                                                   customCircleDiameter: circleDiameter,
                                                   customCircleBorderThickness: circleBorderThickness,
                                                   customRectangleBackgroundColor: rectangleBackgroundColor,
                                                   customRectangleBorderColor: rectangleBorderColor,
                                                   customRectangleCornerRadius: rectangleCornerRadius,
                                                   customSquareSide: squareSide))
        }

        ScrollView {
            Group {
                VStack(spacing: 0) {
                    Text("Circle")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title)
                    FluentDivider(orientation: .horizontal)
                }
                FluentUIDemoToggle(titleKey: "Has Border", isOn: $circleHasBorder)
                ColorPicker("Background Color", selection: $circleBackgroundColor)
                ColorPicker("Border Color", selection: $circleBorderColor)
                TextField("Diameter", text: $circleDiameter)
                    .keyboardType(.numberPad)
                TextField("Border Thickness", text: $circleBorderThickness)
                    .keyboardType(.numberPad)
            }

            Group {
                VStack(spacing: 0) {
                    Text("Rectangle")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title)
                    FluentDivider(orientation: .horizontal)
                }
                FluentUIDemoToggle(titleKey: "Has Border", isOn: $rectangleHasBorder)
                FluentUIDemoToggle(titleKey: "Has Rounded Corners", isOn: $rectangleHasRoundedCorners)
                ColorPicker("Background Color", selection: $rectangleBackgroundColor)
                ColorPicker("Border Color", selection: $rectangleBorderColor)
                TextField("Corner Radius", text: $rectangleCornerRadius)
                    .keyboardType(.numberPad)
            }

            Group {
                VStack(spacing: 0) {
                    Text("Square")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title)
                    FluentDivider(orientation: .horizontal)
                }
                FluentUIDemoToggle(titleKey: "Has Border", isOn: $squareHasBorder)
                FluentUIDemoToggle(titleKey: "Has Rounded Corners", isOn: $squareHasRoundedCorners)
                TextField("Side", text: $squareSide)
                    .keyboardType(.numberPad)
            }
        }
    }
}

private class CustomShapesTokens: ShapesTokens {
    var customCircleBackgroundColor: Color = .green
    var customCircleBorderColor: Color = .black
    var customCircleDiameter: String = ""
    var customCircleBorderThickness: String = ""
    var customRectangleBackgroundColor: Color = .red
    var customRectangleBorderColor: Color = .white
    var customRectangleCornerRadius: String = ""
    var customSquareSide: String = ""
    init(customCircleBackgroundColor: Color,
         customCircleBorderColor: Color,
         customCircleDiameter: String,
         customCircleBorderThickness: String,
         customRectangleBackgroundColor: Color,
         customRectangleBorderColor: Color,
         customRectangleCornerRadius: String,
         customSquareSide: String) {
        self.customCircleBackgroundColor = customCircleBackgroundColor
        self.customCircleBorderColor = customCircleBorderColor
        self.customCircleDiameter = customCircleDiameter
        self.customCircleBorderThickness = customCircleBorderThickness
        self.customRectangleBackgroundColor = customRectangleBackgroundColor
        self.customRectangleBorderColor = customRectangleBorderColor
        self.customRectangleCornerRadius = customRectangleCornerRadius
        self.customSquareSide = customSquareSide
    }

    required init() {}
    open override var circleBackgroundColor: DynamicColor {
        UIColor(customCircleBackgroundColor).dynamicColor ?? super.circleBackgroundColor
    }

    open override var circleBorderColor: DynamicColor {
        UIColor(customCircleBorderColor).dynamicColor ?? super.circleBorderColor
    }

    open override var circleDiameter: CGFloat {
        guard let diameter = Int(customCircleDiameter) else {
            return super.circleDiameter
        }
        return CGFloat(diameter)
    }

    open override var circleBorderThickness: CGFloat {
        guard let circleBorderThickness = Int(customCircleBorderThickness) else {
            return super.circleBorderThickness
        }
        return CGFloat(circleBorderThickness)
    }

    open override var rectangleBackgroundColor: DynamicColor {
        UIColor(customRectangleBackgroundColor).dynamicColor ?? super.rectangleBackgroundColor
    }

    open override var rectangleBorderColor: DynamicColor {
        UIColor(customRectangleBorderColor).dynamicColor ?? super.rectangleBorderColor
    }

    open override var rectangleCorerRadius: CGFloat {
        guard let rectangleCornerRadius = Int(customRectangleCornerRadius) else {
            return super.rectangleCorerRadius
        }
        return CGFloat(rectangleCornerRadius)
    }

    open override var squareSide: CGFloat {
        guard let squareSide = Int(customSquareSide) else {
            return super.squareSide
        }
        return CGFloat(squareSide)
    }
}
