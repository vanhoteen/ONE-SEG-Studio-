# ONE SEG Studio

**by vanhoteen**

[English](README.md) · [Castellano](README.es.md) · [Asturianu](README.ast.md) · [Deutsch](README.de.md) · [Català](README.ca.md)

<img src="Assets/app-icon.png" width="180" alt="ONE SEG Studio icon">

Eine native macOS-App, die Videos für den japanischen One-Seg-Empfang vorbereitet und die Übertragung mit einem HackRF One steuert. Getestet mit einem Sony XDV-D500. Der Entwickler hat außerdem bestätigt, dass die gebündelte App auf einem zweiten M1-Mac funktioniert.

## Funkbetrieb und Verantwortung

Prüfe vor dem Senden die Vorschriften deines Landes sowie die Anforderungen an Frequenzen, Leistung und Genehmigungen. Eine japanische Kanalnummer erlaubt nicht automatisch die Nutzung dieser Frequenz in einem anderen Land. Verwende gegebenenfalls einen kabelgebundenen oder ausreichend abgeschirmten Testaufbau und verursache keine schädlichen Störungen. Der Nutzer ist für erforderliche Genehmigungen, Gerätekonfiguration und Betrieb verantwortlich. Dieses Projekt dient Bildungs- und Experimentierzwecken und erteilt keine Sendegenehmigung. Soweit gesetzlich zulässig, übernimmt der Autor keine Verantwortung für unbefugte Nutzung oder vom Nutzer verursachte Störungen.

## Was ist One-Seg?

Das japanische Digitalfernsehen ISDB-T unterteilt das Signal in 13 Segmente. Bei der üblichen 12+1-Konfiguration dienen zwölf dem herkömmlichen Fernsehen; das mittlere Segment überträgt einen Dienst mit geringerer Auflösung für tragbare Empfänger. Robuste Empfangseinstellungen und die Verarbeitung nur eines Segments erleichtern den Batteriebetrieb ohne Internetverbindung.

## Das Projekt

**ONE SEG Studio wurde von vanhoteen entwickelt**, um einen japanischen Taschenfernseher mit Videos vom Mac und einem HackRF One wieder nutzbar zu machen. Der Mac bereitet die Transportströme vor und erzeugt das digitale Signal; der HackRF wandelt es in ein Funksignal um. GNU Radio und gr-isdbt stellen die Signalverarbeitung bereit; FFmpeg codiert Bild und Ton; TSDuck erstellt die Signalisierungstabellen.

## Download und Installation

[DMG herunterladen](https://github.com/vanhoteen/ONE-SEG-Studio-/releases/latest) · Apple Silicon · macOS 26+

1. DMG öffnen und **ONE SEG Studio** in **Programme** ziehen.
2. HackRF One über USB anschließen und die App öffnen.
3. **Detect HackRF** wählen, dann Video, Kanal und Videobitrate auswählen.
4. **Prepare video** wählen. Dieser Schritt sendet kein Funksignal.
5. Mit **Start transmission** starten und mit **Stop** beenden.

Nur senden, wenn dies zulässig ist. Erforderlich ist ein Empfänger für japanisches One-Seg; ein gewöhnlicher DVB-T-Fernseher ist kein Ersatz.

## Voraussetzungen und enthaltene Komponenten

- Apple-Silicon-Mac, M1 oder neuer; dieser Build benötigt macOS 26 oder neuer.
- HackRF One und kompatibler One-Seg-Empfänger für die Funkvorführung.
- Python, GNU-Radio-Laufzeit, gr-isdbt, NumPy, FFmpeg, TSDuck, SoapySDR, libHackRF und libusb sind enthalten. Homebrew und Xcode müssen nicht installiert werden. Der Editor GNU Radio Companion ist weder enthalten noch erforderlich.

Die Benutzeroberfläche unterstützt derzeit **Englisch und Spanisch**. Die fünf Sprachen beziehen sich ausschließlich auf die Dokumentation.

## Funktionen

Videokonvertierung auf 320 × 240 bei 15 Bildern pro Sekunde, AAC-Audio mit 48 kb/s. Videobitraten: 80, 100, 200 und 300 kb/s. Kanalauswahl, VGA-Verstärkung, RF-Verstärkerschalter, HackRF-Erkennung, Signalanzeige und Protokoll. Die Signalanzeige misst nicht den Empfang am Fernseher.

## Demovideo

[![ONE SEG — Demo](https://img.youtube.com/vi/hW7jU8Ro0uk/hqdefault.jpg)](https://youtu.be/hW7jU8Ro0uk)

[YouTube · ONE SEG la Señal de Television Japonesa para dispositivos portatiles](https://youtu.be/hW7jU8Ro0uk)

## Aktuelle Einschränkungen

Experimentelle Version mit Ad-hoc-Signatur, ohne Apple-Notarisierung; macOS kann eine manuelle Freigabe verlangen. Kamera- und Capture-Eingänge sind nicht implementiert. Vorbereitete Dateien sind zeitlich begrenzte Tests; lückenlose Wiederholung und Live-Signalisierung sind nicht garantiert. Eine Zertifizierung nach dem Sendestandard wird nicht behauptet.

Arbeitsdateien liegen unter `~/Library/Application Support/ONE SEG Studio`.

Siehe [Entwicklung](docs/DEVELOPMENT.md) und [Lizenzen](LICENSE-NOTICE.md).
