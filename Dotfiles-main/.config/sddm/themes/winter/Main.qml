import QtQuick 2.15
import QtQuick.Controls 2.15

// ═══════════════════════════════════════════════════════════
// ❄ Winter SDDM Login — hyprlock Twin
// 与 hyprlock 使用同一张壁纸 + 相同时钟/日期/密码框样式
// ═══════════════════════════════════════════════════════════

Item {
    id: root

    // ─── 同一张壁纸（pywallpaper.jpg = 当前桌面壁纸）───
    Image {
        anchors.fill: parent
        source: "Background.jpg"
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
    }
    // 暗化 ≈ hyprlock brightness 0.6
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0.043, 0.040, 0.063, 0.40)
    }

    // ─── 时钟（hyprlock: 120px, #A8C5E6, center+180上）───
    property var now: new Date()
    Timer { interval: 1000; repeat: true; running: true; onTriggered: now = new Date() }

    Text {
        id: clockText
        text: Qt.formatTime(now, "HH:mm")
        color: "#A8C5E6"
        font { family: "Code New Roman Nerd Font Propo"; pixelSize: 120 }
        renderType: Text.NativeRendering
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height / 2 - 180 - height / 2
    }

    // ─── 日期（hyprlock: 40px, #A8C5E6, center+40上）───
    Text {
        id: dateText
        text: Qt.formatDate(now, "dddd, MMMM d")
        color: "#A8C5E6"
        font { family: "Code New Roman Nerd Font Propo"; pixelSize: 40 }
        renderType: Text.NativeRendering
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height / 2 - 40 - height / 2
    }

    // ─── 用户名（显示当前选中用户）───
    Text {
        id: userName
        color: Qt.rgba(0.92, 0.91, 0.94, 0.6)
        font { family: "Code New Roman Nerd Font Propo"; pixelSize: 18 }
        renderType: Text.NativeRendering
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height / 2 + 70
    }

    // ─── 密码框（hyprlock: 深底#0B0A10, 圆角20, center-120下）───
    TextField {
        id: passField
        width: 300; height: 50
        echoMode: TextInput.Password
        placeholderText: ""
        color: "#eae9f0"
        font { family: "Code New Roman Nerd Font Propo"; pixelSize: 16 }
        horizontalAlignment: TextInput.AlignHCenter
        verticalAlignment: TextInput.AlignVCenter
        focus: true
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height / 2 + 120 - height / 2
        background: Rectangle {
            radius: 20
            color: "#0B0A10"
            border.color: passField.activeFocus ? "#A8C5E6" : Qt.rgba(0.2, 0.19, 0.24, 1)
            border.width: 1
        }
        Keys.onReturnPressed: doLogin()
        Keys.onEnterPressed: doLogin()
    }

    // ─── 隐藏的用户选择器 ───
    ComboBox {
        id: userCombo
        visible: false; width: 1; height: 1
        model: userModel
        textRole: "name"
        currentIndex: (typeof userModel.lastIndex !== "undefined" && userModel.lastIndex >= 0) ? userModel.lastIndex : 0
        onCurrentTextChanged: userName.text = currentText
        Component.onCompleted: userName.text = currentText
    }

    // ─── 错误提示 ───
    Text {
        id: errText
        color: "#f1a7b3"
        opacity: 0
        text: ""
        anchors.horizontalCenter: parent.horizontalCenter
        y: passField.y + passField.height + 16
        font { family: "Code New Roman Nerd Font Propo"; pixelSize: 14 }
        renderType: Text.NativeRendering
        Behavior on opacity { NumberAnimation { duration: 200 } }
    }

    // ─── 左下：会话 ───
    ComboBox {
        id: sessionCombo
        width: 160
        anchors.bottom: parent.bottom; anchors.bottomMargin: 24
        anchors.left: parent.left; anchors.leftMargin: 28
        model: sessionModel; textRole: "name"
        currentIndex: (typeof sessionModel.lastIndex !== "undefined" && sessionModel.lastIndex >= 0) ? sessionModel.lastIndex : 0
        font { family: "Code New Roman Nerd Font Propo"; pixelSize: 12 }
        palette.text: "#eae9f0"; palette.highlight: "#A8C5E6"; palette.highlightedText: "#0B0A10"
        contentItem: Text {
            text: sessionCombo.displayText
            color: Qt.rgba(0.92, 0.91, 0.94, 0.4)
            font { family: "Code New Roman Nerd Font Propo"; pixelSize: 12 }
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle { radius: 6; color: "transparent" }
    }

    // ─── 右下：电源 ───
    Row {
        spacing: 4
        anchors.bottom: parent.bottom; anchors.bottomMargin: 24
        anchors.right: parent.right; anchors.rightMargin: 28
        Repeater {
            model: [{ icon: "⏻", act: "powerOff" }, { icon: "↻", act: "reboot" }, { icon: "⏾", act: "suspend" }]
            Button {
                id: pwrBtn; width: 32; height: 32
                contentItem: Text {
                    text: modelData.icon
                    color: pwrBtn.hovered ? "#A8C5E6" : Qt.rgba(0.92, 0.91, 0.94, 0.3)
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle { radius: 16; color: "transparent" }
                onClicked: {
                    if (modelData.act === "powerOff") sddm.powerOff()
                    else if (modelData.act === "reboot") sddm.reboot()
                    else if (modelData.act === "suspend") sddm.suspend()
                }
            }
        }
    }

    function doLogin() {
        if (userCombo.currentText === "") return
        errText.opacity = 0
        sddm.login(userCombo.currentText, passField.text, sessionCombo.currentIndex)
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            errText.text = "Login failed"; errText.opacity = 1
            passField.text = ""; passField.forceActiveFocus()
        }
        function onLoginSucceeded() {}
    }
}
