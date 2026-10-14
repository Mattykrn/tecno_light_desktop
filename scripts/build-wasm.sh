#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${WASM_BUILD_DIR:-${PROJECT_ROOT}/build-wasm}"
DIST_DIR="${DIST_DIR:-${PROJECT_ROOT}/dist}"

if ! command -v emcmake >/dev/null 2>&1; then
    printf 'error: emcmake no está en PATH. Instala/activa Emscripten 3.1.56.\n' >&2
    exit 1
fi

if [[ -z "${QT_WASM_ROOT:-}" ]]; then
    printf 'error: define QT_WASM_ROOT con la ruta del kit Qt 6.8.3 wasm_singlethread.\n' >&2
    exit 1
fi

QT_WASM_ROOT="$(cd "${QT_WASM_ROOT}" && pwd)"
QT6_CONFIG="${QT6_CONFIG:-}"
if [[ -z "${QT6_CONFIG}" ]]; then
    QT6_CONFIG="$(find "${QT_WASM_ROOT}" -type f -name Qt6Config.cmake -print -quit)"
fi
if [[ -z "${QT6_CONFIG}" || ! -f "${QT6_CONFIG}" ]]; then
    printf 'error: no se encontró Qt6Config.cmake dentro de QT_WASM_ROOT=%s\n' "${QT_WASM_ROOT}" >&2
    exit 1
fi
QT6_DIR="$(cd "$(dirname "${QT6_CONFIG}")" && pwd)"

rm -rf "${BUILD_DIR}" "${DIST_DIR}" "${PROJECT_ROOT}/.vercel/output"
mkdir -p "${DIST_DIR}" "${PROJECT_ROOT}/.vercel/output/static"

emcmake cmake -S "${PROJECT_ROOT}" -B "${BUILD_DIR}" \
    -DCMAKE_BUILD_TYPE=Release \
    -DQt6_DIR="${QT6_DIR}" \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=OFF

cmake --build "${BUILD_DIR}" --parallel "${BUILD_JOBS:-2}"

find "${BUILD_DIR}" -maxdepth 2 -type f \
    \( -name 'tecno_light_desktop.html' \
    -o -name 'tecno_light_desktop.js' \
    -o -name 'tecno_light_desktop.wasm' \
    -o -name 'qtloader.js' \) \
    -exec cp -f {} "${DIST_DIR}/" \;

for artifact in tecno_light_desktop.html tecno_light_desktop.js tecno_light_desktop.wasm qtloader.js; do
    if [[ ! -s "${DIST_DIR}/${artifact}" ]]; then
        printf 'error: falta el artefacto esperado %s en %s\n' "${artifact}" "${DIST_DIR}" >&2
        printf 'Revisa la versión/arquitectura de Qt WebAssembly y el log de CMake.\n' >&2
        exit 1
    fi
done

cp "${DIST_DIR}/tecno_light_desktop.html" "${DIST_DIR}/index.html"
cp "${PROJECT_ROOT}/vercel-output-config.json" "${PROJECT_ROOT}/.vercel/output/config.json"
cp -a "${DIST_DIR}/." "${PROJECT_ROOT}/.vercel/output/static/"

printf '\nBuild WebAssembly completo. Archivos de hosting:\n'
find "${DIST_DIR}" -maxdepth 1 -type f -printf '  %f (%s bytes)\n' | sort
printf 'Vercel prebuilt: %s/.vercel/output\n' "${PROJECT_ROOT}"