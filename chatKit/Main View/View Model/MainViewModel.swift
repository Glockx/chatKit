//
//  MainViewModel.swift
//  chatKit
//
//  Created by Nijat Muzaffarli on 2022/08/02.
//

import Combine
import Foundation

class MainViewModel {
    // MARK: - Variables

    // Cancellables
    var cancellables = Set<AnyCancellable>()

    // Parent Controller
    weak var parentController: MainViewController!

    // MARK: - INIT

    init() {
        // Bind Items
        bindItems()
    }

    // MARK: - Bind Items

    func bindItems() {}
}
