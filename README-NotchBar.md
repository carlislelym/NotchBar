# NotchBar

为刘海屏 Mac 定制的原生菜单栏管理工具，基于 [Thaw 2.1.0](https://github.com/thaw-app/Thaw/releases/tag/2.1.0)，继承 Ice 的开源实现。支持 macOS 26，当前本地构建面向 Apple Silicon。

## 使用

打开 `~/Applications/NotchBar.app`，完成引导。系统会要求你亲自允许：

- **辅助功能**：移动和点击菜单栏图标。
- **屏幕与系统音频录制**：读取菜单栏图标图像，用于独立面板、搜索和布局预览。缺少此权限可以使用部分隐藏功能，但不能完整验证图标面板。

进入设置里的中文快速入口 **整理图标**，将不常用的图标拖到 Hidden / 隐藏分区，常用图标留在 Visible / 可见分区。

- `⌃⌥B`：展开 / 收起隐藏图标。
- `⌃⌥F`：搜索菜单栏图标。
- 点击菜单栏 NotchBar 图标：打开隐藏区。
- **面板与显示器**：调整独立面板的位置、布局和每屏设置。
- **修改快捷键**：处理与其他应用冲突的快捷键，也可以清空绑定。

首次启动默认使用菜单栏下方、靠右的六列网格，图标较多时不必挤回刘海旁边。新出现的图标保持可见，隐藏哪些图标由你决定。自动收起沿用上游设置。登录时启动可在设置中开启。

## 本分支修改

- 独立应用名称、标识 `dev.carlisle.NotchBar`、XPC 服务标识和 `notchbar://` URL scheme。
- 用注册默认值提供初始配置，用户保存的选择优先；清空快捷键后重启不会重新绑定。
- 中文快速入口复用上游布局、显示器和快捷键页面，快捷键提示显示实际绑定。
- 默认不因间距变化重启其他应用；不启动上游自动更新器，手动更新入口打开本 fork。
- 保留上游分组、搜索、配置方案、多屏管理、权限引导和 GPL-3.0 授权。

这是个人定制分支，不是 Thaw 官方发行版。原作者的版权、署名与许可证保留在源文件及 LICENSE 中。应用中部分文字、图标和界面沿用 Thaw。

## 构建与安装

需要 Xcode 26.3 或更新版本。本机验证环境是 Xcode 26.6、macOS 26.3、M4 Max。

```sh
git clone --branch notchbar/m4-notch https://github.com/carlislelym/NotchBar.git
cd NotchBar
xcodebuild -resolvePackageDependencies -project Thaw.xcodeproj -scheme Thaw -clonedSourcePackagesDirPath build/SourcePackages
scripts/build-notchbar.sh --install
open "$HOME/Applications/NotchBar.app"
```

构建产物位于 `build/DerivedData/Build/Products/Release/NotchBar.app`。构建脚本使用本地临时签名，不需要 Apple Developer 付费账号；它不具备官方发行版的 Developer ID 公证。再次构建后 macOS 可能要求重新授权。

安装脚本不会结束正在运行的应用；先从 NotchBar 菜单退出再安装。已有安装会备份到 `build/NotchBar-backup-时间.app`。

卸载时先从菜单退出，让上游退出流程恢复隐藏图标，再将 `~/Applications/NotchBar.app` 移入废纸篓。不要同时运行多个菜单栏管理器。

## 验证

回归检查使用临时偏好设置，不重置用户权限或布局。测试宿主使用项目已有的预览开关，跳过菜单栏运行逻辑。新增测试覆盖默认面板、用户设置优先、清空快捷键的持久性，以及本地版更新路径。

上游 CI 固定使用 SwiftLint 0.63.3；更高版本会对上游现有代码报新的规则错误，不能混用规则结果。具体执行结果见 `docs/NOTCHBAR-VALIDATION.md`，调研见 `docs/NOTCHBAR-RESEARCH.md`。
