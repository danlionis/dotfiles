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

    enum AnchorSide {
        Left,
        Right
    }

    signal groupsChanged()

    required property var screen
    property int side: Bar.AnchorSide.Left
    property bool showBattery: false
    property bool showNetwork: false
    property string backgroundColor: "#142027"

    property var targetScreens: {
        var screens = Quickshell.screens;
        for (var i = 0; i < screens.length; i++) {
            if (screens[i].name === root.screen) return [screens[i]];
        }
        return []
    }

    function getIcon(appId) {
        if (!appId) return "application-x-executable";
        if (appId === "System") return "settings";
        var entry = DesktopEntries.heuristicLookup(appId);
        if (entry && entry.icon) return entry.icon;
        return appId;
    }

    property var windowGroups: ({})
    property var appsList: []

    function updateAppsList() {
        var apps = Object.keys(root.windowGroups).filter(function(app) {
            return root.windowGroups[app] && root.windowGroups[app].length > 0;
        });
        apps.sort();
        root.appsList = apps;
        root.groupsChanged();
    }

    function registerWindow(win) {
        if (!win || !win.appId) return;
        var app = win.appId;

        if (!root.windowGroups[app]) {
            root.windowGroups[app] = [];
        }

        if (root.windowGroups[app].indexOf(win) === -1) {
            root.windowGroups[app].push(win);
            updateAppsList();
        }
    }

    function unregisterWindow(win) {
        if (!win) return;
        
        var found = false;
        for (var app in root.windowGroups) {
            var list = root.windowGroups[app];
            var idx = list.indexOf(win);
            if (idx > -1) {
                list.splice(idx, 1);
                if (list.length === 0) {
                    delete root.windowGroups[app];
                }
                found = true;
                break;
            }
        }
        if (found) {
            updateAppsList();
        }
    }

    function activateGroup(appId) {
        var list = root.windowGroups[appId];
        if (!list || list.length === 0) return;
        if (list.length === 1) {
            list[0].activate();
        } else {
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

    Variants {
        model: root.targetScreens

        PanelWindow {
            id: panel

            required property var modelData
            screen: modelData

            exclusiveZone: implicitWidth

            anchors {
                top: true
                bottom: true
                left: root.side === Bar.AnchorSide.Left
                right: root.side === Bar.AnchorSide.Right
            }

            implicitWidth: 42
            color: root.backgroundColor

            ColumnLayout {
                anchors.fill: parent
                anchors.topMargin: 8
                anchors.bottomMargin: 8
                spacing: 4

                Item {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 42
                    Layout.preferredHeight: clockColumn.implicitHeight + 2
                    Layout.bottomMargin: 4

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
                        enabled: false

                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: Qt.formatDateTime(clock.date, "hh")
                            color: "white"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 14
                            font.weight: 800
                        }

                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: Qt.formatDateTime(clock.date, "mm")
                            color: "white"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 14
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

                Repeater {
                    model: root.appsList
                    delegate: Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 34

                        readonly property string currentAppId: modelData
                        readonly property int groupCount: root.getGroupCount(currentAppId)

                        Connections {
                            target: root
                            function onGroupsChanged() {
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
                            width: 30; height: 30
                            anchors.centerIn: parent
                            radius: 5
                            color: "white"
                            opacity: mouseArea.containsMouse ? 0.1 : 0.0
                            Behavior on opacity { NumberAnimation { duration: 150 } }
                        }

                        IconImage {
                            anchors.centerIn: parent
                            width: 20; height: 20
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

                Item { Layout.fillHeight: true }

                ColumnLayout {
                    spacing: 8

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


                    Loader {
                        id: batteryLoader
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: active ? 30 : 0
                        Layout.preferredHeight: active ? 34 : 0
                        active: root.showBattery
                        visible: root.showBattery

                        sourceComponent: Item {
                            id: batteryIndicator
                            width: 30
                            height: 34

                            property int percent: 0
                            property bool isCharging: false

                            readonly property var batteryProcess: Process {
                                command: ["sh", "-c", "cat /sys/class/power_supply/BAT0/capacity; cat /sys/class/power_supply/BAT0/status"]
                                running: true
                                stdout: StdioCollector {
                                    onStreamFinished: {
                                        var lines = this.text.trim().split("\n");
                                        if (lines.length >= 2) {
                                            var p = parseInt(lines[0]);
                                            if (!isNaN(p)) {
                                                batteryIndicator.percent = p;
                                            }
                                            var s = lines[1].trim();
                                            batteryIndicator.isCharging = (s === "Charging");
                                        }
                                    }
                                }
                            }

                            Timer {
                                interval: 10000
                                running: true
                                repeat: true
                                triggeredOnStart: true
                                onTriggered: batteryIndicator.batteryProcess.running = true
                            }

                            MouseArea {
                                id: battMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: batteryIndicator.batteryProcess.running = true
                            }

                            Rectangle {
                                width: 28; height: 28
                                anchors.centerIn: parent
                                radius: 5
                                color: "white"
                                opacity: battMouseArea.containsMouse ? 0.1 : 0.0
                                Behavior on opacity { NumberAnimation { duration: 150 } }
                            }

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 1

                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: {
                                        if (batteryIndicator.isCharging) {
                                            return "󰂄";
                                        } else {
                                            var p = batteryIndicator.percent;
                                            if (p >= 95) return "󰁹";
                                            if (p >= 85) return "󰂂";
                                            if (p >= 75) return "󰂁";
                                            if (p >= 65) return "󰂀";
                                            if (p >= 55) return "󰁿";
                                            if (p >= 45) return "󰁾";
                                            if (p >= 35) return "󰁽";
                                            if (p >= 25) return "󰁼";
                                            if (p >= 15) return "󰁻";
                                            return "󰁺";
                                        }
                                    }
                                    color: batteryIndicator.isCharging ? "#50fa7b" : (batteryIndicator.percent < 20 ? "#ff5555" : "white")
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 14
                                }

                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: batteryIndicator.percent + "%"
                                    color: "white"
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 10
                                    font.weight: 600
                                }
                            }
                        }
                    }

                    Loader {
                        id: networkLoader
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: active ? 30 : 0
                        Layout.preferredHeight: active ? 24 : 0
                        active: root.showNetwork
                        visible: root.showNetwork

                        sourceComponent: Item {
                            id: networkIndicator
                            width: 30
                            height: 24

                            property string stateStr: "disconnected"
                            property string ssid: ""
                            property int rssi: -100

                            readonly property var networkProcess: Process {
                                command: ["sh", "-c", "iwctl station wlan0 show | awk -F '  +' '/State|Connected network|RSSI/ {print $2 \":\" $3}'"]
                                running: true
                                stdout: StdioCollector {
                                    onStreamFinished: {
                                        var lines = this.text.trim().split("\n");
                                        var state = "disconnected";
                                        var ssid = "";
                                        var rssi = -100;
                                        for (var i = 0; i < lines.length; i++) {
                                            var parts = lines[i].split(":");
                                            if (parts.length >= 2) {
                                                var key = parts[0].trim();
                                                var val = parts[1].trim();
                                                if (key === "State") {
                                                    state = val;
                                                } else if (key === "Connected network") {
                                                    ssid = val;
                                                } else if (key === "RSSI") {
                                                    var p = parseInt(val);
                                                    if (!isNaN(p)) rssi = p;
                                                }
                                            }
                                        }
                                        networkIndicator.stateStr = state;
                                        networkIndicator.ssid = ssid;
                                        networkIndicator.rssi = rssi;
                                    }
                                }
                            }

                            Timer {
                                interval: 5000
                                running: true
                                repeat: true
                                triggeredOnStart: true
                                onTriggered: networkIndicator.networkProcess.running = true
                            }

                            readonly property var impalaProcess: Process {
                                command: ["lio-launch-floating-terminal", "--silent", "impala"]
                            }

                            MouseArea {
                                id: netMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: networkIndicator.impalaProcess.startDetached()
                            }

                            Rectangle {
                                width: 28; height: 28
                                anchors.centerIn: parent
                                radius: 5
                                color: "white"
                                opacity: netMouseArea.containsMouse ? 0.1 : 0.0
                                Behavior on opacity { NumberAnimation { duration: 150 } }
                            }

                            Text {
                                anchors.centerIn: parent
                                text: {
                                    if (networkIndicator.stateStr !== "connected") {
                                        return "󰤮";
                                    }
                                    var r = networkIndicator.rssi;
                                    if (r >= -55) return "󰤨";
                                    if (r >= -70) return "󰤥";
                                    if (r >= -85) return "󰤢";
                                    return "󰤟";
                                }
                                color: networkIndicator.stateStr === "connected" ? "white" : "#6272a4"
                                opacity: networkIndicator.stateStr === "connected" ? 1.0 : 0.6
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 14
                            }
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
                    }
                }
            }
        }
    }
}
