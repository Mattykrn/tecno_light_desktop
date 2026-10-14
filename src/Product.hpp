#pragma once

#include <QJsonObject>
#include <QString>
#include <QStringList>

struct Product {
    int id = 0;
    QString name;
    QString category;
    QString description;
    double price = 0.0;
    int stock = -1;
    QString badge;
    QString imageUrl;
    QStringList gallery;

    [[nodiscard]] bool isValid() const;
    [[nodiscard]] QJsonObject toJson() const;
    static Product fromJson(const QJsonObject &object);
};