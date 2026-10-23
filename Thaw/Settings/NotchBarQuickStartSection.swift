//
//  NotchBarQuickStartSection.swift
//  Project: Thaw
//
//  Copyright (Thaw) © 2026 Toni Förster
//  Licensed under the GNU GPLv3

import SwiftUI

struct NotchBarQuickStartSection: View {
    let navigationState: AppNavigationState
    let hotkeys: HotkeysSettings

    var body: some View {
        IceSection {
            Label("NotchBar · 让图标避开刘海", systemImage: "menubar.rectangle")
        } content: {
            Text("将不常用的图标拖到「隐藏」分区，点击菜单栏图标即可在刘海下方展开。常用图标留在「可见」分区。")
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                navigationButton("整理图标", destination: .menuBarLayout)
                navigationButton("面板与显示器", destination: .displays)
                navigationButton("修改快捷键", destination: .hotkeys)
                Spacer()
            }
            HStack(spacing: 20) {
                shortcut("展开 / 收起", action: .toggleHiddenSection)
                shortcut("搜索图标", action: .searchMenuBarItems)
            }
            .font(.callout)
            .foregroundStyle(.secondary)
        } footer: {
            Text("辅助功能权限用于移动和点击图标；屏幕录制权限用于显示真实图标预览。面板样式与快捷键都可以修改。")
        }
    }

    private func navigationButton(_ title: String, destination: SettingsNavigationIdentifier) -> some View {
        Button(title) {
            navigationState.settingsNavigationIdentifier = destination
        }
    }

    private func shortcut(_ title: String, action: HotkeyAction) -> some View {
        let binding = hotkeys.hotkey(withAction: action)?.keyCombination?.displayValue ?? "未设置"
        return Text("\(title)：\(binding)")
    }
}
