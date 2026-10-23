//
//  NotchBarDefaults.swift
//  Project: Thaw
//
//  Copyright (Thaw) © 2026 Toni Förster
//  Licensed under the GNU GPLv3

import Foundation

enum NotchBarDefaults {
    static func register(in store: UserDefaults) throws {
        let encoder = JSONEncoder()
        let display = DisplayIceBarConfiguration.defaultConfiguration
            .withUseIceBar(true)
            .withIceBarLocation(.rightAligned)
            .withIceBarLayout(.grid)
            .withGridColumns(6)
        let hotkeys = try [
            HotkeyAction.toggleHiddenSection.rawValue:
                encoder.encode(KeyCombination(key: .b, modifiers: [.control, .option])),
            HotkeyAction.searchMenuBarItems.rawValue:
                encoder.encode(KeyCombination(key: .f, modifiers: [.control, .option])),
        ]

        // Registration supplies fallbacks without overwriting saved choices.
        try store.register(defaults: [
            Defaults.Key.globalDisplayConfiguration.rawValue: encoder.encode(display),
            Defaults.Key.hasMigratedPerDisplayIceBar.rawValue: true,
            Defaults.Key.hideDockIconWhenToggling.rawValue: true,
            Defaults.Key.newItemsSection.rawValue: "visible",
            Defaults.Key.spacingApplyMode.rawValue: SpacingApplyMode.writeOnly.rawValue,
            Defaults.Key.hotkeys.rawValue: hotkeys,
            Defaults.Key.hasSeenUpdateConsent.rawValue: true,
            "SUEnableAutomaticChecks": false,
            "SUAutomaticallyUpdate": false,
        ])
    }
}
