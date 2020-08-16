import QtQuick 2.0

Item {
    function getMediaName(path, addDotsIfNeeded = true) {
        var fullName = (path.slice(path.lastIndexOf("/")+1))
        if (fullName.length > 40) {
            return fullName.slice(0, 40) + (addDotsIfNeeded ? "..." : "")
        }
        return fullName
    }
}
