import Foundation
import Combine

@MainActor
final class SynthwaveViewModel: ObservableObject {
    struct GridPoint {
        var x: Double
        var y: Double
        var z: Double
    }

    @Published private(set) var points: [[GridPoint]]

    let columns: Int
    let rows: Int
    let spacing: Double
    let depthSpacing: Double
    let focalLength: Double
    let maxDepth: Double

    private let zSpeed: Double
    private let yBase: Double = 30.0

    var offset: Double {
        Double(columns) * spacing / 2.0
    }

    init(
        columns: Int = 60,
        rows: Int = 30,
        spacing: Double = 40,
        depthSpacing: Double = 10,
        focalLength: Double = 300,
        zSpeed: Double = 30,
        maxDepth: Double = -300
    ) {
        self.columns = columns
        self.rows = rows
        self.spacing = spacing
        self.depthSpacing = depthSpacing
        self.focalLength = focalLength
        self.zSpeed = zSpeed
        self.maxDepth = maxDepth

        var initialPoints: [[GridPoint]] = []
        initialPoints.reserveCapacity(rows)

        for rowIndex in 0..<rows {
            initialPoints.append(
                SynthwaveViewModel.generateRow(
                    rowIndex: rowIndex,
                    columns: columns,
                    spacing: spacing,
                    depthSpacing: depthSpacing,
                    yBase: yBase
                )
            )
        }

        self.points = initialPoints
    }

    func update(deltaTime: Double) {
        guard deltaTime > 0 else { return }

        objectWillChange.send()

        let deltaZ = -zSpeed * deltaTime

        for rowIndex in points.indices {
            for columnIndex in points[rowIndex].indices {
                points[rowIndex][columnIndex].z += deltaZ
            }
        }

        recycleRowsIfNeeded()
    }

    private func recycleRowsIfNeeded() {
        guard !points.isEmpty else { return }

        while let lastRow = points.last,
              lastRow.contains(where: { $0.z < maxDepth }) {
            var recycledRow = points.removeLast()

            for columnIndex in recycledRow.indices {
                let distance = abs(Double(columnIndex) - Double(columns) / 2.0)
                recycledRow[columnIndex].z = 0
                recycledRow[columnIndex].y = yBase - Double.random(in: 0...1) * (distance * distance)
            }

            points.insert(recycledRow, at: 0)
        }
    }

    private static func generateRow(
        rowIndex: Int,
        columns: Int,
        spacing: Double,
        depthSpacing: Double,
        yBase: Double
    ) -> [GridPoint] {
        var row: [GridPoint] = []
        row.reserveCapacity(columns)

        for columnIndex in 0..<columns {
            let distance = abs(Double(columnIndex) - Double(columns) / 2.0)
            let yValue = yBase - Double.random(in: 0...1) * (distance * distance)

            row.append(
                GridPoint(
                    x: Double(columnIndex) * spacing,
                    y: yValue,
                    z: -Double(rowIndex) * depthSpacing
                )
            )
        }

        return row
    }
}
