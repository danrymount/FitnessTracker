
import SwiftUI


struct ActivityCardView: View {
    var activityData: ActivityDataModel
    @State var activityTime: String = ""
    
    @State var isOpenView = false
    init(data: ActivityDataModel) {
        activityData = data
        activityTime = activityData.getDate()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text(activityData.getPerformedInfo()).padding(EdgeInsets(top: 14, leading: 0, bottom: 0, trailing: 0))
                    .font(.system(size: 22, weight: .semibold))
                Text("\(activityData.getDurationStr())").padding(EdgeInsets(top: 0, leading: 0, bottom: 9, trailing: 0))
                    .foregroundColor(.gray)
                
                HStack {
                    HStack
                    {
                        ActivityIconView(imageName: activityData.type.toIconName(), radius: 12)
                        Text(activityData.type.toString())
                    }
                    Spacer()
                    Text("\(activityTime)")
                        .onAppear {
                            activityTime = activityData.getDate()
                        }
                }
            }
        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 14, trailing: 16))

        .background(Color.white)
        .cornerRadius(10)
        .onTapGesture {
            isOpenView = true
        }
        .background(NavigationLink(destination: ActivityDetailsScreen(activityId: activityData.id), isActive: $isOpenView)
        {
            EmptyView()
        })
        
    }
}

//#Preview {
//    ActivityCardView()
//}
