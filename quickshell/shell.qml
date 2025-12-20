import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

ShellRoot {
    id: root

    property color colBg: "#1a1b26"
    property color colFg: "#a9b1d6"
    property color colMuted: "#444b6a"
    property color colCyan: "#0db9d7"
    property color colPurple: "#ad8ee6"
    property color colRed: "#f7768e"
    property color colYellow: "#e0af68"
    property color colBlue: "#7aa2f7"

    property string fontFamily: "JetBrainsMono NFM SemiBold"
    property int fontSize: 16

    property string datetimeFormat: " ddd, MMM dd |  HH:mm"

    property string kernelVersion
    property double memTotal: 0
    property double memUsed: 0
    property int diskUsage: 0
    property string networkInfo
    property int volumeLevel: 0
    property bool volumeMuted: false
    property string activeWindow
    property int notificationCount: 0
    property string currentLayout

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

    Process {
        id: windowProc
        command: ["sh", "-c", "hyprctl activewindow -j | jq -r '.initialTitle // empty'"]
        stdout: SplitParser {
            onRead: data => {
                if (data && data.trim()) {
                    activeWindow = data.trim()
                }
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: layoutProc
        command: ["sh", "-c", "hyprctl activewindow -j | jq -r 'if .floating then \" Floating\" elif .fullscreen == 1 then \" Fullscreen\" else \" Tiled\" end'"]
        stdout: SplitParser {
            onRead: data => {
                if (data && data.trim()) {
                    currentLayout = data.trim()
                }
            }
        }
        Component.onCompleted: running = true
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            windowProc.running = true
            layoutProc.running = true
        }
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

    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: {
            layoutProc.running = true
            windowProc.running = true
            volProc.running = true
            notiProc.running = true
        }
    }

    PanelWindow {
        screen: Quickshell.screens.find(s => s.name === "HDMI-A-1")

        anchors {
            top: true
            left: true
            right: true
        }

        implicitHeight: 30
        color: root.colBg

        margins {
            top: 0
            bottom: 0
            left: 0
            right: 0
        }

        Rectangle {
            anchors.fill: parent
            color: root.colBg

            RowLayout {
                anchors.fill: parent
                spacing: 0

                Item { width: 16 }

                Text {
                    text: " " + kernelVersion
                    color: root.colRed
                    font.pixelSize: root.fontSize
                    font.family: root.fontFamily
                    font.bold: true

                    Rectangle {
                        width: parent.width
                        height: 2
                        color: root.colRed
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 1
                    Layout.preferredHeight: 16
                    Layout.alignment: Qt.AlignVCenter
                    Layout.leftMargin: 8
                    Layout.rightMargin: 8
                    color: root.colMuted
                }

                Repeater {
                    model: 10

                    Rectangle {
                        Layout.preferredWidth: 20
                        Layout.preferredHeight: parent.height
                        color: "transparent"

                        property var workspace: Hyprland.workspaces.values.find(ws => ws.id === index + 1) ?? null
                        property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                        property bool hasWindows: workspace !== null

                        Text {
                            text: index + 1 !== 10 ? index + 1 : ""
                            color: layoutMouseArea.containsMouse ? root.colFg : (parent.isActive ? root.colCyan : (parent.hasWindows ? root.colCyan : root.colMuted))
                            font.pixelSize: root.fontSize
                            font.family: root.fontFamily
                            font.bold: true
                            anchors.centerIn: parent
                        }

                        Rectangle {
                            width: 20
                            height: 3
                            color: parent.isActive ? root.colPurple : root.colBg
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                        }

                        MouseArea {
                            id: layoutMouseArea
                            anchors.fill: parent
                            onClicked: Hyprland.dispatch("workspace " + (index + 1))
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 1
                    Layout.preferredHeight: 16
                    Layout.alignment: Qt.AlignVCenter
                    Layout.leftMargin: 8
                    Layout.rightMargin: 8
                    color: root.colMuted
                }

                Text {
                    text: currentLayout
                    color: root.colFg
                    font.pixelSize: root.fontSize
                    font.family: root.fontFamily
                    font.bold: true
                    Layout.leftMargin: 8
                }

                Rectangle {
                    Layout.preferredWidth: 1
                    Layout.preferredHeight: 16
                    Layout.alignment: Qt.AlignVCenter
                    Layout.leftMargin: 8
                    Layout.rightMargin: 8
                    color: root.colMuted
                }

                Text {
                    text: activeWindow
                    color: root.colFg
                    font.pixelSize: root.fontSize
                    font.family: root.fontFamily
                    font.bold: true
                    Layout.fillWidth: true
                    Layout.leftMargin: 8
                }

                Text {
                    id: clockText
                    text: Qt.formatDateTime(new Date(), datetimeFormat)
                    color: root.colCyan
                    font.pixelSize: root.fontSize
                    font.family: root.fontFamily
                    font.bold: true
                    anchors.centerIn: parent

                    Timer {
                        interval: 1000
                        running: true
                        repeat: true
                        onTriggered: clockText.text = Qt.formatDateTime(new Date(), datetimeFormat)
                    }
                }

                Text {
                    text: networkInfo
                    color: root.colYellow
                    font.pixelSize: root.fontSize
                    font.family: root.fontFamily
                    font.bold: true

                    Rectangle {
                        width: parent.width
                        height: 2
                        color: root.colYellow
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                    }

                    MouseArea {
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

                Rectangle {
                    Layout.preferredWidth: 1
                    Layout.preferredHeight: 16
                    Layout.alignment: Qt.AlignVCenter
                    Layout.leftMargin: 8
                    Layout.rightMargin: 8
                    color: root.colMuted
                }

                Text {
                    text: " Mem: " + memUsed.toFixed(2) + "/" + memTotal.toFixed(2) + " GB"
                    color: root.colCyan
                    font.pixelSize: root.fontSize
                    font.family: root.fontFamily
                    font.bold: true

                    Rectangle {
                        width: parent.width
                        height: 2
                        color: root.colCyan
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Quickshell.execDetached({
                            command: ["gnome-system-monitor"]
                        });
                        cursorShape: Qt.PointingHandCursor
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 1
                    Layout.preferredHeight: 16
                    Layout.alignment: Qt.AlignVCenter
                    Layout.leftMargin: 8
                    Layout.rightMargin: 8
                    color: root.colMuted
                }

                Text {
                    text: " Disk: " + diskUsage + "%"
                    color: root.colBlue
                    font.pixelSize: root.fontSize
                    font.family: root.fontFamily
                    font.bold: true

                    Rectangle {
                        width: parent.width
                        height: 2
                        color: root.colBlue
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Quickshell.execDetached({
                            command: ["gnome-disks"]
                        });
                        cursorShape: Qt.PointingHandCursor
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 1
                    Layout.preferredHeight: 16
                    Layout.alignment: Qt.AlignVCenter
                    Layout.leftMargin: 8
                    Layout.rightMargin: 8
                    color: root.colMuted
                }

                Text {
                    text: volumeMuted ? " Muted" : (volumeLevel > 50 ? " " : " ") + "Vol: " + volumeLevel + "%"
                    color: root.colPurple
                    font.pixelSize: root.fontSize
                    font.family: root.fontFamily
                    font.bold: true

                    Rectangle {
                        width: parent.width
                        height: 2
                        color: root.colPurple
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            Quickshell.execDetached({
                                command: ["swayosd-client", "--output-volume", "mute-toggle"]
                            })
                        }
                        cursorShape: Qt.PointingHandCursor
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 1
                    Layout.preferredHeight: 16
                    Layout.alignment: Qt.AlignVCenter
                    Layout.leftMargin: 12
                    Layout.rightMargin: 12
                    color: root.colMuted
                }

                Text {
                    text: notificationCount > 0 ? "󱅫" : "󰂚"
                    color: notiMouseArea.containsMouse ? root.colMuted : root.colFg
                    font.pixelSize: 18
                    font.family: root.fontFamily
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

                Item { width: 16 }
            }
        }
    }
}
