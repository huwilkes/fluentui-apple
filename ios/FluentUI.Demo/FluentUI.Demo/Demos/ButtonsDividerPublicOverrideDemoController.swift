//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit
import SwiftUI

class ButtonsDividerPublicOverrideDemoController: DemoTableViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(style: .grouped)
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return ButtonsDividerPublicOverrideDemoSection.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ButtonsDividerPublicOverrideDemoSection.allCases[section].rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = ButtonsDividerPublicOverrideDemoSection.allCases[indexPath.section]
        let row = section.rows[indexPath.row]

        switch row {
        case .swiftUIDemo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
                return UITableViewCell()
            }
            cell.setup(title: row.title)
            cell.accessoryType = .disclosureIndicator

            return cell
        case .controlDemo:
            let cell = TableViewCell()
            cell.backgroundColor = Colors.surfacePrimary
            let contentView = cell.contentView

            let useOverrideTokens = section == .override

            let verticalStack = UIStackView()
            verticalStack.translatesAutoresizingMaskIntoConstraints = false
            verticalStack.axis = .vertical

            let buttonsDividerPublicOverride = MSFButtonsDividerPublicOverride()
            if useOverrideTokens {
            }

            verticalStack.addArrangedSubview(buttonsDividerPublicOverride)

            contentView.addSubview(verticalStack)
            NSLayoutConstraint.activate([
                contentView.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor),
                contentView.topAnchor.constraint(equalTo: verticalStack.topAnchor),
                contentView.bottomAnchor.constraint(equalTo: verticalStack.bottomAnchor)
            ])

            return cell
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ButtonsDividerPublicOverrideDemoSection.allCases[section].title
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return ButtonsDividerPublicOverrideDemoSection.allCases[indexPath.section].rows[indexPath.row] == .swiftUIDemo
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }

        cell.setSelected(false, animated: true)

        switch ButtonsDividerPublicOverrideDemoSection.allCases[indexPath.section].rows[indexPath.row] {
        case .swiftUIDemo:
            navigationController?.pushViewController(ButtonsDividerPublicOverrideDemoControllerSwiftUI(),
                                                     animated: true)
        case .controlDemo:
            break
        }
    }

    private enum ButtonsDividerPublicOverrideDemoSection: CaseIterable {
        case swiftUI
        case `default`
        case override

        var isDemoSection: Bool {
            return self != .swiftUI
        }

        var title: String {
            switch self {
            case .swiftUI:
                return "SwiftUI"
            case .default:
                return "Default/Theme"
            case .override:
                return "Override"
            }
        }

        var rows: [ButtonsDividerPublicOverrideDemoRow] {
            switch self {
            case .swiftUI:
                return [.swiftUIDemo]
            case .default,
                    .override:
                return [.controlDemo]
            }
        }
    }

    private enum ButtonsDividerPublicOverrideDemoRow: CaseIterable {
        case swiftUIDemo
        case controlDemo

        var isDemoRow: Bool {
            return self != .swiftUIDemo
        }

        var title: String {
            switch self {
            case .swiftUIDemo:
                return "Swift UI Demo"
            case .controlDemo:
                return ""
            }
        }
    }
}
