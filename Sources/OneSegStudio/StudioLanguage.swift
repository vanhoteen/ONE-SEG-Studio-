import Foundation

enum StudioLanguage {
    static func translate(_ text: String, language: String) -> String {
        guard language == "en" else { return text }
        if let value = english[text] { return value }
        for (prefix, replacement) in [("Emitiendo · CH ","Transmitting · CH "), ("Emisión no iniciada · ","Transmission not started · ")] {
            if text.hasPrefix(prefix) { return replacement + translate(String(text.dropFirst(prefix.count)),language:language) }
        }
        return text
    }
    static let english: [String:String] = [
        "Probado con Sony XDV-D500":"Tested with Sony XDV-D500", "Idioma":"Language",
        "CONEXIÓN HACKRF":"HACKRF CONNECTION", "CONTENIDO":"CONTENT", "CANAL Y CALIDAD":"CHANNEL & QUALITY",
        "Tu próximo canal empieza aquí":"Your next channel starts here", "Archivo de vídeo · perfil One-Seg":"Video file · One-Seg profile",
        "Elegir vídeo…":"Choose video…", "Canal":"Channel", "%.6f MHz · Japón":"%.6f MHz · Japan",
        "Bitrate de vídeo":"Video bitrate", "Ganancia VGA":"VGA gain", "Amplificador RF":"RF amplifier",
        "Preparar vídeo":"Prepare video", "Iniciar emisión":"Start transmission", "Detener":"Stop",
        "Registro":"Log", "Registro técnico":"Technical log", "Cerrar":"Close", "Sin actividad todavía.":"No activity yet.",
        "Detectar HackRF":"Detect HackRF", "Detectando…":"Detecting…", "HackRF sin comprobar":"HackRF not checked",
        "Buscando HackRF…":"Searching for HackRF…", "Detección cancelada":"Detection cancelled",
        "HackRF detectado y accesible":"HackRF detected and accessible", "HackRF detectado, pero no accesible":"HackRF detected but inaccessible",
        "HackRF no encontrado · revisa USB y otras apps SDR":"HackRF not found · check USB and other SDR apps",
        "Falta la herramienta de detección":"Detection tool is missing", "HackRF no responde · reconecta el USB":"HackRF not responding · reconnect USB",
        "Error de detección · consulta el registro":"Detection failed · check the log",
        "Elige un vídeo para preparar el canal":"Choose a video to prepare the channel", "Vídeo seleccionado":"Video selected",
        "Convirtiendo y preparando las tablas…":"Converting video and preparing tables…",
        "Canal preparado · RF detenida":"Channel prepared · RF stopped", "Preparación fallida · consulta el registro":"Preparation failed · check the log",
        "Emisión terminada":"Transmission finished", "Emisión detenida · consulta el registro":"Transmission stopped · check the log", "Deteniendo…":"Stopping…",
        "Señal de salida":"Output signal", "RMS %.3f · Pico %.3f":"RMS %.3f · Peak %.3f", "Esperando muestras…":"Waiting for samples…",
        "La gráfica aparecerá al emitir":"Waveform appears during transmission"
    ]
}
