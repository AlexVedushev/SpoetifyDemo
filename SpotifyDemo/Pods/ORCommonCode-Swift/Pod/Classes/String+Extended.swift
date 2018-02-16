//
//  String+Extended.swift
//  Pods
//
//  Created by Maxim Soloviev on 11/04/16.
//
//

import Foundation

extension String {
    
    public var or_length: Int {
        get {
            return self.characters.count
        }
    }
    
    public func or_estimatedSize(font: UIFont,
                                 maxWidth: CGFloat = CGFloat.greatestFiniteMagnitude,
                                 maxHeight: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGSize {
        let fontAttributes: [String : AnyObject] = [NSFontAttributeName : font]
        let maxSize: CGSize = CGSize(width: maxWidth, height: maxHeight)
        let boundingRect: CGRect = self.boundingRect(with: maxSize,
                                                     options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                     attributes: fontAttributes,
                                                     context: nil)
        
        return boundingRect.size
    }
    
    public static func or_uniqueString() -> String {
        let uuid: String = UUID().uuidString;
        
        return uuid.trimmingCharacters(in: CharacterSet(charactersIn: "-"));
    }
    
    public static func or_localized(_ keyStr: String) -> String {
        return NSLocalizedString(keyStr, comment: "")
    }
    
    public func or_isFileURL() -> Bool {
        return self.or_matchesForRegexInText("^file:///").count > 0
    }
    
    public func or_repeatingString(_ n:Int) -> String {
        if (n < 1) {
            return ""
        }
        
        var result = self
        for _ in 1 ..< n {
            result.append(self)
        }
        return result
    }
    
    public mutating func or_appendToChain(_ other: String?, separator: String = " ") {
        guard let strToAdd = other else { return }
        self = (self.or_length > 0) ? "\(self)\(separator)\(strToAdd)" : strToAdd
    }
    
    public func or_matchesForRegexInText(_ regex: String!) -> [NSTextCheckingResult] {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = self as NSString
            let results = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
            return results
        } catch let error as NSError {
            print("Invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    public func or_withoutFirstAndLastChars() -> String {
        let result = String(self.characters.dropFirst().dropLast())
        return result
    }
    
    public func or_substring(range: NSRange) -> String {
        let startIndex = self.characters.index(self.startIndex, offsetBy: range.location)
        let endIndex = self.characters.index(self.startIndex, offsetBy: range.length)
        let substringRange = startIndex ..< endIndex
        
        let result = self.substring(with: substringRange)
        return result
    }

    public func or_withHttpIfNeeded() -> String {
        if self.hasPrefix("http://") || self.hasPrefix("https://") {
            return self
        } else {
            return "http://" + self
        }
    }
    
    public func or_stringByAppendingString(_ str: String, withSeparatorIfNeeded sep: String) -> String {
        return self.isEmpty ? str : self + sep + str
    }
    
    public func or_phoneSymbolsOnlyString() -> String {
        var validationString = ""
        
        for char in self.characters {
            switch char {
            case "0","1","2","3","4","5","6","7","8","9","-","+","(",")":
                validationString.append(char)
            default:
                continue
            }
        }
        return validationString
    }
}
