import SwiftUI
import AppKit

struct StudioView: View {
    @EnvironmentObject var model: Studio
    @State private var showLog = false
    private let ink = Color(red: 0.08, green: 0.15, blue: 0.22)
    private let paper = Color(red: 0.97, green: 0.96, blue: 0.93)
    private let red = Color(red: 0.84, green: 0.17, blue: 0.13)
    private var locked: Bool { model.busy || model.running || model.detecting }
    private var logo: NSImage? { Bundle.main.url(forResource: "one-seg-logo", withExtension: "png").flatMap { NSImage(contentsOf: $0) } }
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                if let logo { Image(nsImage: logo).resizable().scaledToFit().frame(width: 62, height: 62) }
                VStack(alignment: .leading, spacing: 3) {
                    Text("ONE SEG").font(.system(size: 27, weight: .black, design: .rounded)).tracking(3)
                    Text("STUDIO / for vanhoteen").font(.system(size: 11, weight: .medium)).tracking(1.5)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 5) {
                    Text("ワンセグ").font(.headline)
                    Text(model.t("Probado con Sony XDV-D500")).font(.caption).foregroundStyle(.secondary)
                }
                Picker(model.t("Idioma"), selection: $model.language) {
                    Text("Español").tag("es"); Text("English").tag("en")
                }.labelsHidden().frame(width: 105)
            }.padding(.horizontal, 22).padding(.vertical, 10)
            Rectangle().fill(red).frame(height: 3)
            VStack(spacing: 14) {
                HStack(spacing: 12) {
                    Image(systemName: "antenna.radiowaves.left.and.right").font(.title2)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(model.t("CONEXIÓN HACKRF")).font(.caption.bold()).tracking(1)
                        Text(model.t(model.deviceStatus)).font(.callout).lineLimit(2)
                    }
                    Spacer()
                    if model.detecting { ProgressView().controlSize(.small) }
                    Circle().fill(model.deviceAvailable ? Color.green : Color.gray).frame(width: 8,height: 8)
                    Button(model.t(model.detecting ? "Detectando…" : "Detectar HackRF")) { model.detect() }
                        .buttonStyle(.borderedProminent).tint(ink).disabled(locked)
                }.padding(12).background(.white.opacity(0.7), in: RoundedRectangle(cornerRadius: 12))
                HStack(alignment: .top, spacing: 16) {
                    VStack(alignment: .leading, spacing: 12) {
                        caption("01", "CONTENIDO")
                        ZStack {
                            RoundedRectangle(cornerRadius: 12).fill(ink)
                            VStack(spacing: 10) {
                                Image(systemName: model.input == nil ? "film.stack" : "play.rectangle").font(.system(size: 30, weight: .light))
                                Text(model.input?.lastPathComponent ?? model.t("Tu próximo canal empieza aquí")).font(.headline).lineLimit(2)
                                Text(model.t("Archivo de vídeo · perfil One-Seg")).font(.caption).opacity(0.6)
                            }.foregroundStyle(paper).padding(16)
                        }.frame(height: 144)
                        Button { model.choose() } label: { Label(model.t("Elegir vídeo…"), systemImage: "folder").frame(maxWidth: .infinity) }.controlSize(.large).disabled(locked)
                        HStack { tag("320 × 240"); tag("15 FPS"); tag("AAC 48k") }
                    }.frame(maxWidth: .infinity)
                    VStack(alignment: .leading, spacing: 10) {
                        caption("02", "CANAL Y CALIDAD")
                        HStack {
                            Text(String(format: "CH %02d", model.channel)).font(.system(size: 27, weight: .bold, design: .monospaced))
                            Spacer()
                            Stepper(model.t("Canal"), value: $model.channel, in: 13...62).labelsHidden().disabled(locked)
                        }
                        Text(String(format: model.t("%.6f MHz · Japón"), model.frequency)).font(.caption.monospaced()).foregroundStyle(.secondary)
                        Divider()
                        Picker(model.t("Bitrate de vídeo"), selection: $model.bitrate) {
                            ForEach([80,100,200,300], id: \.self) { Text("\($0)k").tag($0) }
                        }.pickerStyle(.segmented).disabled(locked)
                        HStack { Text(model.t("Ganancia VGA")); Spacer(); Text("\(Int(model.gain)) dB").monospacedDigit().bold() }.font(.subheadline)
                        Slider(value: $model.gain, in: 0...47, step: 1).tint(red).disabled(locked)
                        Toggle(model.t("Amplificador RF"), isOn: $model.amplifier).toggleStyle(.switch).tint(red).disabled(locked)
                    }.padding(14).frame(maxWidth: .infinity).background(.white.opacity(0.7), in: RoundedRectangle(cornerRadius: 12))
                }
                SignalView(snapshot: model.waveform, running: model.running)
                Spacer(minLength: 0)
            }.padding(.horizontal, 20).padding(.top, 14).padding(.bottom, 12)
            Divider()
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    Circle().fill(model.running ? red : Color.gray).frame(width: 9,height: 9)
                    Text(model.t(model.status)).font(.callout).lineLimit(2)
                    Spacer()
                    if model.busy { ProgressView().controlSize(.small) }
                    Button(model.t("Registro")) { showLog = true }.buttonStyle(.link)
                }
                HStack(spacing: 12) {
                    Button { model.prepare() } label: { Label(model.t("Preparar vídeo"), systemImage: "wand.and.stars").frame(maxWidth: .infinity) }.disabled(model.input == nil || locked)
                    Button { model.transmit() } label: { Label(model.t("Iniciar emisión"), systemImage: "play.fill").frame(maxWidth: .infinity) }.buttonStyle(.borderedProminent).tint(red).disabled(!model.ready || locked)
                    Button { model.stop() } label: { Label(model.t("Detener"), systemImage: "stop.fill") }.disabled(!locked)
                }.controlSize(.large)
            }.padding(.horizontal,20).padding(.vertical,14).background(.white.opacity(0.6))
        }.background(paper).foregroundStyle(ink).preferredColorScheme(.light).frame(minWidth: 830, minHeight: 670)
        
        .onChange(of: model.channel) { _,_ in model.ready = false }
        .onChange(of: model.gain) { _,_ in model.ready = false }
        .onChange(of: model.bitrate) { _,_ in model.ready = false }
        .onChange(of: model.amplifier) { _,_ in model.ready = false }
        .sheet(isPresented: $showLog) {
            VStack(alignment: .leading, spacing: 15) {
                Text(model.t("Registro técnico")).font(.title2.bold())
                ScrollView { Text(model.log.isEmpty ? model.t("Sin actividad todavía.") : model.log).font(.system(.caption,design: .monospaced)).textSelection(.enabled).frame(maxWidth: .infinity,alignment: .leading) }
                HStack { Spacer(); Button(model.t("Cerrar")) { showLog = false }.keyboardShortcut(.cancelAction) }
            }.padding(20).frame(width: 670, height: 400)
        }
    }
    private func caption(_ number: String, _ title: String) -> some View {
        HStack { Text(number).foregroundStyle(red); Text(model.t(title)).tracking(1.5) }.font(.caption.bold())
    }
    private func tag(_ label: String) -> some View {
        Text(label).font(.caption2.monospaced()).padding(.horizontal,10).padding(.vertical,5).background(ink.opacity(0.06),in: Capsule())
    }
}
