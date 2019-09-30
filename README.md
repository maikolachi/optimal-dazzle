# Optimal Dazzle
Implements a look ahead search against the Seat Geek API. The results are displayed in a table view and tapping on an item, shows the detail screen. 

## Design
1. Implemented using a Split View and therefore works well both on the iPad and the iPhone. The Navigation Views were removed to allow the display as close as possible to the requirements. 
2. Search results are not cached, ever as the search targets are not clear. 
3. The user can "favourite" an even on the detail page fills the heart shape and adds the event to the favorites list. 
4. The favourites list is stored in Core Data and loaded once in a hash table when the application launches. 
5. Some events do not have URL's provided, in which case a stock image is displayed in the thumbnail and on the detail page. There are a number of events that have no image. 
6. Displays the detail as a Popover view instead of as showin in the

## Important

- Some events do not have url's for the i

### Deviation from the requrements
1. The header colors are slghtly are different than the requrements


### Architecture
