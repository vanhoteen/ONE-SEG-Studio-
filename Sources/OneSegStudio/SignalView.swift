import SwiftUI

struct SignalSnapshot: Decodable {
    let i: [Double]
    let q: [Double]
    let rms: Double
    let peak: Double
    let time: Double
}

struct SignalView: View {
    @EnvironmentObject var model: Studio
    let snapshot: SignalSnapshot?
    let running: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label(model.t("Señal de salida"), systemImage: "waveform.path").font(.subheadline.bold())
                Spacer()
                Text("I").foregroundStyle(.cyan)
                Text("Q").foregroundStyle(.orange)
                if let s = snapshot { Text(String(format: model.t("RMS %.3f · Pico %.3f"), s.rms,s.peak)).monospacedDigit() }
            }.font(.caption)
            ZStack {
                Canvas { context, size in
                    for n in 0...4 {
                        let y = size.height * CGFloat(n)/4
                        var path = Path(); path.move(to: CGPoint(x: 0,y: y)); path.addLine(to: CGPoint(x: size.width,y:y))
                        context.stroke(path, with: .color(.white.opacity(0.12)),lineWidth: 1)
                    }
                    if let s = snapshot {
                        for (values, color) in [(s.i,Color.cyan),(s.q,Color.orange)] {
                            guard values.count > 1 else { continue }
                            var path = Path()
                            for (index,v) in values.enumerated() {
                                let point = CGPoint(x: size.width * CGFloat(index)/CGFloat(values.count-1), y:size.height * CGFloat(1-min(1,max(-1,v)))/2)
                                if index == 0 { path.move(to:point) } else { path.addLine(to:point) }
                            }
                            context.stroke(path,with:.color(color),lineWidth:1)
                        }
                    }
                }
                if snapshot == nil { Text(model.t(running ? "Esperando muestras…" : "La gráfica aparecerá al emitir")).font(.caption).foregroundStyle(.white.opacity(0.6)) }
            }.frame(height:65).padding(8).background(Color(red:0.08,green:0.15,blue:0.22),in:RoundedRectangle(cornerRadius:10))
        }
    }
}
