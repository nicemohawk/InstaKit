#  InskaKit

InstaKit is a simple package including a basic SwiftUI button to share a photo to Instagram, with the option of adding a custom sticker too.

<hr>

## Installation

**SwiftPM** is the best and easiest way to distribute Swift packages in 2025 so I am providing a GitHub link HERE to install the package:
**https://github.com/DanielCrompton123/InstaKit.git**

1. Open Project settings in Xcode (the actual *project* rather than the main target)
2. Go to the "**Package Dependencies**" tab and under the list of dependencies, press the **+** button.
3. Paste the GitHub link above into the search field and add the package to your project.

## Documentation

This package provides a single struct called `InstagramButton` that can be created in a number of different ways:

- You can pass in a *titleKey* or give it a label using the trailing closure syntax
- You can either provide a URL to the background image & optionally, sticker image, or a closure to retieve the data for the background/sticker image
- You **must** provide a `instagramAppId` (see below)

**The `InstagramButton` is a regular SwiftUI button** with a pre-defined Instagram icon & action, therefore **you can add styling as you need** either by using SwiftUI's `ButtonStyle` or providing a view in the label.

## Prerequisites

(Don't be intimidated by this list, they're small stages :))

In order for this button to work effectively and open Instagram, you must hare registered your app with the Meta API & retrieved an app ID.

Firstly, you must add the key **`LSApplicationQueriesSchemes`** in your app's `Info.plist` file and include **`instagram-stories`**. [(See docs here)](https://developers.facebook.com/docs/instagram-platform/sharing-to-stories#:~:text=You%20need%20to%20register%20Instagram%27s%20custom%20URL%20scheme%20before%20your%20app%20use%20it.%20Add%20instagram%2Dstories%20to%20the%20LSApplicationQueriesSchemes%20key%20in%20your%20app%27s%20Info.plist.])

Secondly, you must have registered your app with Meta's API (although you do not need an API key, and this is **free** to do).
- Go to [Meta's developer page](https://developers.facebook.com) and create a new developer account.
- Create a new application in the portal 
- In your Meta app's settings, go to **Settings > Basic** and at the bottom, press a thin grey button **"+ Add Platform"**.
- Enter your app's **bundle ID** and during development, leave the App Store IDs blank. *Note I have not texted this theory but when your app is ready to go live, and you have an App Store ID, put this value here and switch the toggle at the top of the page from "Development" to "Live"*.

And you're done! Now you can **copy the meta app ID to Xcode and pass to `InstagramButton`**. 

Enjoy using

## Future considerations

The Instagram API docs provide a [list of different things](https://developers.facebook.com/docs/instagram-platform/sharing-to-stories#:~:text=app%20is%20able%20to.-,Data,-You%20send%20the%20following) that can be passed from your app to Instagram. In the future I may add some more of these, or you can. Just make sure to create a pull request and I will accept.

## License

I'm no lawyer so I can't name different licenses. Basically, use as you please. The instagram button is **yours to do what you want with including selling it, modifying and redistributing**.
