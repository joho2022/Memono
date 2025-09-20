//
//  RichTextEditorView.swift
//  Memono
//
//  Created by 조호근 on 9/15/25.
//

import UIKit

final class RichTextEditorView: UITextView {
    
    private var lastCommittedTypingAttributes: [NSAttributedString.Key: Any]?
    
    private var isSlantOn: Bool = false
    
    // MARK: - Init
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        font = .systemFont(ofSize: 17)
        isScrollEnabled = true
        alwaysBounceVertical = true
        delegate = self
        textStorage.delegate = self
        
        let toolbar = RichTextEditorToolbar(editorDelegate: self)
        inputAccessoryView = toolbar
    }
    
}

// MARK: - Toggle helpers

extension RichTextEditorView {
    
    private func currentTypingFont() -> UIFont {
        (typingAttributes[.font] as? UIFont) ?? font ?? .systemFont(ofSize: 17)
    }
    
    private func applySlant(_ enabled: Bool) {
        let range = selectedRange
        if range.length > 0 {
            textStorage.beginEditing()
            textStorage.enumerateAttribute(.font, in: range, options: []) { value, subrange, _ in
                let base = (value as? UIFont) ?? self.currentTypingFont()
                let newFont = base.withSlant(enabled)
                textStorage.addAttribute(.font, value: newFont, range: subrange)
            }
            textStorage.endEditing()
            
            let base = currentTypingFont()
            typingAttributes[.font] = base.withSlant(enabled)
        } else {
            let base = currentTypingFont()
            typingAttributes[.font] = base.withSlant(enabled)
        }
        lastCommittedTypingAttributes = typingAttributes
    }
     
    private func toggleTrait(_ trait: UIFontDescriptor.SymbolicTraits) {
        let selectionRange = selectedRange
        
        if selectionRange.length > 0 {
            textStorage.beginEditing()
            textStorage.enumerateAttribute(.font, in: selectionRange, options: []) { value, subrange, _ in
                let base = (value as? UIFont) ?? self.currentTypingFont()
                var toggled = base.withToggledTrait(trait)
                toggled = toggled.withSlant(self.isSlantOn)
                textStorage.addAttribute(.font, value: toggled, range: subrange)
            }
            textStorage.endEditing()
            
            let base = currentTypingFont()
            var toggled = base.withToggledTrait(trait)
            toggled = toggled.withSlant(isSlantOn)
            typingAttributes[.font] = toggled
            
        } else {
            let base = currentTypingFont()
            var toggled = base.withToggledTrait(trait)
            toggled = toggled.withSlant(isSlantOn)
            typingAttributes[.font] = toggled
        }
        
        lastCommittedTypingAttributes = typingAttributes
    }
    
    private func toggleAttribute(_ key: NSAttributedString.Key, value: Any) {
        let selectionRange = selectedRange
        
        if selectionRange.length > 0 {
            textStorage.beginEditing()
            textStorage.enumerateAttribute(key, in: selectionRange, options: []) { existing, subrange, _ in
                if existing == nil {
                    textStorage.addAttribute(key, value: value, range: subrange)
                } else {
                    textStorage.removeAttribute(key, range: subrange)
                }
            }
            textStorage.endEditing()
            
            let inspectIndex = max(0, selectionRange.location)
            if inspectIndex < textStorage.length {
                let attributesAtPosition = textStorage.attributes(at: inspectIndex, effectiveRange: nil)
                typingAttributes = attributesAtPosition
                lastCommittedTypingAttributes = typingAttributes
            } else {
                lastCommittedTypingAttributes = typingAttributes
            }
        } else {
            if typingAttributes[key] == nil {
                typingAttributes[key] = value
            } else {
                typingAttributes.removeValue(forKey: key)
            }
            
            lastCommittedTypingAttributes = typingAttributes
        }
    }
}

// MARK: - RichTextEditorToolbarDelegate
extension RichTextEditorView: RichTextEditorToolbarDelegate {
    func toolbarDidTapBold() {
        if markedTextRange != nil { unmarkText() }
        toggleTrait(.traitBold)
    }
    
    func toolbarDidTapItalic() {
        if markedTextRange != nil { unmarkText() }
        isSlantOn.toggle()
        applySlant(isSlantOn)
        print("ℹ️ isSlantOn =", isSlantOn)
    }
    
    func toolbarDidTapUnderline() {
        toggleAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue)
    }
    
    func toolbarDidTapStrikethrough() {
        toggleAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue)
    }
    
    func toolbarDidTapHideKeyboard() {
        resignFirstResponder()
    }
}


// MARK: - Toggle Tap Handling
extension RichTextEditorView: UITextViewDelegate {
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        print("입력 이벤트: \(text.debugDescription)")
     
        return true
    }
    
}

// MARK: - NSTextStorageDelegate
extension RichTextEditorView: NSTextStorageDelegate {
    
    func textStorage(_ textStorage: NSTextStorage,
                     willProcessEditing editedMask: NSTextStorage.EditActions,
                     range editedRange: NSRange,
                     changeInLength delta: Int) {
        
        print("📍 willProcessEditing:")
        print("  • editedMask: \(editedMask)")
        print("  • editedRange: \(editedRange)")
        print("  • changeInLength: \(delta)")
        
        if self.markedTextRange != nil {
            print("  ⚠️ 현재 조합 중(marked)입니다.")
        } else {
            print("  ✅ 조합 아님 (정식 입력)")
        }
    }
    
    func textStorage(_ textStorage: NSTextStorage,
                     didProcessEditing editedMask: NSTextStorage.EditActions,
                     range editedRange: NSRange,
                     changeInLength delta: Int) {
        guard editedMask.contains(.editedCharacters) else { return }
        
        guard let snapshot = lastCommittedTypingAttributes else { return }
        
        textStorage.beginEditing()
        
        textStorage.enumerateAttributes(in: editedRange, options: []) { existingAttributes, subrange, _ in
            if existingAttributes[.attachment] != nil { return }
            
            textStorage.removeAttribute(.font, range: subrange)
            
            textStorage.removeAttribute(.underlineStyle, range: subrange)
            
            textStorage.removeAttribute(.strikethroughStyle, range: subrange)
        }
        
        textStorage.addAttributes(snapshot, range: editedRange)
        
        textStorage.endEditing()
    }
    
}

