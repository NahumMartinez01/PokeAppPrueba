//
//  ViewExtension.swift
//  PokeApiApp
//
//  Created by Nahum Martinez on 1/5/25.
//

import Foundation
import SwiftUI

extension View {
    func keyboardToolbar(doneButtonTitle: String = "Listo", onDone: @escaping() -> Void) -> some View {
        self.toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button(doneButtonTitle) {
                    onDone()
                }
            }
        }
    }
}
