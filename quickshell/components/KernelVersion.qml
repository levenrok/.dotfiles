import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

RowLayout {
    property var config

    property string kernelVersion

    Process {
        id: kernelProc
        command: ["uname", "-r"]
        stdout: SplitParser {
            onRead: data => {
                if (data) kernelVersion = data.trim()
            }
        }
        Component.onCompleted: running = true
    }

    Text {
        text: " " + kernelVersion
        color: kernelVersionMouseArea.containsMouse ? config.colFg : config.colRed
        font.pixelSize: config.fontSize
        font.family: config.fontFamily
        font.bold: true

        Rectangle {
            width: parent.width
            height: 2
            color: kernelVersionMouseArea.containsMouse ? config.colFg : config.colRed
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
        }

        MouseArea {
            id: kernelVersionMouseArea
            anchors.fill: parent
            onClicked: {
                Quickshell.execDetached({
                    command: ["ghostty"]
                });
            }
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
        }
    }
}
