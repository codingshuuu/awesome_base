## 为了更好的创建项目，这里提供了一个基础的依赖

## Getting started
- 创建项目 
- 主要框架：provider数据共享、Getx路由管理、dio网络请求、flutter_screenutil屏幕适配、eventbus事件传递
- 引入 awesome_ext 扩展包
## content

- 防止刷机
- 

## 接入项目
1、创建项目
- 项目中引入 awesome_base 扩展包
```dart
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return App(
        initialRoute: AppPages.initial,
        fallbackLocale: TranslationService.fallbackLocale,
        getPages: AppPages.routes,
        providers: providers,
    );
  }
}
```
