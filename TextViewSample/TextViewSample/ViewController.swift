//
//  ViewController.swift
//  TextViewSample
//
//  Created by 横山 祥平 on 2017/04/18.
//  Copyright © 2017年 Shohei Yokoyama. All rights reserved.
//

import UIKit

extension String {
    func nsRange(from range: Range<String.Index>) -> NSRange {
        let from = range.lowerBound.samePosition(in: utf16)
        let to = range.upperBound.samePosition(in: utf16)
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
                       length: utf16.distance(from: from, to: to))
    }
    
    mutating func dropTrailingNonAlphaNumericCharacters() {
        let nonAlphaNumericCharacters = NSCharacterSet.alphanumerics.inverted
        let characterArray = components(separatedBy: nonAlphaNumericCharacters)
        if let first = characterArray.first {
            self = first
        }
    }
}

// Linkable textview
//https://github.com/ThornTechPublic/SwiftTextViewHashtag
class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textView2: UITextView!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var textView3: UITextView!
    
    var lastTextViewHeight:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView2.delegate = self
        textView2.tag = 1
        
        highlightMention()
        
        
        let text = "change color test"
        let attributedString = NSMutableAttributedString(string: text)
        let range = NSRange(0..<5)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: range)
        textView3.attributedText = attributedString
    }

    func highlightMention(with symbol: String = "@") {
        
        // Separate the string into individual words.
        // Whitespace is used as the word boundary.
        // You might see word boundaries at special characters, like before a period.
        // But we need to be careful to retain the # or @ characters.
        let words = textView.text.components(separatedBy: .whitespacesAndNewlines)
        let attributedString = textView.attributedText.mutableCopy() as! NSMutableAttributedString
        
        // keep track of where we are as we interate through the string.
        // otherwise, a string like "#test #test" will only highlight the first one.
        var bookmark = textView.text.startIndex
        
        // Iterate over each word.
        // So far each word will look like:
        // - I
        // - visited
        // - #123abc.go!
        // The last word is a hashtag of #123abc
        // Use the following hashtag rules:
        // - Include the hashtag # in the URL
        // - Only include alphanumeric characters.  Special chars and anything after are chopped off.
        // - Hashtags can start with numbers.  But the whole thing can't be a number (#123abc is ok, #123 is not)
        for word in words {
            
            var scheme:String?
            
            if word.hasPrefix(symbol) {
                scheme = "mention"
            }
            
            // Drop the # or @
            var wordWithTagRemoved = String(word.characters.dropFirst())
            
            // Drop any trailing punctuation
            wordWithTagRemoved.dropTrailingNonAlphaNumericCharacters()
            
            // Make sure we still have a valid word (i.e. not just '#' or '@' by itself, not #100)
            guard let schemeMatch = scheme, Int(wordWithTagRemoved) == nil && !wordWithTagRemoved.isEmpty
                else { continue }
            
            let remainingRange = Range(bookmark..<textView.text.endIndex)
            
            // URL syntax is http://123abc
            
            // Replace custom scheme with something like hash://123abc
            // URLs actually don't need the forward slashes, so it becomes hash:123abc
            // Custom scheme for @mentions looks like mention:123abc
            // As with any URL, the string will have a blue color and is clickable
            
            if let matchRange = textView.text.range(of: word, options: .literal, range: remainingRange),
                let escapedString = wordWithTagRemoved.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed) {
                attributedString.addAttribute(NSLinkAttributeName, value: "\(schemeMatch):\(escapedString)", range: textView.text.nsRange(from: matchRange))
            }
            
            // just cycled through a word. Move the bookmark forward by the length of the word plus a space
            bookmark = textView.text.index(textView.text.startIndex, offsetBy: word.characters.count)
        }
        
        textView.attributedText = attributedString
    }
}

//MARK: - UITextViewDelegate
extension ViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme == "mention" {
            print("tapped linkable")
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard textView.tag == 1 else {
            return
        }
        
        let newSize: CGSize = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        // remember that new height
        let newHeight = newSize.height
        // change the height constraint only if it's different.
        // otherwise, it get set on every single character the user types.
        if lastTextViewHeight != newHeight {
            lastTextViewHeight = newHeight
            // the 7.0 is to account for the top of the text getting scrolled up slightly
            // to account for a potential new line
            textViewHeight.constant = newSize.height + 7.0
        }
        
    }
}




