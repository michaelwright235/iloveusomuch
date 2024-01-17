
# I &lt;U SO MUCH

**This project is not associated with Cassius band and doesn't distribute any copyrighted materials. You need to provide them yourself.**

Back in 2010 a french band **Cassius** released a song called **I &lt;U SO** (I Love U So) and an app imitating lip syncing. Check their [music video](https://www.youtube.com/watch?v=NazVKnD-_sQ) to see how it works.

**I &lt;U SO MUCH** is a modern remake of the original app. The original app is only available for older iPhones (running iOS 4.1-10.0). The project aims to resolve this issue and provide 2010s experience on modern iPhones/iPads running iOS 12+.

In order to run the app, please follow the next two sections.

## Preparing an .ipa file

Every iOS app is contained inside a special `.ipa` file. You need to "make" one to sideload (install) it onto your device. I can only publish such files without the original videos and graphics because it's copyrighted. **Therefore the app from *Releases* section won't work out of the box!** However it's pretty easy to inject those files yourself, here is a simple instruction!

### macOS & Linux

1. Create a temporary directory on your computer, let's call it `iloveusomuch` and locate it on your Desktop.
2. Open Terminal app.
3. If you created a directory with a path from the first step, run `cd ~/Desktop/iloveusomuch` command.
4. Run `sh -c "$(curl -sSL "https://raw.githubusercontent.com/michaelwright235/iloveusomuch/master/inject.sh")"` command.
5. Read an appeared message carefully. If you agree, type `y` and press Enter.
6. Downloading necessary files and injecting them may take a while.
7. After a successful injecting you can find an `iloveusomuch.ipa` file in a directory from the first step. This is a file you need to sideload onto your device.

### Manual/Windows

1. Download the latest `iloveusomuch.ipa` from *Releases* tab.
2. Download [an archived version](https://archive.org/download/i-3-u-so-com.julienadam.cassius-1.04/I-3-U-SO-com.julienadam.cassius-1.04.ipa") of the original app.
3. Change both files' extention to `.zip`.
4. Download the original app icon [here](https://web.archive.org/web/20240111215624if_/https://is4-ssl.mzstatic.com/image/thumb/Purple/2b/df/56/mzi.rptjtlhi.png/738x0w.png). Rename this file to `AppIcon.png`.
5. Open `I-3-U-SO-com.julienadam.cassius-1.04.zip` with your archiver. You need to extract these files:
   - Payload/Cassius.app/background.png
   - Payload/Cassius.app/loader@2x.png
   - Payload/Cassius.app/Loader.m4v
   - Payload/Cassius.app/Videos.m4v
6. Rename an extracted `loader@2x.png` file to `loader.png`.
7. Open `iloveusomuch.zip` with your archiver. Put previosly extracted files and `AppIcon.png` in a folder `Payload/iloveusomuch.app/` of this archive.
8. Rename `iloveusomuch.zip` back to `iloveusomuch.ipa`. This is a file you need to sideload onto your device.

## Sideloading

Sideloading an app onto iOS is a process of installing any app that comes not from the official App Store. iOS is infamous for how not easy it can be. Here's a list of options you can choose from:

1. [Sideloadly](https://sideloadly.io/)
2. [AltStore](https://altstore.io/)

## Compilation

In order to compile this app you need to have macOS and Xcode 12+ installed.

This project aims to support the vast majority of iOS versions that cannot run the original app natively. Even though the app only supports iOS 12+ (the latest Xcode doesn't allow to choose any lower version), it should be possible to compile it for iOS 11 if you use an older version of Xcode, because the app doesn't use any fancy features.

1. `git clone` this repository.
2. In terminal `cd` to the cloned directory.
3. Run `chmod +x ./inject.sh && ./inject.sh project`. This script automatically downloads [an archived version](https://archive.org/details/i-3-u-so-com.julienadam.cassius-1.04) of the original app and injects necessary files into the project.
4. Run `chmod +x ./build.sh && ./build.sh ipa`. It will result in a compiled `iloveusomuch.ipa` file in `build` directory. If you want an `.app` instead, drop `ipa` from the command.

## FAQ

**Q: Is Cassius associated with this project?**

**A:** No. This is a fan project. I'd appreciate if you support the band, their music is great!

**Q: Can I share an .ipa with injected files on the Internet?**

**A:** **You cannot!** This file now contains some copyrighted materials. Please, leave this app for personal use only.

**Q: Can I download this app from the App Store?**

**A:** Unfortunately, no. As I said before this app uses some copyrighted materials.

**Q: Does it run on iPads?**

**A:** It does! However, the main idea of showing lips right in front of your mouth doesn't quite work with iPads.

**Q: Is there an Android version of the app?**

**A:** Unfortunately, there isn't.

**Q: Why do the videos appear blurry/blocky?**

**A:** Since the original app is pretty old, it was meant to run on smaller iPhone screens (3G and 4 models at the time). The main video has a 1920x640 resolution, but every lip video is scaled down to 495x320. I can't do anything about it.

**Q: Is this a pixel perfect recreation of the original app?**

**A:** No, there are some things that I have changed to provide a better user experience.

1. New button graphics. I tried to make them look as similar as I could do. But there are some differences.
   - A slightly different font (a font under Open Font License).
   - *Play* button has a slightly different description.
   - *Share* button has a different icon (it was a Facebook logo previously). A description text has been slightly changed and pressing it opens a familiar iOS share screen where you can share a link of this project.
   - *Buy* button is replaced with a *Listen* button. Many things have changed since 2010, including an explosion of streaming services popularity. So I decided to implement a popup with links to popular streaming services instead.
2. No bottom copyright text.
3. A loading screen disappears with a pleasant animation.

**Q: Why can't I just install the original app?**

**A:** Apple stopped supporting 32-bit applications (which this app is) since iOS 11. It means that the original app can only be installed on an iPhone running iOS version from 4.1 (target version) to 10.0. Original developers never updated this app to mitigate this.

**Q: Why didn't you use some fancy framework like SwiftUI?**

**A:** The main goal of this project is to support as many iOS versions as possible. SwiftUI is supported only on iOS 13+. Plus the functionality of this app is pretty simple, and it all can be achieved using standard tools.

**Q: What files from the original app do this app need?**

**A:** Look at `iloveusomuch/originalAssets/readme.txt` file.

**Q: I've encountered an issue, how may I report it?**

**A:** Use GitHub's *Issues* tab to do this. I would appreciate any feedback!
