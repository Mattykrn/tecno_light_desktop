#include "CartModel.hpp"

#include <algorithm>
#include <QFile>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonParseError>
#include <QSaveFile>

CartModel::CartModel(QObject *parent) : QAbstractListModel(parent)
{
}

int CartModel::rowCount(const QModelIndex &parent) const
{
    return parent.isValid() ? 0 : m_entries.size();
}

QVariant CartModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_entries.size() || m_catalog == nullptr) {
        return {};
    }
    const Entry &entry = m_entries.at(index.row());
    const Product *product = m_catalog->find(entry.productId);
    if (product == nullptr) {
        return {};
    }

    switch (role) {
    case IdRole: return product->id;
    case NameRole: return product->name;
    case CategoryRole: return product->category;
    case PriceRole: return product->price;
    case QuantityRole: return entry.quantity;
    case StockRole: return product->stock;
    case ImageUrlRole: return product->imageUrl;
    case LineTotalRole: return product->price * entry.quantity;
    default: return {};
    }
}

QHash<int, QByteArray> CartModel::roleNames() const
{
    return {
        {IdRole, "productId"},
        {NameRole, "name"},
        {CategoryRole, "category"},
        {PriceRole, "price"},
        {QuantityRole, "quantity"},
        {StockRole, "stock"},
        {ImageUrlRole, "imageUrl"},
        {LineTotalRole, "lineTotal"}
    };
}

int CartModel::itemCount() const
{
    int count = 0;
    for (const Entry &entry : m_entries) {
        count += entry.quantity;
    }
    return count;
}

double CartModel::subtotal() const
{
    if (m_catalog == nullptr) {
        return 0.0;
    }
    double total = 0.0;
    for (const Entry &entry : m_entries) {
        if (const Product *product = m_catalog->find(entry.productId)) {
            total += product->price * entry.quantity;
        }
    }
    return total;
}

bool CartModel::empty() const
{
    return m_entries.isEmpty();
}

void CartModel::setCatalog(ProductModel *catalog)
{
    m_catalog = catalog;
}

void CartModel::setStoragePath(const QString &path)
{
    m_storagePath = path;
}

bool CartModel::add(int productId, int quantity)
{
    if (m_catalog == nullptr || quantity <= 0) {
        return false;
    }
    const Product *product = m_catalog->find(productId);
    if (product == nullptr) {
        return false;
    }

    const int existingRow = rowForId(productId);
    const int existingQuantity = existingRow >= 0 ? m_entries.at(existingRow).quantity : 0;
    if (product->stock >= 0 && existingQuantity + quantity > product->stock) {
        return false;
    }

    if (existingRow >= 0) {
        m_entries[existingRow].quantity += quantity;
        emit dataChanged(index(existingRow, 0), index(existingRow, 0));
    } else {
        const int newRow = m_entries.size();
        beginInsertRows(QModelIndex(), newRow, newRow);
        m_entries.append({productId, quantity});
        endInsertRows();
    }
    persistAndNotify();
    return true;
}

bool CartModel::setQuantity(int productId, int quantity)
{
    const int row = rowForId(productId);
    if (row < 0 || m_catalog == nullptr) {
        return false;
    }
    if (quantity <= 0) {
        return remove(productId);
    }
    const Product *product = m_catalog->find(productId);
    if (product == nullptr || (product->stock >= 0 && quantity > product->stock)) {
        return false;
    }
    m_entries[row].quantity = quantity;
    emit dataChanged(index(row, 0), index(row, 0));
    persistAndNotify();
    return true;
}

bool CartModel::remove(int productId)
{
    const int row = rowForId(productId);
    if (row < 0) {
        return false;
    }
    beginRemoveRows(QModelIndex(), row, row);
    m_entries.removeAt(row);
    endRemoveRows();
    persistAndNotify();
    return true;
}

void CartModel::clear()
{
    if (m_entries.isEmpty()) {
        return;
    }
    beginResetModel();
    m_entries.clear();
    endResetModel();
    persistAndNotify();
}

QHash<int, int> CartModel::quantities() const
{
    QHash<int, int> result;
    for (const Entry &entry : m_entries) {
        result.insert(entry.productId, entry.quantity);
    }
    return result;
}

bool CartModel::load()
{
    QFile file(m_storagePath);
    if (!file.exists()) {
        return true;
    }
    if (!file.open(QIODevice::ReadOnly)) {
        emit storageError(file.errorString());
        return false;
    }

    QJsonParseError error;
    const QJsonDocument document = QJsonDocument::fromJson(file.readAll(), &error);
    if (error.error != QJsonParseError::NoError || !document.isArray()) {
        emit storageError(QStringLiteral("El archivo del carrito no contiene JSON válido."));
        return false;
    }

    QVector<Entry> restored;
    for (const QJsonValue &value : document.array()) {
        if (!value.isObject()) {
            continue;
        }
        const QJsonObject object = value.toObject();
        const int id = object.value(QStringLiteral("productId")).toInt();
        const int quantity = object.value(QStringLiteral("quantity")).toInt();
        const Product *product = m_catalog != nullptr ? m_catalog->find(id) : nullptr;
        if (product != nullptr && quantity > 0) {
            restored.append({id, product->stock >= 0 ? qMin(quantity, product->stock) : quantity});
        }
    }
    restored.erase(std::remove_if(restored.begin(), restored.end(), [](const Entry &entry) {
        return entry.quantity <= 0;
    }), restored.end());

    beginResetModel();
    m_entries = std::move(restored);
    endResetModel();
    emit summaryChanged();
    return true;
}

bool CartModel::save()
{
    QJsonArray items;
    for (const Entry &entry : m_entries) {
        items.append(QJsonObject{
            {QStringLiteral("productId"), entry.productId},
            {QStringLiteral("quantity"), entry.quantity}
        });
    }

    QSaveFile file(m_storagePath);
    if (!file.open(QIODevice::WriteOnly) || file.write(QJsonDocument(items).toJson()) < 0 || !file.commit()) {
        emit storageError(file.errorString());
        return false;
    }
    return true;
}

int CartModel::rowForId(int productId) const
{
    for (qsizetype row = 0; row < m_entries.size(); ++row) {
        if (m_entries.at(row).productId == productId) {
            return static_cast<int>(row);
        }
    }
    return -1;
}

void CartModel::persistAndNotify()
{
    save();
    emit summaryChanged();
}