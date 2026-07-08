# 开发工作流 — 多多学 Duoduo Learn

## 复刻指引

以下步骤让任何人 fork 后都能跑通完整的 CI/CD 管道。

### 1. 前置条件

| 工具 | 用途 | 备注 |
|------|------|------|
| Flutter SDK ≥3.5 | 编译运行 | `flutter --version` 确认 |
| JDK 17+ | Android 构建 | `JAVA_HOME` 必须指向 JDK 17 |
| Visual Studio 2022 (Windows) | Windows 桌面构建 | 需勾选"使用 C++ 的桌面开发" |
| Xcode 15+ (macOS) | macOS 桌面构建 | 需在 macOS 机器上 |

### 2. 本地开发

```bash
git clone <你的 fork 地址>
cd duoduo-learn
flutter pub get
flutter run              # 自动选择已连接设备
flutter run -d windows   # Windows 桌面
flutter run -d macos     # macOS 桌面
```

### 3. 桌面端关键配置

sqflite 在移动端通过平台通道调用原生 SQLite，桌面端没有此通道，需用 `sqflite_common_ffi` 通过 FFI 加载 SQLite。

**`lib/main.dart`** 中 `main()` 开头已添加：

```dart
if (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}
```

> ⚠️ 如果 fork 后新增了数据库操作，**不要移除这段代码**，否则桌面端会报 `databaseFactory not initialized`。

### 4. CI/CD 管道

文件：`.github/workflows/build.yml`

| Job | 运行环境 | 触发条件 | 说明 |
|-----|---------|---------|------|
| `check` | ubuntu-latest | push + PR + manual | `flutter analyze` + `flutter test` |
| `build` | windows-latest / macos-latest (矩阵) | push to main | 构建桌面安装包 |
| `release` | ubuntu-latest | push to main | 打包上传 GitHub Releases |

**触发方式：**
- 自动：push 到 `main` 分支
- 手动：GitHub → Actions → Build Desktop → Run workflow

### 5. 发布产物

每次 push 到 `main` 成功后自动创建 Release：

- tag 格式：`v1.0.<run_number>`
- 下载地址：GitHub 仓库 → Releases 页面
- 包含两个 zip：Windows 安装包、macOS 安装包

### 6. 常见问题

**Q: `databaseFactory not initialized`**
→ 桌面端未执行 FFI 初始化，检查 `main.dart` 中的 `sqfliteFfiInit()` 调用。

**Q: `receive_sharing_intent` 编译报错**
→ 该包仅支持移动端（Android/iOS），桌面端已通过平台 guard 跳过。

**Q: `flutter analyze` 报 `info` 级别警告**
→ CI 使用 `--no-fatal-infos`，info 不会导致失败。

**Q: 本地没有 Flutter 环境可以构建吗？**
→ 可以。push 到 GitHub 后 CI 自动构建，从 Releases 下载即可。

---

*此文件描述的是项目当前的开发工作流，如需修改流程请同步更新。*
