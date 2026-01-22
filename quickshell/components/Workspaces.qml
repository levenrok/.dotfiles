import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland

RowLayout {
    property var config

    readonly property int itemSize: 19
    readonly property var workspaceTags: ({
        1: "",
        2: "",
        3: "",
        4: "",
        5: "󱘶",
        6: "",
        7: "󰊯",
        8: "",
        9: "",
        10: "󱡶"
    })

    property string activeWindow
    property string currentLayout

    function getWorkspaceTag(id) {
        return workspaceTags[id];
    }

    function truncateWords(str, numWords, suffix) {
        suffix = suffix || "...";
        var words = str.split(" ");
        if (words.length > numWords) {
            return words.slice(0, numWords).join(" ") + suffix;
        }
        return str;
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
        command: ["sh", "-c", "hyprctl activewindow -j | jq -r 'if .floating and .fullscreen == 1 then \"[󰊓]\" elif .floating then \"[]\" elif .fullscreen == 1 then \"[]\" else \"[]\" end'"]
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
        interval: 100
        running: true
        repeat: true
        onTriggered: {
            layoutProc.running = true
            windowProc.running = true
        }
    }

    Repeater {
        model: 10

        Rectangle {
            Layout.preferredWidth: itemSize
            Layout.preferredHeight: parent.height
            color: "transparent"

            property var workspace: Hyprland.workspaces.values.find(ws => ws.id === index + 1) ?? null
            property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
            property bool hasWindows: workspace !== null

            Text {
                text: getWorkspaceTag(index + 1)
                color: layoutMouseArea.containsMouse ? config.colFg : (parent.isActive ? config.colCyan : (parent.hasWindows ? config.colCyan : config.colMuted))
                font.pixelSize: itemSize
                font.family: config.fontFamily
                font.bold: true
                anchors.centerIn: parent
            }

            Rectangle {
                width: 20
                height: 3
                color: parent.isActive ? config.colPurple : config.colBg
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

    Separator { 
        config: config

        Layout.leftMargin: 4
    }

    Text {
        text: currentLayout
        color: config.colFg
        font.pixelSize: config.fontSize
        font.family: config.fontFamily
        font.bold: true
    }

    Separator { config: config }

    Text {
        text: truncateWords(activeWindow, 4);
        color: config.colFg
        font.pixelSize: config.fontSize
        font.family: config.fontFamily
        font.bold: true
        Layout.fillWidth: true
    }
}
