#include "StoreController.hpp"

#include <QDateTime>
#include <QDir>
#include <QFile>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QLocale>
#include <QRegularExpression>
#include <QSaveFile>
#include <QStandardPaths>
#include <QUrl>
#include <QUrlQuery>

StoreController::StoreController(QObject *parent) : QObject(parent), m_products(), m_cart()
{
    const QString dataDirectory = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir().mkpath(dataDirectory);
    m_catalogPath = dataDirectory + QStringLiteral("/products.json");
    m_ordersPath = dataDirectory + QStringLiteral("/quote-requests.json");
    m_cart.setStoragePath(dataDirectory + QStringLiteral("/cart.json"));

    loadCatalog();
    m_cart.setCatalog(&m_products);
    m_cart.load();
    connect(&m_cart, &CartModel::summaryChanged, this, &StoreController::totalsChanged);
    connect(&m_cart, &CartModel::storageError, this, &StoreController::checkoutFailed);
}

ProductModel *StoreController::products()
{
    return &m_products;
}

CartModel *StoreController::cart()
{
    return &m_cart;
}

QString StoreController::assetBaseUrl() const
{
#ifdef __EMSCRIPTEN__
    return QStringLiteral("/site-assets/");
#else
    return QStringLiteral("https://tecno-light-v3-irux.vercel.app/images/");
#endif
}

QVariantMap StoreController::selectedProduct() const
{
    return m_selectedProduct;
}

int StoreController::itemCount() const
{
    return m_cart.itemCount();
}

void StoreController::openProduct(int productId)
{
    const QVariantMap product = m_products.productById(productId);
    if (product.isEmpty()) {
        return;
    }
    m_selectedProduct = product;
    emit selectedProductChanged();
}

void StoreController::closeProduct()
{
    if (m_selectedProduct.isEmpty()) {
        return;
    }
    m_selectedProduct.clear();
    emit selectedProductChanged();
}

bool StoreController::addToCart(int productId, int quantity)
{
    if (!m_cart.add(productId, quantity)) {
        emit checkoutFailed(QStringLiteral("No hay stock disponible para esa cantidad."));
        return false;
    }
    return true;
}

bool StoreController::setCartQuantity(int productId, int quantity)
{
    if (!m_cart.setQuantity(productId, quantity)) {
        emit checkoutFailed(QStringLiteral("La cantidad solicitada supera el stock disponible."));
        return false;
    }
    return true;
}

bool StoreController::removeFromCart(int productId)
{
    return m_cart.remove(productId);
}

QString StoreController::money(double amount) const
{
    return QLocale(QLocale::Spanish, QLocale::Argentina).toCurrencyString(amount, QStringLiteral("$"), 0);
}

bool StoreController::confirmOrder(const QString &customerName, const QString &email)
{
    static const QRegularExpression emailPattern(QStringLiteral(R"(^[^\s@]+@[^\s@]+\.[^\s@]+$)"));
    if (customerName.trimmed().isEmpty() || !emailPattern.match(email.trimmed()).hasMatch()) {
        emit checkoutFailed(QStringLiteral("Ingresa tu nombre y un correo electrónico válido."));
        return false;
    }
    if (m_cart.empty()) {
        emit checkoutFailed(QStringLiteral("El carrito está vacío."));
        return false;
    }

    const QString reference = QStringLiteral("TL-%1")
        .arg(QDateTime::currentDateTimeUtc().toString(QStringLiteral("yyMMdd-hhmmss")));
    if (!saveOrder(customerName.trimmed(), email.trimmed(), reference)) {
        emit checkoutFailed(QStringLiteral("No se pudo guardar la solicitud en el almacenamiento local."));
        return false;
    }

    m_cart.clear();
    closeProduct();
    emit orderConfirmed(reference);
    return true;
}

QString StoreController::whatsappQuoteUrl(const QString &customerName, const QString &email) const
{
    QString message = QStringLiteral("Hola, me comunico desde el sitio web de Tecno Light para solicitar un presupuesto.\n\n");
    message += QStringLiteral("Nombre: %1\nCorreo: %2\n\nProductos y servicios de interés:\n")
        .arg(customerName.trimmed(), email.trimmed());
    const QHash<int, int> quantities = m_cart.quantities();
    for (const auto &item : quantities.asKeyValueRange()) {
        const Product *product = m_products.find(item.first);
        if (product != nullptr) {
            message += QStringLiteral("• %1 — cantidad: %2\n").arg(product->name).arg(item.second);
        }
    }
    message += QStringLiteral("\nAgradezco una cotización sin cargo.");

    QUrl url(QStringLiteral("https://wa.me/5493424278117"));
    QUrlQuery query;
    query.addQueryItem(QStringLiteral("text"), message);
    url.setQuery(query);
    return url.toString(QUrl::FullyEncoded);
}

bool StoreController::loadCatalog()
{
    QFile storedCatalog(m_catalogPath);
    if (storedCatalog.exists() && storedCatalog.open(QIODevice::ReadOnly)) {
        if (m_products.loadJson(storedCatalog.readAll())) {
            return true;
        }
        emit checkoutFailed(QStringLiteral("El catálogo guardado no es válido; se restaurarán los productos iniciales."));
    }

    QFile seedCatalog(QStringLiteral(":/store/products.json"));
    if (!seedCatalog.open(QIODevice::ReadOnly) || !m_products.loadJson(seedCatalog.readAll())) {
        emit checkoutFailed(QStringLiteral("No se pudo cargar el catálogo inicial."));
        return false;
    }
    return saveCatalog();
}

bool StoreController::saveCatalog() const
{
    QSaveFile file(m_catalogPath);
    const QByteArray json = m_products.toJson();
    if (!file.open(QIODevice::WriteOnly) || file.write(json) != json.size() || !file.commit()) {
        return false;
    }
    return true;
}

bool StoreController::saveOrder(const QString &name, const QString &email, const QString &reference) const
{
    QJsonArray orders;
    QFile existing(m_ordersPath);
    if (existing.open(QIODevice::ReadOnly)) {
        const QJsonDocument previous = QJsonDocument::fromJson(existing.readAll());
        if (previous.isArray()) {
            orders = previous.array();
        }
    }

    QJsonArray items;
    const QHash<int, int> quantities = m_cart.quantities();
    for (auto it = quantities.cbegin(); it != quantities.cend(); ++it) {
        const Product *product = m_products.find(it.key());
        if (product == nullptr) {
            continue;
        }
        items.append(QJsonObject{
            {QStringLiteral("productId"), product->id},
            {QStringLiteral("name"), product->name},
            {QStringLiteral("category"), product->category},
            {QStringLiteral("quantity"), it.value()}
        });
    }

    orders.append(QJsonObject{
        {QStringLiteral("reference"), reference},
        {QStringLiteral("createdAt"), QDateTime::currentDateTimeUtc().toString(Qt::ISODate)},
        {QStringLiteral("customerName"), name},
        {QStringLiteral("email"), email},
        {QStringLiteral("items"), items}
    });

    QSaveFile file(m_ordersPath);
    const QByteArray json = QJsonDocument(orders).toJson(QJsonDocument::Indented);
    return file.open(QIODevice::WriteOnly) && file.write(json) == json.size() && file.commit();
}