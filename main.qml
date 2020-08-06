import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Dialogs.qml 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls 2.3
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.12

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
        function set_visibility() {
            visible = !visible
            soundEffects.play_space()
        }
        visible: false
        anchors.bottom: parent.bottom
        width: window.width; height: 98
        Rectangle {
            color: "#101010"
            anchors.fill: parent
            //opacity: 0.4
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
            }
        }
    }

}


