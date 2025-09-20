//
//  RichTextEditorToolbar.swift
//  Memono
//
//  Created by 조호근 on 9/20/25.
//

import UIKit

protocol RichTextEditorToolbarDelegate: AnyObject {
    func toolbarDidTapBold()
    func toolbarDidTapItalic()
    func toolbarDidTapUnderline()
    func toolbarDidTapStrikethrough()
    func toolbarDidTapHideKeyboard()
}

final class RichTextEditorToolbar: UIToolbar {
    
    weak var editorDelegate: RichTextEditorToolbarDelegate?

    init(editorDelegate: RichTextEditorToolbarDelegate) {
        self.editorDelegate = editorDelegate
        super.init(frame: .zero)
        setupToolbar()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupToolbar()
    }

    private func setupToolbar() {
        self.isTranslucent = true
        self.items = [
            makeItem(systemName: "bold", fallback: "B", action: #selector(didTapBold)),
            makeItem(systemName: "italic", fallback: "I", action: #selector(didTapItalic)),
            makeItem(systemName: "underline", fallback: "U", action: #selector(didTapUnderline)),
            makeItem(systemName: "strikethrough", fallback: "S", action: #selector(didTapStrikethrough)),
            .flexibleSpace(),
            makeItem(systemName: "keyboard.chevron.compact.down", fallback: "Hide", action: #selector(didTapHideKeyboard))
        ]
        self.sizeToFit()
    }

    private func makeItem(systemName: String, fallback: String, action: Selector) -> UIBarButtonItem {
        if let image = UIImage(systemName: systemName) {
            return UIBarButtonItem(image: image, style: .plain, target: self, action: action)
        } else {
            return UIBarButtonItem(title: fallback, style: .plain, target: self, action: action)
        }
    }

    @objc private func didTapBold() { editorDelegate?.toolbarDidTapBold() }
    @objc private func didTapItalic() { editorDelegate?.toolbarDidTapItalic() }
    @objc private func didTapUnderline() { editorDelegate?.toolbarDidTapUnderline() }
    @objc private func didTapStrikethrough() { editorDelegate?.toolbarDidTapStrikethrough() }
    @objc private func didTapHideKeyboard() { editorDelegate?.toolbarDidTapHideKeyboard() }
}
