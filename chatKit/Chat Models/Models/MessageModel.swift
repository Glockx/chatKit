//
//  MessageModel.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/03.
//

import Foundation

/// The Main Message Model Of The Chatting System.
///  The Structure Of The Message Model:
///  1. id: The Identifier Of The Message
///  2. owner: The Owner Of The Message.
///  3. messageType: Message Type Of Chat Content
///  4. creationDate: Creation Date Of The Message
///  5. updaetDate: Last Update Date Of The Message (Optional)
 struct MessageModel: Hashable, Equatable, Identifiable {
    /// The Identifier Of The Message
    public var id: String

    ///  The Owner Of The Message
    public var owner: MessageOwner

    /// Message Type Of Chat Content
    public var messageType: MessageContentType

    /// Creation Date Of The Message
    public var creationDate: TimeInterval

    /// Last Update Date Of The Message (Optional)
    public var updateDate: TimeInterval?
}
