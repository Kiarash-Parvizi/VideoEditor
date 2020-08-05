import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import QtMultimedia 5.12

Item {
    property var _parent: parent
    // ControlButtons
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
                video.focus = true
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
                source: "resources/speaker.png"
                Layout.preferredWidth: 17; Layout.preferredHeight: 17
            }
            Slider {
                Layout.preferredWidth: 80
                value: 0.85
                onValueChanged: {
                    video.set_volume(value)
                }
                Component.onCompleted: {
                    video.set_volume(value)
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
                    visible: video.playbackState != MediaPlayer.PlayingState
                    source: "resources/play-button_sm.png"
                    x: 7; y: 7
                    width: 20
                    height: 20
                }
                Image {
                    id: pauseImg
                    visible: !playImg.visible
                    source: "resources/pause.png"
                    x: 7; y: 7
                    width: 20
                    height: 20
                }
                onClicked: {
                    video.set_play()
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
                    source: "resources/fast-forward_plus.png"
                    x: 6; y: 5
                    width: 20
                    height: 20
                }
                onClicked: {
                    video.fast_forward(-5000)
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
                    source: "resources/fast-forward.png"
                    x: 6; y: 5
                    width: 20
                    height: 20
                }
                onClicked: {
                    video.fast_forward(-1000)
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
                    source: "resources/fast-forward.png"
                    x: 6; y: 5
                    width: 20
                    height: 20
                }
                onClicked: {
                    video.fast_forward(1000)
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
                    source: "resources/fast-forward_plus.png"
                    x: 6; y: 5
                    width: 20
                    height: 20
                }
                onClicked: {
                    video.fast_forward(5000)
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
            text: (video.position/1000).toFixed(2) + "s"
        }

    }

    // TimeLine
    Rectangle {
        id: timeLine
        width: parent.width
        height: 32
        //color: "#0C090A"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 43

        function setPointerPosition(d) {
            timePointer.x = d*width
        }

        //LINES
        Rectangle {
            width: parent.width
            height: 1
            opacity: 0.2
            color: "black"
            y: parent.height/4
        }
        Rectangle {
            id: midLine
            width: parent.width
            height: 2
            opacity: 0.2
            color: "black"
            y: parent.height/2
        }
        Rectangle {
            width: parent.width
            height: 1
            opacity: 0.2
            color: "black"
            y: parent.height*3/4
        }

        // Pointer
        Rectangle {
            id:timePointer
            Rectangle {
                id: timePointer_circle
                anchors.centerIn: parent
                width: 6; height: 4
                color: "#1F45FD"
                radius: width/2
            }

            width: 4
            height: parent.height
            color: "#1F45FC"
        }


        MouseArea {
            anchors.fill: parent
            onMouseXChanged: {
                //print(mouseX)
                var diam = timePointer.width/2
                var newX = mouseX-diam
                if (newX < -diam) {
                    newX = -diam
                }
                if (newX > parent.width-diam) {
                    newX = parent.width-diam
                }
                timePointer.x = newX
                video.seek(video.duration*newX/width)
            }
        }
        Glow {
            anchors.fill: midLine
            radius: 8
            samples: 19
            color: "#3060D7"
            source: midLine
        }
        Glow {
            anchors.fill: timeTail
            radius: 10
            samples: 19
            color: "#5080A7"
            source: midLine
        }
        // Tail
        Rectangle {
            id: timeTail
            color: "#1a49c9";
            y: midLine.y
            height: 2; width: timePointer.x
        }

        // timePointer Effects
        Glow {
            anchors.fill: timePointer
            radius: 10
            samples: 19
            color: "#4090C7"
            source: timePointer
        }
    }
}
