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
    public enum Confirmation {
      /// Almost there!
      public static let header = Strings.tr("Localizable", "Authentication.Confirmation.Header")
      /// Enter the confirmation code sent to this device. You may need to wait a few seconds for it to be delivered.
      public static let prompt = Strings.tr("Localizable", "Authentication.Confirmation.Prompt")
    }
    public enum Credentials {
      /// Welcome to Coven
      public static let header = Strings.tr("Localizable", "Authentication.Credentials.Header")
      /// Choose a username or enter your existing one, along with your phone number.
      public static let prompt = Strings.tr("Localizable", "Authentication.Credentials.Prompt")
      public enum Error {
        /// Email address is invalid.
        public static let email = Strings.tr("Localizable", "Authentication.Credentials.Error.email")
      }
      public enum Placeholder {
        /// Phone Number
        public static let password = Strings.tr("Localizable", "Authentication.Credentials.Placeholder.password")
        /// Username
        public static let username = Strings.tr("Localizable", "Authentication.Credentials.Placeholder.username")
      }
      public enum Title {
        /// Submit
        public static let submit = Strings.tr("Localizable", "Authentication.Credentials.Title.submit")
      }
    }
  }
}

extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = Bundle.module.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}
