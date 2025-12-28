import QtQuick
import QtQuick.Layouts
import Quickshell

import "components"

ShellRoot {
    id: root

    Config { id: cfg }

    PanelWindow {
        screen: Quickshell.screens.find(s => s.name === "HDMI-A-1")

        anchors {
            top: true
            left: true
            right: true
        }

        implicitHeight: 30
        color: cfg.colBg

        margins {
            top: 0
            bottom: 0
            left: 0
            right: 0
        }

        Rectangle {
            anchors.fill: parent
            color: cfg.colBg

            RowLayout {
                anchors.fill: parent
                spacing: 0

                Item { width: 16 }

                KernelVersion { config: cfg }

                Separator { 
                    config: cfg

                    Layout.leftMargin: 10
                    Layout.rightMargin: 10
                }

                Workspaces { config: cfg }

                Clock { config: cfg }

                SystemStats { config: cfg }

                Separator { 
                    config: cfg

                    Layout.leftMargin: 12
                    Layout.rightMargin: 12
                }

                Notifications { config: cfg }

                Item { width: 16 }
            }
        }
    }
}
