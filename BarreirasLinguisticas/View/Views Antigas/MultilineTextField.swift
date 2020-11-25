////
////  MultilineTextField.swift
////  BarreirasLinguisticas
////
////  Created by Victor S. Duarte on 04/08/20.
////  Copyright © 2020 Matheus S. Moreira. All rights reserved.
////
//
//import Foundation
//import SwiftUI
//
//struct MultilineTextField: UIViewRepresentable {
//    var placeholder: String
//    var minHeight: CGFloat
//    var maxHeight: CGFloat = 100
//    @Binding var text: String
//    @Binding var calculatedHeight: CGFloat
//
//    init(placeholder: String, text: Binding<String>, minHeight: CGFloat, calculatedHeight: Binding<CGFloat>) {
//        self.placeholder = placeholder
//        self._text = text
//        self.minHeight = minHeight
//        self._calculatedHeight = calculatedHeight
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    func makeUIView(context: Context) -> UITextView {
//        let textView = UITextView()
//        textView.delegate = context.coordinator
//
//        // Decrease priority of content resistance, so content would not push external layout set in SwiftUI
//        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        textView.isScrollEnabled = false
//        textView.isEditable = true
//        textView.isUserInteractionEnabled = true
//
//        // Set the placeholder
//        textView.text = placeholder
//        textView.textColor = UIColor.lightGray
//        textView.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
//        
//        return textView
//    }
//
//    func updateUIView(_ textView: UITextView, context: Context) {
//        textView.text = self.text
//        //recalculateHeight(view: textView)
//    }
//
//    func recalculateHeight(view: UIView) {
//        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
//        if minHeight < newSize.height && $calculatedHeight.wrappedValue != newSize.height {
//            DispatchQueue.main.async {
//                self.$calculatedHeight.wrappedValue = newSize.height // !! must be called asynchronously
//            }
//        } else if minHeight >= newSize.height && $calculatedHeight.wrappedValue != minHeight {
//            DispatchQueue.main.async {
//                self.$calculatedHeight.wrappedValue = self.minHeight // !! must be called asynchronously
//            }
//        }
//    }
//
//    class Coordinator: NSObject, UITextViewDelegate {
//        var parent: MultilineTextField
//
//        init(_ uiTextView: MultilineTextField) {
//            self.parent = uiTextView
//            self.parent.text = self.parent.placeholder
//        }
//
//        func textViewDidChange(_ textView: UITextView) {
//            // This is needed for multistage text input (eg. Chinese, Japanese)
//            if textView.markedTextRange == nil {
//                parent.text = textView.text ?? String()
//                //parent.recalculateHeight(view: textView)
//            }
//            
//            if textView.text == parent.placeholder {
//                textView.text = nil
//            }
//            
//            if textView.contentSize.height >= parent.maxHeight {
//                textView.isScrollEnabled = true
//            }
//            else {
//                textView.frame.size.height = textView.contentSize.height
//                textView.isScrollEnabled = false
//            }
//        }
//
//        func textViewDidBeginEditing(_ textView: UITextView) {
//            if textView.text == parent.placeholder {
//                textView.text = nil
//            }
//        }
//
//        func textViewDidEndEditing(_ textView: UITextView) {
//            if textView.text.isEmpty {
//                textView.text = parent.placeholder
//            }
//        }
//    }
//}
