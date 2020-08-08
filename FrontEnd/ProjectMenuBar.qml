import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

MenuBar{
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
                text: "Import"
                onTriggered: {
                    soundEffects.play_done()
                    fileDialog.getFiles(mediaMenu.addMedias)
                }
            }
            Action {
                text: "Export"
                onTriggered: {
                    exportWindow.show()
                    soundEffects.play_done()
                }
            }

            Action {
                text: "Open Project"
                onTriggered: {
                    soundEffects.play_done()
                }
            }
            Action {
                text: "Save Project"
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
