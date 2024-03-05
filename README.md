# StocksApp

Look like The official Yahoo Finance API was shut down by Yahoo in 2017 so i used https://rapidapi.com/apidojo/api/yahoo-finance1 and that API have a limit of 500 request per month, so if requests start to fail, it's probably because the limit has been reached.

The app have was made with SwiftUI and Combine, and have 2 screens, first one have a list of stocks with the stock name and the full name(that api sometimes return the same name for both), the current stock value formatted, and the daily change value. That screen contain pull to refresh if you scroll down.

The second screen contain the name and the full name, ISIN(that API don't provide the ISIN, but i know the isin starts with 2 letters and have 12 chars, so i did a random isin for each stock), the current value and the daily market change, tabs for change the chart by day, week,month and YTD. and i also added more information like open value, high value, low value etc. The chart have the functionality to drag and the user can see the values, at the day and week charts doesn't work very well but for month and YTD works well

Both screens contains logic to loading when we do api calls and error handling when the API return error

The app contain unit tests, for api layer and for the viewModels(both have more then 80% of coverage)

<img width="30px" src="https://ibb.co/WpGkR2D" alt="image_name png" />
<img href="https://ibb.co/WpGkR2D"><img src="https://i.ibb.co/WpGkR2D/12.png" alt="12" border="0" /></img>
<img href="https://ibb.co/WpGkR2D"><img src="https://i.ibb.co/WpGkR2D/12.png" alt="12" border="0" /></img>

# Project Paths
StocksNetwork Path: is the layer that contains the nertwork logic to do requests across the app

Common Path: contain 2 paths
    1- Desing: contain a class for paddings to use across the app
    2- Extensions: Contain extensins String, Double, View, TimeInterval
    3- Common also contains a file for constants(API key for example)

Stockcs Path: contain a path for The stocks list screen and another one for the stock detail, both have a service path with the use case for call the endpoints, a viewModel and the Screen
    
    StockListItemView is a global view for each item of the stocks list
    
    StocksLinearChartView: is a view for the chart
    
    StockItem: contains a protocol with the stock information
    
UnitTests: contain 2 path one for API layers tests another one for the app layer tests
