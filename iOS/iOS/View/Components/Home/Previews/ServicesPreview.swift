import SwiftUI

struct ServicesPreview: View {
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "shield.fill")
                   .overlay(
                        LinearGradient(gradient: Gradient(colors: [Color("Green Dark"),Color("Green Light")]), startPoint:.top, endPoint:.bottom)
                           .mask(Image(systemName: "shield.fill"))
                    )
                Text("Services").font(.body.weight(.semibold))
                Spacer()
                Image("Arrow")
            }
            .frame(alignment: .leading)
            HStack{
                VStack{
                    VStack (alignment: .leading){
                        HStack{
                            Text("Theft Detection").font(.system(size: 13)).bold()
                                .frame(alignment: .leading)
                            Spacer()
                        }
                        .padding( .leading)
                        HStack{
                            Text("Free").font(.system(size: 11)).fontWeight(.medium)
                            Spacer()
                            Image(systemName: "checkmark.shield.fill").foregroundColor(Color("Green Light")).font(.system(size: 11))
                        }
                        .padding(.leading)
                        .padding(.trailing)
                    }
                    .frame(width: 94, height: 59)
                    .background(Color("StatisticPreviewMiniBox"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    VStack{
                        HStack{
                            Text("Physical Violence").font(.system(size: 13)).bold()
                                .frame(alignment:.leading)
                            Spacer()
                        }
                        .padding(.leading)
                        HStack{
                            Text("$5").font(.system(size: 11)).fontWeight(.medium)
                            Spacer()
                            Image(systemName: "xmark.shield.fill").foregroundColor(Color("xmarkShieldRed")).font(.system(size: 11))
                        }
                        .padding(.leading)
                        .padding(.trailing)
                    }
                    .frame(width: 94, height: 59)
                    .background(Color("StatisticPreviewMiniBox"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                }
                VStack{
                    VStack{
                        HStack{
                            Text("Fire Detection").font(.system(size: 13)).bold()
                                .frame(alignment:.leading)
                            Spacer()
                        }
                        .padding(.leading)
                        HStack{
                            Text("Free").font(.system(size: 11)).fontWeight(.medium)
                            Spacer()
                            Image(systemName: "checkmark.shield.fill").foregroundColor(Color("Green Light")).font(.system(size: 11))
                        }
                        .padding(.leading)
                        .padding(.trailing)
                    }
                    .frame(width: 94, height: 59)
                    .background(Color("StatisticPreviewMiniBox"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    VStack{
                        HStack{
                            Text("Dash Cam").font(.system(size: 13)).bold()
                                .frame(alignment:.leading)
                            Spacer()
                        }
                        .padding(.leading)
                        .padding(.top)
        
                        Spacer()
                                                
                        HStack{
                            Text("$5").font(.system(size: 11)).fontWeight(.medium)
                            Spacer()
                            Image(systemName: "xmark.shield.fill").foregroundColor(Color("xmarkShieldRed")).font(.system(size: 11))
                        }
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.bottom, 10)
                    }
                    .frame(width: 94, height: 59)
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
    ServicesPreview()
}

