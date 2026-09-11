import SwiftUI

/// A hairline rule in the border color - shadcn/ui's `Separator`, restyled
/// for a near-black surface where a plain system `Divider` reads too faint.
struct ShadcnSeparator: View {
    var body: some View {
        Rectangle()
            .fill(Color.appBorder)
            .frame(height: Metrics.hairline)
    }
}
