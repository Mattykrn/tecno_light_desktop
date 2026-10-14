#pragma once

#include "Product.hpp"
#include "CategoryModel.hpp"

#include <QAbstractListModel>
#include <QVariantMap>
#include <QVector>

class ProductModel final : public QAbstractListModel {
    Q_OBJECT
    Q_PROPERTY(QString category READ category WRITE setCategory NOTIFY filtersChanged)
    Q_PROPERTY(QString searchText READ searchText WRITE setSearchText NOTIFY filtersChanged)
    Q_PROPERTY(CategoryModel *categories READ categories CONSTANT)
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)

public:
    enum Roles {
        IdRole = Qt::UserRole + 1,
        NameRole,
        CategoryRole,
        DescriptionRole,
        PriceRole,
        StockRole,
        BadgeRole,
        ImageUrlRole,
        GalleryRole
    };
    Q_ENUM(Roles)

    explicit ProductModel(QObject *parent = nullptr);

    [[nodiscard]] int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    [[nodiscard]] QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    [[nodiscard]] QHash<int, QByteArray> roleNames() const override;

    [[nodiscard]] QString category() const;
    void setCategory(const QString &category);
    [[nodiscard]] QString searchText() const;
    void setSearchText(const QString &searchText);
    [[nodiscard]] CategoryModel *categories();

    [[nodiscard]] QVariantMap productById(int id) const;
    [[nodiscard]] const Product *find(int id) const;
    [[nodiscard]] QVector<Product> products() const;
    bool loadJson(const QByteArray &json);
    [[nodiscard]] QByteArray toJson() const;
    bool reduceStock(const QHash<int, int> &quantities);

signals:
    void filtersChanged();
    void countChanged();
    void catalogChanged();

private:
    [[nodiscard]] QVector<int> visibleIndices() const;
    void resetFilters();

    QVector<Product> m_products;
    CategoryModel m_categories;
    QString m_category = QStringLiteral("Todos");
    QString m_searchText;
};