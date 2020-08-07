import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Dialogs.qml 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls 2.3
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

// Basu-Video-Editor FrontEnd

ApplicationWindow {
    id: window
    visible: true
    width: Screen.width*2/3
    height: Screen.height*2/3 + 200
    minimumWidth: Screen.width*0.65
    minimumHeight: Screen.height*0.65 + 200
    maximumWidth: Screen.width*0.7
    maximumHeight: Screen.height*0.7 + 200
    title: qsTr("Video Editor")

    SoundEffects {
        id: soundEffects
    }

    // FontAssets
    FontLoader {
        id: eliantoFontLoader
        source: "resources/fonts/Elianto-Regular.ttf"
    }


    // Dialogs + extra-windows
    Window {
        id: exportWindow
        title: "Export"
        minimumWidth: window.minimumWidth*0.4; minimumHeight: window.minimumHeight*0.4
        maximumWidth: window.maximumWidth*0.41; maximumHeight: window.maximumHeight*0.42
        Rectangle {
            anchors.fill: parent
            color: "#101010"
        }
    }

    FileDialog {
        id: fileDialog
        title: "Please choose your files"
        folder: shortcuts.home
        selectMultiple: true
        property var callback: function() {}
        onAccepted: {
            callback(fileUrls)
        }
        function getFiles(callBack) {
            callback = callBack
            open()
        }
    }

    // about-dialogs
    Dialog {
        id: aboutDialog
        title: "About"
        ColumnLayout {
            Label {
                text: "This project was developed by"
            }
            Label {
                Layout.alignment: Layout.Center
                text: "<a href='https://github.com/Kiarash-Parvizi'>Kiarash</a>"
                onLinkActivated: Qt.openUrlExternally(link)
            }
        }
    }

    // ---------


    // MenuBar
    menuBar: ProjectMenuBar {
    }

    SciButton {
        anchors.left: window.left
        anchors.top: window.top
        focusPolicy: Qt.NoFocus
        //click
        onClicked: {
            drawer.open()
            soundEffects.play_mouse()
        }
    }

    //Item {
    //    anchors.left: parent.left; anchors.top: parent.top
    //    anchors.topMargin: 20
    //    width: window.width*0.01; height: window.height*0.1
    //    z: 1
    //    Rectangle {
    //        anchors.fill: parent
    //    }
    //    MouseArea {
    //        anchors.fill: parent
    //        hoverEnabled: true
    //        onHoveredChanged: {
    //            drawer.open()
    //            soundEffects.play_mouse()
    //        }
    //    }
    //}

    Drawer {
        z: 10
        id: drawer
        width: 0.3 * window.width
        height: window.height
        interactive: true

        ItemMenu {
            id: mediaMenu
            anchors.fill: parent
        }
    }

    // BackGround + TinyStyles
    TinyStyles {
    }

    // SplitView
    SplitView {
        anchors.fill: parent
        anchors.bottomMargin: 100
        orientation: Qt.Horizontal

        MediaSection {
            id: mediaSection
        }

        ToolMenu {
            id: toolMenu
        }

    }

    // VideoControls
    Item {
        anchors.fill: parent
        // Editor-FeedBack
        EditorFeedBack {
            id: editorFeedBack
        }
        // Basic-Video-Controls
        BasicVideoControls {
            visible: !timeLine.visible
        }
        // Video-Slider
        VideoSlider {
            visible: !timeLine.visible
            id: videoSlider
        }
    }

    // TimeLine
    Item {
        id: timeLine
        function setMode() {
            visible = !visible
            mediaSection.video.timeLineMode = visible
            soundEffects.play_space()
        }
        visible: false
        anchors.bottom: parent.bottom
        width: window.width; height: 98
        property real progressRatio: 0
        // bg
        Rectangle {
            color: "#101010"
            anchors.fill: parent
            //opacity: 0.4
        }
        // mouse
        MouseArea {
            anchors.fill: parent
            property int startX: 0
            onPressed: {
                startX = mouseX
                trace.x = mouseX
                trace.width = 0
                pointer.x = mouseX
            }
            onPressedChanged: {
                soundEffects.play_done_low()
            }
            onMouseXChanged: {
                var coord_x = mouseX
                pointer2.x = mouseX
                timeLine.progressRatio = mouseX/width
                if (coord_x < 0) {
                    coord_x = 0
                } else if (coord_x > width) {
                    coord_x = width
                }
                //
                //print("X: " + coord_x)
                var d = coord_x - startX
                if (d === 0) {
                    return
                } if (d > 0) {
                    trace.x = startX
                    trace.width = d
                } else {
                    trace.x = coord_x;
                    trace.width = -d
                }
            }
        }
        // sepLine
        Item {
            anchors.fill: parent
            Rectangle {
                anchors.verticalCenter: parent.verticalCenter; z: 1
                height: 2; width: parent.width; color: "#4474D7"
            }
            Glow {
                anchors.fill: parent.children[0]; color: "#010101"
                samples: 18; radius: 7; source: parent.children[0];
            }
        }
        // pointer + trace container
        Item {
            anchors.fill: parent
            // Pointer
            Rectangle {
                id: pointer
                width: 1; height: parent.height; color: "#3060C0"; z: 2
            }
            // Pointer2
            Rectangle {
                id: pointer2
                width: 1; height: parent.height; color: "#3060C0"; z: 2
            }
            // Trace
            Rectangle {
                id: trace
                width: 2; height: parent.height; color: "#3060C0"; z: 2
                opacity: 0.1
            }
            DropShadow {
                anchors.fill: parent.children[0]; source: parent.children[0]
                horizontalOffset: 2; verticalOffset: 0
                radius: 2; samples: 17; color: "black"
            }
            DropShadow {
                anchors.fill: parent.children[0]; source: parent.children[0]
                horizontalOffset: -2; verticalOffset: 0
                radius: 2; samples: 17; color: "black"
            }
            DropShadow {
                anchors.fill: parent.children[1]; source: parent.children[0]
                horizontalOffset: 2; verticalOffset: 0
                radius: 2; samples: 17; color: "black"
            }
            DropShadow {
                anchors.fill: parent.children[1]; source: parent.children[0]
                horizontalOffset: -2; verticalOffset: 0
                radius: 2; samples: 17; color: "black"
            }
        }
    }

}


