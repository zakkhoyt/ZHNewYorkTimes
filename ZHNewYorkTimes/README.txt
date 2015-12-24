

I've chosen two write this app in both Obj-C and Swift. While the vast majority of my experience is using Objective-C, I really do like Swift and am coming up to speed with it. I've written the UI code in swift and the utilites in Obj-C.'

REST. For this assignment I've decided to code up the REST calls using NSURLSession. For a bigger application which would talk to more endpoints I would consider using AFNetworking.
The REST manager class exposes a singleton which is clipped to 1 concurrent call. This could be increased in a busier application with some caution. For what we are doing, 1 concurrent call is plenty.
Our instance of NSURLSession will do its work on a background queue. Any final commpletion handlers will be called on the main queue. This allows the UI to run smoothly and by calling commpletion handlers on the main queue, it reduces complexity in the view controller code.

Third Party Libs. I used cocoapods to include:
* MBProgressHUD - The standard 3rd party lib for telling the user to wait.
* SDWebImage - A terrific/popular image cacher with a handy category for loading remove images.

I've used the Apperance protocol to give the app a color pallette. This can be expanded out to other types of UI controls easily.

What's left to do?
* When accessing the multimedia key of an article, I am accepting the first entry. In a prod app we would want to find the largest image in this set.
* Would be nice to display if an article or feed came from cache. Perhaps a subtle label which fades away.
* A clear cache button could be useful if we had a settings area.


