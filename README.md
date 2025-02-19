
### Summary: Include screen shots or a video of your app highlighting its features

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
I particularly prioritized code re-usability and SwiftUI view separation. I created a generic method for network requests and injected it in the viewModel in order to later simulate network calls and create UnitTests with MockNetworkService. I also put a lot of focus in the UI, making sure that it provides some decent functionality even though it has limited information.

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
I spent around 7-8 hours on it. I believe I spent less than half the time building the UI and the rest with everything else.
 
### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
I believe I maintained a good balance overall.

### Weakest Part of the Project: What do you think is the weakest part of your project?
I wouldn't call it the weakest part but certainly the most challenging part of the project would be the ImageService. I managed to visualize the different operations like image download, image store in-memory cache, image store in disk using FileManager, and then after the first initial download, retreive from disk instead. I like it because it made the images load very fast since there's no need for downloading, however the first ever initial load, it's not as fast as I want it to be. In a real life scenario the Endpoint would support pagination and that would potentially make the initial load quicker.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
Due to limited time, I also wanted to create unit tests for ImageService. I would first remove direct depencencies for services like fetching data or FileManager and move them into protocols. I would then create new interfaces that would conform to these protocols and those would be used in production. Of course they would also need to be injected in ImageService. Then I would create Mock services for UnitTests. This way, during testing I would inject these mock objects and simulate various scenarios like: successful image downloads, disk read success/failures etc. without performing actual network or disk calls.
