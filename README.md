# LXPlayerLive
一步步搭建视频直播系统，基于LFLiveKit＋ijkplayer＋rtmp（iOS端）


##本文主要使用的三个技术：
* 推流：LFLiveKit
* 播放：ijkplayer
* 服务器:nginx+rtmp+ffmpeg<br>
有了这三点技术就可以完成一个简约的直播系统。效果图如下（右边的是用模拟器设备运行播放的，中间的是用VLC播放器播放的，当前在用手机推流直播）。<br>

![效果图.gif](http://upload-images.jianshu.io/upload_images/301102-f17034a855973086.gif?imageMogr2/auto-orient/strip)

##一、推流
LFLiveKit：框架支持RTMP，由Adobe公司开发。github地址https://github.com/LaiFengiOS/LFLiveKit

LFLiveKit库里已经集成GPUImage框架用于美颜功能，GPUImage基于OpenGl开发，纯OC语言框架，封装好了各种滤镜同时也可以编写自定义的滤镜，其本身内置了多达125种常见的滤镜效果。
####1.将项目下载到本地。
####2.根据README.md文件集成，如下截图：
![screen1.png](http://upload-images.jianshu.io/upload_images/301102-1ad9999f78d7d3c6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

终端cd 到LFLiveKitDemo后，再输入vim Podfile后，文件直接自动补全如下
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios,'7.0'

target “LFLiveKitDemo” do
    pod 'LFLiveKit', :path => '../.'
end
```
注意：须将“LFLiveKitDemo”的中文引号改为英文引号。同时删掉, :path => '../.'

####3.运行LFLiveKitDemo。
1）会有如下报错代码，将其注释

```
videoConfiguration.outputImageOrientation = UIInterfaceOrientationLandscapeLeft;
videoConfiguration.autorotate = NO;
```
2）再次运行代码会有报错，修改后如下
```
            _videoCamera.outputImageOrientation = statusBar;
//            if (statusBar != UIInterfaceOrientationPortrait && statusBar != UIInterfaceOrientationPortraitUpsideDown) {
//                @throw [NSException exceptionWithName:@"当前设置方向出错" reason:@"LFLiveVideoConfiguration landscape error" userInfo:nil];
//            } else {
//            }
```
3）再次运行便可成功推流。

####4.百度里下载支持rtmp协议的视频播放器VLC，以确保我的直播已被推到服务器。
打开VLC，然后点击工具栏File - Open Network... ，然后输入的URL是LFLivePreview.m文件里stream.url值如下：
```
LFLiveStreamInfo *stream = [LFLiveStreamInfo new];
stream.url = @"rtmp://live.hkstv.hk.lxdns.com:1935/live/stream153";
[_self.session startLive:stream];
```
请注意这是LFLiveKit的公用服务器地址，别人也可以拉流获取看到你的直播。将在最后介绍在自己电脑中搭建自己的服务器，再也不怕被别人偷看了。

####5.将LFLiveKit集成到自己的项目
新建项目名为LXLiveDemo，将Podfile里填写为
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios,'7.0'

target "LXLiveDemo" do
    pod 'LFLiveKit'
end
```
将LFLivePreview、UIControl+YYAdd、UIView+Add这三个类的.h与.m文件拖入项目中，运行无误后做如下修改
1）改为竖屏直播，配置如下图
![screen3.png](http://upload-images.jianshu.io/upload_images/301102-482e32a21a8a2e0f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

2）注释掉ViewController.m里的代码
```
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskLandscape;
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
//    return YES;
//}
```
3）修改LFLivePreview.m的对应代码videoSize的值为
```
videoConfiguration.videoSize = CGSizeMake(360, 640);
```



##二、播放
ijkplayer：是基于FFmpeg的跨平台播放器框架，由B站开发。目前已被多个主流直播App集成使用。github地址：https://github.com/Bilibili/ijkplayer
若不愿运行源demo（配置时间较久），可以直接跳到第四步集成IJKMediaFramework库。
####1.查看README.md，找到Build iOS，如下截图：
![screen4.png](http://upload-images.jianshu.io/upload_images/301102-82620448cc082dc7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

####2.根据介绍进行终端命令行操作，截图如下：
![screen5.png](http://upload-images.jianshu.io/upload_images/301102-3428b8c1120b1d76.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

继续执行如下命令（时间稍长）
```
cd ios
./compile-ffmpeg.sh clean
./compile-ffmpeg.sh all
```

####3.运行IJKMediaDemo示例项目
成功后找到拉流的关键代码用于自己项目集成。在app界面上点击Online Samples，再点击任意一个cell即可播放。从而在demo中可追踪到IJKMoviePlayerViewController类，即是播放的类。

####4.在自己项目LXLiveDemo中使用IJKMediaFramework.framework库播放
按照如上的步骤便可集成好ijkplayer，但是下载ffmpeg与编译，执行脚本时间太长也麻烦，所以有大神将其集成为了一个IJKMediaFramework.framework库，直接添加即可使用，免去上面步骤中的麻烦。（下载地址忘记了，有Debug与Release版本）
1）注意：一定先把IJKMediaFramework.framework复制到项目文件夹中，别拖到项目中，然后在Build Phases -> Link Binary with Libraries -> Add这个位置添加IJKMediaFramework库
2）根据screen4.png截图中的提示，再添加相应的13个库。

####5.集成代码
实例demo中的播放界面用的mediaControl自己感觉很丑就不使用其相关代码了，将其余代码全部复制到自己项目的播放控制器中。集成的核心代码如下：

```objective-c
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    // [IJKFFMoviePlayerController checkIfPlayerVersionMatch:YES major:1 minor:0 micro:0];

    IJKFFOptions *options = [IJKFFOptions optionsByDefault];

    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.url withOptions:options];
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = self.view.bounds;
    self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
    self.player.shouldAutoplay = YES;

    self.view.autoresizesSubviews = YES;
    [self.view addSubview:self.player.view];
```
此处的self.url暂时还使用LFLiveKit的开发者提供的免费公用直播推流服务器地址（在播放时常常看到别的程序员的直播，偷笑）。




##三、服务器搭建
nginx+rtmp+ffmpeg：在本地搭建服务器，免去开通第三方直播的流量费用。
现在我们的项目中集成了推流的所用的LFLiveKit，播放所需的ijkplayer，便可用手机做推流直播，模拟器做拉流播放。

####1.安装Homebrew
因为安装nginx+rtmp+ ffmpeg需要Homebrew。使用命令man brew查看是否装有Homebrew，若没有自行再百度安装即可，我的由于之前装过ReactNative的环境需要Homebrew，因此会提示一个帮助信息（证明已经安装有了），然后输入Q即可退出。

####2.安装nginx
分别键入如下命令
```
brew tap homebrew/nginx
brew install nginx-full --with-rtmp-module
nginx
brew info nginx-full
```
此时在终点末尾查找nginx.conf文件的位置，如下图
![screen6.png](http://upload-images.jianshu.io/upload_images/301102-71fb86817a3055d0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
然后进入进入/usr/local/etc/nginx/nginx.conf文件里，在最后一行添加如下代码
```
rtmp {
    server {
        listen 1935;
        application rtmplive {
            live on;
            record off;
        }
    }
}
```

####3.重启nginx
nginx -v  查看版本号后再执行
```
/usr/local/Cellar/nginx-full/1.10.1/bin/nginx -s reload
```
将上面的1.10.1换成你刚才输出的版本号。

####4.安装ffmpeg
键入如下命令（时间较长）。
```
brew install ffmpeg
```

####5.到此已完成nginx的服务器搭建
可将项目中所用的推流与拉流的URL由rtmp://live.hkstv.hk.lxdns.com:1935/live/stream153换成rtmp://192.168.15.122:1935/rtmplive/room。
注意：
1.将192.168.15.122换成自己电脑的ip地址，端口号1935别改。
2.必须保证推流与拉流的设备与此电脑使用的是同一个局域网。


QQ:2239344645
源码请点击[github地址](https://github.com/SoftProgramLX/LXPlayerLive)下载。
---
（运行源码会报错，因缺少IJKMediaFramework库，文件太大不能上传到Github，请另外下载IJKMediaFramework按照上面的方法添加到我的demo中）
