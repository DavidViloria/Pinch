//
//  PageModel.swift
//  Pinch
//
//  Created by David Viloria Ortega on 22/09/24.
//

import Foundation


struct Page: Identifiable {
    let id: Int
    let imageName: String
}

extension Page{
    var thumbnailName: String{
        return "thumb-" + imageName
    }
}
