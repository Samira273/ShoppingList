# ShoppingList
It's a simple SwiftUI/Combine App that takes items to be bought from User (Name, Quantity, Description) and saves them locally (for now), And it allaws the user to edit this item later on, mark it as bought, delete it.
There's a search in the displayed list by key word, searching in the description and the name fields.
There's Sorting that allaws the user to choose ascending or descing and the sorting criteria which is name, quantity, or desciption.

Techninal Documentation:
This app is build using:
- XCode 15.3
- Swift 5.2
MVVM structure is applied, we'll have homePageView with it's view model and the model of the data stored in the view Model.
View model is mainly with combine and it's working with publishers.
View is built with Swiftui.
Here's Sample of the app:

![trial 3](https://github.com/Samira273/ShoppingList/assets/46921426/39d90508-8773-4e07-bfba-3548db1b8176)
