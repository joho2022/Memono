//
//  UIFont+.swift
//  Memono
//
//  Created by 조호근 on 9/18/25.
//

import UIKit

extension UIFont {

    func withSlant(_ enabled: Bool, degrees: CGFloat = 15) -> UIFont {
        if enabled {
            let r = degrees * .pi / 180
            let c = tan(r)
            let m = CGAffineTransform(a: 1, b: 0, c: c, d: 1, tx: 0, ty: 0)
            return UIFont(descriptor: fontDescriptor.withMatrix(m), size: pointSize)
        } else {
            return UIFont(descriptor: fontDescriptor.withMatrix(.identity), size: pointSize)
        }
    }

    func withToggledTrait(_ trait: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard trait != .traitItalic else { return self }

        var traits = fontDescriptor.symbolicTraits
        
        if traits.contains(trait) {
            traits.remove(trait)
        } else {
            traits.insert(trait)
        }
        guard let newDesc = fontDescriptor.withSymbolicTraits(traits) else {
            return self
        }

        return UIFont(descriptor: newDesc, size: pointSize)
    }
    
}
