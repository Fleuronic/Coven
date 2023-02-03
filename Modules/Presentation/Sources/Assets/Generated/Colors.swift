// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
#endif


 public enum Colors {
  public enum Background {

    public enum Button {
      public static let primary = UIColor(named: "Background/Button/Primary", in: Bundle.module, compatibleWith: nil)!
    }
    public enum TextField {
      public static let info = UIColor(named: "Background/Text Field/Info", in: Bundle.module, compatibleWith: nil)!
    }
  }
  public enum Border {

    public enum TextField {
      public static let primary = UIColor(named: "Border/Text Field/Primary", in: Bundle.module, compatibleWith: nil)!
      public static let secondary = UIColor(named: "Border/Text Field/Secondary", in: Bundle.module, compatibleWith: nil)!
    }
    public enum View {
      public enum Cursor {
        public static let active = UIColor(named: "Border/View/Cursor/Active", in: Bundle.module, compatibleWith: nil)!
        public static let inactive = UIColor(named: "Border/View/Cursor/Inactive", in: Bundle.module, compatibleWith: nil)!
      }
    }
  }
  public enum Text {

    public static let error = UIColor(named: "Text/Error", in: Bundle.module, compatibleWith: nil)!
    public static let light = UIColor(named: "Text/Light", in: Bundle.module, compatibleWith: nil)!
    public static let primary = UIColor(named: "Text/Primary", in: Bundle.module, compatibleWith: nil)!
    public static let secondary = UIColor(named: "Text/Secondary", in: Bundle.module, compatibleWith: nil)!
  }
}

