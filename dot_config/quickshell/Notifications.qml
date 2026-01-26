import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications

Scope {
    // 1. Define the Window for the Notification Center
    PanelWindow {
        id: notifWindow
        
        // Position: Top Right of the screen
        anchors {
            top: true
            right: true
        }
        margins {
            top: 10
            right: 10
        }

        // Size: Flexible height, fixed width
        implicitWidth: 350
        implicitHeight: notifList.contentHeight
        
        // Transparency allows us to round corners on the background rectangle
        color: "transparent"

        // 2. The visual list of notifications
        ListView {
            id: notifList
            anchors.fill: parent
            spacing: 10
            
            // Connects to the Notification Daemon provided by Quickshell
            model: NotificationServer.trackedNotifications

            // 3. How each notification looks
            delegate: Rectangle {
                width: ListView.view.width
                height: contentCol.implicitHeight + 20
                color: "#1e1e2e" // Background color (dark grey/blue)
                radius: 8
                border.color: "#313244"
                border.width: 1

                // MouseArea to dismiss on click
                MouseArea {
                    anchors.fill: parent
                    onClicked: modelData.dismiss()
                }

                // Layout for Icon, Title, Body
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10

                    // Icon (if available)
                    Image {
                        source: modelData.icon || "image://icon/" + modelData.appIcon
                        Layout.preferredWidth: 32
                        Layout.preferredHeight: 32
                        visible: status === Image.Ready
                    }

                    // Text Content
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2

                        Text {
                            text: modelData.summary
                            color: "#ffffff"
                            font.bold: true
                            font.pixelSize: 14
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }

                        Text {
                            text: modelData.body
                            color: "#bac2de"
                            font.pixelSize: 12
                            wrapMode: Text.Wrap
                            Layout.fillWidth: true
                            maximumLineCount: 3
                            elide: Text.ElideRight
                        }
                    }
                }
            }
        }
    }
}
