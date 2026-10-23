# 开源菜单栏管理工具调研

核验日期：2026-10-24。设备实测：Apple M4 Max、arm64、macOS 26.3。以下数据来自各项目 GitHub API、仓库说明与官方发布页，星标数是当次快照。

| 项目 | GitHub 星标 | 最近稳定版 | 判断 |
| --- | ---: | --- | --- |
| [Ice](https://github.com/jordanbaird/Ice) | 29,857 | 0.11.12，2024-10-29 | 这份候选清单里社区规模最大，具有独立 Ice Bar；稳定版发布较早，当前系统适配需要区分开发分支。 |
| [Hidden Bar](https://github.com/dwarvesf/hidden) | 15,250 | v1.11.1，2026-09-18 | MIT、轻量，主要通过分隔项折叠菜单栏；不提供同类独立图标面板，展开空间仍受刘海限制。 |
| [Thaw](https://github.com/thaw-app/Thaw) | 12,259 | 2.1.0，2026-10-14 | Ice 的活跃衍生项目，独立面板、搜索、分组、多屏与配置方案齐全；2.1.0 明确面向 macOS 26，适合作为本机基线。 |
| [Dozer](https://github.com/Mortennn/Dozer) | 8,719 | v4.0.0，2019-08-20 | 极简折叠工具，最新仓库推送停在 2023 年，不作为新系统定制基线。 |
| [SaneBar](https://github.com/sane-apps/SaneBar) | 328 | v2.1.90，2026-08-22 | MIT、独立面板等功能较丰富，但社区规模明显小于前几项。 |
| [IceMelt](https://github.com/pnikolaidis/icemelt) | 38 | v2026.4.0，2026-10-06 | 另一条 macOS 26+ 的 Ice 衍生线，仍属较小社区。 |
| [holzBar](https://github.com/holzcloud/holzBar) | 8 | API 无 latest 稳定发布 | 新分支，功能描述丰富，部分功能在官方 README 中仍标注 Preview，优先级低于 Thaw。 |

## 选择理由

本任务的关键是访问被刘海遮挡的图标，而不仅是把图标暂时收起。独立面板把图标绘制到菜单栏下方，避免重新展开时再次受菜单栏可用宽度限制。Thaw 官方资料明确支持这种用法。

选择 Thaw 2.1.0 的依据是功能匹配、近期维护和当前 macOS 26 的稳定版本定位；这不是对所有产品进行过完整性能测试后的绝对排名。没有采用 Thaw 3 测试版，因为它要求 macOS 27。

来源：[Thaw 官方网站](https://www.getthaw.app/)、[2.1.0 发布说明](https://github.com/thaw-app/Thaw/releases/tag/2.1.0)、[Hidden Bar 使用说明](https://github.com/dwarvesf/hidden/blob/develop/README.md)，以及上表每个仓库的元数据和 releases/latest API。

## 实现基线

- 上游：`thaw-app/Thaw`
- 标签：`2.1.0`
- Commit：`c5ec1337b684d185b3cb3e7f3b75358ec036c412`
- Fork：`carlislelym/NotchBar`
- 工作分支：`notchbar/m4-notch`
- 授权：GPL-3.0，保留上游 LICENSE 与版权说明。

项目核心依赖 macOS 菜单栏、辅助功能、屏幕捕获与部分私有接口。后续升级 macOS 大版本时需要重新验证，不把 M4 的芯片兼容性等同于未来所有 macOS 的兼容性。
