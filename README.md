# SwiftCurrency

# Overview
SwiftCurrency is a currency conversion app developed as part of a coding challenge. The app fetches real-time exchange rates from the Open Exchange Rates API, allowing users to convert a specified amount from one currency to others. The app is built using Swift and follows the MVVM (Model-View-ViewModel) architecture pattern.

# Features
Real-Time Currency Conversion: Fetches the latest exchange rates from the Open Exchange Rates API and converts the specified amount.
Offline Support: Stores exchange rates locally to allow the app to function offline.
API Call Limitation: Ensures that the API is called no more frequently than once every 30 minutes to conserve bandwidth.
User-Friendly Interface: Simple and intuitive UI with a text input for the amount, a picker for currency selection, and a collection view displaying conversion results.
Unit Tests: Includes comprehensive unit tests to verify the correct functioning of the app.

# Technologies Used
Language: Swift
Architecture: MVVM (Model-View-ViewModel)
Networking: Alamofire
Data Persistence: UserDefaults
Testing: XCTest
