//
//  String.swift
//  RealMe
//
//  Created by 임우섭 on 2023/05/10.
//

import Foundation
 
extension String {
  var localized: String {
    return NSLocalizedString(self, comment: "")
  }
}
