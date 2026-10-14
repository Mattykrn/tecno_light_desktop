#pragma once

#include <QAbstractListModel>
#include <QStringList>

class CategoryModel final : public QAbstractListModel {
    Q_OBJECT

public:
    enum Roles {
        NameRole = Qt::UserRole + 1
    };
    Q_ENUM(Roles)

    explicit CategoryModel(QObject *parent = nullptr);
    [[nodiscard]] int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    [[nodiscard]] QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    [[nodiscard]] QHash<int, QByteArray> roleNames() const override;
    [[nodiscard]] QStringList names() const;

private:
    QStringList m_names;
};