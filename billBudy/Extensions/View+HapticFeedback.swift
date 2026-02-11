import SwiftUI

extension View {
    func onLightHaptic() -> some View {
        self.onTapGesture {
            HapticManager.lightImpact()
        }
    }

    func onMediumHaptic() -> some View {
        self.onTapGesture {
            HapticManager.mediumImpact()
        }
    }

    func withHapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .light, onTap action: @escaping () -> Void) -> some View {
        self.onTapGesture {
            switch style {
            case .light:
                HapticManager.lightImpact()
            case .medium:
                HapticManager.mediumImpact()
            default:
                HapticManager.lightImpact()
            }
            action()
        }
    }
}
