

import SwiftUI

struct DefaultTextFieldView: View {
    
    var title: LocalizedStringKey
    var text : Binding<String>
    var isSecure: Bool

    public init(_ titleKey: LocalizedStringKey, text: Binding<String>, isSecure: Bool = false)
    {
        title = titleKey
        self.text = text
        self.isSecure = isSecure
    }
    
    var body: some View {
        {
            !isSecure ? AnyView(TextField(title, text: text)) : AnyView(SecureField(title, text: text))
        }()
            .padding(.all)
            .background(RoundedRectangle(cornerRadius: 10)
                .fill(Constants.GRAY_COLOR()))
    }
}
