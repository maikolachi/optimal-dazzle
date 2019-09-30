# Optimal Dazzle
Implements a look ahead search against the Seat Geek API. 

## Details

1. Using a Split View Controller to allow iPad and iOS versions using the same code base
2. User types ahead that triggers a new search from the API
3. Implemented without the navigation controller as the detail view did not show one
4. The detail view appears as a popover on the iPhone instead of a full detail view
5. MVVM is the architecture of choice to encourage unit testing
6. Developed using Xcode 11 and targets iOS 12.4
7. Dark mode may not appear correctly
8. If the image url is not supplied by the API a stock image is displayed, as there are many events without one
9. Some quirks may be remaining like on the Split View the back button shold not show in some layouts, have to add the split view button.

## Caching mechanism

- The favourities are cached in Core Data and are loaded into a hash table (Set) on startup to allow for O(1) search efficiency
- Images are cached in the documents folder
- UITableView prefeching is used to verify that the imaage is in the cache, if not present an NSOperation is queued to fetch the image and place it in the cache. 
- Also during cell construction for the Table View, if the image is not found in the cache an operation is queued and that operation provides a call back that is called when the download is complete. 
- When downloading images while building a cell, the callback verifies that the downloaded image is for the same cell that is displaying, as may not be the case when the cell is reused.
- The operation to download images runs on a background thread and if the iamge is found in the cache it ignores the process, else downloads it and saves it in the cache. 
- **Query results and details of events are not cached**

## Unit Tests

- The design uses MVVM architecture and created a simple test to retrieve verify that all events starting with "a" have an image. They do not, the url is missing in many cases. 


# Screen Captures

![iPhone Master](docs/iphone-master.png) ![Details screen](docs/iphone-detail.png) 

![iPad Screen](docs/ipad.png) 