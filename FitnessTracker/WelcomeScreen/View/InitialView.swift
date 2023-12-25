
import SwiftUI


struct InitialView: View {
    @State private var showRegistration = false
    @State private var action: Int? = 0
    
    var body: some View {
        NavigationView{
            VStack(alignment: .center) {
                Image(Resources.welcomeScreenImage).padding(EdgeInsets(top: 112, leading: 16, bottom: 0, trailing: 16))
                Text("Fitness tracker").font(.title2).bold().padding(EdgeInsets(top: 32, leading: 16, bottom: 0, trailing: 16))
                Spacer()
                
//                NavigationLink(destination: RegistrationView(), tag: 1, selection: $action) {
//                                    
//                                }
                
//                NavigationLink(LocalizedStringKey(""), destination: RegistrationView()
//                    .navigationBarTitle(Text("Registration"), displayMode: .large)
////                    .navigationTitle("Registration")
////                    .navigationBarTitleDisplayMode(.large)
//
//                )
                

                
                    Button(action:{
                        self.showRegistration = true
                        self.action = 1
                    }){
                        Text("Register").font(.title3).frame(maxWidth: .infinity)
                    }
                    .padding().frame(maxWidth: .infinity).background(Color.blue
                        )
                    .cornerRadius(10)
                    .foregroundColor(Color.white)
                
                    

                Button {
                    
                } label: {
                    Text("Already registered")
                }
                .padding()
            }
            .padding(.all)
        }
        
    }
}


