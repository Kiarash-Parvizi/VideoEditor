import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
// Audio-Cpy
Item {
    id: audioCpy
    height: children[0].height
    function reset() {
        textField_from.text = ""
        textField_to.text = ""
        editorFeedBack.redLine_indicator.set_x(0)
        editorFeedBack.redLine_indicator.set_w(0)
    }

    Rectangle {
        anchors.fill: parent.children[1]
        color: "#1C1C1C"
    }
    Frame {

    RowLayout {
        spacing: 16
        property bool isEnabled: mediaSection.video.hasSource
        Image {
            Layout.preferredHeight: 20
            Layout.preferredWidth: 20
            source: "qrc:/resources/speaker.png"
        }
        Button {
            Layout.leftMargin: -5
            Layout.preferredHeight: 25
            Layout.preferredWidth: 25
            ToolTip.visible: hovered
            enabled: parent.isEnabled
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
                var curFrom = parent.children[2].text
                var curTo = parent.children[3].text
                if (curFrom === "" || (curFrom !== "" && curTo !== "")) {
                    parent.children[3].text = ""
                    parent.children[2].text = val
                    return
                }
                var curFromInt = parseInt(curFrom)
                var curToInt = parseInt(curTo)
                if (val === curFromInt) {
                    return
                }
                if (val > curFromInt) {
                    parent.children[3].text = val
                } else {
                    parent.children[2].text = val
                    parent.children[3].text = curFrom
                }
            }
        }
        TextField{
            id: textField_from
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: 80
            placeholderText: "from (ms)"
            readOnly: !mediaSection.video.hasSource
            validator: IntValidator {bottom: 1; top: mediaSection.video.duration}
            onTextChanged: {
                action_textChanged()
                textField_to.action_textChanged()
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
            id: textField_to
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: 80
            placeholderText: "to (ms)"
            readOnly: !mediaSection.video.hasSource
            validator: IntValidator {bottom: 1; top: mediaSection.video.duration}
            onTextChanged: {
                textField_from.action_textChanged()
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
            ToolTip.text: "Copy Audio"
            enabled: parent.isEnabled
            Image {
                source: "qrc:/resources/cpy.png"
                y: parent.width*0.15
                x: y
                width: parent.width*0.7
                height: parent.height*0.7
            }
            onClicked: {
                parent.start = parseInt(textField_from.text)
                parent.end   = parseInt(textField_to.text)
                parent._source = mediaSection.video.fullVidSource
                parent.hasData = true
                soundEffects.play_done()
            }
        }
        property int start: 0
        property int end  : 0
        property string _source: ""
        property bool hasData: false
        Button {
            focusPolicy: Qt.NoFocus
            Layout.preferredHeight: 25
            Layout.preferredWidth: 25
            ToolTip.visible: hovered
            ToolTip.text: "Paste"
            enabled: parent.isEnabled
            text: "P"; font: fontAssets.eliantoFontLoader.name
            onClicked: {
                if (!parent.hasData) return
                CppTimeLine.add_aaudioBuf(parent._source, parent.start, parent.end);
                soundEffects.play_done()
            }
        }
    }
    }
}
