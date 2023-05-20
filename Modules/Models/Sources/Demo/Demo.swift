// Copyright © Fleuronic LLC. All rights reserved.

public enum Demo: Hashable {
	case swiftUI
	case uiKit(declarative: Bool)
}

// MARK: -
public extension Demo {
	var name: String {
		switch self {
		case .swiftUI:
			return "SwiftUI"
		case let .uiKit(declarative):
			return declarative ? "Declarative UIKit" : "UIKit"
		}
	}
}

// MARK: -
extension Demo: Identifiable {
	// MARK: Identifiable
	public var id: Self { self }
}
