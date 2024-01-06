

import SwiftUI

struct LoginView: View {
    @ObservedObject private var viewModel = LoginViewModel()

    var body: some View
    {
        VStack(alignment: .center)
        {
            Section {
                DefaultTextFieldView("Login", text: $viewModel.login)
                DefaultTextFieldView("Password", text: $viewModel.password, isSecure: true)
            } footer: {
                Text(viewModel.errorMsg.isEmpty ? " " : viewModel.errorMsg ).font(.footnote).foregroundColor(.red)
            }
            
            Button {
                viewModel.logIn()
                
            } label: {
                Group{
                    if viewModel.status != .inProgress
                    {
                        Text("Login")
                    }
                    else
                    {
                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    }
                }
                    .frame(maxWidth: .infinity).padding(EdgeInsets(top: 14, leading: 0, bottom: 14, trailing: 0))
                
            }
            .background(Color.blue)
            .foregroundColor(Color.white)
            .cornerRadius(10)
            .padding(EdgeInsets(top: 40, leading: 0, bottom: 0, trailing: 0))
            
            
            Spacer()
        }
        .padding(.all)
        .navigationBarTitle("Login", displayMode: .large)
    }
}

#Preview {
    LoginView()
}
