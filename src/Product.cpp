#include "Product.hpp"

#include <QJsonArray>

bool Product::isValid() const
{
    return id > 0 && !name.isEmpty() && !category.isEmpty() && price >= 0.0 && stock >= -1;
}

QJsonObject Product::toJson() const
{
    QJsonArray galleryArray;
    for (const QString &image : gallery) {
        galleryArray.append(image);
    }

    return {
        {QStringLiteral("id"), id},
        {QStringLiteral("name"), name},
        {QStringLiteral("category"), category},
        {QStringLiteral("description"), description},
        {QStringLiteral("price"), price},
        {QStringLiteral("stock"), stock},
        {QStringLiteral("badge"), badge},
        {QStringLiteral("imageUrl"), imageUrl},
        {QStringLiteral("gallery"), galleryArray}
    };
}

Product Product::fromJson(const QJsonObject &object)
{
    Product product;
    product.id = object.value(QStringLiteral("id")).toInt();
    product.name = object.value(QStringLiteral("name")).toString();
    product.category = object.value(QStringLiteral("category")).toString();
    product.description = object.value(QStringLiteral("description")).toString();
    product.price = object.value(QStringLiteral("price")).toDouble();
    product.stock = object.value(QStringLiteral("stock")).toInt();
    product.badge = object.value(QStringLiteral("badge")).toString();
    product.imageUrl = object.value(QStringLiteral("imageUrl")).toString();

    for (const QJsonValue &image : object.value(QStringLiteral("gallery")).toArray()) {
        if (image.isString()) {
            product.gallery.append(image.toString());
        }
    }

    if (product.gallery.isEmpty() && !product.imageUrl.isEmpty()) {
        product.gallery.append(product.imageUrl);
    }
    return product;
}