import SwiftUI

struct StatisticsPreview: View {
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "chart.bar.xaxis")
                   .overlay(
                        LinearGradient(gradient: Gradient(colors: [Color("Blue Light"),Color("Blue Dark")]), startPoint:.leading, endPoint:.trailing)
                           .mask(Image(systemName: "chart.bar.xaxis"))
                    )
                Text("Statistics").font(.body.weight(.semibold))
                Spacer()
                Image("Arrow")
            }
            .frame(alignment: .leading)
            HStack{
                VStack{
                    VStack{
                        Text("AQI").font(.system(size: 13))
                        Text("30").bold().font(.system(size: 21))
                    }
                    .frame(width: 59, height: 59)
                    .background(Color("StatisticPreviewMiniBox"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    VStack{
                        Text("CO").font(.system(size: 13))
                        Text("0.7").bold().font(.system(size: 21))
                    }
                    .frame(width: 59, height: 59)
                    .background(Color("StatisticPreviewMiniBox"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                VStack{
                    VStack{
                        Text("Temp").font(.system(size: 13))
                        HStack(spacing: 0) {
                            Text("72")
                            Text("°F")
                                .baselineOffset(14)
                                .font(.system(size: 12))
                        }
                        .bold()
                        .font(.system(size: 21))
                    }
                    .frame(width: 59, height: 59)
                    .background(Color("StatisticPreviewMiniBox"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    VStack{
                        Text("RH").font(.system(size: 13))
                        Text("80%").bold().font(.system(size: 21))
                    }
                    .frame(width: 59, height: 59)
                    .background(Color("StatisticPreviewMiniBox"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                VStack{
                    VStack{
                        Text("TVOC").font(.system(size: 13))
                        Text("0.4").bold().font(.system(size: 21))
                    }
                    .frame(width: 59, height: 59)
                    .background(Color("StatisticPreviewMiniBox"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    VStack{
                        VStack{
                            HStack(spacing: 0) {
                                Text("p").font(.system(size: 13))
                                Text("b").baselineOffset(-8).font(.system(size: 9))
                            }
                            
                            Text("29.5").bold().font(.system(size: 21)).baselineOffset(4)
                        }
                    }
                    .frame(width: 59, height: 59)
                    .background(Color("StatisticPreviewMiniBox"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            
        }
        .padding()
        .background(Color("TabViewColor"))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    StatisticsPreview()
}
