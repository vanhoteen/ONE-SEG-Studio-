# ONE SEG Studio

**by vanhoteen**

## 🌐 Escueyi la to llingua

### [🇬🇧 English](README.md)
### [🇪🇸 Castellano](README.es.md)
### [<img src="Assets/flag-asturias.svg" width="32" alt="Bandera de Asturias"> Asturianu](README.ast.md)
### [🇩🇪 Deutsch](README.de.md)
### [<img src="Assets/flag-catalunya.svg" width="32" alt="Bandera de Catalunya"> Català](README.ca.md)

---

<img src="Assets/app-icon.png" width="180" alt="ONE SEG Studio icon">

Aplicación nativa pa macOS que prepara un videu pa la recepción xaponesa One-Seg y controla la tresmisión con un HackRF One. Probada con un Sony XDV-D500. L'autor confirmó tamién que l'aplicación empaquetada funciona n'otru Mac M1.

## Emisión de radio y responsabilidá del usuariu

Enantes d'emitir, comprueba la normativa del to país y los requisitos de frecuencia, potencia y autorización. Que una canal seya xaponesa nun significa que puedas usar esa frecuencia n'otru país. Usa pruebes per cable o un recintu bien apantalláu cuando corresponda y nun causes interferencies perxudiciales. L'usuariu ye responsable de les autorizaciones necesaries y de configurar y usar l'equipu. Esti proyeutu tien fines educativos y esperimentales; nun da permisu pa emitir. L'autor nun asume responsabilidá pol usu non autorizáu nin poles interferencies causaes pol usuariu, na midida permitida pola llexislación aplicable.

## ¿Qué ye One-Seg?

La televisión dixital xaponesa ISDB-T divide la señal en 13 segmentos. Na configuración habitual de doce más ún, doce lleven televisión convencional y el segmentu central lleva una versión de menor resolución pa receptores pequeños. La recepción robusta y el procesamientu d'un solu segmentu faciliten l'usu con batería, ensin conexón a internet.

## El proyeutu

**ONE SEG Studio ye un proyeutu creáu por vanhoteen** pa volver usar un televisor portátil xaponés con vídeos preparaos nun Mac y un HackRF One. El Mac prepara los fluxos y xenera la señal dixital; el HackRF conviértela nuna señal de radio. GNU Radio y gr-isdbt ponen la cadena de procesamientu; FFmpeg codifica'l videu y el soníu; TSDuck prepara les tables de señalización.

## Descarga ya instalación

[Descargar el DMG](https://github.com/vanhoteen/ONE-SEG-Studio-/releases/latest) · Apple Silicon · macOS 26+

1. Abre'l DMG y arrastra **ONE SEG Studio** a **Aplicaciones**.
2. Coneuta'l HackRF One per USB y abre l'aplicación.
3. Calca **Detectar HackRF** y escueyi'l videu, la canal y la tasa de bits.
4. Calca **Preparar vídeo**. Esti pasu nun tresmite.
5. Calca **Iniciar emisión** cuando teas preparáu y **Detener** pa terminar.

Tresmite namái onde tea autorizao. Precises un receptor compatible con One-Seg xaponés; un televisor DVB-T convencional nun sirve como sustitutu.

## Otres versiones

- **[ONE SEG Web Lab — Beta](https://vanhoteen.github.io/ONE-SEG-Studio-WEB-/)** funciona en Chrome o Edge con un HackRF conectáu a esi ordenador. Ye una prueba rápida nel navegador y anguaño prepara vídeos finitos de hasta **15 segundos**.
- **[ONE SEG Studio pa Linux — Vista previa Ubuntu 26.04 amd64](https://github.com/vanhoteen/ONE-SEG-Studio-for-Linux---Ubuntu-26.04-amd64-Preview)** ye una beta funcional pa Linux, probada pol autor en Ubuntu 26.04 amd64. Sigue siendo una vista previa esperimental.

## Requisitos y ferramientes incluyíes

- Mac con Apple Silicon, M1 o posterior, y macOS 26 o posterior pa esta compilación.
- HackRF One y receptor One-Seg compatible pa la demostración per radio.
- Inclúi Python, el motor de GNU Radio, gr-isdbt, NumPy, FFmpeg, TSDuck, SoapySDR, libHackRF y libusb. Nun fai falta instalar Homebrew nin Xcode. L'editor GNU Radio Companion nun ta incluyíu nin ye necesariu.

L'aplicación ta disponible en **castellanu ya inglés**. Los cinco idiomes son los de la documentación, non los de la interfaz.

## Funciones

Convierte ficheros a 320 × 240, 15 fotogrames por segundu y soníu AAC a 48 kb/s. Tases de videu: 80, 100, 200 y 300 kb/s. Inclúi seleición de canal, ganancia VGA, interruptor del amplificador RF, deteición de HackRF, gráfica y rexistru. La gráfica nun mide la recepción del televisor.

## Videu de demostración

[![ONE SEG — Demo](https://img.youtube.com/vi/hW7jU8Ro0uk/hqdefault.jpg)](https://youtu.be/hW7jU8Ro0uk)

[YouTube · ONE SEG la Señal de Television Japonesa para dispositivos portatiles](https://youtu.be/hW7jU8Ro0uk)

## Llimitaciones actuales

Versión esperimental con firma ad hoc, ensin notarización d'Apple; macOS puede pidir autorización manual. Entá nun almite cámara nin capturadora. Los ficheros preparaos son pruebes de duración finita; nun se garantiza un bucle continuu nin señalización en direuto. Nun s'afirma certificación de la norma d'emisión.

Los ficheros de trabayu guárdense en `~/Library/Application Support/ONE SEG Studio`.

Consulta [Desenvolvimientu](docs/DEVELOPMENT.md) y [Llicencies](LICENSE-NOTICE.md).
