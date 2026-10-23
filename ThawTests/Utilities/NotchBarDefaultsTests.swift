//
//  NotchBarDefaultsTests.swift
//  Project: Thaw
//
//  Copyright (Thaw) © 2026 Toni Förster
//  Licensed under the GNU GPLv3

import Foundation
import Testing
@testable import Thaw

@MainActor
@Suite("NotchBar first launch defaults", .serialized)
struct NotchBarDefaultsTests {
    @Test("Fresh installs use an overflow grid without restarting other apps")
    func freshInstall() throws {
        try withScratchDefaults { store in
            try NotchBarDefaults.register(in: store)
            let data = try #require(store.data(forKey: Defaults.Key.globalDisplayConfiguration.rawValue))
            let config = try JSONDecoder().decode(DisplayIceBarConfiguration.self, from: data)
            #expect(config.useIceBar)
            #expect(config.iceBarLayout == .grid)
            #expect(config.gridColumns == 6)
            #expect(config.iceBarLocation == .rightAligned)
            #expect(config.itemSpacingOffset == 0)
            #expect(store.string(forKey: Defaults.Key.spacingApplyMode.rawValue) == "writeOnly")
            #expect(store.string(forKey: Defaults.Key.newItemsSection.rawValue) == "visible")
            #expect(!store.bool(forKey: "SUEnableAutomaticChecks"))
            #expect(!store.bool(forKey: "SUAutomaticallyUpdate"))
        }
    }

    @Test("Saved preferences and cleared shortcuts survive repeated launches")
    func savedChoicesWin() throws {
        try withScratchDefaults { store in
            let saved = try JSONEncoder().encode(DisplayIceBarConfiguration.defaultConfiguration)
            store.set(saved, forKey: Defaults.Key.globalDisplayConfiguration.rawValue)
            store.set([String: Data](), forKey: Defaults.Key.hotkeys.rawValue)
            store.set(false, forKey: Defaults.Key.hideDockIconWhenToggling.rawValue)
            try NotchBarDefaults.register(in: store)
            try NotchBarDefaults.register(in: store)
            #expect(store.data(forKey: Defaults.Key.globalDisplayConfiguration.rawValue) == saved)
            #expect(store.dictionary(forKey: Defaults.Key.hotkeys.rawValue)?.isEmpty == true)
            #expect(!store.bool(forKey: Defaults.Key.hideDockIconWhenToggling.rawValue))
        }
    }

    @Test("Default shortcuts load through the real hotkey settings model")
    func shortcutsLoad() throws {
        try withScratchDefaults { store in
            try NotchBarDefaults.register(in: store)
            let settings = HotkeysSettings()
            #expect(settings.hotkey(withAction: .toggleHiddenSection)?.keyCombination ==
                KeyCombination(key: .b, modifiers: [.control, .option]))
            #expect(settings.hotkey(withAction: .searchMenuBarItems)?.keyCombination ==
                KeyCombination(key: .f, modifiers: [.control, .option]))
        }
    }

    @Test("Local builds open their fork instead of running the upstream updater")
    func localUpdates() {
        let manager = UpdatesManager()
        var opened: [URL] = []
        manager.openURL = { opened.append($0) }
        #expect(!manager.supportsAutomaticUpdates)
        manager.startUpdaterIfNeeded()
        manager.checkForUpdates()
        manager.checkForBetaUpdateAfterCompatibilityWarning()
        #expect(opened == [Constants.repositoryURL, Constants.repositoryURL])
    }
}
