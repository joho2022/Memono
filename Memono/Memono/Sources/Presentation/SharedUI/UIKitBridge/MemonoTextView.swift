//
//  MemonoTextView.swift
//  Memono
//
//  Created by 조호근 on 9/15/25.
//

import SwiftUI

struct MemonoTextView: UIViewRepresentable {
    @Binding var text: NSAttributedString
    
    func makeUIView(context: Context) -> RichTextEditorView {
        let view = RichTextEditorView()
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: RichTextEditorView, context: Context) {
        if uiView.attributedText != text {
            uiView.attributedText = text
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Coordinator
    final class Coordinator: NSObject, UITextViewDelegate {
        var parent: MemonoTextView
        
        init(_ parent: MemonoTextView) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            guard let view = textView as? RichTextEditorView else { return }
            parent.text = view.attributedText
        }
    }
}
