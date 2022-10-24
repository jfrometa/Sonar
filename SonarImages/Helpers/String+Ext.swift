//
//  String+Ext.swift
//  SonarImages
//
//  Created by Jose Frometa on 21/10/22.
//

import UIKit

extension String {
    func formatText(_ size: CGFloat = 22, _ color: UIColor = .lightGray) -> NSMutableAttributedString {
        NSMutableAttributedString(string: self, attributes: [.font: UIFont.systemFont(ofSize:  size),
                                                             .foregroundColor: color])
    }
    
    func font26(_ color: UIColor = UIColor.black) -> NSMutableAttributedString {
        NSMutableAttributedString(string: self, attributes: [.font: UIFont.boldSystemFont(ofSize: 26),
                                                             .foregroundColor: color])
    }
    
    func font20(_ color: UIColor = UIColor.black) -> NSMutableAttributedString {
        NSMutableAttributedString(string: self, attributes: [.font:UIFont.systemFont(ofSize: 20),
                                                             .foregroundColor: color])
    }
    
    func font16(_ color: UIColor = UIColor.black) -> NSMutableAttributedString {
        NSMutableAttributedString(string: self, attributes: [.font: UIFont.systemFont(ofSize: 16),
                                                             .foregroundColor: color])
    }
    
    func font12(_ color: UIColor = UIColor.black) -> NSMutableAttributedString {
        NSMutableAttributedString(string: self, attributes: [.font: UIFont.systemFont(ofSize: 12),
                                                             .foregroundColor: color])
    }

}
