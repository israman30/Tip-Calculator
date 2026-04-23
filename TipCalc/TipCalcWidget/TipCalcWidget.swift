//
//  TipCalcWidget.swift
//  TipCalcWidget
//
//  Home / Lock Screen widget: preset tip shortcuts open the main app.
//

import SwiftUI
import UIKit
import WidgetKit

private enum TipCalcWidgetURL {
    static let openApp = URL(string: "tipcalc://open")!

    static func open(percent: Int) -> URL {
        URL(string: "tipcalc://open?percent=\(percent)")!
    }
}

// MARK: - Entry

struct TipCalcEntry: TimelineEntry {
    let date: Date
}

struct TipCalcTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> TipCalcEntry {
        TipCalcEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (TipCalcEntry) -> Void) {
        completion(TipCalcEntry(date: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TipCalcEntry>) -> Void) {
        let entry = TipCalcEntry(date: Date())
        completion(Timeline(entries: [entry], policy: .never))
    }
}

// MARK: - Views

struct TipPercentLink: View {
    let percent: Int

    var body: some View {
        Link(destination: TipCalcWidgetURL.open(percent: percent)) {
            Text("\(percent)%")
                .font(.headline.weight(.semibold))
                .foregroundStyle(Color.primary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(UIColor.secondarySystemFill))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }
}

struct TipCalcWidgetEntryView: View {
    @Environment(\.widgetFamily) private var family

    var body: some View {
        switch family {
        case .systemSmall:
            smallContent
        case .systemMedium:
            mediumContent
        default:
            mediumContent
        }
    }

    private var smallContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "percent")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.teal)
                Text("Tip Calc")
                    .font(.subheadline.weight(.bold))
            }
            HStack(spacing: 8) {
                TipPercentLink(percent: 15)
                TipPercentLink(percent: 20)
            }
            .frame(maxHeight: .infinity)
        }
        .padding(.horizontal, 2)
    }

    private var mediumContent: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "tipjar.fill")
                    .foregroundStyle(Color.teal)
                Text("Quick tip")
                    .font(.headline.weight(.bold))
                Spacer(minLength: 0)
                Link(destination: TipCalcWidgetURL.openApp) {
                    Text("Open app")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.teal)
                }
            }
            HStack(spacing: 8) {
                TipPercentLink(percent: 10)
                TipPercentLink(percent: 15)
            }
            HStack(spacing: 8) {
                TipPercentLink(percent: 20)
                TipPercentLink(percent: 25)
            }
            .frame(maxHeight: .infinity)
        }
    }
}

// MARK: - Widget

struct TipCalcQuickAccessWidget: Widget {
    let kind: String = "TipCalcQuickAccessWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TipCalcTimelineProvider()) { _ in
            TipCalcWidgetEntryView()
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("TipCalc")
        .description("Open the app with 10%, 15%, 20%, or 25% tip selected.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

@main
struct TipCalcWidgetBundle: WidgetBundle {
    var body: some Widget {
        TipCalcQuickAccessWidget()
    }
}

// MARK: - Previews

#Preview(as: .systemSmall) {
    TipCalcQuickAccessWidget()
} timeline: {
    TipCalcEntry(date: Date())
}

#Preview(as: .systemMedium) {
    TipCalcQuickAccessWidget()
} timeline: {
    TipCalcEntry(date: Date())
}
