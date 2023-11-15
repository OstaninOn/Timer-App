//
//  Home.swift
//  Timer App
//
//  Created by  aleksandr on 27.01.23.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var timerModel: TimerModel
    var body: some View {
        
        VStack {
            
            Text("Timer").font(Font.custom("Nosifer-Regular", size: 60))
                .fontWeight(.bold)
                .foregroundColor(Color("orang"))
                .shadow(color: Color("black"), radius: 5, x: 5, y: 0)
            
            
            Text(getTime())
                .font(Font.custom("Iceberg-Regular", size: 40))
                .font(.system(size: 45))
                .fontWeight(.ultraLight)
                .foregroundColor(Color("black"))
                .shadow(color: Color("wait"), radius: 2, x: 0, y: 0)
            
// MARK: - Lottie animations
            LottieView(name: Constant.backgroundAnime, loopMode: .loop)
                .frame(width: 0, height: 0)
                .scaleEffect(0.6)
            
            GeometryReader { proxy in
                VStack(spacing: 15) {
                    
                    ZStack {
                        
// MARK: - Shadow
                        Circle()
                            .stroke(LinearGradient(gradient: Gradient(colors: [.blue, .red]), startPoint: .top,
                                                endPoint: .bottomTrailing),
                                                style: .init(lineWidth: 40,
                                                lineCap: .round))
                        
                            .blur(radius: 2)
                            .padding(-3)
                        Circle()
                            .fill(Color("green"))
                        
                        Circle()
                            .trim(from: 0, to: timerModel.progress)
                            .stroke(Color("orang").opacity(1),lineWidth: 23)
                            .blur(radius: 0)
                            .padding(-12)
                            .shadow(color: Color("black"), radius: 5, x: 0, y: 0)
                        
                        // MARK: - Knob Circle
                        
                        GeometryReader{ proxy in
                            let size = proxy.size
                            
                            Circle()
                                .fill(Color("orang"))
                                .frame(width: 50, height: 50)
                                .overlay(content: {
                                    Circle()
                                        .fill(Color("green"))
                                        .padding(2)
                                    
                                })
                                .frame(width: size.width, height: size.height, alignment: .center)
                            
                            //MARK: - Since View is Rotated
                            
                                .offset(x: size.height / 1.86)
                                .rotationEffect(.init(degrees: timerModel.progress * 360))
                        }
                        
                        Text(timerModel.timerStrinngValue)
                            .font(.system(size: 45, weight: .light))
                            .rotationEffect(.init(degrees: 90))
                            .animation(.none, value: timerModel.progress)
                    }
                    .padding(40)
                    .frame(height: proxy.size.width)
                    .rotationEffect(.init(degrees: -90))
                    .animation(.easeInOut, value: timerModel.progress)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    
                    Button {
                        if timerModel.isStarted {
                            timerModel.stopTimer()
                            
                            // MARK: - Cancelling All Notifications
                            
                            UNUserNotificationCenter.current()
                                .removeAllPendingNotificationRequests()
                        } else {
                            timerModel.addNewTimer = true
                        }
                    } label: {
                        
                        Image(systemName: !timerModel.isStarted ? "timer" : "stop.fill")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                            .frame(width: 90, height: 90)
                            .background {
                                Circle()
                                    .fill(Color("green"))
                            }
                            .shadow(color: Color("orang"), radius: 9, x: 0, y: 0)
                    }
                }
                
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .padding()
        .background {
            Color("green")
                .ignoresSafeArea()
        }
        .overlay(content: {
            ZStack {
                Color.black
                    .opacity(timerModel.addNewTimer ? 0.2 : 0)
                    .onTapGesture {
                        timerModel.hour = 0
                        timerModel.minutes = 0
                        timerModel.seconds = 0
                        timerModel.addNewTimer = false
                        
                    }
                
                NewTimerView()
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(y: timerModel.addNewTimer ? 0 : 500)
            }
            .animation(.easeInOut, value: timerModel.addNewTimer)
        })
        .preferredColorScheme(.dark)
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) {
            _ in
            if timerModel.isStarted {
                timerModel.updateTimer()
            }
        }
        .alert("Timer ⏰", isPresented: $timerModel.isFinished) {
            Button("Start New", role: .cancel) {
                timerModel.stopTimer()
                timerModel.addNewTimer = true
            }
            Button("Close", role: .destructive) {
                timerModel.stopTimer()
            }
        }
    }
    // MARK: - New Timer Botton Sheet
    
    @ViewBuilder
    func NewTimerView() -> some View {
        VStack(spacing: 15) {
            Text("New Timer")
                .foregroundColor(Color("orang"))
                .font(Font.custom("Iceberg-Regular", size: 50))
                .font(.title2.bold())
                .padding(.top,10)
            
            HStack(spacing: 15) {
                Text("\(timerModel.hour) hr")
                    .font(Font.custom("Iceberg-Regular", size: 30))
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(1))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background {
                        Capsule()
                            .fill(.white.opacity(0.07))
                    }
                    .contextMenu {
                        ContextMenuOptions(maxValue: 24, hint: "hr") { value in
                            timerModel.hour = value
                        }
                    }
                
                Text("\(timerModel.minutes) min")
                    .font(Font.custom("Iceberg-Regular", size: 30))
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(1))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background {
                        Capsule()
                            .fill(.white.opacity(0.07))
                    }
                    .contextMenu {
                        ContextMenuOptions(maxValue: 60, hint: "min") { value in
                            timerModel.minutes = value
                        }
                    }
                
                Text("\(timerModel.seconds) sec")
                    .font(Font.custom("Iceberg-Regular", size: 30))
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(1))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background {
                        Capsule()
                            .fill(.white.opacity(0.07))
                    }
                    .contextMenu {
                        ContextMenuOptions(maxValue: 60, hint: "sec") { value in
                            timerModel.seconds = value
                        }
                    }
            }
            .padding(.top,20)
            
            Button {
                timerModel.StartTimer()
            } label: {
                
                Text("Start")
                    .font(Font.custom("Iceberg-Regular", size: 35))
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .padding(.horizontal, 100)
                    .background {
                        Capsule()
                            .fill(Color("green"))
                            .shadow(color: Color("orang"), radius: 9, x: 0, y: 0)
                     }
              }
        }
        .padding()
        .frame(maxWidth: .infinity)
        
        .background {
            
            RoundedRectangle(cornerRadius: 44, style: .continuous)
                .fill(Color("green"))
                .ignoresSafeArea()
            
        }
        // MARK: - New Timer alert
        .animation(Animation.spring(response: 0.2, dampingFraction: 0.6))
    }
    
    // MARK: - Reusable Conntext Menu Options
    
    @ViewBuilder
    func ContextMenuOptions(maxValue: Int, hint: String, onClick: @escaping (Int) ->()) -> some View {
        ForEach(0...maxValue,id: \.self) {value in
            Button("\(value) \(hint)") {
                onClick(value)
                
            }
        }
    }
    
    // MARK: - Clock
    
    func getTime() -> String {
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
        return format.string(from: Date())
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(TimerModel())
    }
}
