//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// UIKit wrapper that exposes the SwiftUI List implementation
@objc open class MSFList: ControlHostingView {

    @objc public init() {
        let list = FluentList()
        state = list.state
        super.init(AnyView(list))
        state.onSelectAction = { [weak self] in
            guard let strongSelf = self, let action = strongSelf.action else {
                return
            }
            action(strongSelf)
        }
    }

    required public init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @objc public let state: MSFListState

    /// Closure that handles the on select event.
    @objc public var action: ((_ sender: MSFList) -> Void)?
}
