#pragma once

#include "CartModel.hpp"
#include "ProductModel.hpp"

#include <QObject>
#include <QVariantMap>

class StoreController final : public QObject {
    Q_OBJECT
    Q_PROPERTY(ProductModel *products READ products CONSTANT)
    Q_PROPERTY(CartModel *cart READ cart CONSTANT)
    Q_PROPERTY(QString assetBaseUrl READ assetBaseUrl CONSTANT)
    Q_PROPERTY(QVariantMap selectedProduct READ selectedProduct NOTIFY selectedProductChanged)
    Q_PROPERTY(int itemCount READ itemCount NOTIFY totalsChanged)

public:
    explicit StoreController(QObject *parent = nullptr);

    [[nodiscard]] ProductModel *products();
    [[nodiscard]] CartModel *cart();
    [[nodiscard]] QString assetBaseUrl() const;
    [[nodiscard]] QVariantMap selectedProduct() const;
    [[nodiscard]] int itemCount() const;

    Q_INVOKABLE void openProduct(int productId);
    Q_INVOKABLE void closeProduct();
    Q_INVOKABLE bool addToCart(int productId, int quantity = 1);
    Q_INVOKABLE bool setCartQuantity(int productId, int quantity);
    Q_INVOKABLE bool removeFromCart(int productId);
    Q_INVOKABLE QString money(double amount) const;
    Q_INVOKABLE bool confirmOrder(const QString &customerName, const QString &email);
    Q_INVOKABLE QString whatsappQuoteUrl(const QString &customerName, const QString &email) const;

signals:
    void selectedProductChanged();
    void totalsChanged();
    void orderConfirmed(const QString &reference);
    void checkoutFailed(const QString &message);

private:
    bool loadCatalog();
    bool saveCatalog() const;
    bool saveOrder(const QString &name, const QString &email, const QString &reference) const;

    ProductModel m_products;
    CartModel m_cart;
    QVariantMap m_selectedProduct;
    QString m_catalogPath;
    QString m_ordersPath;
};