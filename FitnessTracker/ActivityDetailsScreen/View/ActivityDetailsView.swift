
import SwiftUI
import Foundation


struct ActivityDetailsScreen: View
{
    @State private var comment: String = ""
    @ObservedObject private var viewModel: ActivityDetailsViewModel
    
    init(activityId: Int) {
        viewModel = ActivityDetailsViewModel(activityId: activityId)
    }
    var body: some View {
        if let activityData = viewModel.activityData
        {
            VStack(alignment: .leading)
            {
                Text(activityData.getPerformedInfo()).bold()
                Text(activityData.getTime()).foregroundColor(.gray)
                Text(activityData.getDurationStr())
                    .bold()
                    .padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0))
                
                Text("Start | Stop").foregroundColor(.gray)
                
                Text(activityData.type.toString()).padding(EdgeInsets(top: 16, leading: 0, bottom: 32, trailing: 0))
                
                TextField("Comment",text: $comment)
                    .padding(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12))
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))
                Spacer()
            }
            .padding(EdgeInsets(top: 32, leading: 32, bottom: 32, trailing: 32))
            .navigationTitle(activityData.type.toString())
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
