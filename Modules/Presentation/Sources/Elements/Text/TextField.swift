// Copyright © Fleuronic LLC. All rights reserved.

import UIKit

import struct Metric.Styled
import struct Metric.Insets
import struct Metric.Kerning
import struct Coven.User
import struct Coven.PhoneNumber
import protocol Metric.Text

public extension UITextField {
	enum Style {
		case username
		case phoneNumber
	}

	static func style(_ style: Style) -> Styled<TextField> {
		.init()
			.autocapitalizationType(.none)
			.autocorrectionType(.no)
			.borderStyle(.roundedRect)
			.backgroundColor { $0.info }
			.style(style)
	}
}

// MARK: -
private extension Styled where Base: TextField {
	func style(_ style: UITextField.Style) -> Self {
		switch style {
		case .username:
			return self
				.maxLength(User.Username.maxLength)
				.acceptedCharacter(User.Username.validCharacter)
		case .phoneNumber:
			return self
				.keyboardType(.phonePad)
				.maxLength(PhoneNumber.validLength)
				.acceptedCharacter(PhoneNumber.validCharacter)
		}
	}
}

// MARK: -
open class TextField: UITextField {
	open var rectInsets: UIEdgeInsets { insets }

	public var maxLength: Int?
	public var acceptedCharacter: Regex<Substring>?

	fileprivate var insets: UIEdgeInsets = .zero

	// MARK: NSCoding
	public required init(coder: NSCoder) {
		fatalError()
	}

	// MARK: UIView
	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.delegate = self
	}

	// MARK: UITextField
	open override func textRect(forBounds bounds: CGRect) -> CGRect {
		super.textRect(forBounds: bounds).inset(by: rectInsets)
	}

	open override func editingRect(forBounds bounds: CGRect) -> CGRect {
		super.editingRect(forBounds: bounds).inset(by: rectInsets)
	}

	open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		super.placeholderRect(forBounds: bounds).inset(by: rectInsets)
	}
}

// MARK: -
extension TextField: UITextFieldDelegate {
	public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		guard
			!string.isEmpty,
			let text = textField.text,
			let range = Range(range, in: text) else { return true }

		let result = text.replacingCharacters(in: range, with: string)
		return
			maxLength.map { result.count <= $0 } ?? true &&
			acceptedCharacter.map(string.wholeMatch).map { $0 != nil } ?? true
	}
}

// MARK: -
public extension Styled where Base: TextField {
	func horizontalInsets(named name: Insets.Horizontal.Name) -> Self {
		let inset = name(Insets.Horizontal.self).value
		base.insets.left = inset
		base.insets.right = inset
		return self
	}

	func verticalInsets(named name: Insets.Vertical.Name) -> Self {
		let inset = name(Insets.Vertical.self).value
		base.insets.top = inset
		base.insets.bottom = inset
		return self
	}
}
