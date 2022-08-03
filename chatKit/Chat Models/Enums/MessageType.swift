//
//  MessageContentType.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/03.
//

import Foundation

/// ✉️ Conent Types Of The Messages.
/// Current Types Are:
/// 1. onlyText -  Consists of any type of characters, numbers, emojis and many more.
/// 2. onlyMedia  - Can be consists of a single or multiple media resources (Image and Video).
/// 3. mediaAndText - Contanis media and text, all together.
/// 4. audio - Contains Audio Recording
public enum MessageContentType: CaseIterable, Equatable, Hashable {
    case onlyText(text: String)
    case onlyMedia(media: MediaItem)
    case mediaAndText(text: String, media: MediaItem)
    case audio
    case emoji(text: String)

    // Mock Media Item
    static var mockMediaItem: MediaItem = .init(mediaType: .image, mediaURL: nil, thumbnailURL: nil, size: .zero)

    // MARK: - Case Iterable

    /// All Cases Of Message Content Types
    public static var allCases: [MessageContentType] = [.onlyText(text: ""), .onlyMedia(media: mockMediaItem), .mediaAndText(text: "", media: mockMediaItem), .audio, .emoji(text: "")]
}
