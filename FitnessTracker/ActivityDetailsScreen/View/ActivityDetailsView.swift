
import Foundation
import SwiftUI

struct ActivityIconView: View {
    let imageName: String
    let radius: CGFloat
    var squareSide: CGFloat {
        2.0.squareRoot() * radius
    }
    
    var body: some View {
        ZStack {
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

struct InfoView: View {
    var title: String
    var data: String
    
    init(title: String, data: String) {
        self.title = title
        self.data = data
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
            Text(data)
        }
    }
}

struct ActivityDetailsScreen: View {
    @State private var comment: String = ""
    @ObservedObject private var viewModel: ActivityDetailsViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(activityId: Int) {
        viewModel = ActivityDetailsViewModel(activityId: activityId)
    }

    var body: some View {
        if let activityData = viewModel.activityData {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack(alignment: .top, content: {
                        ActivityIconView(imageName: activityData.type.toIconName(), radius: 40).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                        VStack(alignment: .leading) {
                            Text(activityData.type.toString())
                            Text("\(activityData.getStartTimeStr()) - \(activityData.getStopTimeStr())").foregroundColor(.gray)
                        }
                    })
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 32, trailing: 0))
                    
                    Text("Workout details").bold()
                    HStack(alignment: .center, spacing: 0) {
                        InfoView(title: "Workout time", data: activityData.getDurationStr())
                            .frame(minWidth: 0, maxWidth: .infinity)

                        InfoView(title: "Summary", data: activityData.summary)
                            .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 32, trailing: 0))
                    
                    if activityData.type == .Run {
                        Text("Map").bold()
                        MapView(locations: (activityData as! RunExerciseDataModel).locations, vc: nil)
                            .scaledToFit()
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 32, trailing: 0))
                    }
                    
                    TextField("Comment", text: $comment)
                        .padding(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12))
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))
                    Spacer()
                }
                .padding(EdgeInsets(top: 32, leading: 32, bottom: 32, trailing: 32))
            }
            
            .navigationTitle(activityData.getDate())
            .toolbar(content: {
                Button(action: {
                    viewModel.deleteData()
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "trash")
                        .foregroundColor(.blue)
                })
                // TODO: add custom confirmation dialog for ios 13+
            })
        }
        else {
            Text("No data")
                .onAppear(perform: {
                    viewModel.loadData()
                })
        }
    }
}

struct ActivityDetailsView_Preview: PreviewProvider {
    static var previews: some View {
        ActivityDetailsScreen(activityId: 6)
    }
}
