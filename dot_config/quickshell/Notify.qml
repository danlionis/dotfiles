import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

import "config.js" as Config

Scope {
    id: notifications

    required property var screen
    property var targetScreens: {
        var screens = Quickshell.screens;
        for (var i = 0; i < screens.length; i++) {
            if (screens[i].name === root.screen) return [screens[i]];
        }
        return []
    }

    property bool centerOpen: false
    ListModel { id: history }

    IpcHandler {
        target: "notifications"
        function toggle(): void { notifications.centerOpen = !notifications.centerOpen }
        function show(): void { notifications.centerOpen = true }
        function hide(): void { notifications.centerOpen = false }
    }

    NotificationServer {
        id: server
        actionsSupported: true
        bodySupported: true
        imageSupported: true

        onNotification: n => {
            history.insert(0, {
                summary: n.summary,
                body: n.body,
                appName: n.appName,
                urgency: n.urgency,
                time: Qt.formatDateTime(new Date(), "HH:mm")
            })
            n.tracked = true
        }
    }

    PanelWindow {
        visible: !notifications.centerOpen

        anchors { top: true; right: true }
        margins { top: 12; right: 12 }
        implicitWidth: 380
        implicitHeight: Math.max(1, column.implicitHeight)
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        mask: Region { item: column }
        screen: notifications.targetScreens

        ColumnLayout {
            id: column
            width: parent.width
            spacing: 10

            Repeater {
                model: server.trackedNotifications

                delegate: Rectangle {
                    id: card
                    required property var modelData

                    Layout.fillWidth: true
                    Layout.preferredHeight: layout.implicitHeight + 20
                    radius: 8
                    color: Config.colors.bg
                    border.width: modelData.urgency === NotificationUrgency.Critical
                        ? 2 : 1
                    border.color: modelData.urgency === NotificationUrgency.Critical
                        ? Config.colors.red : Config.colors.fg

                    Timer {
                        running: card.modelData.urgency !== NotificationUrgency.Critical
                        interval: Config.notifications.timeout
                        onTriggered: card.modelData.dismiss()
                    }

                    RowLayout {
                        id: layout
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10

                        Image {
                            Layout.preferredWidth: 36
                            Layout.preferredHeight: 36
                            Layout.alignment: Qt.AlignTop
                            fillMode: Image.PreserveAspectFit
                            visible: source.toString() !== ""
                            source: card.modelData.image || card.modelData.appIcon || ""
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2

                            Text {
                                Layout.fillWidth: true
                                text: "critical"
                                visible: card.modelData.urgency === NotificationUrgency.Critical
                                color: Config.colors.muted
                                font.family: Config.bar.fontFamily
                                font.pixelSize: Config.bar.fontSize - 4
                                elide: Text.ElideRight
                            }
                            Text {
                                Layout.fillWidth: true
                                text: card.modelData.summary
                                color: Config.colors.fg
                                font.family: Config.bar.fontFamily
                                font.pixelSize: Config.bar.fontSize
                                font.bold: true
                                elide: Text.ElideRight
                            }
                            Text {
                                Layout.fillWidth: true
                                visible: text !== ""
                                text: card.modelData.body
                                color: Config.colors.fg
                                font.family: Config.bar.fontFamily
                                font.pixelSize: Config.bar.fontSize - 1
                                wrapMode: Text.WordWrap
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: card.modelData.dismiss()
                    }
                }
            }
        }
    }

    // notification center
    PanelWindow {
        visible: notifications.centerOpen
        anchors { bottom: true; left: true }
        margins { bottom: 12; left: Config.bar.width + 12 }
        implicitWidth: 380
        implicitHeight: centerCol.implicitHeight + 24
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore

        Rectangle {
            anchors.fill: parent
            radius: 10
            color: Config.colors.bgDark
            border.width: 2
            border.color: Config.colors.purple

            ColumnLayout {
                id: centerCol
                anchors.fill: parent
                anchors.margins: 12
                spacing: 10

                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        Layout.fillWidth: true
                        text: "Notifications"
                        color: Config.colors.fg
                        font.family: Config.bar.fontFamily
                        font.pixelSize: Config.bar.fontSize + 2
                        font.bold: true
                    }
                    Text {
                        text: "Clear all"
                        visible: history.count > 0
                        color: Config.colors.red
                        font.family: Config.bar.fontFamily
                        font.pixelSize: Config.bar.fontSize - 1
                        MouseArea {
                            anchors.fill: parent
                            onClicked: history.clear()
                        }
                    }
                }

                Text {
                    visible: history.count === 0
                    text: "No notifications"
                    color: Config.colors.muted
                    font.family: Config.bar.fontFamily
                    font.pixelSize: Config.bar.fontSize
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 20
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.min(contentHeight, 500)   
                    clip: true
                    spacing: 8
                    model: history

                    delegate: Rectangle {
                        required property int index
                        required property var model

                        width: ListView.view.width
                        implicitHeight: cardCol.implicitHeight + 16
                        radius: 8
                        color: Config.colors.bgDark
                        border.width: 1
                        border.color: model.urgency === NotificationUrgency.Critical
                            ? Config.colors.red : Config.colors.muted

                        ColumnLayout {
                            id: cardCol
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 2

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 6
                                Text {
                                    Layout.fillWidth: true
                                    text: model.summary
                                    color: Config.colors.fg
                                    font.family: Config.bar.fontFamily
                                    font.pixelSize: Config.bar.fontSize
                                    font.bold: true
                                    elide: Text.ElideRight
                                }
                                Text {
                                    text: model.time
                                    color: Config.colors.muted
                                    font.family: Config.bar.fontFamily
                                    font.pixelSize: Config.bar.fontSize - 3
                                }
                                Text {
                                    text: "󰅖"
                                    color: Config.colors.muted
                                    font.family: Config.bar.fontFamily
                                    font.pixelSize: Config.bar.fontSize - 1
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: history.remove(index)
                                    }
                                }
                            }

                            Text {
                                Layout.fillWidth: true
                                visible: model.body !== ""
                                text: model.body
                                color: Config.colors.fg
                                font.family: Config.bar.fontFamily
                                font.pixelSize: Config.bar.fontSize - 1
                                wrapMode: Text.WordWrap
                            }
                            Text {
                                visible: model.appName !== ""
                                text: model.appName
                                color: Config.colors.muted
                                font.family: Config.bar.fontFamily
                                font.pixelSize: Config.bar.fontSize - 3
                            }
                        }
                    }
                }
            }
        }
    }
}
