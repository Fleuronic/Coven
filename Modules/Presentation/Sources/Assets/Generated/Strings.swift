// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

public enum Strings {

  public enum Alert {
    /// Dismiss
    public static let dismiss = Strings.tr("Localizable", "Alert.Dismiss")
    public enum Error {
      /// Network Error
      public static let network = Strings.tr("Localizable", "Alert.Error.Network")
    }
  }

  public enum Authentication {
    /// Welcome to Coven
    public static let header = Strings.tr("Localizable", "Authentication.header")
    /// Choose a username or enter your existing one, along with your phone number.
    public static let prompt = Strings.tr("Localizable", "Authentication.prompt")
    public enum Error {
      /// Email address is invalid.
      public static let email = Strings.tr("Localizable", "Authentication.Error.email")
    }
    public enum Placeholder {
      /// Phone Number
      public static let password = Strings.tr("Localizable", "Authentication.Placeholder.password")
      /// Username
      public static let username = Strings.tr("Localizable", "Authentication.Placeholder.username")
    }
    public enum Title {
      /// Submit
      public static let submit = Strings.tr("Localizable", "Authentication.Title.submit")
    }
  }

  public enum Counter {
    /// The value is %d
    public static func value(_ p1: Int) -> String {
      return Strings.tr("Localizable", "Counter.value", p1)
    }
  }
}

extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = Bundle.module.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}
