//
//  CheckboxView.swift
//  Todo-App
//
//  Created by ASIF on 10/07/23.
//

import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
    
    // MARK: - Body
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 16) {
            Button {
                configuration.isOn.toggle()
            } label: {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .foregroundStyle(configuration.isOn ? Color.accentColor : .secondary)
                    .imageScale(.large)
            }
            .buttonStyle(.plain)
            configuration.label
        }
    }
}


extension ToggleStyle where Self == CheckboxToggleStyle {
 
    static var checkmark: CheckboxToggleStyle { CheckboxToggleStyle() }
}
