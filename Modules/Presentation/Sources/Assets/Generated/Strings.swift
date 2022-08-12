// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

public enum Strings {

  public enum Todo {
    public enum Edit {
      /// Edit
      public static let title = Strings.tr("Localizable", "Todo.Edit.title")
      public enum Placeholder {
        /// Title
        public static let title = Strings.tr("Localizable", "Todo.Edit.Placeholder.title")
      }
      public enum Title {
        public enum Button {
          /// Save
          public static let save = Strings.tr("Localizable", "Todo.Edit.Title.Button.save")
        }
      }
    }
    public enum List {
      /// %@’s Todos
      public static func title(_ p1: Any) -> String {
        return Strings.tr("Localizable", "Todo.List.title", String(describing: p1))
      }
      public enum Message {
        /// No Todos
        public static let emptyState = Strings.tr("Localizable", "Todo.List.Message.emptyState")
      }
      public enum Title {
        public enum Button {
          /// New Todo
          public static let newTodo = Strings.tr("Localizable", "Todo.List.Title.Button.newTodo")
        }
      }
    }
  }

  public enum Welcome {
    /// Welcome! Please enter your information.
    public static let prompt = Strings.tr("Localizable", "Welcome.Prompt")
    public enum Error {
      /// Email address invalid
      public static let email = Strings.tr("Localizable", "Welcome.Error.email")
    }
    public enum Placeholder {
      /// Email Address
      public static let email = Strings.tr("Localizable", "Welcome.Placeholder.email")
      /// Full Name
      public static let name = Strings.tr("Localizable", "Welcome.Placeholder.name")
    }
    public enum Title {
      /// Log In
      public static let login = Strings.tr("Localizable", "Welcome.Title.login")
    }
  }
}

extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = Bundle.module.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}
