import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Dialogs.qml 1.0
import QtQuick.Shapes 1.11
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtMultimedia 5.12
import QtQuick.Controls 2.12
import QtQuick.Controls 2.3
import QtQuick.Dialogs 1.2

// This hell was written by hand :)

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

    // MenuBar
    menuBar: MenuBar{
        background: Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color	: "#FDFEFE" }
                GradientStop { position: 0.5; color : "#F7F9F9" }
                GradientStop { position: 1.0; color	: "#F0F3F4" }
            }
        }

        Menu {
            title: "File"
            Action {
                text: "Add"
                onTriggered: {
                    soundEffects.play_done()
                    fileDialog.getFiles(mediaMenu.addMedias)
                }
            }
            Action {
                text: "Open"
                onTriggered: {
                    soundEffects.play_done()
                }
            }
            Action {
                text: "Save"
                onTriggered: {
                    soundEffects.play_done()
                }
            }
            onOpened: {
                soundEffects.play_done()
            }
        }
        Menu {
            title: "Help"
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
            Action {
                text: "About"
                onTriggered: {
                    aboutDialog.open()
                    soundEffects.play_done()
                }
            }
            onOpened: {
                soundEffects.play_done()
            }
        }
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

    // upper Shadow
    Rectangle {
        id: upperShadow
        anchors.top: parent.top
        width: parent.width; height: 2
        color: "#0B0B0B"
        z: 1
    }
    Glow {
        anchors.fill: upperShadow
        radius: 10
        samples: 20
        color: "#0B0B0B"
        source: upperShadow
        z: 1
    }

    // BackGround
    Rectangle {
        color: "#1E1E1E"
        visible: true
        anchors.fill: parent
        MouseArea {
            anchors.fill: parent
            onPressed: {
                video.focus = true
            }
        }
    }

    MouseBox {
        anchors.fill: parent
        visible: false
    }

    // SplitView
    SplitView {
        anchors.fill: parent
        anchors.bottomMargin: 100
        orientation: Qt.Horizontal
        // Video
        Item {
            id: videoContainer
            width: window.width*0.68
            Layout.minimumWidth: window.width*0.65

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
                anchors.centerIn: parent
                property bool blackScreen: true
                property bool hasSource: false
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
                    visible: !video.hasVideo && video.hasSource
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
                    print("Pos Changed")
                    var ratio = position/duration
                    timeLine.setPointerPosition(ratio)
                    focus = true
                }
                // Source Changed
                onSourceChanged: {
                    video.hasSource = true
                    redLine_indicator.reset()
                    mainMenu.reset_all()
                }
            }
        }

        Rectangle {
            Layout.minimumWidth: window.width*0.3
            color: "#2C2C2C"

            // blueRect Style
            Rectangle {
                id: glowLine_1
                color: "#3060D7"
                width: 1; height: parent.height
                anchors.right: parent.right
                opacity: 0.3
            }
            Glow {
                anchors.fill: glowLine_1
                radius: 8
                samples: 19
                color: "#3060D7"
                source: glowLine_1
                opacity: 0.3
            }

            // Right Menu
            Flickable {
                id: rightMenu
                height: parent.height
                width: parent.width
                contentHeight: mainMenu.height
                contentWidth: parent.width

                // Tools & Components
                ColumnLayout {
                    id: mainMenu
                    spacing: 10
                    width: parent.width

                    property var childs: Array.from(children)
                    function reset_all() {
                        childs.forEach(function(child) {
                            child.reset()
                        })
                    }

                    // Interval-Cutter
                    Item {
                        id: intervalCutter
                        height: children[0].height
                        Layout.topMargin: 16
                        Layout.leftMargin: 20
                        function reset() {
                            intervalCutter_textField_from.text = ""
                            intervalCutter_textField_to.text = ""
                        }

                        Rectangle {
                            id: intervalCutter_bg
                            anchors.fill: parent.children[1]
                            color: "#1C1C1C"
                        }
                        Frame {

                        RowLayout {
                            spacing: 16
                            Button {
                                Layout.preferredHeight: 25
                                Layout.preferredWidth: 25
                                ToolTip.visible: hovered
                                ToolTip.text: "add current position"
                                focusPolicy: Qt.NoFocus
                                Image {
                                    source: "resources/plus.png"
                                    y: parent.width*0.15
                                    x: y
                                    width: parent.width*0.7
                                    height: parent.height*0.7
                                }
                                onClicked: {
                                    var val = video.position
                                    var curFrom = parent.children[1].text
                                    var curTo = parent.children[2].text
                                    if (curFrom === "" || (curFrom !== "" && curTo !== "")) {
                                        parent.children[2].text = ""
                                        parent.children[1].text = val
                                        return
                                    }
                                    var curFromInt = parseInt(curFrom)
                                    var curToInt = parseInt(curTo)
                                    if (val === curFromInt) {
                                        return
                                    }
                                    if (val > curFromInt) {
                                        parent.children[2].text = val
                                    } else {
                                        parent.children[1].text = val
                                        parent.children[2].text = curFrom
                                    }
                                }
                            }
                            TextField{
                                id: intervalCutter_textField_from
                                Layout.alignment: Qt.AlignCenter
                                Layout.preferredWidth: 80
                                placeholderText: "from (ms)"
                                validator: IntValidator {bottom: 1; top: video.duration}
                                onTextChanged: {
                                    var val = text.length > 0 ? parseInt(text) : 0
                                    if (val > video.duration) {
                                        text = video.duration
                                    }
                                    redLine_indicator.set_x(val/video.duration)
                                    soundEffects.play_done()
                                }
                            }
                            TextField{
                                id: intervalCutter_textField_to
                                Layout.alignment: Qt.AlignCenter
                                Layout.preferredWidth: 80
                                placeholderText: "to (ms)"
                                validator: IntValidator {bottom: 1; top: video.duration}
                                onTextChanged: {
                                    var val = text.length > 0 ? parseInt(text) : 0
                                    if (val > video.duration) {
                                        text = video.duration
                                    }
                                    redLine_indicator.set_w(val/video.duration)
                                    soundEffects.play_done()
                                }
                            }
                            Button {
                                focusPolicy: Qt.NoFocus
                                Layout.preferredHeight: 25
                                Layout.preferredWidth: 25
                                ToolTip.visible: hovered
                                ToolTip.text: "Cut"
                                Image {
                                    source: "resources/scissors.png"
                                    y: parent.width*0.15
                                    x: y
                                    width: parent.width*0.7
                                    height: parent.height*0.7
                                }
                            }
                            Button {
                                focusPolicy: Qt.NoFocus
                                Layout.preferredHeight: 23
                                Layout.preferredWidth: 23
                                ToolTip.visible: hovered
                                ToolTip.text: "Undo"
                                Image {
                                    source: "resources/undo.png"
                                    y: parent.width*0.15
                                    x: y
                                    width: parent.width*0.7
                                    height: parent.height*0.7
                                }
                            }
                            Button {
                                focusPolicy: Qt.NoFocus
                                Layout.preferredHeight: 23
                                Layout.preferredWidth: 23
                                Layout.leftMargin: -12
                                ToolTip.visible: hovered
                                ToolTip.text: "Redo"
                                Image {
                                    source: "resources/redo.png"
                                    y: parent.width*0.15
                                    x: y
                                    width: parent.width*0.7
                                    height: parent.height*0.7
                                }
                            }
                        }
                        }
                    }
                    Rectangle {
                        color: "red"
                        width: 10
                        height: 10
                        function reset() {}
                    }
                }
            }
        }

    }

    // ControlView
    Item {
        width: parent.width; height: 42
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 75

        Rectangle {
            anchors.bottom: parent.bottom
            color: "white"
            width: Window.width; height: 23
        }
        // some style
        Rectangle {
            id: glowLine_vr_1
            color: "#5080A7"
            width: Window.width; height: 2
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 23
        }
        Glow {
            anchors.fill: glowLine_vr_1
            radius: 9
            samples: 20
            color: "#5080A7"
            source: glowLine_vr_1
        }
        Rectangle {
            color: "red"
        }

        Image {
            id: ruler
            property int init_width: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2
            width: init_width; height: 12
            source: "resources/ruler.png"
            OpacityMask {
                source: ruler_mask
                maskSource: ruler
            }

            LinearGradient {
                id: ruler_mask
                anchors.fill: parent
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "white" }
                    GradientStop { position: 0.5; color: "transparent"}
                }
            }
            Component.onCompleted: {
                init_width = Window.width*1.05
            }
            Rectangle {
                color: "#3d3d40"
                anchors.bottom: parent.bottom
                width: parent.width
                height: 2
                y: parent.height
            }
            Rectangle {
                id: ruler_blueLine
                color: "#3060D7"
                opacity: 0.5
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 3
                width: parent.width
                height: 2
                y: parent.height
            }
            Glow {
                anchors.fill: ruler_blueLine
                radius: 8
                opacity: 0.5
                samples: 20
                color: "#3060D7"
                source: ruler_blueLine
            }
            // Red Indicators
            Rectangle {
                id: redLine_indicator
                color: "red"
                opacity: 0.5
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 3
                width: 2
                height: 4
                y: parent.height
                function set_x(x_r) {
                    x = x_r * window.width
                }
                function set_w(w_r) {
                    if (w_r === 0) {
                        width = 2; return
                    }
                    width = w_r * window.width - x + 2
                }
                function reset() {
                    width = 2
                }
            }
        }
    }

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















