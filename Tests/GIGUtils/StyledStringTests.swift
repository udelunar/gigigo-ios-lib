//
//  StyledStringTests.swift
//  GiGLibrary
//
//  Created by Sergio López on 2/8/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import XCTest
import GIGLibrary

class StyledStringTests: XCTestCase {
    
    var label = UILabel(frame: CGRectMake(0, 0, 0, 0))
    
    override func setUp() {
        super.setUp()
        
        self.label = UILabel(frame: CGRectMake(0, 0, 0, 0))
    }
    
    func test_applySyles_preservesText()
    {
        self.label.styledString = "texto".applyStyles(.Color(UIColor.redColor()))
        XCTAssert(self.label.attributedText?.string == "texto")
    }
    
    func test_applySyles_should_concatenate_text()
    {
        self.label.styledString = "texto" + " texto2" + " texto3".applyStyles(.Color(UIColor.redColor()))
        XCTAssert(self.label.attributedText?.string == "texto texto2 texto3")
    }
    
    func test_applySyles_shouldSetRedText() {
     
        self.label.styledString = "texto" + "rojo".applyStyles(.Color(UIColor.redColor()))
        
        let firstWordcolor = self.label.attributedText?.attribute(named:NSForegroundColorAttributeName, forText:"texto")
        let secondWordcolor = self.label.attributedText?.attribute(named:NSForegroundColorAttributeName, forText:"rojo") as! UIColor
        
        XCTAssert(firstWordcolor == nil)
        XCTAssert(secondWordcolor == UIColor.redColor())
    }
    
    func test_applySyles_shouldSetRedTextAndUnderlinedText() {
        
        self.label.styledString = "texto" + "subrayado".applyStyles(.Color(UIColor.redColor()), .Underline)
        
        let color = self.label.attributedText?.attribute(named: NSForegroundColorAttributeName, forText: "subrayado") as! UIColor
        let underlineStyle = self.label.attributedText?.attribute(named: NSUnderlineStyleAttributeName, forText: "subrayado")

        XCTAssert(color == UIColor.redColor())
        XCTAssert(underlineStyle != nil)
    }
    
    func test_applySyles_shouldSetBackgroundColor() {
        
        self.label.styledString = "texto" + "con background".applyStyles(.BackgroundColor(UIColor.redColor()))
        
        let backgroundColor = self.label.attributedText?.attribute(named: NSBackgroundColorAttributeName, forText: "con background") as! UIColor
        
        XCTAssert(backgroundColor == UIColor.redColor())
    }
    
    func test_applySyles_shouldSetRightFont() {
        
        let font = UIFont(name: "ChalkboardSE-Light", size: 15)!
        self.label.styledString = "texto" + "con background".applyStyles(.Font(font))
        
        let resultFont = self.label.attributedText?.attribute(named: NSFontAttributeName, forText: "con background") as! UIFont
        
        XCTAssert(resultFont == font)
    }
    
    func test_applySyles_shouldSetBoldColor() {
        
        self.label.styledString = "texto" + "con background".applyStyles(.Bold)
        
        let font = self.label.attributedText?.attribute(named: NSFontAttributeName, forText: "con background") as! UIFont
        
        XCTAssert(font.isBold() == true)
    }
    
    func test_fromHTML_returnTheRightString() {
        
        self.label.html = "texto <b>importante</b>"
        
        let font = self.label.attributedText?.attribute(named:NSFontAttributeName, forText: "importante") as! UIFont
        
        XCTAssert(font.isBold() == true)
    }
    
    func test_htmlLabel_preservesLabelColor() {

        self.label.textColor = UIColor.redColor()
        self.label.html = "texto <b>importante</b>"
        
        let color = self.label.attributedText?.attribute(named:NSForegroundColorAttributeName, forText: "importante") as! UIColor
        
        XCTAssert(color == UIColor.redColor())
    }
}

// MARK: Helpers

extension NSAttributedString {
    
    func attribute(named name: String, forText text: String) -> AnyObject? {
        
        let string = self.string
        let substringRangeOptional = string.rangeOfString(text)
        
        guard let substringRange = substringRangeOptional else { return nil }
        
        let start = string.startIndex.distanceTo(substringRange.startIndex)
        let length = substringRange.startIndex.distanceTo(substringRange.endIndex)
        
        var attributedRange = NSMakeRange(0, length-1)
        let attribute = self.attribute(name, atIndex: start, effectiveRange: &attributedRange)
        return attribute
    }
}

extension UIFont {
    
    func isBold() -> Bool {
        
        return ((self.fontDescriptor().symbolicTraits.rawValue & (UIFontDescriptorSymbolicTraits.TraitBold).rawValue) != 0)
    }
}
