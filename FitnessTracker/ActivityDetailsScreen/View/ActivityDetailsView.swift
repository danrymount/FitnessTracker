
import SwiftUI
import Foundation

struct ActivityIconView: View
{
    let imageName: String
    let radius: CGFloat
    var squareSide: CGFloat {
        2.0.squareRoot() * radius
    }
    
    var body: some View {
        ZStack
        {
            Circle()
                .fill(.blue)
                .frame(width: radius * 2, height: radius * 2)
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: squareSide, height: squareSide)
                .foregroundColor(.white)
        }
    }
}

struct ActivityDetailsScreen: View
{
    @State private var comment: String = ""
    @ObservedObject private var viewModel: ActivityDetailsViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(activityId: Int) {
        viewModel = ActivityDetailsViewModel(activityId: activityId)
    }
    var body: some View {
        if let activityData = viewModel.activityData
        {
            VStack(alignment: .leading)
            {
                Text(activityData.getPerformedInfo()).bold()
                Text(activityData.getDate()).foregroundColor(.gray)
                Text(activityData.getDurationStr())
                    .bold()
                    .padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0))
                
                Text("Start \(activityData.getStartTime()) | Stop \(activityData.getStopTime())").foregroundColor(.gray)
                
                Label {
                    Text(activityData.type.toString())
                } icon: {
                    ActivityIconView(imageName: activityData.type.toIconName(), radius: 14)
                }
                .padding(EdgeInsets(top: 16, leading: 0, bottom: 32, trailing: 0))
                
                
                TextField("Comment",text: $comment)
                    .padding(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12))
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))
                Spacer()
            }
            .padding(EdgeInsets(top: 32, leading: 32, bottom: 32, trailing: 32))
            .navigationTitle(activityData.type.toString())
            .toolbar(content: {
                Button(action: {
                    viewModel.deleteData()
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "trash")
                        .foregroundColor(.blue)
                })
                // TODO add custom confirmation dialog for ios 13+
            })
        }
        else
        {
            Text("No data")
                .onAppear(perform: {
                    viewModel.loadData()
                })
        }
    }
}


struct ActivityDetailsView_Preview: PreviewProvider {
    static var previews: some View {
        ActivityDetailsScreen(activityId: 0)
    }
}
