import WidgetKit
import SwiftUI

// Configura il gruppo di default come dal plugin home_widget
// IMPORTANTE: Assicurati di usare il group ID esatto registrato nell'Apple Developer Portal.
let appGroupId = "group.com.example.cubetrainer" 

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> StatsEntry {
        StatsEntry(date: Date(), bestTime: "--", ao5: "--", ao12: "--", solveCount: 0, cubeType: "3x3", sparklinePath: "")
    }

    func getSnapshot(in context: Context, completion: @escaping (StatsEntry) -> ()) {
        let entry = StatsEntry(date: Date(), bestTime: "12.34", ao5: "13.50", ao12: "14.20", solveCount: 42, cubeType: "3x3", sparklinePath: "")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [StatsEntry] = []

        // Lettura dati condivisi da Flutter tramite UserDefaults
        let defaults = UserDefaults(suiteName: appGroupId)
        let bestTime = defaults?.string(forKey: "best_time") ?? "--"
        let ao5 = defaults?.string(forKey: "ao5") ?? "--"
        let ao12 = defaults?.string(forKey: "ao12") ?? "--"
        let solveCount = defaults?.integer(forKey: "solve_count") ?? 0
        let cubeType = defaults?.string(forKey: "cube_type") ?? "3x3"
        let sparklinePath = defaults?.string(forKey: "sparkline_path") ?? ""

        let entry = StatsEntry(
            date: Date(),
            bestTime: bestTime,
            ao5: ao5,
            ao12: ao12,
            solveCount: solveCount,
            cubeType: cubeType,
            sparklinePath: sparklinePath
        )

        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct StatsEntry: TimelineEntry {
    let date: Date
    let bestTime: String
    let ao5: String
    let ao12: String
    let solveCount: Int
    let cubeType: String
    let sparklinePath: String
}

struct StatsWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            smallWidget
        case .systemMedium:
            mediumWidget
        default:
            smallWidget
        }
    }

    var smallWidget: some View {
        VStack(alignment: .leading) {
            Text(entry.cubeType)
                .font(.caption)
                .foregroundColor(.cyan)
                .bold()
            Spacer()
            Text("BEST")
                .font(.system(size: 10))
                .foregroundColor(.gray)
            Text(entry.bestTime)
                .font(.title2)
                .bold()
            Spacer()
            Text("Ao5")
                .font(.system(size: 10))
                .foregroundColor(.gray)
            Text(entry.ao5)
                .font(.headline)
                .bold()
        }
        .padding()
        //.background(Color(red: 15/255, green: 23/255, blue: 42/255))
    }

    var mediumWidget: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(entry.cubeType)
                    .font(.caption)
                    .foregroundColor(.cyan)
                    .bold()
                Spacer()
                Text("BEST")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                Text(entry.bestTime)
                    .font(.title)
                    .bold()
                Text("Solves: \(entry.solveCount)")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Ao5")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                        Text(entry.ao5)
                            .font(.headline)
                            .bold()
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Ao12")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                        Text(entry.ao12)
                            .font(.headline)
                            .bold()
                    }
                }
                Spacer()
                if !entry.sparklinePath.isEmpty,
                   let uiImage = UIImage(contentsOfFile: entry.sparklinePath) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        //.background(Color(red: 15/255, green: 23/255, blue: 42/255))
    }
}

@main
struct StatsWidget: Widget {
    let kind: String = "StatsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            StatsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("CubeTrainer Stats")
        .description("Visualizza le tue statistiche recenti.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
