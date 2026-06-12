// @ pragma IconTheme Papirus-Dark
import QtQuick
import QtQuick.Layouts
import QtQml
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Widgets

Scope {
    id: root

    signal groupsChanged()

    required property var screen

    // --- Configuration & Helpers ---

    // Reactive screen lookup — re-evaluates whenever Quickshell.screens changes,
    // so a lock/unlock cycle that briefly rebuilds the screen list won't leave a
    // stale reference behind.
    property var targetScreen: {
        var screens = Quickshell.screens;
        for (var i = 0; i < screens.length; i++) {
            if (screens[i].name === screen) return screens[i];
        }
        return screens.length > 0 ? screens[0] : null;
    }

    function getIcon(appId) {
        if (!appId) return "application-x-executable";
        if (appId === "System") return "settings";
        var entry = DesktopEntries.heuristicLookup(appId);
        if (entry && entry.icon) return entry.icon;
        return appId;
    }

    // --- Grouping Logic ---

    ListModel { id: groupedAppsModel }
    property var windowGroups: ({})

    function registerWindow(win) {
        // Guard against null windows or missing appId (common during lock/unlock)
        if (!win || !win.appId) return;

        var app = win.appId;

        if (!root.windowGroups[app]) {
            root.windowGroups[app] = [];

            // Insert sorted alphabetically
            var inserted = false;
            for (var i = 0; i < groupedAppsModel.count; i++) {
                if (app.localeCompare(groupedAppsModel.get(i).appId) < 0) {
                    groupedAppsModel.insert(i, { "appId": app });
                    inserted = true;
                    break;
                }
            }
            if (!inserted) groupedAppsModel.append({ "appId": app });
        }

        // Avoid double-registering the same window object
        if (root.windowGroups[app].indexOf(win) === -1) {
            root.windowGroups[app].push(win);
        }

        root.groupsChanged();
    }

    function unregisterWindow(win) {
        if (!win) return;
        var app = win.appId || "unknown";
        if (!root.windowGroups[app]) return;

        var list = root.windowGroups[app];
        var idx = list.indexOf(win);
        if (idx > -1) {
            list.splice(idx, 1);
            if (list.length === 0) {
                delete root.windowGroups[app];
                for (var i = 0; i < groupedAppsModel.count; i++) {
                    if (groupedAppsModel.get(i).appId === app) {
                        groupedAppsModel.remove(i);
                        break;
                    }
                }
            }
            root.groupsChanged();
        }
    }

    function activateGroup(appId) {
        var list = root.windowGroups[appId];
        if (!list || list.length === 0) return;
        if (list.length === 1) {
            list[0].activate();
        } else {
            // Cycle through windows in the group
            var next = list.shift();
            next.activate();
            list.push(next);
        }
    }

    function getGroupCount(appId) {
        return root.windowGroups[appId] ? root.windowGroups[appId].length : 0;
    }

    Instantiator {
        model: ToplevelManager.toplevels
        delegate: QtObject {
            readonly property var win: modelData
            Component.onCompleted: root.registerWindow(win)
            Component.onDestruction: root.unregisterWindow(win)
        }
    }

    // --- Visuals ---

    PanelWindow {
        id: panel

        // Fall back to first screen if targetScreen is null (e.g. briefly after unlock)
        screen: root.targetScreen ?? Quickshell.screens[0]

        // Declaring the exclusive zone prevents the compositor from dropping the
        // layer-shell surface after hyprlock releases — the most common cause of
        // the bar disappearing on niri.
        exclusiveZone: implicitWidth

        anchors {
            top: true
            bottom: true
            left: true
        }

        implicitWidth: 48
        color: "#142027"

        ColumnLayout {
            anchors.fill: parent
            anchors.topMargin: 8
            anchors.bottomMargin: 8
            spacing: 4

            // --- Clock & Date ---
            // Wrap the entire clock block in a single MouseArea so clicks register
            // reliably. The previous MouseArea had no explicit size and was a sibling
            // of the Text items rather than a parent, so it would intercept erratically.
            Item {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 48
                Layout.preferredHeight: clockColumn.implicitHeight + 8
                Layout.bottomMargin: 10

                readonly property var calProcess: Process {
                    command: ["brave", "--app=https://calendar.google.com"]
                }

                MouseArea {
                    width: parent.width
                    height: parent.height
                    cursorShape: Qt.PointingHandCursor
                    onClicked: parent.calProcess.startDetached()

                    Rectangle {
                        anchors.fill: parent
                        radius: 5
                        color: "white"
                        opacity: parent.containsMouse ? 0.07 : 0.0
                        Behavior on opacity { NumberAnimation { duration: 150 } }
                    }
                }

                SystemClock {
                    id: clock
                    precision: SystemClock.Minutes
                }

                ColumnLayout {
                    id: clockColumn
                    anchors.centerIn: parent
                    spacing: -2
                    // Pointer events fall through to the MouseArea above
                    enabled: false

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: Qt.formatDateTime(clock.date, "hh")
                        color: "white"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 18
                        font.weight: 800
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: Qt.formatDateTime(clock.date, "mm")
                        color: "white"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 18
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.topMargin: 4
                        text: Qt.formatDateTime(clock.date, "dd.M")
                        color: "white"
                        opacity: 0.6
                        font.family: "JetBrainsMono Nerd Font"
                        font.weight: 600
                        font.pixelSize: 10
                    }
                }
            }

            // --- App List ---
            Repeater {
                model: groupedAppsModel
                delegate: Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 42

                    readonly property string currentAppId: model.appId

                    // Track badge visibility locally so it updates without relying
                    // solely on the Connections signal (avoids missed updates when
                    // the delegate is created after groupsChanged fires).
                    readonly property int groupCount: root.getGroupCount(currentAppId)

                    Connections {
                        target: root
                        function onGroupsChanged() {
                            // Re-read so the binding updates
                            badgeRect.visible = root.getGroupCount(currentAppId) > 1;
                            countText.text    = root.getGroupCount(currentAppId);
                        }
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.activateGroup(currentAppId)
                    }

                    Rectangle {
                        width: 38; height: 38
                        anchors.centerIn: parent
                        radius: 5
                        color: "white"
                        opacity: mouseArea.containsMouse ? 0.1 : 0.0
                        Behavior on opacity { NumberAnimation { duration: 150 } }
                    }

                    IconImage {
                        anchors.centerIn: parent
                        width: 28; height: 28
                        source: Quickshell.iconPath(root.getIcon(currentAppId))
                    }

                    Rectangle {
                        id: badgeRect
                        visible: groupCount > 1
                        width: 14; height: 14
                        radius: 7
                        color: "#AD3822"
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                        anchors.rightMargin: 8
                        anchors.bottomMargin: 2

                        Text {
                            id: countText
                            anchors.centerIn: parent
                            text: groupCount
                            color: "#BDDDD2"
                            font.pixelSize: 10
                            font.bold: true
                            font.family: "JetBrainsMono Nerd Font"
                        }
                    }
                }
            }

            // --- Spacer ---
            Item { Layout.fillHeight: true }

            // --- Bottom Controls ---
            ColumnLayout {
                spacing: 8

                // Helper component so we don't repeat the hover-rectangle + icon pattern
                // for every control button.
                component ControlButton: Item {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    Layout.preferredHeight: 24

                    property string iconName: ""
                    signal clicked()

                    MouseArea {
                        id: btnMouseArea
                        width: parent.width
                        height: parent.height 
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: parent.clicked()
                    }

                    Rectangle {
                        width: 28; height: 28
                        anchors.centerIn: parent
                        radius: 5
                        color: "white"
                        opacity: btnMouseArea.containsMouse ? 0.1 : 0.0
                        Behavior on opacity { NumberAnimation { duration: 150 } }
                    }

                    IconImage {
                        anchors.centerIn: parent
                        width: 16; height: 16
                        source: Quickshell.iconPath(parent.iconName)
                    }
                }

                ControlButton {
                    iconName: "volume-level-high"
                    readonly property var process: Process {
                        command: ["lio-launch-floating-terminal", "--silent", "wiremix"]
                    }
                    onClicked: process.startDetached()
                }

                ControlButton {
                    iconName: "system-shutdown"
                    readonly property var process: Process {
                        command: ["walker", "--provider", "menus:power"]
                    }
                    onClicked: process.startDetached()
                }

                ControlButton {
                    iconName: "notifications"
                    // Wire this up to your notification daemon when ready
                }
            }
        }
    }
}
