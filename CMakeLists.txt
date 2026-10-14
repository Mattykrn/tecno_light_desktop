cmake_minimum_required(VERSION 3.21)
project(TecnoLightDesktop VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_package(Qt6 6.6 REQUIRED COMPONENTS Core Gui Qml Quick QuickControls2)
qt_standard_project_setup(REQUIRES 6.6)
qt_policy(SET QTP0004 NEW)

qt_add_executable(tecno_light_desktop
    src/main.cpp
)

qt_add_qml_module(tecno_light_desktop
    URI TecnoLight
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/ProductCard.qml
        qml/ProductDetail.qml
        qml/CartDrawer.qml
        qml/CheckoutDialog.qml
    SOURCES
        src/Product.hpp
        src/Product.cpp
        src/CategoryModel.hpp
        src/CategoryModel.cpp
        src/ProductModel.hpp
        src/ProductModel.cpp
        src/CartModel.hpp
        src/CartModel.cpp
        src/StoreController.hpp
        src/StoreController.cpp
)

qt_add_resources(tecno_light_desktop catalog_data
    PREFIX "/store"
    FILES data/products.json
)

target_include_directories(tecno_light_desktop PRIVATE src)
target_link_libraries(tecno_light_desktop PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::QuickControls2
)
target_compile_options(tecno_light_desktop PRIVATE -Wall -Wextra -Wpedantic)

if(EMSCRIPTEN)
    target_link_options(tecno_light_desktop PRIVATE
        "-sALLOW_MEMORY_GROWTH=1"
        "-sMAXIMUM_MEMORY=1GB"
        "-sUSE_ZLIB=1"
    )
    target_compile_options(tecno_light_desktop PRIVATE "-sUSE_ZLIB=1")
endif()