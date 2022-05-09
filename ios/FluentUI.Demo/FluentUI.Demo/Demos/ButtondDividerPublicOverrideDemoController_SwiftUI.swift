//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI
import UIKit

class ButtonsDividerPublicOverrideDemoControllerSwiftUI: UIHostingController<ButtonsDividerPublicOverrideDemoView> {
    override init?(coder aDecoder: NSCoder, rootView: ButtonsDividerPublicOverrideDemoView) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    init() {
        super.init(rootView: ButtonsDividerPublicOverrideDemoView())
        self.title = "Shapes (SwiftUI)"
    }
}

struct ButtonsDividerPublicOverrideDemoView: View {
    public var body: some View {
        ButtonsDivider()
    }
}
