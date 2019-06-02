# Travel-Diary
Travel Diary
It is a digital diary for every traveller. This app allows user to add their current location as they enjoy their journey along with name and description when they are logged in through their google account. This will be stored in core data of the app and it can be retrieved every time user opens the app. When saving the location, user can also explore nearby restaurants which is being fetched by Foursquare Places API.
The app has multiple view controller scenes.The scenes are described in detail below:

LOGIN SCREEN:
Travel Diary uses Google Sign-In. It is a secure authentication system that reduces the burden of login for  users, by enabling them to sign in with their Google Account—the same account they already use with Gmail, Play, and other Google services. 


LOCATIONS VIEW:
This view will show all the previous saved pins. Tapping on any of the shown pins will take user to the detail view page for that particular pin. The page also shows tabs for Map view and List View. Clicking on them will navigate the user to the desired view.  Also, tapping on add button will take user to a page to add new pin for current location. Using logout button can bring the user out of the app.

LOCATIONS LIST : 
This provides names of all the previously saved locations with recently added location at the top. Tapping on any of the names will take user to the details view page for that particular location.
User can add new location, can logout from this page. 
          

ADD LOCATION:
This provide user to save current location with name and description. User can save only one location on one latitude and longitude. 



Show Detail:
The page shows detail about the saved location. Pressing the Edit button can take user to an editable page for the corresponding location.


EDIT LOCATION:
This page allows user  to edit or delete name or description of previous saved location. 

SHOW RESTAURANTS:
This page lets users explore nearby restaurants.

