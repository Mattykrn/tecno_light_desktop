import QtQuick 6.6
import QtQuick.Controls 6.6
import QtQuick.Layouts 6.6

Dialog {
    id: checkout
    required property var storeController
    property bool darkMode: true
    signal submitted(string customerName, string email)
    modal: true
    title: "Solicitar presupuesto"
    width: Math.min(470, parent.width - 32)
    anchors.centerIn: Overlay.overlay
    padding: 21
    standardButtons: Dialog.NoButton
    background: Rectangle { color: checkout.darkMode ? "#101729" : "#ffffff"; radius: 5; border.color: checkout.darkMode ? "#293248" : "#dce1e9" }
    contentItem: ColumnLayout {
        spacing: 11
        Label { Layout.fillWidth: true; text: "Solicitar presupuesto"; color: checkout.darkMode ? "#f5f6fa" : "#151c2d"; font.family: "Noto Sans"; font.pixelSize: 20; font.weight: Font.Bold }
        Label { Layout.fillWidth: true; text: "Completá tus datos. La cotización es sin cargo; no se realiza ningún cobro desde esta aplicación."; color: checkout.darkMode ? "#abb4c5" : "#5b6576"; wrapMode: Text.WordWrap; font.family: "Noto Sans"; font.pixelSize: 10 }
        Label { text: "Nombre y empresa"; color: checkout.darkMode ? "#abb4c5" : "#5b6576"; font.family: "Noto Sans"; font.pixelSize: 10; font.weight: Font.DemiBold }
        TextField {
            id: customerName
            Layout.fillWidth: true
            placeholderText: "Nombre y empresa"
            color: checkout.darkMode ? "#f5f6fa" : "#151c2d"
            leftPadding: 11
            background: Rectangle { radius: 3; color: checkout.darkMode ? "#1a2439" : "#f2f4f7"; border.color: customerName.activeFocus ? "#f36b35" : "transparent" }
        }
        Label { text: "Correo electrónico"; color: checkout.darkMode ? "#abb4c5" : "#5b6576"; font.family: "Noto Sans"; font.pixelSize: 10; font.weight: Font.DemiBold }
        TextField {
            id: customerEmail
            Layout.fillWidth: true
            placeholderText: "nombre@empresa.com"
            inputMethodHints: Qt.ImhEmailCharactersOnly
            color: checkout.darkMode ? "#f5f6fa" : "#151c2d"
            leftPadding: 11
            background: Rectangle { radius: 3; color: checkout.darkMode ? "#1a2439" : "#f2f4f7"; border.color: customerEmail.activeFocus ? "#f36b35" : "transparent" }
        }
        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: 5
            spacing: 9
            Button {
                id: backButton
                Layout.fillWidth: true
                text: "Volver"
                onClicked: checkout.close()
                background: Rectangle { radius: 3; color: checkout.darkMode ? "#202b42" : "#e8edf3" }
                contentItem: Text { text: backButton.text; color: checkout.darkMode ? "#f5f6fa" : "#151c2d"; font.family: "Noto Sans"; font.pixelSize: 10; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
            }
            Button {
                id: continueButton
                Layout.fillWidth: true
                text: "Continuar por WhatsApp"
                onClicked: checkout.submitted(customerName.text, customerEmail.text)
                background: Rectangle { radius: 3; color: "#f36b35" }
                contentItem: Text { text: continueButton.text; color: "#ffffff"; font.family: "Noto Sans"; font.pixelSize: 10; font.weight: Font.Bold; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
            }
        }
    }
}
