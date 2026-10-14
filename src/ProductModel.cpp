#include "ProductModel.hpp"

#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonParseError>
#include <QUrl>

ProductModel::ProductModel(QObject *parent) : QAbstractListModel(parent), m_categories()
{
}

int ProductModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid()) {
        return 0;
    }
    return visibleIndices().size();
}

QVariant ProductModel::data(const QModelIndex &index, int role) const
{
    const QVector<int> indices = visibleIndices();
    if (!index.isValid() || index.row() < 0 || index.row() >= indices.size()) {
        return {};
    }

    const Product &product = m_products.at(indices.at(index.row()));
    switch (role) {
    case IdRole: return product.id;
    case NameRole: return product.name;
    case CategoryRole: return product.category;
    case DescriptionRole: return product.description;
    case PriceRole: return product.price;
    case StockRole: return product.stock;
    case BadgeRole: return product.badge;
    case ImageUrlRole: return product.imageUrl;
    case GalleryRole: {
        QVariantList gallery;
        for (const QString &image : product.gallery) {
            gallery.append(image);
        }
        return gallery;
    }
    default: return {};
    }
}

QHash<int, QByteArray> ProductModel::roleNames() const
{
    return {
        {IdRole, "productId"},
        {NameRole, "name"},
        {CategoryRole, "category"},
        {DescriptionRole, "description"},
        {PriceRole, "price"},
        {StockRole, "stock"},
        {BadgeRole, "badge"},
        {ImageUrlRole, "imageUrl"},
        {GalleryRole, "gallery"}
    };
}

QString ProductModel::category() const
{
    return m_category;
}

void ProductModel::setCategory(const QString &category)
{
    if (m_category == category) {
        return;
    }
    m_category = category;
    resetFilters();
}

QString ProductModel::searchText() const
{
    return m_searchText;
}

void ProductModel::setSearchText(const QString &searchText)
{
    if (m_searchText == searchText) {
        return;
    }
    m_searchText = searchText;
    resetFilters();
}

CategoryModel *ProductModel::categories()
{
    return &m_categories;
}

QVariantMap ProductModel::productById(int id) const
{
    const Product *product = find(id);
    if (product == nullptr) {
        return {};
    }

    QVariantList gallery;
    for (const QString &image : product->gallery) {
        gallery.append(image);
    }
    return {
        {QStringLiteral("productId"), product->id},
        {QStringLiteral("name"), product->name},
        {QStringLiteral("category"), product->category},
        {QStringLiteral("description"), product->description},
        {QStringLiteral("price"), product->price},
        {QStringLiteral("stock"), product->stock},
        {QStringLiteral("badge"), product->badge},
        {QStringLiteral("imageUrl"), product->imageUrl},
        {QStringLiteral("gallery"), gallery}
    };
}

const Product *ProductModel::find(int id) const
{
    for (const Product &product : m_products) {
        if (product.id == id) {
            return &product;
        }
    }
    return nullptr;
}

QVector<Product> ProductModel::products() const
{
    return m_products;
}

bool ProductModel::loadJson(const QByteArray &json)
{
    QJsonParseError error;
    const QJsonDocument document = QJsonDocument::fromJson(json, &error);
    if (error.error != QJsonParseError::NoError || !document.isArray()) {
        return false;
    }

    QVector<Product> loaded;
    for (const QJsonValue &value : document.array()) {
        if (!value.isObject()) {
            return false;
        }
        Product product = Product::fromJson(value.toObject());
        if (!product.isValid()) {
            return false;
        }
#ifdef __EMSCRIPTEN__
        const auto makeSameOrigin = [](QString &image) {
            const QUrl url(image);
            if (url.host() == QStringLiteral("tecno-light-v3-irux.vercel.app")
                && url.path().startsWith(QStringLiteral("/images/"))) {
                image = QStringLiteral("/site-assets/") + url.path().mid(8);
            }
        };
        makeSameOrigin(product.imageUrl);
        for (QString &image : product.gallery) {
            makeSameOrigin(image);
        }
#endif
        loaded.append(std::move(product));
    }
    if (loaded.isEmpty()) {
        return false;
    }

    beginResetModel();
    m_products = std::move(loaded);
    endResetModel();
    emit countChanged();
    emit catalogChanged();
    return true;
}

QByteArray ProductModel::toJson() const
{
    QJsonArray array;
    for (const Product &product : m_products) {
        array.append(product.toJson());
    }
    return QJsonDocument(array).toJson(QJsonDocument::Indented);
}

bool ProductModel::reduceStock(const QHash<int, int> &quantities)
{
    for (auto it = quantities.cbegin(); it != quantities.cend(); ++it) {
        const Product *product = find(it.key());
        if (product == nullptr || it.value() < 0 || product->stock < it.value()) {
            return false;
        }
    }

    beginResetModel();
    for (auto it = quantities.cbegin(); it != quantities.cend(); ++it) {
        for (Product &product : m_products) {
            if (product.id == it.key()) {
                product.stock -= it.value();
                break;
            }
        }
    }
    endResetModel();
    emit catalogChanged();
    return true;
}

QVector<int> ProductModel::visibleIndices() const
{
    QVector<int> indices;
    const QString query = m_searchText.trimmed();
    for (qsizetype i = 0; i < m_products.size(); ++i) {
        const Product &product = m_products.at(i);
        const bool categoryMatches = m_category == QStringLiteral("Todos") || product.category == m_category;
        const bool searchMatches = query.isEmpty()
            || product.name.contains(query, Qt::CaseInsensitive)
            || product.category.contains(query, Qt::CaseInsensitive)
            || product.description.contains(query, Qt::CaseInsensitive);
        if (categoryMatches && searchMatches) {
            indices.append(static_cast<int>(i));
        }
    }
    return indices;
}

void ProductModel::resetFilters()
{
    beginResetModel();
    endResetModel();
    emit filtersChanged();
    emit countChanged();
}