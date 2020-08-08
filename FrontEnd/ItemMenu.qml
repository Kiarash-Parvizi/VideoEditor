import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    function addMedias(meds) {
        var preCount = drawer_listViewId.count
        meds.forEach(function(path) {
            drawer_listViewId.addMedia(path)
        })
        var count = drawer_listViewId.count
        if (preCount !== count) {
            mediaSection.video.set_source(drawer_listModel.get(preCount).source)
            drawer_listViewId.setFocus(preCount)
        }
    }

    ListModel {
        id: drawer_listModel
    }

    ListView {
        id: drawer_listViewId
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.topMargin: 10
        header: Rectangle {
            id: drawerHeaderId
            color: "#e5e4e2"
            width: parent.width - 10
            height: 60
            Label {
                anchors.centerIn: parent
                text: "DOCUMENTS:"
                font.family: fontAssets.eliantoFontLoader.name; font.pointSize: 13;
            }
        }
        property int preSelectedId: -1
        property string rectColor: "#c5c4c2"
        function setFocus(index) {
            if (preSelectedId >= 0 && preSelectedId < count) {
                drawer_listModel.setProperty(preSelectedId, "rectColor", rectColor)
            }
            drawer_listModel.setProperty(index, "rectColor", "#a5a4a2")
            preSelectedId = index
        }

        property var dict: ({})
        function addMedia(path) {
            if (path in dict) {
                return
            }
            dict[path] = true
            drawer_listModel.append({
                "rectColor": rectColor,
                "source": path,
                "name": util.getMediaName(path)
            })
        }

        Component.onCompleted: {
        }

        model: drawer_listModel
        delegate: Rectangle {
            color: rectColor
            border.color: "#555452"
            width: parent.width - 10
            height: 40
            Label {
                anchors.centerIn: parent
                text: name
                font.pointSize: 9
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                function play() {
                    // Action
                    mediaSection.video.set_source(source)
                }

                onClicked: {
                    drawer_listViewId.setFocus(index)
                    soundEffects.play_click()
                    // popup
                    if (mouse.button === Qt.RightButton)
                        contextMenu.popup()
                    else play()
                }
                acceptedButtons: Qt.LeftButton | Qt.RightButton

                Menu {
                    id: contextMenu
                    MenuItem {
                        text: "Select"
                        onClicked: {
                            mouseArea.play()
                            soundEffects.play_done()
                        }
                    }
                    MenuItem {
                        text: "Remove"
                        onClicked: {
                            if (mediaSection.video.fullVidSource === source)
                                mediaSection.video.set_source("")
                            delete drawer_listViewId.dict[source]
                            drawer_listModel.remove(index)
                            soundEffects.play_done()
                        }
                    }
                    z: 20
                }
            }
        }
    }
}
