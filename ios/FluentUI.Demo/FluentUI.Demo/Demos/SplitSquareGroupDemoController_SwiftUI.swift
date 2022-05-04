//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI
import UIKit

class SplitSquareGroupDemoControllerSwiftUI: UIHostingController<SplitSquareGroupDemoView> {
    override init?(coder aDecoder: NSCoder, rootView: SplitSquareGroupDemoView) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    init() {
        super.init(rootView: SplitSquareGroupDemoView())
        self.title = "Split Square Group (SwiftUI)"
    }
}

struct SplitSquareGroupDemoView: View {
    @State var borders: Bool = false
    @State var roundedCorners: Bool = false
    @State var topRowString: String = ""
    var topRows: Int {
        guard let rowNumber = Int(topRowString) else {
            return 2
        }
        return rowNumber
    }
    @State var bottomRowString: String = ""
    var bottomRows: Int {
        guard let rowNumber = Int(bottomRowString) else {
            return 2
        }
        return rowNumber
    }
    @State var colString: String = ""
    var cols: Int {
        guard let colNumber = Int(colString) else {
            return 5
        }
        return colNumber
    }
    @State var backgroundColor: Color = .black
    @State var squareBackgroundColor: Color = .white
    @State var squareBorderColor: Color = .green
    @State var topSideString: String = ""
    var topSide: Int {
        guard let sideNumber = Int(topSideString) else {
            return 50
        }
        return sideNumber
    }
    @State var topBorderString: String = ""
    var topBorder: Int {
        guard let borderNumber = Int(topBorderString) else {
            return 2
        }
        return borderNumber
    }
    @State var topRadiusString: String = ""
    var topRadius: Int {
        guard let radiusNumber = Int(topRadiusString) else {
            return 5
        }
        return radiusNumber
    }
    @State var bottomSideString: String = ""
    var bottomSide: Int {
        guard let sideNumber = Int(bottomSideString) else {
            return 30
        }
        return sideNumber
    }
    @State var bottomBorderString: String = ""
    var bottomBorder: Int {
        guard let borderNumber = Int(bottomBorderString) else {
            return 10
        }
        return borderNumber
    }
    @State var bottomRadiusString: String = ""
    var bottomRadius: Int {
        guard let radiusNumber = Int(bottomRadiusString) else {
            return 15
        }
        return radiusNumber
    }

    public var body: some View {
        VStack {
            FluentSplitSquareGroup(squaresHaveBorders: borders,
                                   squaresHaveRoundedCorners: roundedCorners,
                                   topRows: topRows,
                                   bottomRows: bottomRows,
                                   cols: cols)
                .overrideTokens(CustomSplitSquareGroupTokens(customBackgroundColor: backgroundColor,
                                                            customSquareBackgroundColor: squareBackgroundColor,
                                                            customSquareBorderColor: squareBorderColor,
                                                            customTopSquareSide: topSide,
                                                            customTopSquareCornerRadius: topRadius,
                                                            customTopSquareBorderSize: topBorder,
                                                            customBottomSquareSide: bottomSide,
                                                            customBottomSquareCornerRadius: bottomRadius,
                                                            customBottomSquareBorderSize: bottomBorder))
        }

        ScrollView {
            Group {
                VStack(spacing: 0) {
                    Text("Group")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title)
                    FluentDivider(orientation: .horizontal)
                }
                FluentUIDemoToggle(titleKey: "Squares Have Borders", isOn: $borders)
                FluentUIDemoToggle(titleKey: "Squares Have Rounded Corners", isOn: $roundedCorners)
                TextField("Number of Columns", text: $colString)
                    .keyboardType(.numberPad)
                ColorPicker("Background Color", selection: $backgroundColor)
                ColorPicker("Square Background Color", selection: $squareBackgroundColor)
                ColorPicker("Square Border Color", selection: $squareBorderColor)
            }

            Group {
                VStack(spacing: 0) {
                    Text("Top Squares")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title)
                    FluentDivider(orientation: .horizontal)
                }
                TextField("Number of Rows", text: $topRowString)
                    .keyboardType(.numberPad)
                TextField("Side", text: $topSideString)
                    .keyboardType(.numberPad)
                TextField("Corner Radius", text: $topRadiusString)
                    .keyboardType(.numberPad)
                TextField("Border Size", text: $topBorderString)
                    .keyboardType(.numberPad)
            }

            Group {
                VStack(spacing: 0) {
                    Text("Bottom Squares")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title)
                    FluentDivider(orientation: .horizontal)
                }
                TextField("Number of Rows", text: $bottomRowString)
                    .keyboardType(.numberPad)
                TextField("Side", text: $bottomSideString)
                    .keyboardType(.numberPad)
                TextField("Corner Radius", text: $bottomRadiusString)
                    .keyboardType(.numberPad)
                TextField("Border Size", text: $bottomBorderString)
                    .keyboardType(.numberPad)
            }
        }
    }
}

private class CustomSplitSquareGroupTokens: SplitSquareGroupTokens {
    var customBackgroundColor: Color = .black
    var customSquareBackgroundColor: Color = .white
    var customSquareBorderColor: Color = .green
    var customTopSquareSide: Int = 50
    var customTopSquareCornerRadius: Int = 5
    var customTopSquareBorderSize: Int = 2
    var customBottomSquareSide: Int = 30
    var customBottomSquareCornerRadius: Int = 15
    var customBottomSquareBorderSize: Int = 10

    init(customBackgroundColor: Color,
         customSquareBackgroundColor: Color,
         customSquareBorderColor: Color,
         customTopSquareSide: Int,
         customTopSquareCornerRadius: Int,
         customTopSquareBorderSize: Int,
         customBottomSquareSide: Int,
         customBottomSquareCornerRadius: Int,
         customBottomSquareBorderSize: Int) {
        self.customBackgroundColor = customBackgroundColor
        self.customSquareBackgroundColor = customSquareBackgroundColor
        self.customSquareBorderColor = customSquareBorderColor
        self.customTopSquareSide = customTopSquareSide
        self.customTopSquareCornerRadius = customTopSquareCornerRadius
        self.customTopSquareBorderSize = customTopSquareBorderSize
        self.customBottomSquareSide = customBottomSquareSide
        self.customBottomSquareCornerRadius = customBottomSquareCornerRadius
        self.customBottomSquareBorderSize = customBottomSquareBorderSize
        super.init()
    }

    required init() {}

    open override var backgroundColor: DynamicColor {
        UIColor(customBackgroundColor).dynamicColor ?? super.backgroundColor
    }

    open override var squareBackgroundColor: DynamicColor {
        UIColor(customSquareBackgroundColor).dynamicColor ?? super.squareBackgroundColor
    }

    open override var squareBorderColor: DynamicColor {
        UIColor(customSquareBorderColor).dynamicColor ?? super.squareBorderColor
    }

    open override var topSquareSide: CGFloat {
        CGFloat(customTopSquareSide)
    }

    open override var topSquareCornerRadius: CGFloat {
        CGFloat(customTopSquareCornerRadius)
    }

    open override var topSquareBorderSize: CGFloat {
        CGFloat(customTopSquareBorderSize)
    }

    open override var bottomSquareSide: CGFloat {
        CGFloat(customBottomSquareSide)
    }

    open override var bottomSquareCornerRadius: CGFloat {
        CGFloat(customBottomSquareCornerRadius)
    }

    open override var bottomSquareBorderSize: CGFloat {
        CGFloat(customBottomSquareBorderSize)
    }
}
