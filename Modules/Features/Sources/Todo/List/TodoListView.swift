// Copyright © Fleuronic LLC. All rights reserved.

import class UIKit.UIView
import class UIKit.UILabel
import class UIKit.UIStackView
import class UIKit.UITableView
import struct Layoutless.Layout
import struct Ergo.VerticallyStacked
import protocol Ergo.Stacking
import protocol Ergo.ScreenProxy
import protocol Ergo.ReactiveScreen

extension Todo.List {
	final class View: UIView {}
}

// MARK: -
extension Todo.List.View: Stacking {
	typealias Screen = Todo.List.Screen

	@VerticallyStacked<Self>
	func content(screen: some ScreenProxy<Screen>) -> Layout<UIStackView> {
		UIView.container
			.isVisible(screen.isEmpty)
			.addingLayout(
				UILabel.style(.emptyState)
					.text(screen.emptyStateMessage)
					.centeringInParent()
			)
		UITableView.plain
			.isHidden(screen.isEmpty)
			.rowSelected(screen.rowSelected)
			.rowDeleted(screen.rowDeleted)
			.cellsText(screen.todoTitles)
	}
}

// MARK: -
extension Todo.List.Screen: ReactiveScreen {
	typealias View = Todo.List.View
}
