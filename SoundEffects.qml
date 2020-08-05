import QtQuick 2.12
import QtMultimedia 5.12

Item {
    function play_click() {
        clickSound.call()
    }
    function play_click41() {
        clickSound_41.call()
    }
    function play_space() {
        clickSound_space.call()
    }
    function play_mouse() {
        clickSound_mouse.call()
    }
    function play_done() {
        clickSound_done.call()
    }

    // audio files
    SoundEffect {
        id: clickSound
        source: "resources/audio/ButtonClick.wav"
        volume: 0.16
        function call() {
            play()
        }
    }
    SoundEffect {
        id: clickSound_41
        source: "resources/audio/41.wav"
        volume: 0.16
        function call() {
            play()
        }
    }
    SoundEffect {
        id: clickSound_space
        source: "resources/audio/space.wav"
        volume: 0.16
        function call() {
            play()
        }
    }
    SoundEffect {
        id: clickSound_mouse
        source: "resources/audio/mouse.wav"
        volume: 0.16
        function call() {
            play()
        }
    }
    SoundEffect {
        id: clickSound_done
        source: "resources/audio/done.wav"
        volume: 0.16
        function call() {
            play()
        }
    }

}