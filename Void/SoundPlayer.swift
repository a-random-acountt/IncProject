import AudioToolbox

enum SoundPlayer {
    static func playClick() {
        AudioServicesPlaySystemSound(1104)
    }
}
