//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI
import UIKit

class SquareGroupDemoControllerSwiftUI: UIHostingController<SquareGroupDemoView> {
    override init?(coder aDecoder: NSCoder, rootView: SquareGroupDemoView) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    init() {
        super.init(rootView: SquareGroupDemoView())
        self.title = "Square Group (SwiftUI)"
    }
}

struct SquareGroupDemoView: View {
    @State var borders: Bool = false
    @State var roundedCorners: Bool = false
    @State var rowString: String = ""
    var rows: Int {
        guard let rowNumber = Int(rowString) else {
            return 4
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
    @State var sideString: String = ""
    var side: Int {
        guard let sideNumber = Int(sideString) else {
            return 50
        }
        return sideNumber
    }
    @State var borderString: String = ""
    var border: Int {
        guard let borderNumber = Int(borderString) else {
            return 2
        }
        return borderNumber
    }
    @State var radiusString: String = ""
    var radius: Int {
        guard let radiusNumber = Int(radiusString) else {
            return 5
        }
        return radiusNumber
    }

    public var body: some View {
        VStack {
            FluentSquareGroup(squaresHaveBorders: borders,
                              squaresHaveRoundedCorners: roundedCorners,
                              rows: rows,
                              cols: cols)
                .overrideTokens(CustomSquareGroupTokens(customBackgroundColor: backgroundColor,
                                                        customSquareBackgroundColor: squareBackgroundColor,
                                                        customSquareBorderColor: squareBorderColor,
                                                        customSquareSide: side,
                                                        customSquareCornerRadius: radius,
                                                        customSquareBorderSize: border))
        }

        ScrollView {
            Group {
                VStack(spacing: 0) {
                    Text("Group")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title)
                    FluentDivider(orientation: .horizontal)
                }
                TextField("Number of Rows", text: $rowString)
                    .keyboardType(.numberPad)
                TextField("Number of Columns", text: $colString)
                    .keyboardType(.numberPad)
                ColorPicker("Background Color", selection: $backgroundColor)
            }

            Group {
                VStack(spacing: 0) {
                    Text("Squares")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title)
                    FluentDivider(orientation: .horizontal)
                }
                FluentUIDemoToggle(titleKey: "Have Borders", isOn: $borders)
                FluentUIDemoToggle(titleKey: "Have Rounded Corners", isOn: $roundedCorners)
                ColorPicker("Background Color", selection: $squareBackgroundColor)
                ColorPicker("Border Color", selection: $squareBorderColor)
                TextField("Side", text: $sideString)
                    .keyboardType(.numberPad)
                TextField("Corner Radius", text: $radiusString)
                    .keyboardType(.numberPad)
                TextField("Border Size", text: $borderString)
                    .keyboardType(.numberPad)
            }
        }
    }
}

private class CustomSquareGroupTokens: SquareGroupTokens {
    var customBackgroundColor: Color = .black
    var customSquareBackgroundColor: Color = .white
    var customSquareBorderColor: Color = .green
    var customSquareSide: Int = 50
    var customSquareCornerRadius: Int = 5
    var customSquareBorderSize: Int = 2

    init(customBackgroundColor: Color,
         customSquareBackgroundColor: Color,
         customSquareBorderColor: Color,
         customSquareSide: Int,
         customSquareCornerRadius: Int,
         customSquareBorderSize: Int) {
        self.customBackgroundColor = customBackgroundColor
        self.customSquareBackgroundColor = customSquareBackgroundColor
        self.customSquareBorderColor = customSquareBorderColor
        self.customSquareSide = customSquareSide
        self.customSquareCornerRadius = customSquareCornerRadius
        self.customSquareBorderSize = customSquareBorderSize
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

    open override var squareSide: CGFloat {
        CGFloat(customSquareSide)
    }

    open override var squareCornerRadius: CGFloat {
        CGFloat(customSquareCornerRadius)
    }

    open override var squareBorderSize: CGFloat {
        CGFloat(customSquareBorderSize)
    }
}
