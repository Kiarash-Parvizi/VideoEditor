import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
// Interval-Cutter
Item {
    height: children[0].height
    function reset() {
        textField_from.text = ""
        textField_to.text = ""
    }
    function set(v1, v2) {
        if (v1 < v2) {
            if (v1 < 0 || v2 > CppTimeLine.totalVidLen) return
            textField_from.text = parseInt(v1); textField_to.text = parseInt(v2)
        } else {
            if (v2 < 0 || v1 > CppTimeLine.totalVidLen) return
            textField_from.text = parseInt(v2); textField_to.text = parseInt(v1)
        }
    }

    Rectangle {
        anchors.fill: parent.children[1]
        color: "#1C1C1C"
    }
    Frame {

    RowLayout {
        spacing: 16
        property bool isEnabled: mediaSection.video.hasSource
        Rectangle {
            Layout.preferredHeight: 25
            Layout.preferredWidth: 25
            border.width: 1; border.color: "black"
            radius: width/2
        }

        TextField{
            id: textField_from
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: 80
            placeholderText: "from (ms)"
            readOnly: !mediaSection.video.hasSource
            validator: IntValidator {bottom: 1; top: mediaSection.video.duration}
        }
        TextField {
            id: textField_to
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: 80
            placeholderText: "to (ms)"
            readOnly: !mediaSection.video.hasSource
            validator: IntValidator {bottom: 1; top: mediaSection.video.duration}
        }
        Button {
            focusPolicy: Qt.NoFocus
            Layout.preferredHeight: 25
            Layout.preferredWidth: 25
            ToolTip.visible: hovered
            ToolTip.text: "Cut"
            enabled: true
            Image {
                source: "qrc:/resources/scissors.png"
                y: parent.width*0.15
                x: y
                width: parent.width*0.7
                height: parent.height*0.7
            }
            onClicked: {
                if (textField_from.text.length === 0 || textField_to.text.length === 0) return
                CppTimeLine.cut_interval(textField_from.text, textField_to.text)
                timeLine.tl_ptr.reset()
                soundEffects.play_done()
                timeLine.reset()
            }
        }
    }
    }
}
