import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_common_ffi.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // sqflite FFI 初始化（桌面端必须，移动端自动使用平台通道）
  if (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // 捕获 Flutter 框架渲染错误
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('=== Flutter Error ===\n${details.exceptionAsString()}');
  };

  // 捕获所有未处理的异步异常
  runZonedGuarded(() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    runApp(
      const ProviderScope(
        child: DIYDuolingoApp(),
      ),
    );
  }, (error, stack) {
    debugPrint('=== Zone Error ===\n$error\n$stack');
  });
}

class DIYDuolingoApp extends StatelessWidget {
  const DIYDuolingoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // widget 构建失败时显示错误信息，而不是灰色界面
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Material(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              '渲染错误:\n${details.exceptionAsString()}',
              style: const TextStyle(color: Colors.red, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    };

    return MaterialApp(
      title: '多多学',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainApp(),
    );
  }
}
