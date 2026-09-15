import SwiftUI
import AppKit
import AVFoundation

@main struct StudioApp: App {
    @StateObject private var model = Studio()
    var body: some Scene { WindowGroup("ONE SEG Studio for vanhoteen") { StudioView().environmentObject(model).onAppear {
        if let url = Bundle.main.url(forResource: "app-icon", withExtension: "png"),
           let icon = NSImage(contentsOf: url) {
            NSApplication.shared.applicationIconImage = icon
        }
    } }.defaultSize(width: 900, height: 690).windowResizability(.contentMinSize) }
}

@MainActor final class Studio: ObservableObject {
    @Published var input: URL?
    @Published var channel = 20
    @Published var gain = 10.0
    @Published var bitrate = 80
    @Published var amplifier = false
    @Published var language = UserDefaults.standard.string(forKey: "studioLanguage") ?? "es" {
        didSet { UserDefaults.standard.set(language, forKey: "studioLanguage") }
    }
    func t(_ text: String) -> String { StudioLanguage.translate(text, language: language) }
    @Published var status = "Elige un vídeo para preparar el canal"
    @Published var log = ""
    @Published var busy = false
    @Published var ready = false
    @Published var running = false
    @Published var detecting = false
    @Published var deviceStatus = "HackRF sin comprobar"
    @Published var deviceAvailable = false
    @Published var waveform: SignalSnapshot?
    private var waveformTimer: Timer?
    private var detectionCancelled = false
    private var process: Process?
    private let base = Bundle.main.resourceURL!
    private var dataDirectory: URL {
        FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].appendingPathComponent("ONE SEG Studio")
    }
    var frequency: Double { 473.142857 + Double(channel - 13) * 6 }
    func choose() {
        let panel = NSOpenPanel(); panel.allowedContentTypes = [.movie, .video]; panel.canChooseDirectories = false
        if panel.runModal() == .OK { input = panel.url; ready = false; status = "Vídeo seleccionado" }
    }
    func launch(_ arguments: [String], completion: @escaping (Int32) -> Void) {
        let p = Process(); p.executableURL = base.appendingPathComponent("Runtime/bin/python3")
        p.arguments = arguments; p.currentDirectoryURL = dataDirectory
        do { try FileManager.default.createDirectory(at: dataDirectory, withIntermediateDirectories: true) }
        catch { log += "\n\(error.localizedDescription)"; completion(-1); return }
        var env = ProcessInfo.processInfo.environment; env["PATH"] = base.appendingPathComponent("Runtime/bin").path + ":/usr/bin:/bin"
        env["PYTHONHOME"] = base.appendingPathComponent("Runtime/python").path
        env["PYTHONPATH"] = nil
        env["PYTHONNOUSERSITE"] = "1"
        env["PYTHONDONTWRITEBYTECODE"] = "1"
        env["SOAPY_SDR_ROOT"] = base.appendingPathComponent("Runtime").path
        env["SOAPY_SDR_PLUGIN_PATH"] = base.appendingPathComponent("Runtime/modules").path
        env["TSPLUGINS_PATH"] = base.appendingPathComponent("Runtime/lib").path
        env["ONESEG_DATA"] = dataDirectory.path
        p.environment = env
        let pipe = Pipe(); p.standardOutput = pipe; p.standardError = pipe
        pipe.fileHandleForReading.readabilityHandler = { h in
            let data = h.availableData
            guard !data.isEmpty else { h.readabilityHandler = nil; return }
            let text = String(decoding: data, as: UTF8.self)
            Task { @MainActor in self.log = String((self.log + text).suffix(24000)) }
        }
        p.terminationHandler = { proc in Task { @MainActor in self.process = nil; completion(proc.terminationStatus) } }
        do { try p.run(); process = p } catch { log += "\n\(error.localizedDescription)"; completion(-1) }
    }
    func prepare() {
        guard let input, !busy, !running, !detecting else { return }
        busy = true; ready = false; status = "Convirtiendo y preparando las tablas…"; log = ""
        launch([base.appendingPathComponent("prepare.py").path, input.path, String(channel), String(Int(gain)), String(bitrate), amplifier ? "1" : "0"]) { code in
            self.busy = false; self.ready = code == 0
            self.status = code == 0 ? "Canal preparado · RF detenida" : "Preparación fallida · consulta el registro"
        }
    }
    func transmit() {
        guard ready, !busy, !running, !detecting else { return }
        detect(startAfter: true)
    }
    func detect(startAfter: Bool = false) {
        guard !busy, !running, !detecting else { return }
        detecting = true; detectionCancelled = false; deviceAvailable = false
        deviceStatus = "Buscando HackRF…"
        launch([base.appendingPathComponent("detect_hackrf.py").path]) { code in
            self.detecting = false
            guard !self.detectionCancelled else {
                self.deviceStatus = "Detección cancelada"; return
            }
            self.deviceAvailable = code == 0
            switch code {
            case 0: self.deviceStatus = "HackRF detectado y accesible"
            case 2: self.deviceStatus = "HackRF no encontrado · revisa USB y otras apps SDR"
            case 3: self.deviceStatus = "HackRF detectado, pero no accesible"
            case 4: self.deviceStatus = "Falta la herramienta de detección"
            case 5: self.deviceStatus = "HackRF no responde · reconecta el USB"
            default: self.deviceStatus = "Error de detección · consulta el registro"
            }
            if startAfter && code == 0 && self.ready { self.startTransmission() }
            else if startAfter { self.status = "Emisión no iniciada · \(self.deviceStatus)" }
        }
    }
    private func startTransmission() {
        running = true; status = "Emitiendo · CH \(channel)"
        waveform = nil
        let snapshot = dataDirectory.appendingPathComponent("outputs/waveform.json")
        try? FileManager.default.removeItem(at: snapshot)
        waveformTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in
            Task { @MainActor in
                guard self.running, let data = try? Data(contentsOf: snapshot),
                      let value = try? JSONDecoder().decode(SignalSnapshot.self, from: data),
                      Date().timeIntervalSince1970 - value.time < 2 else { self.waveform = nil; return }
                self.waveform = value
            }
        }
        launch([base.appendingPathComponent("signal_tx.py").path, dataDirectory.appendingPathComponent("outputs").path]) { code in
            self.waveformTimer?.invalidate(); self.waveformTimer = nil; self.waveform = nil
            self.running = false; self.status = code == 0 ? "Emisión terminada" : "Emisión detenida · consulta el registro"
        }
    }
    func stop() { if detecting { detectionCancelled = true }; process?.terminate(); status = "Deteniendo…" }
}
