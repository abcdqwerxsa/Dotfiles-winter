import QtQuick 2.15
import QtQuick.Controls 2.15

// Winter login theme for SDDM — snowy background, blue-pink palette.
// Palette: bg #0B0A10, blue #A8C5E6, pink #f1a7e2, white #eae9f0, widget #111019
Item {
    id: root

    // ─────────────────────── Background ───────────────────────
    Image {
        id: bg
        anchors.fill: parent
        source: "Background.jpg"
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: true
    }
    Rectangle {
        anchors.fill: parent
        color: "#0B0A10"
        opacity: 0.55
    }

    // ─────────────────────── Clock ───────────────────────
    property var now: new Date()
    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: now = new Date()
    }

    Column {
        spacing: 4
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height * 0.15

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatTime(now, "HH:mm")
            color: "#A8C5E6"
            font { family: "Code New Roman Nerd Font Propo"; pixelSize: 96; bold: true }
            renderType: Text.NativeRendering
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDate(now, "dddd, MMMM d")
            color: "#eae9f0"
            opacity: 0.8
            font { family: "Code New Roman Nerd Font Propo"; pixelSize: 22 }
            renderType: Text.NativeRendering
        }
    }

    // ─────────────────────── Login card ───────────────────────
    Rectangle {
        id: card
        width: 360
        height: 224
        radius: 18
        anchors.centerIn: parent
        color: Qt.rgba(0.066, 0.063, 0.098, 0.92)   // #111019 @ 0.92
        border.color: "#f1a7e2"                       // winter pink
        border.width: 1

        Column {
            anchors.centerIn: parent
            spacing: 16

            // User selector
            ComboBox {
                id: userCombo
                width: 290
                model: userModel
                textRole: "name"
                currentIndex: (typeof userModel.lastIndex !== "undefined" && userModel.lastIndex >= 0) ? userModel.lastIndex : 0
                font { family: "Code New Roman Nerd Font Propo"; pixelSize: 15 }
                palette.text: "#eae9f0"
                palette.window: "#111019"
                palette.base: "#1a1825"
                palette.highlight: "#A8C5E6"
                palette.highlightedText: "#0B0A10"
            }

            // Password
            TextField {
                id: passField
                width: 290
                echoMode: TextInput.Password
                placeholderText: "Password"
                placeholderTextColor: "#7d7a8a"
                color: "#eae9f0"
                font { family: "Code New Roman Nerd Font Propo"; pixelSize: 15 }
                horizontalAlignment: TextInput.AlignHCenter
                focus: true
                background: Rectangle {
                    radius: 10
                    color: "#1a1825"
                    border.color: passField.activeFocus ? "#A8C5E6" : "#33302f"
                    border.width: 1
                }
                Keys.onReturnPressed: doLogin()
                Keys.onEnterPressed: doLogin()
                onActiveFocusChanged: if (activeFocus) selectAll()
            }

            // Login button
            Button {
                id: loginBtn
                width: 290
                height: 38
                enabled: userCombo.currentText !== ""
                contentItem: Text {
                    text: "Log in"
                    color: loginBtn.enabled ? "#0B0A10" : "#7d7a8a"
                    font { family: "Code New Roman Nerd Font Propo"; pixelSize: 15; bold: true }
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    radius: 10
                    color: loginBtn.enabled
                        ? (loginBtn.down ? "#d3e8ff" : (loginBtn.hovered ? "#b4d4f0" : "#A8C5E6"))
                        : "#3a3744"
                }
                onClicked: doLogin()
            }
        }
    }

    // Error message
    Text {
        id: errText
        text: ""
        color: "#f1a7b3"
        anchors.top: card.bottom
        anchors.topMargin: 14
        anchors.horizontalCenter: parent.horizontalCenter
        font { family: "Code New Roman Nerd Font Propo"; pixelSize: 14 }
        renderType: Text.NativeRendering
    }

    // ─────────────────────── Bottom bar: session + power ───────────────────────
    Row {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 36
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 16

        ComboBox {
            id: sessionCombo
            width: 190
            model: sessionModel
            textRole: "name"
            currentIndex: (typeof sessionModel.lastIndex !== "undefined" && sessionModel.lastIndex >= 0) ? sessionModel.lastIndex : 0
            font { family: "Code New Roman Nerd Font Propo"; pixelSize: 13 }
            palette.text: "#eae9f0"
            palette.window: "#111019"
            palette.base: "#1a1825"
            palette.highlight: "#A8C5E6"
            palette.highlightedText: "#0B0A10"
        }

        Row {
            spacing: 6
            Repeater {
                model: [
                    { icon: "⏻", act: "powerOff" },
                    { icon: "↻", act: "reboot" },
                    { icon: "⏾", act: "suspend" }
                ]
                Button {
                    id: pwrBtn
                    width: 38; height: 38
                    contentItem: Text {
                        text: modelData.icon
                        color: "#eae9f0"
                        font.pixelSize: 18
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle {
                        radius: 19
                        color: pwrBtn.hovered ? Qt.rgba(0.945, 0.655, 0.886, 0.25) : "transparent"
                        border.color: "#33302f"; border.width: 1
                    }
                    onClicked: {
                        if (modelData.act === "powerOff") sddm.powerOff()
                        else if (modelData.act === "reboot") sddm.reboot()
                        else if (modelData.act === "suspend") sddm.suspend()
                    }
                }
            }
        }
    }

    // Brand
    Text {
        text: "❄ Hyprland · winter"
        color: "#eae9f0"
        opacity: 0.25
        anchors.top: parent.top; anchors.left: parent.left
        anchors.margins: 18
        font { family: "Code New Roman Nerd Font Propo"; pixelSize: 13 }
        renderType: Text.NativeRendering
    }

    function doLogin() {
        if (userCombo.currentText === "") return
        errText.text = ""
        sddm.login(userCombo.currentText, passField.text, sessionCombo.currentIndex)
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            errText.text = "Login failed — please try again"
            passField.text = ""
            passField.forceActiveFocus()
        }
        function onLoginSucceeded() {}
    }
}
