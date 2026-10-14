#include "CategoryModel.hpp"

CategoryModel::CategoryModel(QObject *parent)
    : QAbstractListModel(parent),
      m_names{
          QStringLiteral("Todos"),
          QStringLiteral("Señalización vial"),
          QStringLiteral("Impresión digital"),
          QStringLiteral("EPP e indumentaria"),
          QStringLiteral("Alquiler y equipamiento"),
          QStringLiteral("Servicios en obra")
      }
{
}

int CategoryModel::rowCount(const QModelIndex &parent) const
{
    return parent.isValid() ? 0 : m_names.size();
}

QVariant CategoryModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_names.size()) {
        return {};
    }
    if (role == NameRole || role == Qt::DisplayRole) {
        return m_names.at(index.row());
    }
    return {};
}

QHash<int, QByteArray> CategoryModel::roleNames() const
{
    return {{NameRole, "name"}};
}

QStringList CategoryModel::names() const
{
    return m_names;
}