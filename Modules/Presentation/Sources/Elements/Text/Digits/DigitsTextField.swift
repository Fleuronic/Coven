// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import ReactiveKit
import Geometric

import struct Metric.Styled
import struct Textbelt.OTP

public final class DigitsTextField: TextField {
	private lazy var outlineView: OutlineView = {
		let view = OutlineView(cursorCount: OTP.validLength)
		inputLength.bind(to: view.reactive.cursorPosition)
		addSubview(view)
		return view
	}()

	// MARK: UIView
	public override func layoutSubviews() {
		super.layoutSubviews()

		outlineView.frame = bounds
		bringSubviewToFront(outlineView)
	}

	// MARK: UITextInput
	public override func caretRect(for position: UITextPosition) -> CGRect {
		.zero
	}

	// MARK: TextField
	public override var rectInsets: UIEdgeInsets {
		var insets = super.rectInsets
		insets.right = 0
		return insets
	}
}

// MARK: -
public extension DigitsTextField {
	enum Style {
		case confirmationCode
	}
}

// MARK: -
private extension DigitsTextField {
	var inputLength: SafeSignal<Int> {
		reactive.text
			.ignoreNils()
			.map(\.count)
			.removeDuplicates()
	}
}

// MARK: -
private extension DigitsTextField.Style {
	var font: UIFont {
		switch self {
		case .confirmationCode:
			return
				.size { $0.extraLarge }
				.weight(.semibold)
				.design(.monospaced)
		}
	}
}

// MARK: -
public extension UITextField {
	static func style(_ style: DigitsTextField.Style) -> Styled<DigitsTextField> {
		.init()
			.font(style.font)
			.style(style)
	}
}

// MARK: -
private extension Styled where Base: DigitsTextField {
	func style(_ style: DigitsTextField.Style) -> Self {
		switch style {
		case .confirmationCode:
			return self
				.keyboardType(.numberPad)
				.maxLength(OTP.validLength)
				.acceptedCharacter(OTP.validCharacter)
				.kerning { $0.confirmationCode }
				.horizontalInsets { $0.confirmationCode }
		}
	}
}
