//
//  Decorations.swift
//  MCatalog
//
//  Created by Eugene on 4/4/19.
//  Copyright © 2019 Eugene. All rights reserved.
//

import Foundation
import UIKit

class Decorations {
    static let shared = Decorations()
    private init() {}

    func highlightText(searchStr: String, text: String) -> NSAttributedString {
        let attrString: NSMutableAttributedString = NSMutableAttributedString(string: text)

        let range: NSRange = (text as NSString).range(of: searchStr, options: NSString.CompareOptions.caseInsensitive)
        attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
        attrString.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.yellow, range: range)

        return attrString
    }

    func viewWithBG() -> UIView {
//        set selected background for cell
        let view = UIView()
        view.backgroundColor = UIColor(named: "bgColorLight")
        return view
    }
}
