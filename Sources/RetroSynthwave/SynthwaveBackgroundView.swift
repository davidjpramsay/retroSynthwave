import SwiftUI

public struct SynthwaveBackgroundView: View {
    @StateObject private var viewModel = SynthwaveViewModel()
    @State private var lastUpdate = Date()
    @State private var hasStarted = false

    public init() {}

    public var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black,
                    Color(red: 0.35, green: 0.0, blue: 0.2),
                    Color.black
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            TimelineView(.animation(minimumInterval: 1.0 / 60.0)) { timeline in
                Canvas { context, size in
                    updateModel(for: timeline.date)

                    drawSun(in: &context, size: size)
                    drawGrid(in: &context, size: size)
                }
                .ignoresSafeArea()
            }
        }
    }

    private func updateModel(for date: Date) {
        DispatchQueue.main.async {
            if !hasStarted {
                hasStarted = true
                lastUpdate = date
                return
            }

            let delta = date.timeIntervalSince(lastUpdate)
            lastUpdate = date
            viewModel.update(deltaTime: delta)
        }
    }

    private func drawSun(in context: inout GraphicsContext, size: CGSize) {
        let diameter = min(size.width, size.height) * 0.5
        let centerY = size.height * 0.35
        let sunRect = CGRect(
            x: (size.width - diameter) / 2.0,
            y: centerY - diameter / 2.0,
            width: diameter,
            height: diameter
        )

        var sunPath = Path(ellipseIn: sunRect)
        var sunContext = context
        sunContext.addFilter(.shadow(color: Color.orange.opacity(0.8), radius: diameter * 0.25, x: 0, y: 0))
        sunContext.fill(
            sunPath,
            with: .linearGradient(
                Gradient(colors: [
                    Color.yellow,
                    Color(red: 0.8, green: 0.0, blue: 0.45)
                ]),
                startPoint: CGPoint(x: sunRect.midX, y: sunRect.minY),
                endPoint: CGPoint(x: sunRect.midX, y: sunRect.maxY)
            )
        )
    }

    private func drawGrid(in context: inout GraphicsContext, size: CGSize) {
        guard viewModel.points.count > 1, size.width > 0, size.height > 0 else { return }

        let offset = viewModel.offset
        let focalLength = viewModel.focalLength

        var projectedGrid: [[CGPoint]] = []
        projectedGrid.reserveCapacity(viewModel.points.count)

        var minX: CGFloat = .infinity
        var maxX: CGFloat = -.infinity
        var minY: CGFloat = .infinity
        var maxY: CGFloat = -.infinity

        for row in viewModel.points {
            var projectedRow: [CGPoint] = []
            projectedRow.reserveCapacity(row.count)

            for point in row {
                let projected = project(point, offset: offset, focalLength: focalLength)
                projectedRow.append(projected)

                minX = min(minX, projected.x)
                maxX = max(maxX, projected.x)
                minY = min(minY, projected.y)
                maxY = max(maxY, projected.y)
            }

            projectedGrid.append(projectedRow)
        }

        guard
            minX.isFinite, maxX.isFinite,
            minY.isFinite, maxY.isFinite
        else { return }

        let width = maxX - minX
        let height = maxY - minY

        guard width > 0, height > 0 else { return }

        let widthScale = size.width / width
        let heightScale = size.height / height
        let scale = max(widthScale, heightScale)

        let centerX = (minX + maxX) / 2.0
        let xOffset = size.width / 2.0 - centerX * scale
        let targetBottom = size.height
        let yOffset = targetBottom - maxY * scale

        var transformedGrid: [[CGPoint]] = []
        transformedGrid.reserveCapacity(projectedGrid.count)

        for row in projectedGrid {
            let transformedRow = row.map { point -> CGPoint in
                CGPoint(
                    x: point.x * scale + xOffset,
                    y: point.y * scale + yOffset
                )
            }
            transformedGrid.append(transformedRow)
        }

        for rowIndex in 0..<(transformedGrid.count - 1) {
            let row = transformedGrid[rowIndex]
            let nextRow = transformedGrid[rowIndex + 1]
            let originalRow = viewModel.points[rowIndex]

            for columnIndex in 0..<(row.count - 1) {
                let current = originalRow[columnIndex]

                let p1 = row[columnIndex]
                let p2 = row[columnIndex + 1]
                let p3 = nextRow[columnIndex + 1]
                let p4 = nextRow[columnIndex]

                var quad = Path()
                quad.move(to: p1)
                quad.addLine(to: p2)
                quad.addLine(to: p3)
                quad.addLine(to: p4)
                quad.closeSubpath()

                let fillOpacity = max(0.0, min(0.85, -current.z / 100.0))
                let colorValue = max(0.0, min(300.0, 300.0 + current.z))
                let strokeRed = max(0.0, min(1.0, (250.0 - colorValue) / 255.0))
                let strokeBlue = max(0.0, min(1.0, (50.0 + colorValue) / 255.0))
                let strokeOpacity = max(0.0, min(1.0, 1.0 - colorValue / 300.0))

                context.fill(quad, with: .color(Color.black.opacity(fillOpacity)))
                context.stroke(
                    quad,
                    with: .color(Color(red: strokeRed, green: 0.0, blue: strokeBlue, opacity: strokeOpacity)),
                    lineWidth: 1.0
                )
            }
        }
    }

    private func project(_ point: SynthwaveViewModel.GridPoint, offset: Double, focalLength: Double) -> CGPoint {
        let scale = focalLength / (focalLength + point.z)
        let x = (point.x - offset) * scale
        let y = point.y * scale
        return CGPoint(x: x, y: y)
    }
}

#if DEBUG
struct SynthwaveBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        SynthwaveBackgroundView()
            .frame(width: 400, height: 300)
    }
}
#endif
