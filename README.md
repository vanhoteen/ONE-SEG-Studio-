# ONE SEG Studio

**by vanhoteen**

## 🌐 Choose your language

### [🇬🇧 English](README.md)
### [🇪🇸 Castellano](README.es.md)
### [<img src="Assets/flag-asturias.svg" width="32" alt="Bandera de Asturias"> Asturianu](README.ast.md)
### [🇩🇪 Deutsch](README.de.md)
### [<img src="Assets/flag-catalunya.svg" width="32" alt="Bandera de Catalunya"> Català](README.ca.md)

---

<img src="Assets/app-icon.png" width="180" alt="ONE SEG Studio icon">

A native macOS application that prepares a video for Japanese One-Seg reception and controls transmission through a HackRF One. Tested with a Sony XDV-D500. The author has also confirmed that the packaged application works on a second M1 Mac.

## RF transmission and user responsibility

Before transmitting, check the regulations in your country and the applicable frequency, power and licensing requirements. A Japanese channel number does not mean that frequency is authorized for your use elsewhere. Use a conducted or properly shielded test setup where appropriate, and do not cause harmful interference. The user is responsible for obtaining any required authorization and for the configuration and operation of the equipment. This project is provided for educational and experimental purposes; it does not grant permission to transmit. The author does not assume responsibility for unauthorized use or interference caused by the user, to the extent permitted by applicable law.

## What is One-Seg?

Japanese ISDB-T digital television divides its signal into 13 segments. In the usual 12+1 configuration, twelve carry conventional television and the central segment carries a lower-resolution service for portable receivers. Robust reception settings and processing only one segment help make battery-powered reception practical, without an internet connection.

## About this project

Created by **vanhoteen**, ONE SEG Studio brings a Japanese portable television back to life using locally prepared video and a HackRF One. The Mac prepares the transport streams and generates the digital signal; the HackRF converts it into an RF signal received by the compatible television. GNU Radio and gr-isdbt provide the signal-processing chain; FFmpeg encodes the video and audio; TSDuck prepares signalling tables.

## Download and installation

[Download the DMG](https://github.com/vanhoteen/ONE-SEG-Studio-/releases/latest) · Apple Silicon · macOS 26+

1. Open the DMG and drag **ONE SEG Studio** to **Applications**.
2. Connect your HackRF One by USB and open the application.
3. Click **Detect HackRF**, select your video, and choose the channel and video bitrate.
4. Click **Prepare video**. Preparation does not transmit.
5. Click **Start transmission** when ready. **Stop** ends transmission.

Use RF transmission only where authorized. The receiver must support Japanese One-Seg; a conventional DVB-T television is not a substitute.

## Other editions

- **[ONE SEG Web Lab — Beta](https://vanhoteen.github.io/ONE-SEG-Studio-WEB-/)** runs in Chrome or Edge with a HackRF connected to that computer. It is a quick browser-based test and currently prepares finite video clips of up to **15 seconds**.
- **[ONE SEG Studio for Linux — Ubuntu 26.04 amd64 Preview](https://github.com/vanhoteen/ONE-SEG-Studio-for-Linux---Ubuntu-26.04-amd64-Preview)** is a working Linux beta, tested by the author on Ubuntu 26.04 amd64. It remains an experimental preview.

## Requirements and included tools

- Apple Silicon Mac (M1 or later), macOS 26 or later for this build.
- HackRF One and a compatible One-Seg receiver for the over-the-air demonstration.
- Python, GNU Radio runtime, gr-isdbt, NumPy, FFmpeg, TSDuck, SoapySDR, libHackRF and libusb are included. Users do not need Homebrew or Xcode. GNU Radio Companion, the editor, is not included or required.

The application currently supports **English and Spanish**. This README is available in five languages; that does not mean the interface supports all five.

## Features

Video files are converted to 320 × 240 at 15 fps, with AAC audio at 48 kb/s. Video choices: 80, 100, 200 and 300 kb/s. Includes channel selection, VGA gain, an RF amplifier switch, HackRF detection, a signal display and a log. The signal display does not measure reception at the television.

## Demo

[![ONE SEG — Demo](https://img.youtube.com/vi/hW7jU8Ro0uk/hqdefault.jpg)](https://youtu.be/hW7jU8Ro0uk)

[YouTube · ONE SEG la Señal de Television Japonesa para dispositivos portatiles](https://youtu.be/hW7jU8Ro0uk)

## Current limits

This is an experimental release. This build is ad-hoc signed, not Apple-notarized; macOS may require manual approval. Camera/capture input is not implemented. Prepared files are finite tests; uninterrupted looping and live signalling are not guaranteed. No broadcast-standard certification is claimed.

Work files are stored in `~/Library/Application Support/ONE SEG Studio`.

For build details, testing and third-party notices see [Development](docs/DEVELOPMENT.md) and [Licensing](LICENSE-NOTICE.md).
