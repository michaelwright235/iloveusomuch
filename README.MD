
# I &lt;U SO MUCH

**This project is not associated with Cassius band and doesn't distribute any copyrighted materials. You need to provide them yourself.**

Back in 2010 the french band **Cassius** released a song called **I &lt;U SO** (I Love U So) and an app that simulated lip-syncing. Check their [music video](https://www.youtube.com/watch?v=NazVKnD-_sQ) to see how it works.

**I &lt;U SO MUCH** is a modern remake of the original app. The original app is only available on older iPhones running iOS 4.1–10.0. The project aims to solve this issue and bring 2010s experience to modern iPhones/iPads running iOS 12+.

In order to run the app, please follow the next two sections.

## Preparing an .ipa file

Every iOS app is packaged in a `.ipa` file. You need to prepare one to sideload (install) it onto your device. I can only distribute these files without the original videos and graphics because they are copyrighted. **Therefore the app from *Releases* section won't work out of the box!** However, it's pretty easy to add those files yourself. Here's a simple guide!

### macOS & Linux

1. Create a temporary directory on your computer, let's call it `iloveusomuch` and locate it on your Desktop.
2. Open the Terminal app.
3. If you created a directory with a path from the first step, run `cd ~/Desktop/iloveusomuch` command.
4. Run `sh -c "$(curl -sSL "https://raw.githubusercontent.com/michaelwright235/iloveusomuch/master/inject.sh")"` command.
5. Read the displayed message carefully. If you agree, type `y` and press Enter.
6. Downloading necessary files and injecting them may take a while.
7. After the injection process is complete, you'll find the `iloveusomuch.ipa` file in the directory you created in the first step. This is a file you need to sideload onto your device.

### Manual & Windows

1. Download the latest `iloveusomuch.ipa` from the *Releases* tab.
2. Download [an archived version](https://archive.org/download/i-3-u-so-com.julienadam.cassius-1.04/I-3-U-SO-com.julienadam.cassius-1.04.ipa) of the original app.
3. Change the extension of both files to `.zip`.
4. Download the original app icon [here](https://web.archive.org/web/20240111215624if_/https://is4-ssl.mzstatic.com/image/thumb/Purple/2b/df/56/mzi.rptjtlhi.png/738x0w.png). Rename this file to `AppIcon.png`.
5. Open `I-3-U-SO-com.julienadam.cassius-1.04.zip` with your archiver. You need to extract these files:
   - `Payload/Cassius.app/background.png`
   - `Payload/Cassius.app/loader@2x.png`
   - `Payload/Cassius.app/Loader.m4v`
   - `Payload/Cassius.app/Videos.m4v`
6. Rename the extracted `loader@2x.png` file to `loader.png`.
7. Open `iloveusomuch.zip` with your archiver. Place the previously extracted files and `AppIcon.png` into the folder `Payload/iloveusomuch.app/` of this archive.
8. Rename `iloveusomuch.zip` back to `iloveusomuch.ipa`. This is a file you need to sideload onto your device.

## Sideloading

Sideloading on iOS is the process of installing an app that does not come from the official App Store. iOS is infamous for how difficult it can be. Here's a list of options you can choose from:

1. [Sideloadly](https://sideloadly.io/)
2. [AltStore](https://altstore.io/)

## Compilation

In order to compile this app you need to have macOS and Xcode 12+ installed.

This project aims to support the vast majority of iOS versions that cannot run the original app natively. Even though the app officially supports iOS 12+ (the latest versions of Xcode don't allow selecting a lower deployment target), it should be possible to compile it for iOS 11 if you use an older version of Xcode, because the app doesn't use any fancy features.

1. `git clone` this repository.
2. In terminal `cd` to the cloned directory.
3. Run `chmod +x ./inject.sh && ./inject.sh project`. This script automatically downloads [an archived version](https://archive.org/details/i-3-u-so-com.julienadam.cassius-1.04) of the original app and injects necessary files into the project.
4. Run `chmod +x ./build.sh && ./build.sh ipa`. This will generate a compiled `iloveusomuch.ipa` file in the `build` directory. If you want an `.app` instead, drop `ipa` from the command.

## FAQ

**Q: Is Cassius associated with this project?**

**A:** No. This is a fan project. I'd appreciate it if you supported the band, their music is great!

**Q: Can I share an .ipa with injected files on the Internet?**

**A:** **You cannot!** This file now contains some copyrighted materials. Please, leave this app for personal use only.

**Q: Can I download this app from the App Store?**

**A:** Unfortunately, no. As mentioned earlier, this app uses copyrighted materials.

**Q: Does it run on iPads?**

**A:** It does! However, the main concept of displaying lips directly in front of your mouth doesn't work quite as well on iPads.

**Q: Is there an Android version of the app?**

**A:** Unfortunately, there isn't.

**Q: Why do the videos appear blurry/blocky?**

**A:** Since the original app is pretty old, it was meant to run on smaller iPhone screens (3G and 4 models at the time). The main video has a resolution of 1920×640, but all lip videos are only 495×320. I can't do anything about it.

**Q: Is this a pixel perfect recreation of the original app?**

**A:** No, there are some things that I have changed to provide a better user experience.

1. New button graphics. I tried to make them look as close to the originals as possible. But there are some differences.
   - A slightly different font (a font under Open Font License).
   - The *Play* button has a slightly different description.
   - The *Share* button has a different icon (it was a Facebook logo previously). The description text has been slightly modified and pressing it opens a familiar iOS share screen where you can share a link of this project.
   - The *Buy* button is replaced with the *Listen* button. Many things have changed since 2010, including the explosion in popularity of streaming services. So I decided to implement a popup with links to popular streaming services instead.
2. No bottom copyright text.
3. A loading screen disappears with a pleasant animation.

**Q: Why can't I just install the original app?**

**A:** Apple has not supported 32-bit applications (which the original app is) since iOS 11. This means that the original app can only be installed on iPhones running iOS 4.1 through 10.0. Original developers never updated this app to mitigate this.

**Q: Why didn't you use some fancy framework like SwiftUI?**

**A:** The main goal of this project is to support as many iOS versions as possible. SwiftUI is only available on iOS 13 and later. Plus the functionality of this app is pretty simple, and it all can be achieved using standard tools.

**Q: Which files from the original app does this project require?**

**A:** See `iloveusomuch/originalAssets/readme.txt`.

**Q: I've encountered an issue. How can I report it?**

**A:** Use GitHub's *Issues* tab to do this. I would appreciate any feedback!
