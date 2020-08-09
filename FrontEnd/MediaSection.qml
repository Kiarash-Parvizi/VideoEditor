import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import QtMultimedia 5.12

// VideoSection
Item {
    property alias videoPlus: videoPlus
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
    property bool timeLineMode: false
    onTimeLineModeChanged: {
        video.timeLineMode_changed()
        video.focus = !timeLineMode
        //
        videoPlus.timeLineMode_changed()
        //videoPlus.
    }

    Video {
        id: video
        width : videoContainer.video_width
        height : videoContainer.video_height
        visible: !timeLineMode
        playbackRate: 1
        anchors.centerIn: parent

        function timeLineMode_changed() {
            if (timeLineMode) pause()
        }

        property int mediaWidth: metaData.resolution ? metaData.resolution.width : width
        property int mediaHeight: metaData.resolution ? metaData.resolution.height : height

        property bool blackScreen: true
        property bool hasSource: false
        property string fullVidSource: ""
        source: fullVidSource
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


        function resetProps() {
            seek(0)
            blackScreen = true
            musicNoteImg.visible = false
            editorFeedBack.redLine_indicator.reset()
            toolMenu.mainMenu.reset_all()
            videoSlider.reset()
        }

        function set_source(path) {
            if (path == source) { return }
            resetProps()
            fullVidSource = path
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

        focus: !timeLineMode

        Keys.onSpacePressed: {
            print("space")
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
        }

        // Mouse-Box
        MouseBox {
            id: mouseBox
            width: parent.mediaWidth; height: parent.mediaHeight
            anchors.centerIn: parent
            visible: true
        }
        Component.onCompleted: {
            //playbackRate = 1
        }
    }
    // VideoPlus
    VideoPlus {
        id: videoPlus
        focus: timeLineMode
        vid_width : videoContainer.video_width
        vid_height: videoContainer.video_height
        visible: timeLineMode
        anchors.centerIn: parent
    }

    // ICONS
    Image {
        id: musicNoteImg
        anchors.centerIn: video
        source: "qrc:/resources/musicNote.png"
        visible: !timeLineMode && !video.hasVideo && video.hasSource
    }
    Image {
        id: videoPlayImg
        anchors.centerIn: video
        source: "qrc:/resources/play_button.png"
        visible: !timeLineMode && !musicNoteImg.visible && video.blackScreen
    }
    Rectangle {
        color: "#1A1A1A"
        anchors.centerIn: video
        width: timeLineImg.width*1.8; height: timeLineImg.height*1.8
        visible: timeLineImg.visible
        radius: width/2
    }
    Image {
        id: timeLineImg
        anchors.centerIn: video
        source: "qrc:/resources/timeLine.png"
        visible: timeLineMode && !videoPlus.isPlaying
    }
}
