//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI
import UIKit

class ButtonsDividerDemoControllerSwiftUI: UIHostingController<ButtonsDividerDemoView> {
    override init?(coder aDecoder: NSCoder, rootView: ButtonsDividerDemoView) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    init() {
        super.init(rootView: ButtonsDividerDemoView())
        self.title = "Shapes (SwiftUI)"
    }
}

struct ButtonsDividerDemoView: View {
    public var body: some View {
        ButtonsDivider()
    }
}
