import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.12
import QtMultimedia 5.12

// Video
Item {
    id: videoContainer
    width: Window.width*0.68
    Layout.minimumWidth: Window.width*0.65

    property int video_width: 800
    property int video_height: 600

    // ShadowLine
    Rectangle {
        id: videoSection_shadowLine
        color: "#0B0B0B"
        width: 2
        anchors.right: parent.right
        height: parent.height
    }
    Glow {
        anchors.fill: videoSection_shadowLine
        radius: 10
        samples: 20
        color: "#0B0B0B"
        source: videoSection_shadowLine
    }

    // videoBackGround
    Rectangle {
        id: videoBackGround
        width: videoContainer.video_width + 2
        height: videoContainer.video_height + 2
        visible: true
        color: "#1A1A1A"
        anchors.centerIn: parent
    }
    Glow {
        anchors.fill: videoBackGround
        radius: 10
        samples: 19
        color: "#050505"
        source: videoBackGround
    }
    // blueRect Style
    Rectangle {
        id: glowLine_2
        color: "#3161D7"
        width: 1; height: parent.height
        anchors.left: parent.left
        opacity: 0.4
        z: 1
    }
    Glow {
        anchors.fill: glowLine_2
        radius: 8
        samples: 19
        color: "#3161D7"
        source: glowLine_2
        opacity: 0.4
        z: 1
    }

    Video {
        id: video
        width : videoContainer.video_width
        height : videoContainer.video_height
        visible: true
        anchors.centerIn: parent
        //source: "C:/Users/Rain/Desktop/Dev/QT/Text_Editor/Resources/R.mp4"
        source: "E:/Movies/Law.Abiding.Citizen.2009.720p_harmonydl.mkv"
        //source: "E:/Folders/Music/Music Pluss/Eluveitie/02. Epona.mp3"
        property bool blackScreen: true
        function set_play() {
            blackScreen = false
            focus = true
            if (video.playbackState !== MediaPlayer.PlayingState) {
                video.play()
            } else {
                video.pause()
            }
        }
        function set_volume(v) {
            video.volume = v
        }

        function fast_forward(amount) {
            video.seek(video.position + amount)
        }

        Image {
            id: musicNoteImg
            anchors.centerIn: parent
            source: "resources/musicNote.png"
            visible: !video.hasVideo
        }

        Image {
            id: videoPlayImg
            anchors.centerIn: parent
            source: "resources/play_button.png"
            visible: !musicNoteImg.visible && video.blackScreen
        }

        function resetProps() {
            print("reset")
            seek(0)
            blackScreen = true
            musicNoteImg.visible = false
        }

        function set_source(path) {
            resetProps()
            source = path
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                video.set_play()
            }
        }

        focus: true

        Keys.onSpacePressed: {
            set_play()
        }
        Keys.onLeftPressed: fast_forward(-5000)
        Keys.onRightPressed: fast_forward(5000)

        onPositionChanged: {
            if (position != 0) {
                blackScreen = false
            }
            print("Pos Changed")
            var ratio = position/duration
            timeLine.setPointerPosition(ratio)
            focus = true
        }
    }
}
