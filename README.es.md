# ONE SEG Studio

**by vanhoteen**

[English](README.md) · [Castellano](README.es.md) · [Asturianu](README.ast.md) · [Deutsch](README.de.md) · [Català](README.ca.md)

<img src="Assets/app-icon.png" width="180" alt="ONE SEG Studio icon">

Aplicación nativa para macOS que prepara un vídeo para recepción japonesa One-Seg y controla la transmisión mediante un HackRF One. Probada con un Sony XDV-D500. El autor también ha confirmado que la aplicación empaquetada funciona en un segundo Mac M1.

## ¿Qué es One-Seg?

La televisión digital japonesa ISDB-T divide su señal en 13 segmentos. En la configuración habitual de doce más uno, doce transportan televisión convencional y el segmento central lleva una versión de menor resolución para pequeños receptores. Una configuración de recepción robusta y el procesamiento de un solo segmento facilitan su uso con batería, sin conexión a internet.

## El proyecto

**ONE SEG Studio es un proyecto creado por vanhoteen** para volver a utilizar un televisor portátil japonés con vídeos preparados en un Mac y un HackRF One. El Mac prepara los flujos de vídeo y genera la señal digital; el HackRF la convierte en una señal de radio que recibe el televisor compatible. GNU Radio y gr-isdbt aportan la cadena de procesamiento; FFmpeg codifica el vídeo y el audio; TSDuck prepara las tablas de señalización.

## Descarga e instalación

[Descargar el DMG](https://github.com/vanhoteen/ONE-SEG-Studio-/releases/latest) · Apple Silicon · macOS 26+

1. Abre el DMG y arrastra **ONE SEG Studio** a **Aplicaciones**.
2. Conecta el HackRF One por USB y abre la aplicación.
3. Pulsa **Detectar HackRF**, elige el vídeo, el canal y el bitrate.
4. Pulsa **Preparar vídeo**. Este paso no transmite.
5. Pulsa **Iniciar emisión** cuando estés listo y **Detener** para terminar.

Transmite solo donde esté autorizado. Necesitas un receptor compatible con One-Seg japonés; una televisión DVB-T convencional no lo sustituye.

## Requisitos y herramientas incluidas

- Mac con Apple Silicon, M1 o posterior, y macOS 26 o posterior para esta compilación.
- HackRF One y receptor One-Seg compatible para la demostración por radio.
- Incluye Python, el motor de GNU Radio, gr-isdbt, NumPy, FFmpeg, TSDuck, SoapySDR, libHackRF y libusb. No hace falta instalar Homebrew ni Xcode. El editor GNU Radio Companion no está incluido ni es necesario.

La aplicación está traducida al **castellano y al inglés**. Los cinco idiomas corresponden a esta documentación, no a la interfaz.

## Funciones

Convierte archivos a 320 × 240, 15 fotogramas por segundo y audio AAC a 48 kb/s. Bitrates de vídeo: 80, 100, 200 y 300 kb/s. Selección de canal, ganancia VGA, interruptor del amplificador RF, detección de HackRF, gráfica y registro. La gráfica no mide la recepción del televisor.

## Vídeo de demostración

[![ONE SEG — Demo](https://img.youtube.com/vi/hW7jU8Ro0uk/hqdefault.jpg)](https://youtu.be/hW7jU8Ro0uk)

[YouTube · ONE SEG la Señal de Television Japonesa para dispositivos portatiles](https://youtu.be/hW7jU8Ro0uk)

## Límites actuales

Versión experimental con firma ad hoc, sin notarización de Apple; macOS puede pedir autorización manual. Todavía no admite cámara ni capturadora. Los archivos preparados son pruebas de duración finita; no se garantiza un bucle ininterrumpido ni señalización en directo. No se afirma certificación de la norma de emisión.

Los archivos de trabajo se guardan en `~/Library/Application Support/ONE SEG Studio`.

Consulta [Desarrollo](docs/DEVELOPMENT.md) y [Licencias](LICENSE-NOTICE.md).
