#pragma once

#include "ProductModel.hpp"

#include <QAbstractListModel>
#include <QHash>
#include <QString>
#include <QVector>

class CartModel final : public QAbstractListModel {
    Q_OBJECT
    Q_PROPERTY(int itemCount READ itemCount NOTIFY summaryChanged)
    Q_PROPERTY(double subtotal READ subtotal NOTIFY summaryChanged)
    Q_PROPERTY(bool empty READ empty NOTIFY summaryChanged)

public:
    enum Roles {
        IdRole = Qt::UserRole + 1,
        NameRole,
        CategoryRole,
        PriceRole,
        QuantityRole,
        StockRole,
        ImageUrlRole,
        LineTotalRole
    };
    Q_ENUM(Roles)

    explicit CartModel(QObject *parent = nullptr);
    [[nodiscard]] int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    [[nodiscard]] QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    [[nodiscard]] QHash<int, QByteArray> roleNames() const override;

    [[nodiscard]] int itemCount() const;
    [[nodiscard]] double subtotal() const;
    [[nodiscard]] bool empty() const;
    void setCatalog(ProductModel *catalog);
    void setStoragePath(const QString &path);

    bool add(int productId, int quantity = 1);
    bool setQuantity(int productId, int quantity);
    bool remove(int productId);
    void clear();
    [[nodiscard]] QHash<int, int> quantities() const;
    bool load();
    bool save();

signals:
    void summaryChanged();
    void storageError(const QString &message);

private:
    struct Entry {
        int productId = 0;
        int quantity = 0;
    };

    [[nodiscard]] int rowForId(int productId) const;
    void persistAndNotify();

    ProductModel *m_catalog = nullptr;
    QString m_storagePath;
    QVector<Entry> m_entries;
};