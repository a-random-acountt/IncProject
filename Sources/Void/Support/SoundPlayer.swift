import AudioToolbox

/// Plays the single sound effect this app needs: a small, satisfying click
/// that confirms nothing happened.
enum SoundPlayer {
    static func playClick() {
        AudioServicesPlaySystemSound(1104) // the standard iOS keyboard "tock"
    }
}
