import Foundation

public enum CompactNumber {
    /// Formats a count the way a stat tile wants it: full precision with
    /// thousands separators below 10,000, then a compact "12.9K" / "1.2M"
    /// style above that. Never negative-input aware; this app only ever counts up.
    public static func format(_ value: Int) -> String {
        switch value {
        case ..<10_000:
            return value.formatted(.number.grouping(.automatic))
        case ..<1_000_000:
            return scaled(value, by: 1_000, suffix: "K")
        default:
            return scaled(value, by: 1_000_000, suffix: "M")
        }
    }

    private static func scaled(_ value: Int, by divisor: Int, suffix: String) -> String {
        let scaledValue = Double(value) / Double(divisor)
        let rounded = (scaledValue * 10).rounded() / 10
        if rounded == rounded.rounded() {
            return "\(Int(rounded))\(suffix)"
        }
        return String(format: "%.1f%@", rounded, suffix)
    }
}
