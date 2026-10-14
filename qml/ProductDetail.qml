import QtQuick 6.6
import QtQuick.Controls 6.6
import QtQuick.Layouts 6.6

Item {
    id: detail
    required property var product
    required property var storeController
    property bool darkMode: true
    signal closeRequested()
    signal addRequested(int productId, int quantity)
    property var gallery: product && product.gallery ? product.gallery : []
    property int selectedImage: 0
    property int quantity: 1
    readonly property color ink: darkMode ? "#f5f6fa" : "#151c2d"
    readonly property color muted: darkMode ? "#abb4c5" : "#5b6576"
    readonly property color surface: darkMode ? "#101729" : "#ffffff"
    readonly property color line: darkMode ? "#293248" : "#dce1e9"

    onProductChanged: {
        selectedImage = 0
        quantity = 1
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 22
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 1.05
            spacing: 9
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumHeight: 280
                clip: true
                Rectangle { anchors.fill: parent; radius: 4; color: detail.darkMode ? "#202b42" : "#e8edf3" }
                Image {
                    id: detailImage
                    anchors.fill: parent
                    source: detail.gallery.length > detail.selectedImage ? detail.gallery[detail.selectedImage] : (detail.product && detail.product.imageUrl ? detail.product.imageUrl : "")
                    asynchronous: true
                    cache: true
                    fillMode: Image.PreserveAspectCrop
                }
                Label {
                    anchors.centerIn: parent
                    visible: detailImage.status === Image.Error || detailImage.source == ""
                    text: "TECNO LIGHT S.R.L."
                    color: detail.muted
                    font.family: "Noto Sans"
                    font.pixelSize: 14
                    font.weight: Font.Bold
                }
            }
            RowLayout {
                Layout.fillWidth: true
                spacing: 7
                Repeater {
                    model: detail.gallery
                    delegate: Rectangle {
                        required property string modelData
                        required property int index
                        Layout.preferredWidth: 74
                        Layout.preferredHeight: 56
                        radius: 3
                        color: detail.darkMode ? "#202b42" : "#e8edf3"
                        border.color: detail.selectedImage === index ? "#f36b35" : detail.line
                        clip: true
                        Image { anchors.fill: parent; source: modelData; asynchronous: true; cache: true; fillMode: Image.PreserveAspectCrop }
                        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: detail.selectedImage = index }
                    }
                }
            }
        }
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 0.95
            spacing: 13
            RowLayout {
                Layout.fillWidth: true
                Label { Layout.fillWidth: true; text: detail.product.category ? detail.product.category.toUpperCase() : ""; color: "#f36b35"; font.family: "Noto Sans"; font.pixelSize: 9; font.weight: Font.Bold }
                Button {
                    id: closeButton
                    text: "Cerrar"
                    onClicked: detail.closeRequested()
                    background: Rectangle { radius: 3; color: detail.darkMode ? "#202b42" : "#e8edf3" }
                    contentItem: Text { text: closeButton.text; color: detail.ink; font.family: "Noto Sans"; font.pixelSize: 10; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter; leftPadding: 10; rightPadding: 10 }
                }
            }
            Label { Layout.fillWidth: true; text: detail.product.name || ""; color: detail.ink; wrapMode: Text.WordWrap; font.family: "Noto Sans"; font.pixelSize: 25; font.weight: Font.Bold }
            Label { text: detail.product.badge || ""; color: detail.muted; wrapMode: Text.WordWrap; font.family: "Noto Sans"; font.pixelSize: 10 }
            Label { text: detail.product.price > 0 ? detail.storeController.money(detail.product.price) : "Precio a cotizar"; color: detail.ink; font.family: "Noto Sans"; font.pixelSize: 20; font.weight: Font.Bold }
            Label { Layout.fillWidth: true; text: detail.product.description || ""; color: detail.muted; wrapMode: Text.WordWrap; lineHeight: 1.28; font.family: "Noto Sans"; font.pixelSize: 12 }
            Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: detail.line }
            Label { text: "Disponibilidad y valores sujetos a cotización según pliego, volumen y destino."; color: detail.muted; wrapMode: Text.WordWrap; font.family: "Noto Sans"; font.pixelSize: 10 }
            RowLayout {
                Layout.fillWidth: true
                Label { text: "Cantidad de interés"; color: detail.muted; font.family: "Noto Sans"; font.pixelSize: 11 }
                Item { Layout.fillWidth: true }
                Button {
                    text: "−"
                    enabled: detail.quantity > 1
                    onClicked: detail.quantity--
                    background: Rectangle { radius: 3; color: detail.darkMode ? "#202b42" : "#e8edf3" }
                    contentItem: Text { text: "−"; color: detail.ink; font.pixelSize: 16; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter; width: 30 }
                }
                Label { text: detail.quantity; color: detail.ink; horizontalAlignment: Text.AlignHCenter; Layout.preferredWidth: 24; font.family: "Noto Sans"; font.pixelSize: 12; font.weight: Font.Bold }
                Button {
                    text: "+"
                    onClicked: detail.quantity++
                    background: Rectangle { radius: 3; color: detail.darkMode ? "#202b42" : "#e8edf3" }
                    contentItem: Text { text: "+"; color: detail.ink; font.pixelSize: 16; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter; width: 30 }
                }
            }
            Item { Layout.fillHeight: true }
            Button {
                id: addDetailButton
                Layout.fillWidth: true
                implicitHeight: 44
                text: "Agregar a la bolsa de cotización"
                onClicked: detail.addRequested(detail.product.productId, detail.quantity)
                background: Rectangle { radius: 4; color: "#f36b35" }
                contentItem: Text { text: addDetailButton.text; color: "#ffffff"; font.family: "Noto Sans"; font.pixelSize: 11; font.weight: Font.Bold; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
            }
            Label { Layout.fillWidth: true; text: "Cotización sin cargo · Atención comercial de lunes a viernes"; color: detail.muted; horizontalAlignment: Text.AlignHCenter; font.family: "Noto Sans"; font.pixelSize: 9 }
        }
    }
}
