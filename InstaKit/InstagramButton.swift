// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI


public struct InstagramButton: View {
    
    /// Store the Instagram app ID
    private let instagramAppId: String
    /// Store the data for the background image of the Instagram story post
    private var getBackgroundImageData: @Sendable () async -> Data
    /// Store the data for the sticker image of the Instagram story post, if a sticker should be added
    private var getStickerImageData: (@Sendable () async -> Data)?
    /// Store the label for the button
    private var label: AnyView
    
    @State private var backgroundImageData: Data?
    @State private var stickerImageData: Data?
    
    /// Creates a new instagram button eith getter methods for the background and optionlly, sticker.
    /// If no getter is prodived for the sticker, no sticker is added to the instagram story.
    /// The label is the label of the button
    public init<Content: View>(
        instagramAppId: String,
        getBackgroundImageData: @escaping @Sendable () async -> Data,
        getStickerImageData: (@Sendable () async -> Data)? = nil,
        @ViewBuilder label: () -> Content
    ) {
        self.instagramAppId = instagramAppId
        self.getBackgroundImageData = getBackgroundImageData
        self.getStickerImageData = getStickerImageData
        self.label = AnyView(label())
    }
    
    /// Creates a new instagram button passing in a title for the button, using an instagram icon as the system image.
    /// If no getter is prodived for the sticker, no sticker is added to the instagram story.
    public init(_ titleKey: String,
                instagramAppId: String,
                getBackgroundImageData: @escaping @Sendable () async -> Data,
                getStickerImageData: (@Sendable () async -> Data)? = nil) {
        self.getBackgroundImageData = getBackgroundImageData
        self.getStickerImageData = getStickerImageData
        self.instagramAppId = instagramAppId
        
        self.label = AnyView(Label(title: {
            Text(titleKey)
        }, icon: {
            Image("instagram", bundle: .module)
                .resizable()
                .scaledToFit()
                .frame(width: 26)
        }))
    }
    
    public init<Content: View>(
        instagramAppId: String,
        backgroundImageURL: URL,
        stickerImageURL: URL? = nil,
        @ViewBuilder label: () -> Content
    ) {
        self.getBackgroundImageData = {
            do {
                return try await URLSession.shared.data(from: backgroundImageURL).0
            } catch {
                print("Error fetching Instagram background image: \(error)")
                return Data()
            }
        }
        if let stickerImageURL {
            self.getStickerImageData = {
                do {
                    return try await URLSession.shared.data(from: stickerImageURL).0
                } catch {
                    print("Error fetching Instagram sticker image: \(error)")
                    return Data()
                }
            }
        }
        self.instagramAppId = instagramAppId
        self.label = AnyView(label())
    }
    
    
    public init(_ titleKey: String,
                instagramAppId: String,
                backgroundImageURL: URL,
                stickerImageURL: URL? = nil) {
        
        self.getBackgroundImageData = {
            do {
                return try await URLSession.shared.data(from: backgroundImageURL).0
            } catch {
                print("Error fetching Instagram background image: \(error)")
                return Data()
            }
        }
        if let stickerImageURL {
            self.getStickerImageData = {
                do {
                    return try await URLSession.shared.data(from: stickerImageURL).0
                } catch {
                    print("Error fetching Instagram sticker image: \(error)")
                    return Data()
                }
            }
        }
        self.instagramAppId = instagramAppId
        self.label = AnyView(Label(title: {
            Text(titleKey)
        }, icon: {
            Image("instagram", bundle: .module)
                .resizable()
                .scaledToFit()
                .frame(width: 26)
        }))
    }
  
    
    public var body: some View {
        Button {
            Task {
                await openInInstagram()
            }
        } label: {
            label
        }
        .task {
            // Get the background & sticker image when the view loads
            async let bg = getBackgroundImageData()
            async let st = getStickerImageData?()
            
            (backgroundImageData, stickerImageData) = await (bg, st)
        }
    }
    
    
    private func openInInstagram() async {
        guard let backgroundImageData else { return }
                
        var pasteboardItems = [
            "com.instagram.sharedSticker.backgroundImage": backgroundImageData
        ]
        
        if let stickerImageData {
            pasteboardItems["com.instagram.sharedSticker.stickerImage"] = stickerImageData
        }
        
        // copy to clipboard
        UIPasteboard.general.setItems([pasteboardItems])
        
        let instagramURL = URL(string: "instagram-stories://share?source_application=\(instagramAppId)")!
        
        if UIApplication.shared.canOpenURL(instagramURL) {
            await UIApplication.shared.open(instagramURL)
            
        } else {
            print("Failed to open Instagram")
            print("This of often because:")
            print("-  Instagram was not installed on the user's device")
            print("-  Your app does not include 'instagram-stories' in the 'LSApplicationQueriesSchemes' key in 'Info.plist'.")
            print("See docs at https://developers.facebook.com/docs/instagram-platform/sharing-to-stories")
        }
    }
}



#Preview {
    
    let url = URL(string: "https://cubanvr.com/wp-content/uploads/2023/07/ai-image-generators.webp")!
    
    let data = try? Data(contentsOf: url)
    
    
    VStack {
        
        Image(uiImage: UIImage(data: data!)!)
            .resizable()
            .scaledToFit()
        
        InstagramButton("Instagram", instagramAppId: "YOUR APP ID") {
            data!
        }
        
    }
}
