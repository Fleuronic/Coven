// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import ReactiveKit
import Bond
import Layoutless
import Geometric

import struct Metric.Styled

extension DigitsTextField {
	final class OutlineView: UIView {
		fileprivate var cursorViews: [Styled<UIView>]

		init(cursorCount: Int) {
			cursorViews = (0..<cursorCount).map { _ in UIView.style(.cursor) }

			super.init(frame: .zero)

			UIStackView.style(.outline, arranging: cursorViews)
				.fillingParent()
				.layout(in: self)
		}

		// MARK: NSCoding
		required init(coder: NSCoder) {
			fatalError()
		}
	}
}

// MARK: -
extension ReactiveExtensions where Base: DigitsTextField.OutlineView {
	var cursorPosition: Bond<Int> {
		bond { outlineView, position in
			outlineView.cursorViews = outlineView.cursorViews.enumerated().map {
				let isActive = ($0 == position)
				return $1
					.borderColor { isActive ? $0.Cursor.active : $0.Cursor.inactive }
					.borderWidth { isActive ? $0.Cursor.active : $0.Cursor.inactive }
			}
		}
	}
}
