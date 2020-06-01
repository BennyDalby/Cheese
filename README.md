# Cheese

Requirement of the project
# Overview
In this challenge you'll build a server and mobile web app that lets customers create cheese baskets for Frank's Fine Cheeses, a purveyor of cheeses in Los Angeles County. This should take about 4-6 hours in total but you don't have to do it all at once, 
we just ask that send us your solution in the next week. 

# Requirements
Frank's Fine Cheeses takes local sourcing to the next level, providing each neighborhood in Los Angeles County with different discounts and inventory. As such, when customers enter the site for Frank's Fine Cheeses they should be prompted to enter their zip code. 
If their zip code is within the service area, they can then search for cheeses by name or country of origin and add any of the cheeses listed in the search result to their basket. Out of stock cheeses should not show up in customer searches and in stock cheeses 
should show their price with the appropriate discount applied. When the customer is done selecting cheeses, they should be able to proceed to a summary of their cheese basket, which should list the cheeses they selected along with the total price.

In the `Data` directory you'll find two datasets:

- `cheeses.csv`, which has the id, name, country of origin, and price for each of the cheeses sold at Frank's Fine Cheeses
- `specials.csv`, which lists cheeses that are discounted and cheeses that are out of stock for each zip code. If a zip code is not listed in `specials.csv`, then it is outside of the service area of Frank's Fine Cheeses.

Frank's Fine Cheeses regularly updates their cheese inventory and neighborhood discounts, so build your system accordingly.

A few other things to mention:

- You can use any language, framework, and build system for your server and web app
- Use as much testing as you think is appropriate for the functionality that you build and mention any additional testing you would do if this were a production system
- You can use any 3rd party libraries and look up any resources you need in the course of this interview.
- We have provided loose design guidelines to follow. Please use the logos, button styles, color palettes and typefaces referenced in the 'Design Guidelines' PDF. The individual assets can be found in the 'design elements PNGs'and 'Cera Font' folders. How you implement 
  them is up to you.



# Details
Write your server and web app in this folder and when you're done, zip this folder and email it back to us. Leave instructions below for how to build and run the server and web app along with any additional comments on the design of your solution.

Technology Stack and Installation Guide
DB - MYSQL  - Cheese.DB.SQL.Zip
API Script - PHP - api.zip
Front End - Swift 5.0 - FranksCheese.zip

Method of installation :- 
API + DB
The server side was implemented locally. The application used on the system to set up the local server was MAMP. Once installed, drag the api.zip(unzipped) folder to the htdocs docs folder created by MAMP.
Front End
Install the Xcode 10 > with simulators. Make sure to have an iphone 11 simulator as the app is developed with iphone 11 UI base.Unzip the FranksCheese.zip and open the Xcodeproj.Run the application by pressing the play button in Xcode.

If you are placing the API folder in LIVE server, then you will need to change the api base URL on the native IOS app, to do that , open the build Settings of the application and change the URL in the User_Defined Settings tab.

Technical Description
Fetching data based on Zip Code :- When user enters the Zip code in the text field, we open a concurrent thread, and make the call to the GET api with Zip code in the URL.

The Api fetches the CheeseID, CheeseName, Country of Orgin, Outof Stock status etc for all those items present in the Zip code, and sends the response as a dictionary of array cheese items.JOIN operator was used to fetch the data from both the tables.

The mobile app, has a model that stores these values obtained from the Server, and once the data fetch is complete, we move to the main thread and displays the cheese items. 

The user is also given the option to search by every character based on Name and Country of Origin. The user can select the items needed and can move into the final cart page to see the items that are being selected.


Use Cases to consider :- 

Invalid Zip code
Wrong Zip code
Multiple Select and unselect of items 
Search and select the items 
Search by existing name / country
Search by invalid name/ country



Design Architecture - Front End
	Initial drawing of the design was done on the white board.Later it was developed in Storyboard.
	

The color theme and font was based on the branding guidelines provided.
Design Architecture - Backend

Architecture of th DB schema :- 
CREATE TABLE `TABLE 1` (
  `ID` varchar(5) DEFAULT NULL,
  `Name` varchar(30) DEFAULT NULL,
  `Country` varchar(24) DEFAULT NULL,
  `Price` varchar(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;





Conclusion

Using this IOS mobile application, the user could enter the Zip code and fetch the cheese results , and select the cheeses into the cart.
