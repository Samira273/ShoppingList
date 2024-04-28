# ShoppingList

This is a straightforward SwiftUI/Combine application designed for managing shopping items inputted by the user (including Name, Quantity, and Description), which are then stored locally. The app enables users to later edit these items, mark them as purchased, or delete them. Additionally, users can search the displayed list using keywords that are matched against both the description and name fields. Sorting functionality is also included, allowing users to choose between ascending or descending order and select the sorting criteria (name, quantity, or description).

Technical details:

This application is developed using:

Xcode 15.3
Swift 5.2
It follows the MVVM architecture pattern. The structure comprises a homePageView, its corresponding view model, and the data model stored within the view model.
The view model primarily utilizes Combine for reactive programming and works with publishers.
The user interface is constructed using SwiftUI.
Sample of the app:

![trial 3](https://github.com/Samira273/ShoppingList/assets/46921426/39d90508-8773-4e07-bfba-3548db1b8176)
