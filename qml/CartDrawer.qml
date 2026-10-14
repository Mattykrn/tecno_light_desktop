import QtQuick 6.6
import QtQuick.Controls 6.6
import QtQuick.Layouts 6.6

Item {
    id: cartView
    required property var storeController
    property bool darkMode: true
    signal checkoutRequested()
    readonly property color ink: darkMode ? "#f5f6fa" : "#151c2d"
    readonly property color muted: darkMode ? "#abb4c5" : "#5b6576"
    readonly property color surface: darkMode ? "#101729" : "#ffffff"
    readonly property color line: darkMode ? "#293248" : "#dce1e9"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 13
        RowLayout {
            Layout.fillWidth: true
            Label { Layout.fillWidth: true; text: "Bolsa de cotización"; color: cartView.ink; font.family: "Noto Sans"; font.pixelSize: 21; font.weight: Font.Bold }
            Label { text: cartView.storeController.itemCount + " ítems"; color: cartView.muted; font.family: "Noto Sans"; font.pixelSize: 10 }
        }
        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: cartView.line }
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Column {
                anchors.centerIn: parent
                visible: cartView.storeController.cart.empty
                spacing: 7
                Text { text: "Aún no agregaste productos"; color: cartView.ink; font.family: "Noto Sans"; font.pixelSize: 15; font.weight: Font.Bold; anchors.horizontalCenter: parent.horizontalCenter }
                Text { text: "Sumá los artículos para solicitar una cotización."; color: cartView.muted; font.family: "Noto Sans"; font.pixelSize: 10; anchors.horizontalCenter: parent.horizontalCenter }
            }
            ListView {
                anchors.fill: parent
                visible: !cartView.storeController.cart.empty
                clip: true
                spacing: 9
                model: cartView.storeController.cart
                delegate: Rectangle {
                    required property int productId
                    required property string name
                    required property string category
                    required property double price
                    required property int quantity
                    required property int stock
                    required property string imageUrl
                    required property double lineTotal
                    width: ListView.view.width
                    height: 98
                    radius: 3
                    color: cartView.darkMode ? "#1a2439" : "#f2f4f7"
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 9
                        Item {
                            Layout.preferredWidth: 70
                            Layout.fillHeight: true
                            clip: true
                            Rectangle { anchors.fill: parent; radius: 3; color: cartView.darkMode ? "#29354d" : "#e3e7ed" }
                            Image { id: cartImage; anchors.fill: parent; source: imageUrl; asynchronous: true; cache: true; fillMode: Image.PreserveAspectCrop }
                            Label { anchors.centerIn: parent; visible: imageUrl === "" || cartImage.status === Image.Error; text: "TL"; color: cartView.muted; font.family: "Noto Sans"; font.pixelSize: 15; font.weight: Font.Bold }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4
                            Label { Layout.fillWidth: true; text: name; color: cartView.ink; font.family: "Noto Sans"; font.pixelSize: 10; font.weight: Font.Bold; wrapMode: Text.WordWrap; maximumLineCount: 2; elide: Text.ElideRight }
                            Label { text: category; color: cartView.muted; font.family: "Noto Sans"; font.pixelSize: 8 }
                            RowLayout {
                                spacing: 3
                                Button {
                                    text: "−"
                                    onClicked: cartView.storeController.setCartQuantity(productId, quantity - 1)
                                    background: Rectangle { color: cartView.surface; radius: 3 }
                                    contentItem: Text { text: "−"; color: cartView.ink; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter; width: 23; height: 22 }
                                }
                                Label { text: quantity; color: cartView.ink; horizontalAlignment: Text.AlignHCenter; Layout.preferredWidth: 18; font.family: "Noto Sans"; font.pixelSize: 10; font.weight: Font.Bold }
                                Button {
                                    text: "+"
                                    onClicked: cartView.storeController.setCartQuantity(productId, quantity + 1)
                                    background: Rectangle { color: cartView.surface; radius: 3 }
                                    contentItem: Text { text: "+"; color: cartView.ink; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter; width: 23; height: 22 }
                                }
                            }
                        }
                        Button {
                            id: removeItemButton
                            text: "Quitar"
                            onClicked: cartView.storeController.removeFromCart(productId)
                            background: Rectangle { color: "transparent" }
                            contentItem: Text { text: removeItemButton.text; color: cartView.muted; font.family: "Noto Sans"; font.pixelSize: 9 }
                        }
                    }
                }
            }
        }
        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: cartView.line }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6
            Label { text: "Importe a confirmar"; color: cartView.ink; font.family: "Noto Sans"; font.pixelSize: 13; font.weight: Font.Bold }
            Label {
                Layout.fillWidth: true
                text: "Precios, disponibilidad, modalidad y entrega se confirman en la cotización según pliego, cantidad y destino."
                color: cartView.muted
                wrapMode: Text.WordWrap
                font.family: "Noto Sans"
                font.pixelSize: 10
            }
            Label { text: "Atención comercial · lunes a viernes · 8:00 a 17:00 hs"; color: cartView.muted; font.family: "Noto Sans"; font.pixelSize: 9 }
        }
        Button {
            id: quoteRequestButton
            Layout.fillWidth: true
            implicitHeight: 44
            text: "Solicitar presupuesto"
            enabled: !cartView.storeController.cart.empty
            onClicked: cartView.checkoutRequested()
            background: Rectangle { radius: 4; color: parent.enabled ? "#f36b35" : "#9ba4b4" }
            contentItem: Text { text: quoteRequestButton.text; color: "#ffffff"; font.family: "Noto Sans"; font.pixelSize: 11; font.weight: Font.Bold; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
        }
        Label { Layout.fillWidth: true; text: "La solicitud se guardará en el equipo y se abrirá WhatsApp para enviarla."; color: cartView.muted; horizontalAlignment: Text.AlignHCenter; wrapMode: Text.WordWrap; font.family: "Noto Sans"; font.pixelSize: 9 }
    }
}
