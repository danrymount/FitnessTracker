
import SwiftUI


enum WelcomeState
{
    case welcome
    case register
    case login
}

struct WelcomeView: View {
    @State private var welcomeState: WelcomeState? = .welcome
    
    var body: some View {
        NavigationView{
            VStack(alignment: .center) {
                
                Image(Resources.welcomeScreenImage).padding(EdgeInsets(top: 112, leading: 16, bottom: 0, trailing: 16))
                
                Text("Fitness tracker").font(.title2).bold().padding(EdgeInsets(top: 32, leading: 16, bottom: 0, trailing: 16))
                Spacer()
                
                Button {
                    self.welcomeState = .register
                    
                } label: {
                    Text("Register").font(.title3)
                }
                .padding().frame(maxWidth: .infinity).background(Color.blue
                )
                .cornerRadius(10)
                .foregroundColor(Color.white)
                
                Button {
                    self.welcomeState = .login
                    
                } label: {
                    Text("Already registered")
                }
                .padding()
                
                
                NavigationLink(destination: RegistrationView(), tag: WelcomeState.register, selection: $welcomeState) {
                    
                }
                
                NavigationLink(destination: LoginView(), tag: WelcomeState.login, selection: $welcomeState) {
                    
                }
            }
            .padding(.all)
        }
        
    }
}


