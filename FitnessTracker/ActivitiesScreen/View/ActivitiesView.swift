
import SwiftUI

struct ActivitiesView: View {
    @State var currentTab: Int = 0;
    @State var needOpenActivitySelection = false
    var body: some View {
        VStack(spacing:0) {
            Picker("Pick", selection: $currentTab) {
                Text("My").tag(0)
                Text("Users").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .border(.gray.opacity(0.4))

            TabView(selection: $currentTab) {

                ActivitiesListView(type: .myActivities)
                    .tag(0)
                ActivitiesListView(type: .userActivities)
                    .tag(1)
                
            }.tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeIn, value: currentTab)
                .transition(.slide)
                .bottomSafeAreaInset(
                    Button(action:
                            {
                                self.needOpenActivitySelection = true})
                    {
                        Text("Start")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .font(.system(size: 17))
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.all)
                            .background(Color.clear)
                    }
                )
                .background(Color.gray.opacity(0.2))
            
            NavigationLink(destination: ActivitySelectionViewControllerRepres(), isActive: $needOpenActivitySelection) {
                EmptyView()
            }
        }
    }
}


#Preview {
    ActivitiesView()
}
