//
//  OwnerDetailsModel.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/03.
//

import Foundation
import LoremSwiftum

/// Message Owner Details Model
public struct OwnerDetailsModel: Equatable, Hashable {
    /// The ID of the Owner
    var id: String

    /// Username of the owner
    var username: String

    /// Profile Image
    var profileImage: String? = "https://picsum.photos/seed/\(UUID().uuidString)/1000/1000"
}
