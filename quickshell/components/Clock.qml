import QtQuick

Text {
    property var config

    property string datetimeFormat: " MMM dd (ddd) |  HH:mm"

    id: clockText
    text: Qt.formatDateTime(new Date(), datetimeFormat)
    color: config.colCyan
    font.pixelSize: config.fontSize
    font.family: config.fontFamily
    font.bold: true
    anchors.centerIn: parent

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: clockText.text = Qt.formatDateTime(new Date(), datetimeFormat)
    }
}
