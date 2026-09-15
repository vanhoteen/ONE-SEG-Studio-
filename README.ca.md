# ONE SEG Studio

**by vanhoteen**

[English](README.md) · [Castellano](README.es.md) · [Asturianu](README.ast.md) · [Deutsch](README.de.md) · [Català](README.ca.md)

<img src="Assets/app-icon.png" width="180" alt="ONE SEG Studio icon">

Aplicació nativa per a macOS que prepara vídeos per a la recepció japonesa One-Seg i controla la transmissió mitjançant un HackRF One. Provada amb un Sony XDV-D500. L'autor també ha confirmat que l'aplicació empaquetada funciona en un segon Mac M1.

## Què és One-Seg?

La televisió digital japonesa ISDB-T divideix el senyal en 13 segments. En la configuració habitual de dotze més un, dotze transporten televisió convencional i el segment central porta una versió de menor resolució per a petits receptors. La recepció robusta i el processament d'un sol segment faciliten l'ús amb bateria, sense connexió a internet.

## El projecte

**ONE SEG Studio és un projecte creat per vanhoteen** per tornar a utilitzar un televisor portàtil japonès amb vídeos preparats en un Mac i un HackRF One. El Mac prepara els fluxos i genera el senyal digital; el HackRF el converteix en un senyal de ràdio. GNU Radio i gr-isdbt aporten el processament; FFmpeg codifica el vídeo i l'àudio; TSDuck prepara les taules de senyalització.

## Descàrrega i instal·lació

[Descarrega el DMG](https://github.com/vanhoteen/ONE-SEG-Studio-/releases/latest) · Apple Silicon · macOS 26+

1. Obre el DMG i arrossega **ONE SEG Studio** a **Aplicacions**.
2. Connecta el HackRF One per USB i obre l'aplicació.
3. Prem **Detect HackRF**, tria el vídeo, el canal i la taxa de bits.
4. Prem **Prepare video**. Aquest pas no transmet.
5. Prem **Start transmission** quan estiguis a punt i **Stop** per acabar.

Transmet només on estigui autoritzat. Cal un receptor compatible amb One-Seg japonès; un televisor DVB-T convencional no el substitueix.

## Requisits i eines incloses

- Mac amb Apple Silicon, M1 o posterior, i macOS 26 o posterior per a aquesta compilació.
- HackRF One i receptor One-Seg compatible per a la demostració per ràdio.
- Inclou Python, el motor de GNU Radio, gr-isdbt, NumPy, FFmpeg, TSDuck, SoapySDR, libHackRF i libusb. No cal instal·lar Homebrew ni Xcode. L'editor GNU Radio Companion no està inclòs ni és necessari.

La interfície està disponible en **anglès i castellà**. Els cinc idiomes corresponen a la documentació, no a la interfície.

## Funcions

Converteix fitxers a 320 × 240, 15 fotogrames per segon i àudio AAC a 48 kb/s. Taxes de vídeo: 80, 100, 200 i 300 kb/s. Selecció de canal, guany VGA, interruptor de l'amplificador RF, detecció del HackRF, gràfica i registre. La gràfica no mesura la recepció del televisor.

## Vídeo de demostració

[![ONE SEG — Demo](https://img.youtube.com/vi/hW7jU8Ro0uk/hqdefault.jpg)](https://youtu.be/hW7jU8Ro0uk)

[YouTube · ONE SEG la Señal de Television Japonesa para dispositivos portatiles](https://youtu.be/hW7jU8Ro0uk)

## Limitacions actuals

Versió experimental amb signatura ad hoc, sense notarització d'Apple; macOS pot demanar autorització manual. Encara no admet càmera ni capturadora. Els fitxers preparats són proves de durada finita; no es garanteixen la repetició ininterrompuda ni la senyalització en directe. No s'afirma cap certificació de la norma d'emissió.

Els fitxers de treball es desen a `~/Library/Application Support/ONE SEG Studio`.

Consulta [Desenvolupament](docs/DEVELOPMENT.md) i [Llicències](LICENSE-NOTICE.md).
