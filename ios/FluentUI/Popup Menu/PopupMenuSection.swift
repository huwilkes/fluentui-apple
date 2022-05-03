//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/**
 `PopupMenuSection` represents a section of menu items inside `PopupMenuController`.
 */
@objc(MSFPopupMenuSection)
open class PopupMenuSection: NSObject {
    @objc public let title: String?
    @objc public var items: [PopupMenuTemplateItem]

    @objc public init(title: String?, items: [PopupMenuTemplateItem]) {
        self.title = title
        self.items = items
        super.init()
    }
}

/**
 `PopupMenuSection` represents a section of menu items inside `PopupMenuController`.
 */
@objc(MSFPopupMenuListSection)
open class PopupMenuListSection: NSObject {
    @objc public let title: String?
    @objc public var items: [PopupMenuListTemplateItem]

    @objc public init(title: String?, items: [PopupMenuListTemplateItem]) {
        self.title = title
        self.items = items
        super.init()
    }
}
