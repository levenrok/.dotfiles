import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

RowLayout {
    property var config

    property double memTotal: 0
    property double memUsed: 0
    property int diskUsage: 0
    property string networkInfo
    property int volumeLevel: 0
    property bool volumeMuted: false

    Process {
        id: memProc
        command: ["sh", "-c", "free | grep Mem"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return

                var parts = data.trim().split(/\s+/)
                var total = parseInt(parts[1]) || 1
                var used = parseInt(parts[2]) || 0
                memTotal = (total / 1000) / 1000

                memUsed = (used / 1000) / 1000
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: diskProc
        command: ["sh", "-c", "df / | tail -1"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return

                var parts = data.trim().split(/\s+/)
                var percentStr = parts[4] || "0%"

                diskUsage = parseInt(percentStr.replace('%', '')) || 0
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: netProc
        command: ["bash", "-c", "$HOME/.local/bin/scripts/info/get_connection"]
        stdout: SplitParser {
            onRead: data => {
                if (data && data.trim()) {
                    networkInfo = data.trim()
                }
            }
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            memProc.running = true
            diskProc.running = true
            netProc.running = true
        }
    }

    Process {
        id: volProc
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return

                var volume = data.match(/Volume:\s*([\d.]+)/)

                if (volume) volumeLevel = Math.round(parseFloat(volume[1]) * 100)
                volumeMuted = data.includes("[MUTED]")
            }
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: {
            volProc.running = true
        }
    }

    Text {
        text: networkInfo
        color: networkInfoMouseArea.containsMouse ? config.colFg : config.colYellow
        font.pixelSize: config.fontSize
        font.family: config.fontFamily
        font.bold: true

        Rectangle {
            width: parent.width
            height: 2
            color: networkInfoMouseArea.containsMouse ? config.colFg : config.colYellow
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
        }

        MouseArea {
            id: networkInfoMouseArea
            anchors.fill: parent
            onClicked: {
                Quickshell.execDetached({
                    command: ["bash", "-c", "$HOME/.local/bin/scripts/menu/network"]
                });
            }
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
        }
    }

    Separator { config: config }

    Text {
        text: " Mem: " + memUsed.toFixed(2) + "/" + memTotal.toFixed(2) + " GB"
        color: memInfoMouseArea.containsMouse ? config.colFg : config.colCyan
        font.pixelSize: config.fontSize
        font.family: config.fontFamily
        font.bold: true

        Rectangle {
            width: parent.width
            height: 2
            color: memInfoMouseArea.containsMouse ? config.colFg : config.colCyan
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
        }

        MouseArea {
            id: memInfoMouseArea
            anchors.fill: parent
            onClicked: Quickshell.execDetached({
                command: ["gnome-system-monitor"]
            });
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
        }
    }

    Separator { config: config }

    Text {
        text: " Disk: " + diskUsage + "%"
        color: diskUsageMouseArea.containsMouse ? config.colFg : config.colBlue
        font.pixelSize: config.fontSize
        font.family: config.fontFamily
        font.bold: true

        Rectangle {
            width: parent.width
            height: 2
            color: diskUsageMouseArea.containsMouse ? config.colFg : config.colBlue
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
        }

        MouseArea {
            id: diskUsageMouseArea
            anchors.fill: parent
            onClicked: Quickshell.execDetached({
                command: ["gnome-disks"]
            });
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
        }
    }

    Separator { config: config }

    Text {
        text: volumeMuted ? " Muted" : (volumeLevel > 50 ? " " : " ") + "Vol: " + volumeLevel + "%"
        color: volumeInfoMouseArea.containsMouse ? config.colFg : config.colPurple
        font.pixelSize: config.fontSize
        font.family: config.fontFamily
        font.bold: true

        Rectangle {
            width: parent.width
            height: 2
            color: volumeInfoMouseArea.containsMouse ? config.colFg : config.colPurple
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
        }
        MouseArea {
            id: volumeInfoMouseArea
            anchors.fill: parent
            onClicked: {
                Quickshell.execDetached({
                    command: ["swayosd-client", "--output-volume", "mute-toggle"]
                })
            }
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
        }
    }
}
