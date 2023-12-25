
import Foundation
import SwiftUI


struct RegistrationView: View{
    @State private var name: String = ""
    
    @ObservedObject private var viewModel: RegistrationViewModel = RegistrationViewModel()
    
    @EnvironmentObject private var rootViewManager: RootViewManager
    
    @State var isOpenLoginView = false
    
    var body: some View
    {
        VStack(alignment: .center)
        {
            Section {
                DefaultTextFieldView("Login", text: $viewModel.login)
                DefaultTextFieldView("Name", text: $viewModel.name)
                DefaultTextFieldView("Password", text: $viewModel.password, isSecure: true)
                DefaultTextFieldView("Confirm password", text: $viewModel.confirmPassword, isSecure: true)
            } footer: {
                Text(viewModel.errorMsg).font(.footnote).foregroundColor(.red)
            }
            
            Button {
                viewModel.register()
                
            } label: {
                Text("Register").frame(maxWidth: .infinity).padding(EdgeInsets(top: 14, leading: 0, bottom: 14, trailing: 0))
            }
            .background(Color.blue)
            .foregroundColor(Color.white)
            .cornerRadius(10)
            .padding(EdgeInsets(top: 40, leading: 0, bottom: 0, trailing: 0))
            
            
            Spacer()
                .onReceive( viewModel.$status, perform: { status in
                    if status == .success
                    {
                        isOpenLoginView = true
                    }
                })
            
            NavigationLink(destination: LoginView(), isActive: $isOpenLoginView)
            {
                EmptyView()
            }
        }
        .padding(.all)
        .navigationBarTitle("Registration", displayMode: .large)
    }
}


#Preview {
    RegistrationView()
}
