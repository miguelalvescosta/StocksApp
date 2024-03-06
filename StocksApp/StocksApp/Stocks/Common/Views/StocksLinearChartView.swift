//
//  StocksLinearChartView.swift
//  StocksApp
//
//  Created by Miguel Costa on 04.03.24.
//

import SwiftUI
import Charts

struct StocksLinearChartData: Identifiable {
    var id = UUID()
    var value: Double
    var date: Date

    init(id: UUID = UUID(), value: Double, timeInterval: TimeInterval) {
        self.id = id
        self.value = value
        self.date = timeInterval.toDate()
    }
}

struct StocksLinearChartView: View {
    @State private var rawSelectedDate: Date? = nil
    @State private var lastValue: Double = 0.0
    let radius: CGFloat = 4
    let ruleMarkY: CGFloat = -10

    var data: [StocksLinearChartData]
    var chartUnit: Calendar.Component

    var chartColor: Color {
        data.isLastValueSmallerThanFirst ? .red : .green
    }

    var gradientColor: LinearGradient {
        LinearGradient(
            gradient: Gradient(
                colors: [
                    chartColor.opacity(0.8),
                    chartColor.opacity(0.1),
                ]
            ),
            startPoint: .top,
            endPoint: .bottom
        )
    }

    var maxValue: Int {
        if let maxValue = data.max(by: { $0.value < $1.value }) {
            return Int(maxValue.value) + 5
        } else {
            return 0
        }
    }

    var minValue: Int {
        if let minValue = data.min(by: { $0.value < $1.value }) {
            return Int(minValue.value) - 5
        } else {
            return 0
        }
    }

    var selectedDateValue: Double {
        if let rawSelectedDate = rawSelectedDate {
            let calendar = Calendar.current
            for entry in data {
                if calendar.isDate(entry.date,
                                   equalTo: rawSelectedDate,
                                   toGranularity: chartUnit) {
                    return entry.value
                }
            }
        }
        return lastValue
    }

    var body: some View {
        VStack(alignment: .leading) {
            Chart(data) { data in
                AreaMark(
                    x: .value("time", data.date, unit: chartUnit),
                    yStart: .value("min Value", Double(minValue)),
                    yEnd: .value("max Value", data.value)
                )
                .foregroundStyle(gradientColor)
                if let rawSelectedDate {
                    RuleMark(x: .value("Selected",
                                       rawSelectedDate,
                                       unit: chartUnit))
                    .foregroundStyle(.gray.opacity(0.3))
                    .offset(yStart: ruleMarkY)
                    .zIndex(-1)
                    .annotation(
                        position: .top,
                        spacing: 0,
                        overflowResolution: .init(
                            x: .fit(to: .chart),
                            y: .disabled
                        )
                    ) {
                        selectionPopover
                    }
                }
            }
            .chartYScale(domain: minValue...maxValue)
            .chartXAxis {
                AxisMarks(values: .automatic) {
                    AxisValueLabel()
                        .foregroundStyle(Color.white)
                }
            }

            .chartYAxis {
                AxisMarks(values: .automatic) {
                    AxisValueLabel()
                        .foregroundStyle(Color.white)
                }
            }
            .chartXSelection(value: $rawSelectedDate)
        }
    }

    @ViewBuilder
    var selectionPopover: some View {
            VStack {
                Text("Value: \(selectedDateValue.formatNumber())")
                    .bold()
                    .foregroundStyle(.black)
                    .padding(.all, PaddingConstants.xxs)
                    .onAppear {
                        lastValue = selectedDateValue
                    }
            }
            .padding(PaddingConstants.xxs)
            .background {
                RoundedRectangle(cornerRadius: radius)
                    .fill(.white)
            }
    }
}
