//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: CalendarViewHeightStyle

enum CalendarViewHeightStyle {
    case short  // Shows 2 weeks
    case half   // Shows 2.5 weeks
    case tall   // Shows 5 weeks
    case extraTall // Show 6 weeks
}

// MARK: - CalendarView

class CalendarView: UIView {
    let weekdayHeadingView: CalendarViewWeekdayHeadingView
    let collectionView: UICollectionView
    let collectionViewLayout: CalendarViewLayout

    weak var accessibleViewDelegate: AccessibleViewDelegate?

    private let headingViewDivider: MSFDivider
    private let collectionViewDivider: MSFDivider

    init(headerStyle: DatePickerHeaderStyle = .light) {
        weekdayHeadingView = CalendarViewWeekdayHeadingView(headerStyle: headerStyle)

        headingViewDivider = MSFDivider()

        collectionViewLayout = CalendarViewLayout()

        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.scrollsToTop = false
        // Enable multiple selection to allow for one cell to be selected and another cell to be highlighted simultaneously
        collectionView.allowsMultipleSelection = true

        collectionViewDivider = MSFDivider()

        super.init(frame: .zero)

        updateCollectionViewBackgroundColor()

        addSubview(weekdayHeadingView)
        addSubview(collectionView)
        addSubview(collectionViewDivider)
        addInteraction(UILargeContentViewerInteraction())

        if headerStyle == .light {
            addSubview(headingViewDivider)
        }

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeDidChange),
                                               name: .didChangeTheme,
                                               object: nil)
    }

    @objc private func themeDidChange(_ notification: Notification) {
        guard let themeView = notification.object as? UIView, self.isDescendant(of: themeView) else {
            return
        }
        updateCollectionViewBackgroundColor()
    }

    private func updateCollectionViewBackgroundColor() {
        collectionView.backgroundColor = UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.background2])
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Weekday heading view
        let weekdayHeadingViewSize = weekdayHeadingView.sizeThatFits(bounds.size)
        weekdayHeadingView.frame = CGRect(
            x: 0.0,
            y: 0.0,
            width: weekdayHeadingViewSize.width,
            height: weekdayHeadingViewSize.height
        )

        headingViewDivider.frame = CGRect(
            x: 0.0,
            y: weekdayHeadingView.frame.height,
            width: bounds.size.width,
            height: headingViewDivider.frame.height
        )

        // Collection view
        //
        // Avoid the default scroll view behavior that shifts the content offset when view frame changes. For example the
        // default behavior would reduce the content offset y when the height is increased to equally grow the visible bounds
        // at the top and bottom. We would just want the visible bounds to grow at the bottom.
        let originalContentOffset = collectionView.contentOffset
        collectionView.frame = CGRect(
            x: 0.0,
            y: weekdayHeadingView.frame.height,
            width: bounds.size.width,
            height: bounds.size.height - weekdayHeadingView.frame.height
        )
        collectionView.contentOffset = originalContentOffset

        collectionViewDivider.frame = CGRect(
            x: 0.0,
            y: collectionView.frame.maxY - collectionViewDivider.frame.height,
            width: bounds.size.width,
            height: collectionViewDivider.frame.height
        )
    }

    func height(for style: CalendarViewHeightStyle, in bounds: CGRect) -> CGFloat {
        var height: CGFloat = 0.0

        // Weekday heading
        height += weekdayHeadingView.sizeThatFits(bounds.size).height

        // Day cells
        height += CalendarViewLayout.preferredItemHeight * rows(for: style)

        // Do not include last divider
        height -= MSFDivider.thickness

        return height
    }

    func rows(for style: CalendarViewHeightStyle) -> CGFloat {
        switch style {
        case .short:
            return 2.0
        case .half:
            return 2.5
        case .tall:
            return 5.0
        case .extraTall:
            return 6.0
        }
    }

    // MARK: Accessibility

    override var isAccessibilityElement: Bool { get { return true } set { } }

    override var accessibilityLabel: String? { get { return "Accessibility.Calendar.Label".localized } set { } }

    override var accessibilityHint: String? { get { return "Accessibility.Calendar.Hint".localized } set { } }

    override var accessibilityTraits: UIAccessibilityTraits { get { return super.accessibilityTraits.union(.adjustable) } set { } }

    override var accessibilityValue: String? {
        get { return accessibleViewDelegate?.accessibilityValueForAccessibleView?(self) ?? super.accessibilityValue }
        set { }
    }

    override func accessibilityIncrement() {
        accessibleViewDelegate?.accessibilityIncrementForAccessibleView?(self)
    }

    override func accessibilityDecrement() {
        accessibleViewDelegate?.accessibilityDecrementForAccessibleView?(self)
    }

    override func accessibilityPerformMagicTap() -> Bool {
        return accessibleViewDelegate?.accessibilityPerformMagicTapForAccessibleView?(self) ?? super.accessibilityPerformMagicTap()
    }

    override func accessibilityActivate() -> Bool {
        return accessibleViewDelegate?.accessibilityActivateForAccessibleView?(self) ?? super.accessibilityActivate()
    }
}
