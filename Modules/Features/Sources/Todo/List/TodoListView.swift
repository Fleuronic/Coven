// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import Layoutless
import Ergo
import Geometric
import Telemetric

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
