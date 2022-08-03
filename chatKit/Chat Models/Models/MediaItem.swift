//
//  MediaItem.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/03.
//

import Foundation
import UIKit

/// A model used to represent the data for a media message.
public struct MediaItem: Hashable, Equatable {
    /// Media Type
    var mediaType: MediaType

    /// The url where the media is located.
    var mediaURL: URL?

    /// A placeholder image for when the image is obtained asynchronously.
    var thumbnailURL: URL?

    /// The size of the media item.
    var size: CGSize
}
