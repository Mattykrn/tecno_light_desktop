# Tecno Light S.R.L. — escritorio y WebAssembly

Aplicación C++20 / Qt Quick con build nativo para Linux y build WebAssembly estático para navegador. GitHub Actions compila la versión wasm y la publica en Vercel al hacer push a `main`.

## Versiones WASM fijadas

- Qt `6.8.3`, kit `wasm_singlethread`.
- Emscripten `3.1.56`, versión indicada por la documentación de Qt 6.8.
- CMake `3.21+` y Node.js `22`.

El build elegido es single-thread, por lo que la aplicación no necesita `SharedArrayBuffer`. Se configuran COOP y COEP según el requisito del despliegue y las imágenes del sitio se sirven mediante un rewrite same-origin en Vercel para evitar bloqueos de COEP.

## Build nativo

Con Qt 6.6+ y CMake instalados:

```sh
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build -j2
./build/tecno_light_desktop
```

## Build WASM local

1. Instala Emscripten 3.1.56:

```sh
git clone https://github.com/emscripten-core/emsdk.git "$HOME/emsdk"
cd "$HOME/emsdk"
./emsdk install 3.1.56
./emsdk activate 3.1.56
source ./emsdk_env.sh
```

2. Instala Qt 6.8.3 con los componentes **Desktop GCC 64-bit** y **WebAssembly (single-threaded)** usando Qt Maintenance Tool. El build cruzado necesita las herramientas y dependencias internas del kit host además del target wasm. En Linux, las rutas habituales son `$HOME/Qt/6.8.3/gcc_64` y `$HOME/Qt/6.8.3/wasm_singlethread`.

3. Desde la raíz de este proyecto, compila y prepara la salida estática:

```sh
source "$HOME/emsdk/emsdk_env.sh"
export QT_WASM_ROOT="$HOME/Qt/6.8.3/wasm_singlethread"
export QT_HOST_PATH="$HOME/Qt/6.8.3/gcc_64"
npm run build
```

El script ejecuta `emcmake cmake`, compila C++/QML y genera:

```text
dist/
├── index.html
├── tecno_light_desktop.html
├── tecno_light_desktop.js
├── tecno_light_desktop.wasm
└── qtloader.js
```

Antes de configurar Qt, el script construye el puerto zlib de Emscripten y le indica a Qt que use ese zlib del sysroot en lugar de su target bundled no disponible en el paquete wasm binario.

También prepara `.vercel/output/` para el comando `vercel deploy --prebuilt`. `npm run build:wasm` y `npm run vercel-build` llaman el mismo script. Las carpetas `build-wasm/`, `dist/` y `.vercel/` son artefactos generados e ignorados por Git.

## Crear y subir el repositorio

Crea primero un repositorio vacío en GitHub, sin README, licencia ni `.gitignore` generados por GitHub. Desde la carpeta `tecno_light_desktop`, sustituye la URL por la del repositorio propio:

```sh
git init
git add .
git commit -m "Prepare Tecno Light Qt WebAssembly deployment"
git branch -M main
git remote add origin https://github.com/USUARIO/tecno-light-desktop.git
git push -u origin main
```

Si el repositorio remoto ya tiene commits, intégralos antes del push en lugar de forzar el historial:

```sh
git pull --rebase origin main
git push -u origin main
```

## Conectar Vercel y GitHub Actions

1. En Vercel, crea/importa un proyecto vinculado al repositorio GitHub. Configura **Framework Preset: Other** y desactiva los despliegues Git automáticos; el workflow de GitHub será el único que publique producción.
2. Copia el **Organization ID** y **Project ID** desde Settings del proyecto Vercel.
3. En GitHub, abre **Settings → Secrets and variables → Actions → New repository secret** y crea estos secrets:
   - `VERCEL_TOKEN`: token personal creado en Vercel Account Settings → Tokens.
   - `VERCEL_ORG_ID`: Organization ID de Vercel.
   - `VERCEL_PROJECT_ID`: Project ID de Vercel.
4. Haz push a `main` o ejecuta el workflow manualmente en **Actions → Build and deploy Tecno Light WASM → Run workflow**.

El workflow instala Emscripten y el kit Qt wasm compatibles, corre `npm run build`, conserva los artefactos de producción durante 14 días y publica `.vercel/output` con Vercel CLI en modo prebuilt.

### Enlazar Vercel CLI localmente

Después de instalar el CLI (`npm install --global vercel`) y autenticarte (`vercel login`), vincula el checkout al proyecto:

```sh
vercel link --yes --project ID_DEL_PROYECTO --scope SLUG_DE_LA_ORGANIZACION
```

`--scope` recibe el slug del equipo de Vercel, no su Organization ID. Con el toolchain configurado y `npm run build` completado, crea una preview o producción manualmente:

```sh
vercel deploy --prebuilt
vercel deploy --prebuilt --prod
```

## Configuración de servidor

`vercel.json` documenta rewrites, MIME `application/wasm`, COOP, COEP y CORP. Para la publicación de GitHub Actions se refleja la configuración equivalente en `vercel-output-config.json`, que el script coloca en `.vercel/output/config.json` conforme al Build Output API de Vercel.

- `Cross-Origin-Opener-Policy: same-origin`
- `Cross-Origin-Embedder-Policy: require-corp`
- `Cross-Origin-Resource-Policy: same-origin`
- `.wasm`: `application/wasm`
- JavaScript: `application/javascript; charset=utf-8`

Las imágenes originales se solicitan a `/site-assets/...` y Vercel las reescribe al host Tecno Light. WhatsApp, correo, teléfono y mapas siguen siendo enlaces externos.

## Límites del navegador

Qt WebAssembly corre dentro del sandbox del navegador. El filesystem que usa `QFile` es temporal por defecto: el carrito y las solicitudes JSON locales no equivalen a persistencia de servidor y pueden perderse al recargar la página. No se procesan pagos ni se envía la cotización hasta que el usuario confirme el mensaje en WhatsApp. Para órdenes persistentes de negocio se requiere conectar un backend/API.

Las imágenes oficiales requieren conexión a internet. Los precios y existencias no se inventan: se solicitan a Tecno Light.

## Estructura

```text
tecno_light_desktop/
├── .github/workflows/deploy.yml
├── CMakeLists.txt
├── data/products.json
├── qml/
│   ├── CartDrawer.qml
│   ├── CheckoutDialog.qml
│   ├── Main.qml
│   ├── ProductCard.qml
│   └── ProductDetail.qml
├── scripts/build-wasm.sh
├── src/
│   ├── CartModel.cpp / CartModel.hpp
│   ├── CategoryModel.cpp / CategoryModel.hpp
│   ├── Product.cpp / Product.hpp
│   ├── ProductModel.cpp / ProductModel.hpp
│   ├── StoreController.cpp / StoreController.hpp
│   └── main.cpp
├── package.json
├── vercel-output-config.json
└── vercel.json
```
