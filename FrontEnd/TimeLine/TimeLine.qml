import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

// TimeLine
Item {
    id: timeLine
    property alias tl_data: tl_data
    property alias tl_ptr : tl_ptr
    function setMode() {
        visible = !visible
        mediaSection.timeLineMode = visible
        soundEffects.play_space()
    }
    visible: false
    width: window.width; height: 98
    property real progressRatio: 0
    // Play/Pause Button
    Button {
        id: playButton
        anchors.bottom: parent.top; anchors.left: parent.left;
        width: 50; height: 50
        anchors.bottomMargin: 10; anchors.leftMargin: 6
        Image {
            id: playImg
            visible: true
            anchors.centerIn: parent
            source: "qrc:/resources/play-button_sm.png"
        }
        onClicked: {
            focus: true
            soundEffects.play_click()
            ///
            TL_Player.play_pos(tl_ptr.pointer2.x/window.width * CppTimeLine.totalVidLen)
        }
        onEnabledChanged: {
            if (!enabled) focus = false
        }
        enabled: !mediaSection.videoPlus.isLoading
        ToolTip.visible: hovered
        ToolTip.text: playImg.visible ? "Play" : "Pause"
    }
    DropShadow {
        anchors.fill: playButton
        horizontalOffset: -3
        verticalOffset: 3
        radius: 8.0
        samples: 17
        color: "black"
        source: playButton
    }

    // bg
    Rectangle {
        color: "#101010"
        anchors.fill: parent
        //opacity: 0.4
    }
    // mouse
    MouseArea {
        anchors.fill: parent
        property alias trace: tl_ptr.trace
        onPressed: {
            trace.x = mouseX
            trace.width = 0
            tl_ptr.set_ptr1(mouseX)
        }
        onPressedChanged: {
            soundEffects.play_done_low()
        }
        onMouseXChanged: {
            timeLine.progressRatio = mouseX/width
            tl_ptr.set_ptr2(mouseX)
        }
    }
    // Data
    TL_Data {
        id: tl_data
        anchors.fill: parent
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
    TL_Ptr {
        id: tl_ptr
    }
}
