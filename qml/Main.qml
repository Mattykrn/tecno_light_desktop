import QtQuick 6.6
import QtQuick.Controls 6.6
import QtQuick.Layouts 6.6

ApplicationWindow {
    id: window
    visible: true
    width: 1440
    height: 940
    minimumWidth: 760
    minimumHeight: 640
    title: "TECNO LIGHT S.R.L. | Señalización Vial e Industrial"
    color: darkMode ? "#080d1c" : "#f4f6f9"

    property bool darkMode: true
    property bool menuOpen: false
    property var storeController: store
    readonly property color navy: "#11182b"
    readonly property color ink: darkMode ? "#f5f6fa" : "#151c2d"
    readonly property color mutedInk: darkMode ? "#abb4c5" : "#5b6576"
    readonly property color surface: darkMode ? "#101729" : "#ffffff"
    readonly property color section: darkMode ? "#080d1c" : "#f4f6f9"
    readonly property color line: darkMode ? "#293248" : "#dce1e9"
    readonly property color orange: "#f36b35"
    readonly property color whatsapp: "#25d366"

    header: Rectangle {
        height: 100
        color: window.navy
        border.color: "#293248"
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 34
            anchors.rightMargin: 34
            spacing: 22

            Image {
                Layout.preferredWidth: Math.min(410, window.width * 0.34)
                Layout.preferredHeight: 76
                source: window.storeController.assetBaseUrl + "logo-tecnolight-white.png"
                fillMode: Image.PreserveAspectFit
                asynchronous: true
                cache: true
                Text {
                    anchors.centerIn: parent
                    visible: parent.status === Image.Error
                    text: "TECNO LIGHT S.R.L.\nSEÑALIZACIÓN VIAL E INDUSTRIAL"
                    color: "#f5f6fa"
                    font.family: "Noto Sans"
                    font.pixelSize: 15
                    font.weight: Font.Bold
                }
            }

            Item { Layout.fillWidth: true }

            TextField {
                id: searchField
                Layout.preferredWidth: Math.min(290, window.width * 0.23)
                Layout.preferredHeight: 42
                placeholderText: "Buscar en el catálogo"
                color: "#ffffff"
                placeholderTextColor: "#aab3c4"
                leftPadding: 15
                rightPadding: 15
                selectByMouse: true
                background: Rectangle {
                    radius: 7
                    color: "#1c263d"
                    border.color: searchField.activeFocus ? window.orange : "#38445d"
                }
                onTextChanged: window.storeController.products.searchText = text
            }

            Button {
                id: themeButton
                text: window.darkMode ? "Claro" : "Oscuro"
                implicitHeight: 40
                onClicked: window.darkMode = !window.darkMode
                background: Rectangle { radius: 7; color: "#202b42"; border.color: "#3b4963" }
                contentItem: Text {
                    text: themeButton.text
                    color: "#ffffff"
                    font.family: "Noto Sans"
                    font.pixelSize: 11
                    font.weight: Font.DemiBold
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 12
                    rightPadding: 12
                }
            }

            Button {
                id: quoteBagButton
                implicitHeight: 42
                onClicked: quoteDrawer.open()
                background: Rectangle { radius: 7; color: window.orange }
                contentItem: Row {
                    spacing: 9
                    leftPadding: 13
                    rightPadding: 13
                    anchors.centerIn: parent
                    Text {
                        text: "Bolsa"
                        color: "#ffffff"
                        font.family: "Noto Sans"
                        font.pixelSize: 12
                        font.weight: Font.Bold
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Rectangle {
                        width: 22
                        height: 22
                        radius: 11
                        color: "#ffffff"
                        anchors.verticalCenter: parent.verticalCenter
                        Text {
                            anchors.centerIn: parent
                            text: window.storeController.itemCount
                            color: window.navy
                            font.pixelSize: 10
                            font.weight: Font.Bold
                        }
                    }
                }
            }

            Button {
                id: menuButton
                text: "☰"
                implicitWidth: 42
                implicitHeight: 42
                onClicked: menuPopup.open()
                background: Rectangle { color: "transparent" }
                contentItem: Text {
                    text: menuButton.text
                    color: "#e7ebf3"
                    font.pixelSize: 29
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

    ScrollView {
        id: contentScroll
        anchors.fill: parent
        clip: true
        contentWidth: availableWidth
        ScrollBar.vertical.policy: ScrollBar.AsNeeded

        ColumnLayout {
            width: contentScroll.availableWidth
            spacing: 0

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: Math.max(420, Math.min(610, window.height * 0.66))
                color: "#050a19"
                clip: true

                Image {
                    anchors.fill: parent
                    source: window.storeController.assetBaseUrl + "carteleria/efed8a3c-6e4d-4d5f-9e20-20d38467c75a.jpg"
                    asynchronous: true
                    cache: true
                    fillMode: Image.PreserveAspectCrop
                    opacity: 0.22
                }
                Rectangle {
                    anchors.fill: parent
                    color: "#050a19"
                    opacity: 0.62
                }
                Rectangle {
                    width: 5
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    color: window.orange
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 60
                    anchors.rightMargin: 52
                    spacing: 24

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 790
                        spacing: 19
                        Label {
                            text: "FABRICACIÓN · PROVISIÓN · SERVICIOS EN OBRA"
                            color: "#ff9a69"
                            font.family: "Noto Sans"
                            font.pixelSize: 11
                            font.weight: Font.Bold
                        }
                        Label {
                            text: "TECNO LIGHT S.R.L."
                            color: "#ffffff"
                            font.family: "Noto Sans"
                            font.pixelSize: Math.min(54, Math.max(36, window.width * 0.046))
                            font.weight: Font.Black
                            wrapMode: Text.WordWrap
                        }
                        Label {
                            Layout.maximumWidth: 730
                            text: "Fabricación y provisión integral de señalización vial, indumentaria de trabajo, elementos de protección personal (EPP) y alquiler de equipamiento para obra bajo normativas DNV, DPV y estándares IRAM."
                            color: "#d8deea"
                            wrapMode: Text.WordWrap
                            lineHeight: 1.25
                            font.family: "Noto Sans"
                            font.pixelSize: 16
                        }
                        RowLayout {
                            spacing: 12
                            Button {
                                id: requestButton
                                text: "Solicitar Presupuesto"
                                implicitHeight: 46
                                onClicked: contentScroll.contentItem.contentY = catalogSection.y
                                background: Rectangle { radius: 6; color: window.orange }
                                contentItem: Text {
                                    text: requestButton.text
                                    color: "#ffffff"
                                    font.family: "Noto Sans"
                                    font.pixelSize: 12
                                    font.weight: Font.Bold
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    leftPadding: 17
                                    rightPadding: 17
                                }
                            }
                            Button {
                                id: heroWhatsappButton
                                text: "Contactar por WhatsApp"
                                implicitHeight: 46
                                onClicked: Qt.openUrlExternally("https://wa.me/5493424278117?text=Hola%2C%20me%20comunico%20desde%20el%20sitio%20web%20de%20Tecno%20Light%20para%20solicitar%20un%20presupuesto.")
                                background: Rectangle { radius: 6; color: "transparent"; border.color: "#d9dfeb" }
                                contentItem: Text {
                                    text: heroWhatsappButton.text
                                    color: "#f6f7fb"
                                    font.family: "Noto Sans"
                                    font.pixelSize: 12
                                    font.weight: Font.DemiBold
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    leftPadding: 15
                                    rightPadding: 15
                                }
                            }
                        }
                        Label {
                            Layout.topMargin: 8
                            text: "DISTRIBUIDORES Y CONVERTIDORES CERTIFICADOS"
                            color: "#aeb8ca"
                            font.family: "Noto Sans"
                            font.pixelSize: 9
                            font.weight: Font.Bold
                        }
                        RowLayout {
                            spacing: 18
                            Image {
                                Layout.preferredWidth: 150
                                Layout.preferredHeight: 34
                                source: window.storeController.assetBaseUrl + "avery-dennison-official.svg"
                                fillMode: Image.PreserveAspectFit
                                asynchronous: true
                            }
                            Image {
                                Layout.preferredWidth: 136
                                Layout.preferredHeight: 34
                                source: window.storeController.assetBaseUrl + "trafficjet-xpress-official.svg"
                                fillMode: Image.PreserveAspectFit
                                asynchronous: true
                            }
                        }
                    }

                    Image {
                        Layout.preferredWidth: Math.min(400, window.width * 0.28)
                        Layout.preferredHeight: 330
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        source: window.storeController.assetBaseUrl + "logo-tecnolight-white.png"
                        fillMode: Image.PreserveAspectFit
                        asynchronous: true
                        cache: true
                        opacity: 0.86
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 74
                color: window.navy
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 38
                    anchors.rightMargin: 38
                    spacing: 24
                    Label { text: "Clientes, organismos y distribuidores"; color: "#aeb8ca"; font.family: "Noto Sans"; font.pixelSize: 10; font.weight: Font.Bold }
                    Repeater {
                        model: ["Vialidad Nacional", "DPV Santa Fe", "Rosi Distribuciones", "Parpal", "Municipios y Comunas", "ASSA", "Constructoras Viales"]
                        delegate: Label {
                            required property string modelData
                            text: modelData
                            color: "#ffffff"
                            font.family: "Noto Sans"
                            font.pixelSize: 10
                            font.weight: Font.DemiBold
                        }
                    }
                }
            }

            ColumnLayout {
                id: aboutSection
                Layout.fillWidth: true
                Layout.leftMargin: 52
                Layout.rightMargin: 52
                Layout.topMargin: 48
                Layout.bottomMargin: 48
                spacing: 18

                Label { text: "QUIÉNES SOMOS"; color: window.orange; font.family: "Noto Sans"; font.pixelSize: 10; font.weight: Font.Bold }
                Label {
                    Layout.fillWidth: true
                    text: "Señalización vial e industrial, desde nuestra planta."
                    color: window.ink
                    wrapMode: Text.WordWrap
                    font.family: "Noto Sans"
                    font.pixelSize: 29
                    font.weight: Font.Bold
                }
                Label {
                    Layout.fillWidth: true
                    text: "TECNO LIGHT S.R.L. fabrica y provee señalización vial reglamentaria, preventiva, informativa y transitoria conforme a pliegos DNV y DPV. Opera planta propia en el Área Industrial Los Polígonos (Santa Fe) con equipamiento de corte, soldadura, pintura y el sistema de impresión digital TrafficJet™ Xpress de Avery Dennison."
                    color: window.mutedInk
                    wrapMode: Text.WordWrap
                    lineHeight: 1.35
                    font.family: "Noto Sans"
                    font.pixelSize: 14
                }
                Label {
                    Layout.fillWidth: true
                    text: "Comercializa equipos de protección personal (EPP) e indumentaria de trabajo para obras civiles, viales e industriales, y provee alquiler de equipamiento de seguridad vial para desvíos y eventos. Distribuye y trabaja en vinculación con Rosi Distribuciones, Parpal, municipios, comunas y empresas contratistas de obra pública y privada en las provincias de Santa Fe, Córdoba, Entre Ríos y Buenos Aires."
                    color: window.mutedInk
                    wrapMode: Text.WordWrap
                    lineHeight: 1.35
                    font.family: "Noto Sans"
                    font.pixelSize: 14
                }
                Label {
                    text: "Atención comercial de lunes a viernes de 8:00 a 17:00 hs. Sedes en Santa Fe Capital y Rosario. Entrega directa en obrador o centro logístico asignado."
                    color: window.ink
                    wrapMode: Text.WordWrap
                    font.family: "Noto Sans"
                    font.pixelSize: 12
                    font.weight: Font.DemiBold
                }
            }

            Rectangle {
                Layout.fillWidth: true
                color: window.darkMode ? "#11182b" : "#e9edf3"
                implicitHeight: standardsColumn.implicitHeight + 62
                ColumnLayout {
                    id: standardsColumn
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 34
                    spacing: 16
                    Label { text: "BLOQUE B — IMPRESIÓN DIGITAL Y ROTULACIÓN"; color: window.orange; font.family: "Noto Sans"; font.pixelSize: 10; font.weight: Font.Bold }
                    Label { text: "Impresión Digital Retrorreflectiva: Avery Dennison TrafficJet™ Xpress"; color: window.ink; wrapMode: Text.WordWrap; font.family: "Noto Sans"; font.pixelSize: 24; font.weight: Font.Bold }
                    Label {
                        Layout.fillWidth: true
                        text: "Impresión digital directa sobre láminas retrorreflectivas microprismáticas (Grado Ingeniería, Alta Intensidad Prismática y Grado Diamante) con tintas eco-solventes de curado UV. Sobrelaminado protector Anti-Graffiti para remoción de aerosoles y pinturas sin pérdida de reflectividad. Rotulación gráfica de vehículos comerciales, transporte pesado y flotas corporativas."
                        color: window.mutedInk
                        wrapMode: Text.WordWrap
                        lineHeight: 1.3
                        font.family: "Noto Sans"
                        font.pixelSize: 13
                    }
                    RowLayout {
                        spacing: 9
                        Repeater {
                            model: ["Norma ASTM D4956", "Tintas Eco-solventes UV", "Sobrelaminado Anti-Graffiti", "Convertidor Oficial"]
                            delegate: Rectangle {
                                required property string modelData
                                implicitWidth: standardLabel.implicitWidth + 22
                                implicitHeight: 32
                                radius: 4
                                color: window.darkMode ? "#202b42" : "#ffffff"
                                border.color: window.line
                                Label { id: standardLabel; anchors.centerIn: parent; text: modelData; color: window.ink; font.family: "Noto Sans"; font.pixelSize: 9; font.weight: Font.DemiBold }
                            }
                        }
                    }
                    GridLayout {
                        Layout.fillWidth: true
                        columns: window.width > 1000 ? 4 : 2
                        columnSpacing: 12
                        rowSpacing: 12
                        Repeater {
                            model: [
                                {title: "Láminas Retrorreflectivas Certificadas", detail: "Grado Ingeniería, Alta Intensidad Prismática (HIP) y Grado Diamante (DNV / DPV)."},
                                {title: "Tintas Eco-solventes Homologadas", detail: "Curado UV de alta penetración, estabilidad de color y uniformidad cromática reglamentaria."},
                                {title: "Protección Integral Anti-Graffiti", detail: "Blindaje repelente a pinturas sintéticas y aerosoles. Permite limpieza sin degradación."},
                                {title: "Garantía Extendida de Fábrica", detail: "Durabilidad a la intemperie de hasta 10 a 12 años certificada por Avery Dennison."}
                            ]
                            delegate: Rectangle {
                                required property var modelData
                                Layout.fillWidth: true
                                Layout.preferredHeight: 95
                                radius: 4
                                color: window.surface
                                border.color: window.line
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    spacing: 6
                                    Label { text: modelData.title; color: window.ink; wrapMode: Text.WordWrap; font.family: "Noto Sans"; font.pixelSize: 11; font.weight: Font.Bold }
                                    Label { Layout.fillWidth: true; text: modelData.detail; color: window.mutedInk; wrapMode: Text.WordWrap; font.family: "Noto Sans"; font.pixelSize: 9 }
                                }
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                id: catalogSection
                Layout.fillWidth: true
                Layout.leftMargin: 42
                Layout.rightMargin: 42
                Layout.topMargin: 42
                Layout.bottomMargin: 48
                spacing: 20

                Label { text: "FABRICACIÓN · CATÁLOGO · COTIZACIÓN"; color: window.orange; font.family: "Noto Sans"; font.pixelSize: 10; font.weight: Font.Bold }
                RowLayout {
                    Layout.fillWidth: true
                    Label {
                        Layout.fillWidth: true
                        text: "Señalización, protección y equipamiento"
                        color: window.ink
                        wrapMode: Text.WordWrap
                        font.family: "Noto Sans"
                        font.pixelSize: 27
                        font.weight: Font.Bold
                    }
                    Label { text: "Cotización sin cargo"; color: window.mutedInk; font.family: "Noto Sans"; font.pixelSize: 11 }
                }
                Label {
                    Layout.fillWidth: true
                    text: "Seleccioná los productos o servicios para armar tu consulta. Los precios y la disponibilidad se cotizan según pliego, volumen y destino."
                    color: window.mutedInk
                    wrapMode: Text.WordWrap
                    font.family: "Noto Sans"
                    font.pixelSize: 12
                }
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    Repeater {
                        model: window.storeController.products.categories
                        delegate: Button {
                            id: categoryButton
                            required property string name
                            text: name
                            implicitHeight: 35
                            onClicked: window.storeController.products.category = name
                            background: Rectangle {
                                radius: 4
                                color: window.storeController.products.category === name ? window.navy : window.surface
                                border.color: window.storeController.products.category === name ? window.navy : window.line
                            }
                            contentItem: Text {
                                text: categoryButton.text
                                color: window.storeController.products.category === name ? "#ffffff" : window.ink
                                font.family: "Noto Sans"
                                font.pixelSize: 10
                                font.weight: Font.DemiBold
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: 11
                                rightPadding: 11
                            }
                        }
                    }
                    Item { Layout.fillWidth: true }
                }
                GridLayout {
                    id: productGrid
                    Layout.fillWidth: true
                    columns: window.width >= 1220 ? 4 : window.width >= 900 ? 3 : 2
                    columnSpacing: 13
                    rowSpacing: 16
                    Repeater {
                        model: window.storeController.products
                        delegate: ProductCard {
                            required property int productId
                            required property string name
                            required property string category
                            required property string description
                            required property double price
                            required property int stock
                            required property string badge
                            required property string imageUrl
                            required property var gallery
                            Layout.fillWidth: true
                            Layout.preferredWidth: (productGrid.width - (productGrid.columns - 1) * productGrid.columnSpacing) / productGrid.columns
                            darkMode: window.darkMode
                            storeController: window.storeController
                            onSelected: window.storeController.openProduct(productId)
                            onAddRequested: window.storeController.addToCart(productId, 1)
                        }
                    }
                }
                Label {
                    Layout.fillWidth: true
                    visible: window.storeController.products.count === 0
                    text: "No encontramos resultados para esa búsqueda."
                    color: window.mutedInk
                    horizontalAlignment: Text.AlignHCenter
                    padding: 22
                    font.family: "Noto Sans"
                    font.pixelSize: 13
                }
            }

            Rectangle {
                Layout.fillWidth: true
                color: window.darkMode ? "#11182b" : "#ffffff"
                implicitHeight: processColumn.implicitHeight + 58
                ColumnLayout {
                    id: processColumn
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 35
                    spacing: 18
                    Label { text: "CAPACIDAD OPERATIVA E INFRAESTRUCTURA"; color: window.orange; font.family: "Noto Sans"; font.pixelSize: 10; font.weight: Font.Bold }
                    Label { text: "PROCESO INDUSTRIAL DE FABRICACIÓN"; color: window.ink; font.family: "Noto Sans"; font.pixelSize: 25; font.weight: Font.Bold }
                    Label { text: "Fabricación integral desde diseño hasta rotulado final. Proceso continuo en planta propia con equipamiento especializado y control de calidad en cada etapa."; color: window.mutedInk; wrapMode: Text.WordWrap; font.family: "Noto Sans"; font.pixelSize: 12 }
                    GridLayout {
                        Layout.fillWidth: true
                        columns: window.width > 1000 ? 5 : 2
                        columnSpacing: 11
                        rowSpacing: 11
                        Repeater {
                            model: [
                                {title: "DISEÑO", detail: "Elaboración de planos técnicos conforme a pliegos DNV / DPV y normativas IRAM."},
                                {title: "CORTE", detail: "Corte de chapas y perfiles mediante guillotina y pantógrafo industrial."},
                                {title: "SOLDADURA", detail: "Ensamble estructural de marcos, refuerzos y pescantes de gran porte."},
                                {title: "PINTURA", detail: "Tratamiento anticorrosivo y pintura horneada para exposición a la intemperie."},
                                {title: "ROTULADO", detail: "Láminas Avery Dennison mediante sistema TrafficJet™ Xpress."}
                            ]
                            delegate: Rectangle {
                                required property var modelData
                                Layout.fillWidth: true
                                Layout.preferredHeight: 112
                                radius: 4
                                color: window.darkMode ? "#1b2437" : "#f4f6f9"
                                border.color: window.line
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    spacing: 8
                                    Label { text: modelData.title; color: window.orange; font.family: "Noto Sans"; font.pixelSize: 11; font.weight: Font.Bold }
                                    Label { Layout.fillWidth: true; text: modelData.detail; color: window.mutedInk; wrapMode: Text.WordWrap; font.family: "Noto Sans"; font.pixelSize: 10 }
                                }
                            }
                        }
                    }
                    Label { text: "Planta fabril en Área Industrial Los Polígonos · Maquinaria de corte, plegado y soldadura · Flota propia · Cuadrillas capacitadas · Sedes en Santa Fe y Rosario"; color: window.ink; wrapMode: Text.WordWrap; font.family: "Noto Sans"; font.pixelSize: 11; font.weight: Font.DemiBold }
                }
            }

            ColumnLayout {
                id: rentalSection
                Layout.fillWidth: true
                Layout.leftMargin: 42
                Layout.rightMargin: 42
                Layout.topMargin: 42
                Layout.bottomMargin: 46
                spacing: 17
                Label { text: "BLOQUE D — SERVICIOS Y ALQUILER DE EQUIPAMIENTO"; color: window.orange; font.family: "Noto Sans"; font.pixelSize: 10; font.weight: Font.Bold }
                Label { text: "ALQUILER DE EQUIPAMIENTO VIAL Y SERVICIOS EN OBRA"; color: window.ink; wrapMode: Text.WordWrap; font.family: "Noto Sans"; font.pixelSize: 25; font.weight: Font.Bold }
                Label { text: "Provisión y alquiler de dispositivos de seguridad vial para desvíos, obras civiles y eventos. Logística de colocación y mantenimiento directamente en traza. Entrega en obrador o depósito asignado."; color: window.mutedInk; wrapMode: Text.WordWrap; font.family: "Noto Sans"; font.pixelSize: 13 }
                GridLayout {
                    Layout.fillWidth: true
                    columns: window.width > 1000 ? 4 : 2
                    columnSpacing: 11
                    rowSpacing: 11
                    Repeater {
                        model: [
                            {title: "Vallas de Seguridad y Cerramiento", detail: "Vallas metálicas peatonales, vallas de obra pesadas y pasarelas con barandas reglamentarias."},
                            {title: "Balizamiento y Señalización Luminosa", detail: "Balizas LED autónomas, semáforos viales portátiles y flechas luminosas direccionales."},
                            {title: "Dispositivos de Delineación", detail: "Tambores canalizadores, conos reflectivos, delineadores flexibles y chapones reforzados."},
                            {title: "Logística de Servicio", detail: "Entrega, montaje, reposición y mantenimiento preventivo durante el plazo de obra."}
                        ]
                        delegate: Rectangle {
                            required property var modelData
                            Layout.fillWidth: true
                            Layout.preferredHeight: 128
                            radius: 4
                            color: window.darkMode ? "#11182b" : "#ffffff"
                            border.color: window.line
                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 13
                                spacing: 8
                                Label { text: modelData.title; color: window.ink; wrapMode: Text.WordWrap; font.family: "Noto Sans"; font.pixelSize: 12; font.weight: Font.Bold }
                                Label { Layout.fillWidth: true; text: modelData.detail; color: window.mutedInk; wrapMode: Text.WordWrap; font.family: "Noto Sans"; font.pixelSize: 10 }
                            }
                        }
                    }
                }
                Label { text: "Modalidad: Alquiler por jornada, semana o plazo de obra. Cotización sin cargo para obras con pliego o por adjudicación directa."; color: window.ink; wrapMode: Text.WordWrap; font.family: "Noto Sans"; font.pixelSize: 12; font.weight: Font.DemiBold }
                Button {
                    id: rentalQuoteButton
                    text: "Cotizar Alquiler de Vallas y Dispositivos"
                    implicitHeight: 42
                    onClicked: Qt.openUrlExternally("https://wa.me/5493424278117?text=Hola%2C%20me%20comunico%20desde%20el%20sitio%20web%20para%20solicitar%20presupuesto%20por%20alquiler%20de%20vallas%20y%20equipamiento.")
                    background: Rectangle { radius: 5; color: window.orange }
                    contentItem: Text { text: rentalQuoteButton.text; color: "#ffffff"; font.family: "Noto Sans"; font.pixelSize: 11; font.weight: Font.Bold; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter; leftPadding: 14; rightPadding: 14 }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                color: window.darkMode ? "#11182b" : "#e9edf3"
                implicitHeight: ppeColumn.implicitHeight + 58
                ColumnLayout {
                    id: ppeColumn
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 35
                    spacing: 16
                    Label { text: "BLOQUE C — EPP E INDUMENTARIA"; color: window.orange; font.family: "Noto Sans"; font.pixelSize: 10; font.weight: Font.Bold }
                    Label { text: "ELEMENTOS DE PROTECCIÓN PERSONAL E INDUMENTARIA"; color: window.ink; wrapMode: Text.WordWrap; font.family: "Noto Sans"; font.pixelSize: 24; font.weight: Font.Bold }
                    Label { text: "Comercialización de indumentaria de trabajo homologada y equipamiento de protección personal (EPP) para obras civiles, viales e industriales. Provisión por unidad o por volumen con entrega en obra o centro logístico asignado."; color: window.mutedInk; wrapMode: Text.WordWrap; font.family: "Noto Sans"; font.pixelSize: 12 }
                    GridLayout {
                        Layout.fillWidth: true
                        columns: window.width > 1000 ? 3 : 2
                        columnSpacing: 12
                        rowSpacing: 8
                        Repeater {
                            model: [
                                "Indumentaria de alta visibilidad — chalecos clase 2 y clase 3",
                                "Ropa de trabajo homologada, prendas térmicas e impermeables",
                                "Calzado con puntera de acero y suela antiperforación",
                                "Semimáscaras, filtros intercambiables y mascarillas N95",
                                "Protectores auditivos, anteojos de seguridad y pantallas faciales",
                                "Arneses, colas de amarre, guantes y cascos de seguridad",
                                "Matafuegos de polvo ABC y CO₂, revisión y recarga",
                                "Botiquines reglamentarios para obra y empresa",
                                "Señalización de seguridad para plantas e instalaciones"
                            ]
                            delegate: RowLayout {
                                required property string modelData
                                Layout.fillWidth: true
                                spacing: 8
                                Label { text: "•"; color: window.orange; font.pixelSize: 15; font.weight: Font.Bold }
                                Label { Layout.fillWidth: true; text: modelData; color: window.mutedInk; wrapMode: Text.WordWrap; font.family: "Noto Sans"; font.pixelSize: 10 }
                            }
                        }
                    }
                    Button {
                        id: ppeQuoteButton
                        text: "Solicitar Cotización de EPP"
                        implicitHeight: 40
                        onClicked: Qt.openUrlExternally("mailto:tecnolightsrl@arnet.com.ar?subject=Cotizaci%C3%B3n%20EPP%20e%20Indumentaria")
                        background: Rectangle { radius: 5; color: window.orange }
                        contentItem: Text { text: ppeQuoteButton.text; color: "#ffffff"; font.family: "Noto Sans"; font.pixelSize: 11; font.weight: Font.Bold; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter; leftPadding: 14; rightPadding: 14 }
                    }
                }
            }

            ColumnLayout {
                id: contactSection
                Layout.fillWidth: true
                Layout.leftMargin: 42
                Layout.rightMargin: 42
                Layout.topMargin: 42
                Layout.bottomMargin: 46
                spacing: 17
                Label { text: "CONTACTO"; color: window.orange; font.family: "Noto Sans"; font.pixelSize: 10; font.weight: Font.Bold }
                Label { text: "CANALES DE CONTACTO"; color: window.ink; font.family: "Noto Sans"; font.pixelSize: 25; font.weight: Font.Bold }
                Label { text: "Atención comercial de Lunes a Viernes, 8:00 a 17:00 hs. Para pliegos y licitaciones, escribinos por email."; color: window.mutedInk; wrapMode: Text.WordWrap; font.family: "Noto Sans"; font.pixelSize: 12 }
                GridLayout {
                    Layout.fillWidth: true
                    columns: window.width > 1050 ? 3 : 1
                    columnSpacing: 12
                    rowSpacing: 12
                    Repeater {
                        model: [
                            {title: "Sede Central · Santa Fe", address: "Suipacha 3243, Santa Fe Capital", phone: "(0342) 455-3582", email: "tecnolightsrl@arnet.com.ar", map: "https://www.google.com/maps/search/?api=1&query=Suipacha+3243,+Santa+Fe,+Argentina"},
                            {title: "Sede Comercial · Rosario", address: "Gutenberg 1122, Rosario, Santa Fe", phone: "(0341) 438-8444", email: "tecnolightrsr@arnet.com.ar", map: "https://www.google.com/maps/search/?api=1&query=Gutenberg+1122,+Rosario,+Santa+Fe,+Argentina"},
                            {title: "Planta fabril · Los Polígonos", address: "Área Industrial Los Polígonos, Santa Fe", phone: "(0342) 455-3582", email: "tecnolightsrl@arnet.com.ar", map: "https://www.google.com/maps/search/?api=1&query=Parque+Industrial+Los+Poligonos,+Santa+Fe,+Argentina"}
                        ]
                        delegate: Rectangle {
                            required property var modelData
                            Layout.fillWidth: true
                            Layout.preferredHeight: 174
                            radius: 4
                            color: window.surface
                            border.color: window.line
                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 15
                                spacing: 7
                                Label { text: modelData.title; color: window.ink; font.family: "Noto Sans"; font.pixelSize: 12; font.weight: Font.Bold }
                                Label { Layout.fillWidth: true; text: modelData.address; color: window.mutedInk; wrapMode: Text.WordWrap; font.family: "Noto Sans"; font.pixelSize: 10 }
                                Button {
                                    text: modelData.phone
                                    onClicked: Qt.openUrlExternally("tel:" + modelData.phone.replace(/[()\s-]/g, ""))
                                    background: Rectangle { color: "transparent" }
                                    contentItem: Text { text: modelData.phone; color: "#2571bb"; font.family: "Noto Sans"; font.pixelSize: 10 }
                                }
                                Button {
                                    text: modelData.email
                                    onClicked: Qt.openUrlExternally("mailto:" + modelData.email)
                                    background: Rectangle { color: "transparent" }
                                    contentItem: Text { text: modelData.email; color: "#2571bb"; font.family: "Noto Sans"; font.pixelSize: 10 }
                                }
                                Button {
                                    text: "Ver ubicación"
                                    onClicked: Qt.openUrlExternally(modelData.map)
                                    background: Rectangle { color: "transparent" }
                                    contentItem: Text { text: "Ver ubicación"; color: window.orange; font.family: "Noto Sans"; font.pixelSize: 9; font.weight: Font.Bold }
                                }
                            }
                        }
                    }
                }
                Label { text: "Zona de cobertura"; color: window.ink; font.family: "Noto Sans"; font.pixelSize: 13; font.weight: Font.Bold }
                Label { text: "Santa Fe  ·  Rosario  ·  Gran Rosario  ·  Córdoba  ·  Entre Ríos  ·  Buenos Aires  ·  +6 provincias"; color: window.mutedInk; wrapMode: Text.WordWrap; font.family: "Noto Sans"; font.pixelSize: 11 }
            }

            Rectangle {
                Layout.fillWidth: true
                color: window.navy
                implicitHeight: footerColumn.implicitHeight + 48
                ColumnLayout {
                    id: footerColumn
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 27
                    spacing: 12
                    Image {
                        Layout.preferredWidth: 300
                        Layout.preferredHeight: 56
                        source: window.storeController.assetBaseUrl + "logo-tecnolight-white.png"
                        fillMode: Image.PreserveAspectFit
                        asynchronous: true
                    }
                    Label { text: "Señalización & Protección Personal. Referentes en seguridad vial, demarcación horizontal y seguridad industrial. Lunes a Viernes de 8:00 a 17:00 hs."; color: "#c0c8d7"; wrapMode: Text.WordWrap; font.family: "Noto Sans"; font.pixelSize: 10 }
                    RowLayout {
                        spacing: 15
                        Button {
                            text: "Cotizaciones Rápidas · WhatsApp"
                            onClicked: Qt.openUrlExternally("https://wa.me/5493424278117?text=Hola%2C%20me%20comunico%20desde%20el%20sitio%20web%20de%20Tecno%20Light%20para%20solicitar%20un%20presupuesto.")
                            background: Rectangle { radius: 4; color: window.whatsapp }
                            contentItem: Text { text: "Cotizaciones Rápidas · WhatsApp"; color: "#ffffff"; font.family: "Noto Sans"; font.pixelSize: 10; font.weight: Font.Bold; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter; leftPadding: 12; rightPadding: 12 }
                        }
                        Button {
                            text: "Instagram Oficial"
                            onClicked: Qt.openUrlExternally("https://www.instagram.com/tecnolight.srl/")
                            background: Rectangle { color: "transparent"; border.color: "#53617a"; radius: 4 }
                            contentItem: Text { text: "Instagram Oficial"; color: "#e8ebf2"; font.family: "Noto Sans"; font.pixelSize: 10; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter; leftPadding: 12; rightPadding: 12 }
                        }
                    }
                    Label { text: "© 2026 Tecno Light S.R.L. — CUIT: 30-69238932-4 | Todos los derechos reservados."; color: "#8f9ab0"; font.family: "Noto Sans"; font.pixelSize: 9 }
                    Label { text: "Rosario · Santa Fe · Argentina"; color: "#8f9ab0"; font.family: "Noto Sans"; font.pixelSize: 9 }
                }
            }
        }
    }

    Popup {
        id: menuPopup
        x: window.width - width - 22
        y: 86
        width: 290
        padding: 11
        modal: false
        background: Rectangle { color: window.navy; radius: 5; border.color: "#344059" }
        Column {
            width: parent.width
            Repeater {
                model: [
                    {label: "Inicio", target: "inicio"},
                    {label: "Fabricación & Catálogo", target: "catalogo"},
                    {label: "Servicios & Instalación en Ruta", target: "servicios"},
                    {label: "Seguridad Industrial y EPP", target: "seguridad"},
                    {label: "Planta Industrial & Tecnología", target: "planta"},
                    {label: "Quiénes Somos", target: "nosotros"},
                    {label: "Sedes & Contacto", target: "contacto"}
                ]
                delegate: Button {
                    id: navigationButton
                    required property var modelData
                    width: parent.width
                    height: 40
                    text: modelData.label
                    onClicked: {
                        menuPopup.close()
                        if (modelData.target === "catalogo") contentScroll.contentItem.contentY = catalogSection.y
                        else if (modelData.target === "servicios") contentScroll.contentItem.contentY = rentalSection.y
                        else if (modelData.target === "seguridad") contentScroll.contentItem.contentY = ppeColumn.y
                        else if (modelData.target === "planta") contentScroll.contentItem.contentY = processColumn.y
                        else if (modelData.target === "nosotros") contentScroll.contentItem.contentY = aboutSection.y
                        else if (modelData.target === "contacto") contentScroll.contentItem.contentY = contactSection.y
                        else contentScroll.contentItem.contentY = 0
                    }
                    background: Rectangle { color: navigationButton.hovered ? "#202b42" : "transparent"; radius: 3 }
                    contentItem: Text { text: navigationButton.text; color: "#f2f4f8"; font.family: "Noto Sans"; font.pixelSize: 11; horizontalAlignment: Text.AlignLeft; verticalAlignment: Text.AlignVCenter; leftPadding: 12 }
                }
            }
        }
    }

    Dialog {
        id: productDialog
        modal: true
        width: Math.min(980, window.width - 36)
        height: Math.min(650, window.height - 36)
        anchors.centerIn: Overlay.overlay
        padding: 0
        background: Rectangle { color: window.surface; radius: 5; border.color: window.line }
        contentItem: ProductDetail {
            product: window.storeController.selectedProduct
            storeController: window.storeController
            darkMode: window.darkMode
            onCloseRequested: productDialog.close()
            onAddRequested: function(productId, quantity) {
                if (window.storeController.addToCart(productId, quantity)) {
                    productDialog.close()
                    quoteDrawer.open()
                }
            }
        }
    }

    Drawer {
        id: quoteDrawer
        edge: Qt.RightEdge
        width: Math.min(460, window.width * 0.94)
        height: window.height
        modal: true
        background: Rectangle { color: window.surface }
        contentItem: CartDrawer {
            storeController: window.storeController
            darkMode: window.darkMode
            onCheckoutRequested: checkoutDialog.open()
        }
    }

    CheckoutDialog {
        id: checkoutDialog
        storeController: window.storeController
        darkMode: window.darkMode
        onSubmitted: function(customerName, email) {
            const whatsappUrl = window.storeController.whatsappQuoteUrl(customerName, email)
            if (window.storeController.confirmOrder(customerName, email)) {
                Qt.openUrlExternally(whatsappUrl)
                checkoutDialog.close()
                quoteDrawer.close()
            }
        }
    }

    Rectangle {
        id: whatsappFloat
        z: 10
        width: 68
        height: 68
        radius: 34
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 28
        anchors.bottomMargin: 28
        color: window.whatsapp
        border.color: "#6be79b"
        border.width: 1
        Text {
            anchors.centerIn: parent
            text: "◉"
            color: "#ffffff"
            font.pixelSize: 30
            font.weight: Font.Bold
        }
        ToolTip.visible: whatsappMouse.containsMouse
        ToolTip.text: "Contactar por WhatsApp"
        MouseArea {
            id: whatsappMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: Qt.openUrlExternally("https://wa.me/5493424278117?text=Hola%2C%20me%20comunico%20desde%20el%20sitio%20web%20de%20Tecno%20Light%20para%20solicitar%20un%20presupuesto.")
        }
    }

    Popup {
        id: toast
        property string message: ""
        x: (window.width - width) / 2
        y: window.height - height - 24
        width: Math.min(450, window.width - 40)
        height: 50
        padding: 0
        background: Rectangle { color: window.navy; radius: 5; border.color: "#344059" }
        contentItem: Label { text: toast.message; color: "#ffffff"; leftPadding: 15; rightPadding: 15; verticalAlignment: Text.AlignVCenter; font.family: "Noto Sans"; font.pixelSize: 11 }
        Timer { id: toastTimer; interval: 4000; onTriggered: toast.close() }
    }

    Connections {
        target: window.storeController
        function onSelectedProductChanged() {
            if (window.storeController.selectedProduct.productId !== undefined)
                productDialog.open()
        }
        function onOrderConfirmed(reference) {
            toast.message = "Solicitud " + reference + " guardada. Continuá por WhatsApp para recibir tu cotización."
            toast.open()
            toastTimer.restart()
        }
        function onCheckoutFailed(message) {
            toast.message = message
            toast.open()
            toastTimer.restart()
        }
    }
}
