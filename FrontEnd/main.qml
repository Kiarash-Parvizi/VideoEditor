import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Dialogs.qml 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls 2.3
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

import "./Window"
import "./TimeLine"
import "./Style"
import "./RC"

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
    title: qsTr("Basu Video Editor")

    Util {
        id: util
    }

    SoundEffects {
        id: soundEffects
    }

    FontAssets {
        id: fontAssets
    }


    // Dialogs + extra-windows // ------------
    ExportWindow {
        id: exportWindow
    }

    TrimWindow {
        id: trimWindow
    }

    FileDialog {
        id: fileDialog
        title: "Please choose your files"
        folder: shortcuts.home
        selectMultiple: true
        property var callback: function() {}
        onAccepted: {
            let urls = new Array(fileUrls.length)
            for (let i = 0; i < fileUrls.length; i++) urls[i] = fileUrls[i].toString().substring(8)
            //for (let i = 0; i < urls.length; i++) print(":->" + urls[i])
            callback(urls)
        }
        function getFiles(callBack) {
            callback = callBack
            open()
        }
    }
    FileDialog {
        id: fileDialog_single
        title: "Please choose your file"
        folder: shortcuts.home
        selectMultiple: false
        property var callback: function() {}
        onAccepted: {
            callback(fileUrl.toString().substring(8))
        }
        function getFile(callBack, dialogTitle = "Please choose your file") {
            title = dialogTitle
            callback = callBack
            open()
        }
    }
    FileDialog {
        id: folderDialog
        title: "Please choose your folder"
        selectFolder: true
        selectMultiple: false
        folder: shortcuts.home
        property var callback: function() {}
        onAccepted: {
            print("folder: " + folder.toString().substring(8))
            callback(folder.toString(8).substring(8))
        }
        function getFolder(callBack) {
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
        dragMargin: mediaSection.timeLineMode ? 0 : Qt.styleHints.startDragDistance

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

    TimeLine {
        id: timeLine
        anchors.bottom: parent.bottom
    }

    // other events
    onWidthChanged: {
        timeLine.tl_ptr.reset()
        timeLine.tl_data.tl_video.repeater.reCalc()
        editorFeedBack.redLine_indicator.calc()
    }
}


