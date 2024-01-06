
import Foundation
import SwiftUI

struct ProfileView: View {
    

    init() {
        if #available(iOS 14.0, *) {
            // iOS 14 doesn't have extra separators below the list by default.
        } else {
            // To remove only extra separators below the list:
            UITableView.appearance().tableFooterView = UIView()
        }
        
        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
    }
    
    var body: some View
    {
        ZStack(alignment: .bottom)
        {
            List {
                Section
                {
                    HStack{
                        Text("Login")
                        Spacer()
                        Text("***")
                    }
                    HStack{
                        Text("Name")
                        Spacer()
                        Text("***")
                    }
                    HStack{
                        Text("Password")
                        Spacer()
                        Text("***")
                    }
                }
                
            }
            .listStyle(.insetGrouped)
            .background(Color.gray)
            .overlay(
                Button(action: {
                    Auth.shared.logout()
                }) {
                    Text("Sign out")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .font(.system(size: 17))
                        .foregroundColor(.white)
                        .shadow(color: .gray, radius: 0.2, x: 1, y: 1)
                        .background(Color.red)
                    
                        .cornerRadius(10)
                        .padding()
                    
                }, alignment:.bottom)
        }
    }
}


#Preview {
    ProfileView()
}
