// Copyright © Fleuronic LLC. All rights reserved.

import Geometric
import Styles
import enum Metric.Spacing
import class UIKit.UIView
import class UIKit.UIStackView
import class UIKit.UITextField
import class UIKit.UITextView
import struct Layoutless.Layout
import struct Ergo.VerticallyStacked
import protocol Ergo.Stacking
import protocol Ergo.ScreenProxy
import protocol Ergo.ReactiveScreen

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
