//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

struct Header: View, ConfigurableTokenizedControl {
    init(state: MSFListSectionStateImpl) {
        self.state = state
    }

    var body: some View {
        let backgroundColor: Color = {
            guard let stateBackgroundColor = state.backgroundColor else {
                return Color(dynamicColor: tokens.backgroundColor)
            }
            return Color(stateBackgroundColor)
        }()

        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                if let title = state.title, !title.isEmpty {
                    Text(title)
                        .font(.fluent(tokens.titleFont))
                        .foregroundColor(Color(dynamicColor: tokens.titleColor))
                }
                if let subtitle = state.subtitle, !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.fluent(tokens.subtitleFont))
                        .foregroundColor(Color(dynamicColor: tokens.subtitleColor))
                }
            }
            Spacer()
        }
        .padding(EdgeInsets(top: tokens.topPadding,
                            leading: tokens.leadingPadding,
                            bottom: tokens.bottomPadding,
                            trailing: tokens.trailingPadding))
        .frame(minHeight: tokens.headerHeight)
        .background(backgroundColor)
    }

    let defaultTokens: HeaderTokens = .init()
    var tokens: HeaderTokens {
        let tokens = resolvedTokens
        tokens.style = state.style
        return tokens
    }
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme
    @ObservedObject var state: MSFListSectionStateImpl
}
