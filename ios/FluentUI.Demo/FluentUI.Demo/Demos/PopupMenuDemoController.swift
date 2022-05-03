//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class PopupMenuDemoController: DemoController {
    private enum CalendarLayout {
        case agenda
        case day
        case threeDay
        case week
        case month
    }

    private var calendarLayout: CalendarLayout = .agenda
    private var cityIndexPath: IndexPath? = IndexPath(item: 2, section: 1)
    private var listIndexPath: IndexPath? = IndexPath(item: 5, section: 0)

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show", style: .plain, target: self, action: #selector(topBarButtonTapped))

        toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Selection", style: .plain, target: self, action: #selector(bottomBarButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Selection (list)", style: .plain, target: self, action: #selector(bottomBarButtonListTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "1-line description", style: .plain, target: self, action: #selector(bottomBarButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "1-line (list)", style: .plain, target: self, action: #selector(bottomBarButtonListTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "2-line header", style: .plain, target: self, action: #selector(bottomBarButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "2-line (list)", style: .plain, target: self, action: #selector(bottomBarButtonListTapped)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        ]

        container.addArrangedSubview(createButton(title: "Show with sections", action: { [weak self] sender in
            guard let strongSelf = self else {
                return
            }

            let buttonView = sender
            let controller = PopupMenuController(sourceView: buttonView, sourceRect: buttonView.bounds, presentationDirection: .down)

            controller.addSections([
                PopupMenuSection(title: "Canada", items: [
                    PopupMenuItem(imageName: "Montreal", generateSelectedImage: false, title: "Montréal", subtitle: "Québec"),
                    PopupMenuItem(imageName: "Toronto", generateSelectedImage: false, title: "Toronto", subtitle: "Ontario"),
                    PopupMenuItem(imageName: "Vancouver", generateSelectedImage: false, title: "Vancouver", subtitle: "British Columbia")
                ]),
                PopupMenuSection(title: "United States", items: [
                    PopupMenuItem(imageName: "Las Vegas", generateSelectedImage: false, title: "Las Vegas", subtitle: "Nevada"),
                    PopupMenuItem(imageName: "Phoenix", generateSelectedImage: false, title: "Phoenix", subtitle: "Arizona"),
                    PopupMenuItem(imageName: "San Francisco", generateSelectedImage: false, title: "San Francisco", subtitle: "California"),
                    PopupMenuItem(imageName: "Seattle", generateSelectedImage: false, title: "Seattle", subtitle: "Washington")
                ])
            ])

            controller.selectedItemIndexPath = strongSelf.cityIndexPath
            controller.onDismiss = { [unowned controller] in
                strongSelf.cityIndexPath = controller.selectedItemIndexPath
            }

            strongSelf.present(controller, animated: true)
        }))

        container.addArrangedSubview(createButton(title: "Show with sections (list)", action: { [weak self] sender in
            guard let strongSelf = self else {
                return
            }

            let buttonView = sender
            let controller = PopupMenuListController(sourceView: buttonView, sourceRect: buttonView.bounds, presentationDirection: .down)

            let canada = controller.createSection()
            canada.title = "Canada"
            canada.style = .subtle

            strongSelf.setupCityCell(cell: canada.createCell(),
                                     imageName: "Montreal",
                                     title: "Montréal",
                                     subtitle: "Québec")

            strongSelf.setupCityCell(cell: canada.createCell(),
                                     title: "Toronto",
                                     subtitle: "Ontario")

            strongSelf.setupCityCell(cell: canada.createCell(),
                                     title: "Vancouver",
                                     subtitle: "British Columbia")

            let unitedStates = controller.createSection()
            unitedStates.title = "United States"
            unitedStates.style = .subtle

            strongSelf.setupCityCell(cell: unitedStates.createCell(),
                                     title: "Las Vegas",
                                     subtitle: "Nevada")

            strongSelf.setupCityCell(cell: unitedStates.createCell(),
                                     title: "Phoenix",
                                     subtitle: "Arizona")

            strongSelf.setupCityCell(cell: unitedStates.createCell(),
                                     title: "San Francisco",
                                     subtitle: "California")

            strongSelf.setupCityCell(cell: unitedStates.createCell(),
                                     title: "Seattle",
                                     subtitle: "Washington")

            controller.selectedItemIndexPath = strongSelf.cityIndexPath
            controller.onDismiss = { [unowned controller] in
                strongSelf.cityIndexPath = controller.selectedItemIndexPath
            }

            strongSelf.present(controller, animated: true)
        }))

        container.addArrangedSubview(createButton(title: "Show with scrollable items and no icons", action: { [weak self] sender in
            guard let strongSelf = self else {
                return
            }

            let buttonView = sender
            let controller = PopupMenuController(sourceView: buttonView, sourceRect: buttonView.bounds, presentationDirection: .down)

            let items = samplePersonas.map { PopupMenuItem(title: !$0.name.isEmpty ? $0.name : $0.email) }
            controller.addItems(items)

            strongSelf.present(controller, animated: true)
        }))

        container.addArrangedSubview(createButton(title: "Show with scrollable items and no icons (list)", action: { [weak self] sender in
            guard let strongSelf = self else {
                return
            }

            let buttonView = sender
            let controller = PopupMenuListController(sourceView: buttonView, sourceRect: buttonView.bounds, presentationDirection: .down)

            for samplePersona in samplePersonas {
                let item = controller.createItem()
                item.title = samplePersona.name.isEmpty ? samplePersona.email : samplePersona.name
            }

            strongSelf.present(controller, animated: true)
        }))

        container.addArrangedSubview(createButton(title: "Show items with custom colors", action: { [weak self] sender in
            guard let strongSelf = self else {
                return
            }

            let buttonView = sender
            let controller = PopupMenuController(sourceView: buttonView, sourceRect: buttonView.bounds, presentationDirection: .down)

            let items = [
                PopupMenuItem(image: UIImage(named: "agenda-24x24"), title: "Agenda", isSelected: strongSelf.calendarLayout == .agenda, onSelected: { strongSelf.calendarLayout = .agenda }),
                PopupMenuItem(image: UIImage(named: "day-view-24x24"), title: "Day", isSelected: strongSelf.calendarLayout == .day, onSelected: { strongSelf.calendarLayout = .day }),
                PopupMenuItem(image: UIImage(named: "3-day-view-24x24"), title: "3-Day", isEnabled: false, isSelected: strongSelf.calendarLayout == .threeDay, onSelected: { strongSelf.calendarLayout = .threeDay })
            ]

            let menuBackgroundColor: UIColor = .darkGray

            for item in items {
                item.titleColor = .white
                item.titleSelectedColor = .white
                item.imageSelectedColor = .white
                item.accessoryCheckmarkColor = .white
                item.backgroundColor = menuBackgroundColor
            }

            controller.addItems(items)

            controller.backgroundColor = menuBackgroundColor
            controller.resizingHandleViewBackgroundColor = menuBackgroundColor
            controller.separatorColor = .lightGray

            strongSelf.present(controller, animated: true)
        }))

        container.addArrangedSubview(createButton(title: "Show items with custom colors (list)", action: { [weak self] sender in
            guard let strongSelf = self else {
                return
            }

            let buttonView = sender
            let controller = PopupMenuListController(sourceView: buttonView, sourceRect: buttonView.bounds, presentationDirection: .down)

            strongSelf.setupCustomColorCell(cell: controller.createItem(),
                                 imageName: "agenda-24x24",
                                 title: "Agenda")

            strongSelf.setupCustomColorCell(cell: controller.createItem(),
                                            imageName: "day-view-24x24",
                                            title: "Day")

            let threeDay = controller.createItem()
            strongSelf.setupCustomColorCell(cell: threeDay,
                                            imageName: "3-day-view-24x24",
                                            title: "3-Day")
            // TODO: Add disabled state?

            let menuBackgroundColor: UIColor = .darkGray
            controller.backgroundColor = menuBackgroundColor
            controller.resizingHandleViewBackgroundColor = menuBackgroundColor

            strongSelf.present(controller, animated: true)
        }))

        container.addArrangedSubview(createButton(title: "Show items without dismissal after being tapped", action: { [weak self] sender in
            guard let strongSelf = self else {
                return
            }

            let buttonView = sender
            let controller = PopupMenuController(sourceView: buttonView, sourceRect: buttonView.bounds, presentationDirection: .down)

            let items = [
                PopupMenuItem(image: UIImage(named: "agenda-24x24"), title: "Agenda", isSelected: strongSelf.calendarLayout == .agenda, executes: .onSelectionWithoutDismissal, onSelected: { strongSelf.calendarLayout = .agenda }),
                PopupMenuItem(image: UIImage(named: "day-view-24x24"), title: "Day", isSelected: strongSelf.calendarLayout == .day, executes: .onSelectionWithoutDismissal, onSelected: { strongSelf.calendarLayout = .day }),
                PopupMenuItem(image: UIImage(named: "3-day-view-24x24"), title: "3-Day", isEnabled: false, isSelected: strongSelf.calendarLayout == .threeDay, executes: .onSelectionWithoutDismissal, onSelected: { strongSelf.calendarLayout = .threeDay })
            ]

            let menuBackgroundColor: UIColor = .darkGray

            for item in items {
                item.titleColor = .white
                item.titleSelectedColor = .white
                item.imageSelectedColor = .white
                item.accessoryCheckmarkColor = .white
                item.backgroundColor = menuBackgroundColor
            }

            controller.addItems(items)

            controller.backgroundColor = menuBackgroundColor
            controller.resizingHandleViewBackgroundColor = menuBackgroundColor
            controller.separatorColor = .lightGray

            strongSelf.present(controller, animated: true)
                    }))

        container.addArrangedSubview(createButton(title: "Show items without dismissal after being tapped (list)", action: { [weak self] sender in
            guard let strongSelf = self else {
                return
            }

            let buttonView = sender
            let controller = PopupMenuListController(sourceView: buttonView, sourceRect: buttonView.bounds, presentationDirection: .down)

            let agenda = controller.createItem()
            strongSelf.setupCustomColorCell(cell: agenda,
                                 imageName: "agenda-24x24",
                                 title: "Agenda")
            agenda.executionMode = .onSelectionWithoutDismissal

            let day = controller.createItem()
            strongSelf.setupCustomColorCell(cell: day,
                                            imageName: "day-view-24x24",
                                            title: "Day")
            day.executionMode = .onSelectionWithoutDismissal

            let threeDay = controller.createItem()
            strongSelf.setupCustomColorCell(cell: threeDay,
                                            imageName: "3-day-view-24x24",
                                            title: "3-Day")
            threeDay.executionMode = .onSelectionWithoutDismissal

            let menuBackgroundColor: UIColor = .darkGray
            controller.backgroundColor = menuBackgroundColor
            controller.resizingHandleViewBackgroundColor = menuBackgroundColor
            // TODO: Add separatorColor?
//            controller.separatorColor = .lightGray

            strongSelf.present(controller, animated: true)
                    }))

        container.addArrangedSubview(createButton(title: "Show with list", action: { [weak self] sender in
            guard let strongSelf = self else {
                return
            }

            let buttonView = sender
            let controller = PopupMenuListController(sourceView: buttonView, sourceRect: buttonView.bounds, presentationDirection: .down)
            controller.headerItem.title = "Test header"

            for i in 0...9 {
                let section = controller.createSection()
                section.title = "Section \(i)"
                for j in 0...9 {
                    let item = controller.createItem()
                    item.title = "Cell \(i).\(j)"
                    item.executionMode = .onSelection
                }
            }
            controller.selectedItemIndexPath = strongSelf.listIndexPath
            controller.onDismiss = { [unowned controller] in
                strongSelf.listIndexPath = controller.selectedItemIndexPath
            }

            strongSelf.present(controller, animated: true)
        }))

        container.addArrangedSubview(UIView())
        addTitle(text: "Show with...")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isToolbarHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isToolbarHidden = true
    }

    private func setupCityCell(cell: MSFListCellState, imageName: String? = nil, title: String, subtitle: String) {
        cell.leadingUIView = UIImageView(image: UIImage(named: imageName ?? title))
        cell.title = title
        cell.subtitle = subtitle
    }

    private class CustomColorTokens: CellBaseTokens {
        override var labelColor: DynamicColor {
            return DynamicColor(light: globalTokens.neutralColors[.white])
        }

        override var labelSelectedColor: DynamicColor {
            return DynamicColor(light: globalTokens.neutralColors[.white])
        }

        override var trailingItemSelectedForegroundColor: DynamicColor {
            return DynamicColor(light: globalTokens.neutralColors[.white])
        }

        override var backgroundColor: DynamicColor {
            return UIColor.darkGray.dynamicColor ?? DynamicColor(light: globalTokens.neutralColors[.grey32])
        }
    }

    private func setupCustomColorCell(cell: MSFListCellState, imageName: String, title: String) {
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .white
        cell.leadingUIView = imageView
        cell.title = title
        cell.overrideTokens = CustomColorTokens()
    }

    private func createAccessoryView(text: String) -> UIView {
        let accessoryView = BadgeView(dataSource: BadgeViewDataSource(text: text, style: .default, size: .small))
        accessoryView.isUserInteractionEnabled = false
        accessoryView.sizeToFit()
        return accessoryView
    }

    @objc private func topBarButtonTapped(sender: UIBarButtonItem) {
        let controller = PopupMenuController(barButtonItem: sender, presentationDirection: .down)

        controller.addItems([
            PopupMenuItem(image: UIImage(named: "mail-unread-24x24"), title: "Unread"),
            PopupMenuItem(image: UIImage(named: "flag-24x24"), title: "Flagged", accessoryView: createAccessoryView(text: "New")),
            PopupMenuItem(image: UIImage(named: "attach-24x24"), accessoryImage: UIImage(named: "gleam"), title: "Attachments", isAccessoryCheckmarkVisible: false)
        ])

        let originalTitle = sender.title
        sender.title = "Shown"
        controller.onDismiss = {
            sender.title = originalTitle
        }

        present(controller, animated: true)
    }

    @objc private func bottomBarButtonTapped(sender: UIBarButtonItem) {
        var origin: CGFloat = -1
        if let toolbar = navigationController?.toolbar {
            origin = toolbar.convert(toolbar.bounds.origin, to: nil).y
        }

        let controller = PopupMenuController(barButtonItem: sender, presentationOrigin: origin, presentationDirection: .up)

        if sender.title == "1-line description" {
            controller.headerItem = PopupMenuItem(title: "Pick a calendar layout")
        }
        if sender.title == "2-line header" {
            controller.headerItem = PopupMenuItem(title: "Calendar layout", subtitle: "Some options might not be available")
        }
        controller.addItems([
            PopupMenuItem(image: UIImage(named: "agenda-24x24"), title: "Agenda", isSelected: calendarLayout == .agenda, onSelected: { self.calendarLayout = .agenda }),
            PopupMenuItem(image: UIImage(named: "day-view-24x24"), title: "Day", isSelected: calendarLayout == .day, onSelected: { self.calendarLayout = .day }),
            PopupMenuItem(image: UIImage(named: "3-day-view-24x24"), title: "3-Day", isEnabled: false, isSelected: calendarLayout == .threeDay, onSelected: { self.calendarLayout = .threeDay }),
            PopupMenuItem(title: "Week (no icon)", isSelected: calendarLayout == .week, onSelected: { self.calendarLayout = .week }),
            PopupMenuItem(image: UIImage(named: "month-view-24x24"), title: "Month", isSelected: calendarLayout == .month, onSelected: { self.calendarLayout = .month })
        ])

        present(controller, animated: true)
    }

    @objc private func bottomBarButtonListTapped(sender: UIBarButtonItem) {
        var origin: CGFloat = -1
        if let toolbar = navigationController?.toolbar {
            origin = toolbar.convert(toolbar.bounds.origin, to: nil).y
        }

        let controller = PopupMenuListController(barButtonItem: sender, presentationOrigin: origin, presentationDirection: .up)

        if sender.title == "1-line (list)" {
            controller.headerItem.title = "Pick a calendar layout"
        }
        if sender.title == "2-line (list)" {
            controller.headerItem.title = "Calendar layout"
            controller.headerItem.subtitle = "Some options might not be available"
        }
        setupBottomBarCell(cell: controller.createItem(), imageName: "agenda-24x24", title: "Agenda")
        setupBottomBarCell(cell: controller.createItem(), imageName: "day-view-24x24", title: "Day")
        setupBottomBarCell(cell: controller.createItem(), imageName: "3-day-view-24x24", title: "3-Day")
        setupBottomBarCell(cell: controller.createItem(), title: "Week (no icon)")
        setupBottomBarCell(cell: controller.createItem(), imageName: "month-view-24x24", title: "Month")

        present(controller, animated: true)
    }

    private func setupBottomBarCell(cell: MSFListCellState, imageName: String? = nil, title: String) {
        if let imageName = imageName {
            let image = UIImage(named: imageName)
            let imageView = UIImageView(image: image?.withRenderingMode(.alwaysTemplate))
            imageView.tintColor = .darkGray
            cell.leadingUIView = imageView
        }
        cell.title = title
    }
}
