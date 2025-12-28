import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

RowLayout {
    property var config

    property int notificationCount: 0

    Process {
        id: notiProc
        command: ["swaync-client", "-c"]
        stdout: SplitParser {
            onRead: data => {
                if (data && data.trim()) {
                    notificationCount = data.trim()
                }
            }
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: {
            notiProc.running = true
        }
    }

    Text {
        text: notificationCount > 0 ? "󱅫" : "󰂚"
        color: notiMouseArea.containsMouse ? config.colMuted : config.colFg
        font.pixelSize: 18
        font.family: config.fontFamily
        font.bold: true


        MouseArea {
            id: notiMouseArea
            anchors.fill: parent
            onClicked: {
                Quickshell.execDetached({
                    command: ["swaync-client", "-t", "--skip-wait"]
                });
            }
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
        }
    }
}
