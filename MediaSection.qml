import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import QtMultimedia 5.12

// VideoSection
Item {
    id: videoContainer
    width: window.width*0.68
    Layout.minimumWidth: window.width*0.65

    property var video: video

    property int video_width: window.width*0.62
    property int video_height: video_width * 0.75

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
        width: videoContainer.video_width
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
        playbackRate: 1
        anchors.centerIn: parent

        property int mediaWidth: metaData.resolution ? metaData.resolution.width : width
        property int mediaHeight: metaData.resolution ? metaData.resolution.height : height

        property bool blackScreen: true
        property bool hasSource: false
        property bool hasTSource: false
        property string fullVidSource: ""
        property string tSource: ""
        property bool timeLineMode: false
        source: timeLineMode ? tSource : fullVidSource
        function set_play() {
            if (!hasVideo) {
                return
            }
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
            if (hasVideo) {
                video.seek(video.position + amount)
            }
        }

        Image {
            id: musicNoteImg
            anchors.centerIn: parent
            source: "resources/musicNote.png"
            visible: !video.timeLineMode && !video.hasVideo && video.hasSource
        }
        Image {
            id: videoPlayImg
            anchors.centerIn: parent
            source: "resources/play_button.png"
            visible: !video.timeLineMode && !musicNoteImg.visible && video.blackScreen
        }
        Image {
            id: timeLineImg
            anchors.centerIn: parent
            source: "resources/timeLine.png"
            visible: video.timeLineMode && !video.hasTSource
        }

        function resetProps() {
            seek(0)
            blackScreen = true
            musicNoteImg.visible = false
        }

        function set_source(path) {
            resetProps()
            fullVidSource = path
        }

        function set_tSource(path) {
            tSource = path
            hasTSource = true
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (video.hasSource) {
                    video.set_play()
                } else {
                }
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
            var ratio = position/duration
            videoSlider.setPointerPosition(ratio)
            focus = true
        }
        // Source Changed
        onSourceChanged: {
            video.play(); video.pause()
            video.hasSource = true
            editorFeedBack.redLine_indicator.reset()
            toolMenu.mainMenu.reset_all()
            videoSlider.reset()
        }

        // Mouse-Box
        MouseBox {
            id: mouseBox
            width: parent.mediaWidth; height: parent.mediaHeight
            anchors.centerIn: parent
            visible: true
        }
    }
}
