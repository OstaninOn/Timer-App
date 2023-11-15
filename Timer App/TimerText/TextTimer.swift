//
//  TextTimer.swift
//  Timer App
//
//  Created by  aleksandr on 12.02.23.
//

import SwiftUI

struct TextTimer: View {
    @EnvironmentObject var timerModel: TimerModel
    @State var isActive: Bool = false
    
    var body: some View {
        VStack {
            if self.isActive {
                ContentView()
            } else {
                Main()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.7) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}
struct TextTimer_Previews: PreviewProvider {
    static var previews: some View {
        TextTimer()
            .environmentObject(TimerModel())
    }
}

struct Main: View {
    @State private var bellRotating = 200
    @State private var clapperMoving = false
    @State var isActive: Bool = false
    
    var body: some View {
        VStack(spacing: 25) {
            TextShimmer(text: "Timer")
            VStack {
                Image("clock")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees( Double(bellRotating)), anchor: .top)
                    .opacity(0.9)
                    .animation(.interpolatingSpring(stiffness: 200, damping: 4).repeatForever(autoreverses: false), value: bellRotating)
            }
            .scaleEffect(1.5)
            .onAppear() {
                bellRotating = 1
                clapperMoving.toggle()
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct TextShimmer: View {
    var text: String
    @State var animation = true
    var body: some View {
        ZStack {
            Text(text)
                .font(.system(size: 100, weight: .bold))
                .foregroundColor(Color.white.opacity(0.2))
            HStack(spacing: 0) {
                ForEach(0..<text.count,id: \.self) { index in
                    Text(String(text[text.index(text.startIndex, offsetBy: index)]))
                        .font(.system(size: 100, weight: .bold))
                        .foregroundColor(randomColor())
                }
            }
            .mask(
                Rectangle()
                    .fill(
                        LinearGradient(gradient: .init(colors: [Color.green.opacity(5), Color.white,Color.white.opacity(1)]), startPoint: .top, endPoint: .bottom)
                    )
                
                    .rotationEffect(.init(degrees: 100))
                    .padding(20)
                    .offset(x: -150)
                    .offset(x: animation ? 250 : 0)
            )
            .onAppear(perform: {
                withAnimation(Animation.linear(duration: 3).repeatForever(autoreverses: true)) {
                    animation.toggle()
                }
            })
        }
    }
    
    func randomColor() -> Color {
        let color = UIColor(red: CGFloat.random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1)
        
        return Color(color)
    }
}
