import QtQuick 6.6
import QtQuick.Controls 6.6
import QtQuick.Layouts 6.6

Item {
    id: card
    required property int productId
    required property string name
    required property string category
    required property string description
    required property double price
    required property int stock
    required property string badge
    required property string imageUrl
    required property var gallery
    required property var storeController
    property bool darkMode: true
    signal selected()
    signal addRequested(int productId, int quantity)
    implicitHeight: 390
    implicitWidth: 230

    Rectangle {
        anchors.fill: parent
        radius: 4
        color: card.darkMode ? "#11182b" : "#ffffff"
        border.color: card.darkMode ? "#293248" : "#dce1e9"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 9
            spacing: 8

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 208
                clip: true
                Rectangle { anchors.fill: parent; radius: 3; color: card.darkMode ? "#202b42" : "#e8edf3" }
                Image {
                    id: productImage
                    anchors.fill: parent
                    source: card.imageUrl
                    asynchronous: true
                    cache: true
                    fillMode: Image.PreserveAspectCrop
                }
                Column {
                    anchors.centerIn: parent
                    spacing: 7
                    visible: card.imageUrl === "" || productImage.status === Image.Error
                    Text {
                        text: card.category === "Impresión digital" ? "TJ" : card.category === "EPP e indumentaria" ? "EPP" : card.category === "Alquiler y equipamiento" ? "VIAL" : "TL"
                        color: "#ffffff"
                        font.family: "Noto Sans"
                        font.pixelSize: 32
                        font.weight: Font.Black
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Text {
                        text: "TECNO LIGHT S.R.L."
                        color: "#e9edf5"
                        font.family: "Noto Sans"
                        font.pixelSize: 8
                        font.weight: Font.Bold
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.margins: 8
                    width: badgeLabel.implicitWidth + 15
                    height: 23
                    radius: 3
                    color: "#101729"
                    opacity: 0.94
                    Text {
                        id: badgeLabel
                        anchors.centerIn: parent
                        text: card.badge
                        color: "#ffffff"
                        font.family: "Noto Sans"
                        font.pixelSize: 8
                        font.weight: Font.Bold
                    }
                }
                Button {
                    anchors.fill: parent
                    opacity: 0
                    onClicked: card.selected()
                }
            }

            Label {
                text: card.category.toUpperCase()
                color: card.darkMode ? "#ff9a69" : "#bd4e25"
                font.family: "Noto Sans"
                font.pixelSize: 8
                font.weight: Font.Bold
            }
            Label {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                text: card.name
                color: card.darkMode ? "#f5f6fa" : "#151c2d"
                wrapMode: Text.WordWrap
                maximumLineCount: 2
                elide: Text.ElideRight
                font.family: "Noto Sans"
                font.pixelSize: 12
                font.weight: Font.Bold
            }
            Label {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.maximumHeight: 50
                text: card.description
                color: card.darkMode ? "#abb4c5" : "#5b6576"
                wrapMode: Text.WordWrap
                maximumLineCount: 3
                elide: Text.ElideRight
                font.family: "Noto Sans"
                font.pixelSize: 9
            }
            RowLayout {
                Layout.fillWidth: true
                Label {
                    Layout.fillWidth: true
                    text: card.price > 0 ? card.storeController.money(card.price) : "Consultar cotización"
                    color: card.darkMode ? "#ffffff" : "#151c2d"
                    font.family: "Noto Sans"
                    font.pixelSize: 12
                    font.weight: Font.Bold
                }
                Button {
                    id: detailButton
                    text: "Ver detalle"
                    onClicked: card.selected()
                    background: Rectangle { color: "transparent" }
                    contentItem: Text { text: detailButton.text; color: card.darkMode ? "#ff9a69" : "#bd4e25"; font.family: "Noto Sans"; font.pixelSize: 9; font.weight: Font.Bold }
                }
            }
            Button {
                id: addButton
                Layout.fillWidth: true
                implicitHeight: 36
                text: "Agregar a cotización"
                onClicked: card.addRequested(card.productId, 1)
                background: Rectangle { radius: 3; color: card.darkMode ? "#f36b35" : "#d95727" }
                contentItem: Text { text: addButton.text; color: "#ffffff"; font.family: "Noto Sans"; font.pixelSize: 9; font.weight: Font.Bold; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
            }
        }
    }
}
