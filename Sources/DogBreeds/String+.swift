//
//  String+.swift
//  
//
//  Created by kwanghyun won on 2021/08/20.
//

import Foundation

extension String {
  var capitalizedFirstLetter: String {
      prefix(1).capitalized + dropFirst()
  }
}

//import NukeUI
//import SwiftUI
//
//extension NukeUI {
//  func header() -> some View {
//    GeometryReader { geometry in
//        resizable()
//            .placeholder {
//                ProgressView()
//                    .frame(height: 240)
//            }
//            .aspectRatio(contentMode: .fill)
//            .frame(width: geometry.size.width, height: 240)
//            .clipped()
//    }
//    .frame(height: 240)
//  }
//}
