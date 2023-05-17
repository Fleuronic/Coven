// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import ErgoUIKit

public extension Counter.UIKit {
	final class View: UIView {
		private let stackView: UIStackView
		private let valueLabel: UILabel
		private let incrementButton: UIButton
		private let decrementButton: UIButton

		// MARK: UpdatedView
		public init(screen: Screen) {
			valueLabel = .init()
			incrementButton = .init(
				type: .system,
				primaryAction: .init { _ in screen.increment() }
			)
			decrementButton = .init(
				type: .system,
				primaryAction: .init { _ in screen.decrement() }
			)
			stackView = .init(
				arrangedSubviews: [
					valueLabel,
					incrementButton,
					decrementButton
				]
			)
			stackView.axis = .vertical
			stackView.translatesAutoresizingMaskIntoConstraints = false

			super.init(frame: .zero)
			update(with: screen)

			addSubview(stackView)
			NSLayoutConstraint.activate(
				[
					stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
					stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
				]
			)
		}

		// MARK: NSCoding
		required init(coder: NSCoder) {
			fatalError()
		}
	}
}

// MARK: -
extension Counter.UIKit.View: UpdatedView {
	// MARK: UpdatedView
	public func update(with screen: Counter.UIKit.Screen) {
		valueLabel.text = screen.valueText
		incrementButton.setTitle(screen.incrementTitle, for: .normal)
		decrementButton.setTitle(screen.decrementTitle, for: .normal)
	}
}

// MARK: -
extension Counter.UIKit.Screen: UpdatedScreen {
	public typealias View = Counter.UIKit.View
}
