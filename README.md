![demo2](https://cloud.githubusercontent.com/assets/5022872/7852211/71f4ac66-052c-11e5-868a-b98b34867a06.png)
![file4](https://cloud.githubusercontent.com/assets/5022872/9400930/482426f8-47fa-11e5-9cad-4763975802a1.png)
![file5](https://cloud.githubusercontent.com/assets/5022872/9400936/58faf380-47fa-11e5-944b-8d9065366b61.png)
![file2](https://cloud.githubusercontent.com/assets/5022872/9401070/2d2737a8-47fc-11e5-852f-7cd44603d5eb.png)
![file3](https://cloud.githubusercontent.com/assets/5022872/9401080/4fe8a268-47fc-11e5-8486-752060611320.png)
![file1](https://cloud.githubusercontent.com/assets/5022872/9401084/59601560-47fc-11e5-8b38-cc09a3584b70.png)

## 介绍
这个示例项目是为了帮助使用 LeanCloud 的开发者, 尽快的熟悉和使用SDK而建立的。主要展示 LeanCloud SDK的各种基础和高级用法。可喜的是，该示例项目用 Swift 2 重写了一遍，放在了 LeanStorageDemoSwift 项目下，将展示如何在 Swift 中优雅地使用 LeanCloud SDK。

## 如何运行

```
 	// Objective-C 
 	cd LeanStorageDemoObjc
    # 如果提示找不到库，则可去掉 --no-repo-update
    pod install --verbose --no-repo-update 
    open LeanStorageDemo.xcworkspace
   
    // Swift
    cd LeanStorageDemoSwift
    pod install --verbose --no-repo-update
    open LeanStorageDemoSwift.xcworkspace
```

 `AVOSCloud.framework` 静态库支持 iOS6 以上的设备上，Demo 也是使用的静态库， Demo 中设置的默认运行设备是 iOS7 以上，如果要在 iOS6 的设备上运行，只需修改 Xcode 里的 `Deployment Target` 为 iOS6 即可。另外注意，因为动态库只支持 iOS8 以上的设备，如果使用了 `AVOSCloud.framework` 动态库， `Deployment Target` 必须为 iOS8 以上 。

## 使用说明

### 登录后台查看数据

用 账号/密码 (leancloud@163.com/Public123) 登录 https://leancloud.cn ，选择应用 `LeanStorage-Demo` ，即可查看后台数据。强烈建议你边查看后台边运行 Demo。当在 Demo 运行代码来增删改查时，就可以在后台看到相应的数据变化。

![image](https://cloud.githubusercontent.com/assets/5022872/7763947/3b25548e-007b-11e5-9a1b-af3ca1806175.png)


### 编译警告
代码中有一些人为添加的编译,是为了引起您足够的重视, 如果觉得没问题可以删除掉该行

### 添加Demo

1. 新建一个继承`Demo`的类, 文件位置在项目的`LeanStorageDemo`文件夹
2. 在.m里的`@end`前加一句`MakeSourcePath` 用来在编译时生成返回这个文件的方法
3. 加一个demo方法. 方法必须以demo开头, 且必须是严格按照骆驼命名法, 否则方法名显示可能会有问题

----
## 其他

如果您在使用 LeanStorage SDK中, 有自己独特高效的用法, 非常欢迎您fork 并提交pull request, 帮助其他开发者更好的使用SDK. 我们将在本项目的贡献者中, 加入您的名字和联系方式(如果您同意的话)
