import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtMultimedia 5.12

// basicVideoControls
Rectangle {
    color: "white"
    id: controlTape
    width: parent.width; height: 42
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 0


    // MouseArea
    MouseArea {
        anchors.fill: parent
        onClicked: {
            //print("VideoMode Focus by click")
            mediaSection.video.focus = true
        }
    }

    RowLayout {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        anchors.topMargin: 0
        spacing: 10
        Image {
            source: "qrc:/resources/speaker.png"
            Layout.preferredWidth: 17; Layout.preferredHeight: 17
        }
        Slider {
            Layout.preferredWidth: 80
            value: 0.85
            onValueChanged: {
                mediaSection.video.set_volume(value)
            }
            Component.onCompleted: {
                mediaSection.video.set_volume(value)
            }
        }
    }

    // First ROW
    RowLayout {
        anchors.top: parent.top
        anchors.topMargin: 0
        spacing: 10
        id: bottom_firstRowLayout

        // Play/Pause Button
        Button {
            Layout.leftMargin: 3
            Layout.topMargin: (controlTape.height-height)/2
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34
            Image {
                id: playImg
                visible: mediaSection.video.playbackState !== MediaPlayer.PlayingState
                source: "qrc:/resources/play-button_sm.png"
                x: 7; y: 7
                width: 20
                height: 20
            }
            Image {
                id: pauseImg
                visible: !playImg.visible
                source: "qrc:/resources/pause.png"
                x: 7; y: 7
                width: 20
                height: 20
            }
            onClicked: {
                mediaSection.video.set_play()
            }
            ToolTip.visible: hovered
            ToolTip.text: playImg.visible ? "Play" : "Pause"
        }

        // fast-forwards/backwards
        Button {
            Layout.leftMargin: 2
            Layout.topMargin: (controlTape.height-height)/2
            Layout.preferredHeight: 30
            Layout.preferredWidth: 30
            Image {
                source: "qrc:/resources/fast-forward_plus.png"
                x: 6; y: 5
                width: 20
                height: 20
            }
            onClicked: {
                mediaSection.video.fast_forward(-5000)
            }
            ToolTip.visible: hovered
            ToolTip.text: "-5s"

            transform: [
              Matrix4x4 {
                matrix: Qt.matrix4x4(-1, 0, 0, 35, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)
              }
            ]
        }
        Button {
            Layout.leftMargin: 2
            Layout.topMargin: (controlTape.height-height)/2
            Layout.preferredHeight: 30
            Layout.preferredWidth: 30
            Image {
                source: "qrc:/resources/fast-forward.png"
                x: 6; y: 5
                width: 20
                height: 20
            }
            onClicked: {
                mediaSection.video.fast_forward(-1000)
            }
            ToolTip.visible: hovered
            ToolTip.text: "-1s"
            transform: [
              Matrix4x4 {
                matrix: Qt.matrix4x4(-1, 0, 0, 26, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)
              }
            ]
        }
        Button {
            Layout.leftMargin: -9
            Layout.topMargin: (controlTape.height-height)/2
            Layout.preferredHeight: 30
            Layout.preferredWidth: 30
            id: fastForward
            Image {
                source: "qrc:/resources/fast-forward.png"
                x: 6; y: 5
                width: 20
                height: 20
            }
            onClicked: {
                mediaSection.video.fast_forward(1000)
            }
            ToolTip.visible: hovered
            ToolTip.text: "+1s"
        }
        Button {
            Layout.leftMargin: -7
            Layout.topMargin: (controlTape.height-height)/2
            Layout.preferredHeight: 30
            Layout.preferredWidth: 30
            id: fastForward_plus
            Image {
                source: "qrc:/resources/fast-forward_plus.png"
                x: 6; y: 5
                width: 20
                height: 20
            }
            onClicked: {
                mediaSection.video.fast_forward(5000)
            }
            ToolTip.visible: hovered
            ToolTip.text: "+5s"
        }
    }
    Label {
        anchors.left: bottom_firstRowLayout.right
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.leftMargin: 10
        height: 30
        width: 30
        text: (mediaSection.video.position/1000).toFixed(2) + "s"
    }

}
