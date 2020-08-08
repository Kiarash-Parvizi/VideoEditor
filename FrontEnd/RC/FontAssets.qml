import QtQuick 2.12

Item {
    property alias eliantoFontLoader: eliantoFontLoader
    // FontAssets
    FontLoader {
        id: eliantoFontLoader
        source: "qrc:/resources/fonts/Elianto-Regular.ttf"
    }
}
