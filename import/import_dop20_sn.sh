#!/bin/bash

# === Konfiguration ===
IMPORT_DIR="/bigdata/import/sn/dop20_sn"
LINKS_FILE="dop20_sn_links.txt"
GDAL_BIN="/opt/gdal/bin"
NUM_JOBS=6

# Aufräumen
rm -f "$IMPORT_DIR"/*tiff*

# Funktion zum Verarbeiten einer einzelnen DOP-Datei
processDOP() {
  url="$1"
  dop=$(basename "${url}" | cut -d'=' -f 3)

  wget -q "$url" -O "$IMPORT_DIR/$dop" || exit 1

  unzip -q "$IMPORT_DIR/$dop" -d "$IMPORT_DIR/${dop%%.*}"

  tiff_path=$(find "$IMPORT_DIR/${dop%%.*}" -name "*.tif" | head -n 1)
  tiff_file=$(basename "$tiff_path")

  "$GDAL_BIN/gdal_translate" -of GTiff --config GDAL_TIFF_OVR_BLOCKSIZE 256 \
    -co BLOCKXSIZE=256 -co BLOCKYSIZE=256 -co NUM_THREADS=ALL_CPUS -r cubic \
    -co COMPRESS=JPEG -co PHOTOMETRIC=YCBCR -co TILED=YES \
    "$tiff_path" "$IMPORT_DIR/$tiff_file"

  "$GDAL_BIN/gdaladdo" --config GDAL_CACHEMAX 20000 -r cubic -ro \
    --config COMPRESS_OVERVIEW JPEG --config PHOTOMETRIC_OVERVIEW YCBCR \
    --config INTERLEAVE_OVERVIEW PIXEL \
    "$IMPORT_DIR/$tiff_file" 2 4 8 16 32 64 128 256 512

  rm -f "$IMPORT_DIR/$dop"
  rm -rf "$IMPORT_DIR/${dop%%.*}"

  # Link aus Liste entfernen
  sed -i "\|$url|d" "$LINKS_FILE"
}

export -f processDOP
export IMPORT_DIR LINKS_FILE GDAL_BIN

cd "$IMPORT_DIR" || exit 1

# Parallelverarbeitung
cat "$LINKS_FILE" | grep -v '^$' | parallel -j "$NUM_JOBS" processDOP {}

# VRT erstellen
"$GDAL_BIN/gdalbuildvrt" dop20_sn.vrt "$IMPORT_DIR"/*.tif
