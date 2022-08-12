// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import Layoutless
import Ergo
import Metric
import Geometric
import Telemetric
import Styles

extension Todo.Edit {
	final class View: UIView {}
}

// MARK: -
extension Todo.Edit.View: Stacking {
	typealias Screen = Todo.Edit.Screen

	static var verticalSpacing: Spacing.Vertical { .element }

	@VerticallyStacked<Self>
	func content(screen: some ScreenProxy<Screen>) -> Layout<UIStackView> {
		UITextField.style(.title)
			.text(screen.title)
			.placeholder(screen.titlePlaceholder)
			.edited(screen.titleTextEdited)
			.height(.element)
		UITextView.style(.notes)
			.text(screen.note)
			.edited(screen.noteTextEdited)
	}
}

// MARK: -
extension Todo.Edit.Screen: ReactiveScreen {
	typealias View = Todo.Edit.View
}
