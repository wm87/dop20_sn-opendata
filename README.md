# DOP20 SN Download- und Verarbeitungs-Skript

Dieses Skript automatisiert den **Download**, die **Dekomprimierung**, **Konvertierung** und **Optimierung** der digitalen Orthophotos (DOP20) aus Sachsen.

📍 **Datenquelle:**
Die herunterladbaren DOP20-Links stammen von der offiziellen Seite des GeoSN:
➤️ [https://www.geodaten.sachsen.de/batch-download-4719.html](https://www.geodaten.sachsen.de/batch-download-4719.html)

---

## 🛠️ Anforderungen

Stelle sicher, dass folgende Tools installiert sind:

* [GNU Parallel](https://www.gnu.org/software/parallel/)
* [`wget`](https://www.gnu.org/software/wget/)
* [`unzip`](https://linux.die.net/man/1/unzip)
* [`gdal_translate`](https://gdal.org/programs/gdal_translate.html)
* [`gdaladdo`](https://gdal.org/programs/gdaladdo.html)
* [`gdalbuildvrt`](https://gdal.org/programs/gdalbuildvrt.html)

---

## 📂 Verzeichnisstruktur

Die wichtigsten Pfade im Skript:

* `IMPORT_DIR`: Zielverzeichnis für Download und Verarbeitung (`/bigdata/import/sn/dop20_sn`)
* `LINKS_FILE`: Textdatei mit den URLs zum Download (`dop20_sn_links.txt`)
* `GDAL_BIN`: Pfad zur GDAL-Installation (`/opt/gdal/bin`)
* `NUM_JOBS`: Anzahl paralleler Prozesse (`6`)

---

## 🚀 Ausführung

1. Stelle sicher, dass sich die Datei `dop20_sn_links.txt` im selben Verzeichnis wie das Skript befindet und eine Liste von Download-URLs enthält (eine pro Zeile).
2. Starte das Skript mit:

   ```bash
   bash import_dop20_sn.sh
   ```

---

## 🔄 Skript-Funktionalität im Überblick

* Entfernt vorhandene TIFF-Dateien im Zielverzeichnis.
* Lädt ZIP-Archive der DOP20-Daten herunter.
* Entpackt die Archive.
* Wandelt `.tif`-Dateien in JPEG-komprimierte GeoTIFFs um.
* Erstellt Pyramidenübersichten (Overviews) für schnelleren Zugriff.
* Entfernt verarbeitete Archive und temporäre Ordner.
* Entfernt erfolgreich verarbeitete URLs aus der Liste.
* Erstellt ein virtuelles Mosaik (`dop20_sn.vrt`) aus allen verarbeiteten TIFF-Dateien.

⚠️ **Hinweis**: Das Gesamtergebnis umfasst ca. 101,6 GB an .tif- und .ovr-Dateien.

---

## 📌 Lizenz & Nutzung

Die Nutzung der Geodaten richtet sich nach den aktuellen Bedingungen des GeoSN. Bitte informiere dich direkt auf der Hauptseite oder im Datenbereich über die jeweils gültigen Lizenzregelungen:

👉 [GeoSN Geodaten-Portal](https://www.geodaten.sachsen.de/)

👉 [Allgemeine Nutzungsbedingungen](https://www.landesvermessung.sachsen.de/allgemeine-nutzungsbedingungen-8954.html)

**Quelle: GeoSN, [dl-de/by-2-0](https://www.govdata.de/dl-de/by-2-0)**