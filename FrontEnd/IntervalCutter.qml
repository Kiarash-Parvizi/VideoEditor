import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
// Interval-Cutter
Item {
    id: intervalCutter
    height: children[0].height
    function reset() {
        intervalCutter_textField_from.text = ""
        intervalCutter_textField_to.text = ""
        editorFeedBack.redLine_indicator.set_x(0)
        editorFeedBack.redLine_indicator.set_w(0)
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
            enabled: mediaSection.video.hasSource
            ToolTip.text: "add current position"
            focusPolicy: Qt.NoFocus
            Image {
                source: "qrc:/resources/plus.png"
                y: parent.width*0.15
                x: y
                width: parent.width*0.7
                height: parent.height*0.7
            }
            onClicked: {
                var val = mediaSection.video.position
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
            readOnly: !mediaSection.video.hasSource
            validator: IntValidator {bottom: 1; top: mediaSection.video.duration}
            onTextChanged: {
                action_textChanged()
                intervalCutter_textField_to.action_textChanged()
                soundEffects.play_done()
            }
            function action_textChanged() {
                var val = text.length > 0 ? parseInt(text) : 0
                if (val > mediaSection.video.duration) {
                    text = mediaSection.video.duration
                }
                editorFeedBack.redLine_indicator.set_x(val/mediaSection.video.duration)
            }
        }
        TextField{
            id: intervalCutter_textField_to
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: 80
            placeholderText: "to (ms)"
            readOnly: !mediaSection.video.hasSource
            validator: IntValidator {bottom: 1; top: mediaSection.video.duration}
            onTextChanged: {
                intervalCutter_textField_from.action_textChanged()
                action_textChanged()
                soundEffects.play_done()
            }
            function action_textChanged() {
                var val = text.length > 0 ? parseInt(text) : 0
                if (val > mediaSection.video.duration) {
                    text = mediaSection.video.duration
                }
                editorFeedBack.redLine_indicator.set_w(val/mediaSection.video.duration)
            }
        }
        Button {
            focusPolicy: Qt.NoFocus
            Layout.preferredHeight: 25
            Layout.preferredWidth: 25
            ToolTip.visible: hovered
            ToolTip.text: "Cut"
            Image {
                source: "qrc:/resources/scissors.png"
                y: parent.width*0.15
                x: y
                width: parent.width*0.7
                height: parent.height*0.7
            }
            onClicked: {
                intervalCutter.reset()
            }
        }
        Button {
            focusPolicy: Qt.NoFocus
            Layout.preferredHeight: 23
            Layout.preferredWidth: 23
            ToolTip.visible: hovered
            ToolTip.text: "Undo"
            Image {
                source: "qrc:/resources/undo.png"
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
                source: "qrc:/resources/redo.png"
                y: parent.width*0.15
                x: y
                width: parent.width*0.7
                height: parent.height*0.7
            }
        }
    }
    }
}
