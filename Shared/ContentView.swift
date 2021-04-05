//
//  ContentView.swift
//  Shared
//
//  Created by Oleg Soldatoff on 3.04.21.
//

import SwiftUI

struct MyOwnPoint: Hashable {
    let x: CGFloat
    let y: CGFloat
    static func createPoints(from path: Path) -> [MyOwnPoint] {
        var points: [MyOwnPoint] = []
        path.forEach { (element) in
            switch element {
            case let .move(to: point),
                 let .line(to: point):
                points.append(MyOwnPoint(x: point.x, y: point.y))
            default:
                break
            }
        }
        return points
    }

    static func createPath(from points: [MyOwnPoint]) -> Path {
        var path = Path()
        points.forEach { (point) in
            if path.isEmpty {
                path.move(to: CGPoint(x: point.x, y: point.y))
            } else {
                path.addLine(to: CGPoint(x: point.x, y: point.y))
            }
        }
        return path
    }
}

struct ContentView: View {

    @State var points: [MyOwnPoint] = []

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.white
            Lines(points: points)
            Points(points: points)
        }
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onEnded({ (state) in
                    points.append(MyOwnPoint(x: state.startLocation.x, y: state.startLocation.y))
                })
        )
    }
}

struct Lines: View {
    let points: [MyOwnPoint]
    var body: some View {
        MyOwnPoint.createPath(from: points)
            .stroke(Color.green, lineWidth: 2)
    }
}

struct Points: View {
    let points: [MyOwnPoint]
    var body: some View {
        if points.isEmpty {
            EmptyView()
        } else {
            ForEach(points, id: \.self) { point in
                Circle()
                    .stroke(Color.red)
                    .frame(width: 10, height: 10)
                    .offset(x: point.x - 5, y: point.y - 5)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
