//
//  TextView.swift
//  SimpleText
//
//  Created by Max094_Reikeb on 19/09/2022.
//

import Foundation
import SwiftUI

struct TextView: UIViewRepresentable {

    @Binding var text: String
    @Binding var textSize: Double

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator

        textView.font = UIFont(name: "HelveticaNeue", size: textSize)
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.textColor = .white
        textView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)

        return textView
    }

    func updateUIView(_ view: UITextView, context: Context) {
        view.text = text
        view.font = UIFont(name: "HelveticaNeue", size: textSize)
    }

    func setTextSize(newTextSize: CGFloat) {
        textSize = newTextSize
    }

    func reset() {
        self.text = ""
    }

    class Coordinator : NSObject, UITextViewDelegate {

        var parent: TextView

        init(_ uiTextView: TextView) {
            self.parent = uiTextView
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }

        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }
    }
}
