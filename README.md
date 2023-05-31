# Kontwapp

## Brief description
Kontwapp is an app that allows you to keep track of anything that you can count. Just add a counter with a name and start having fun.

## How it works.
Kontwapp has these functionalities already integrated:
1. It lets you add a new counter with the + button on the top right of the main screen.
2. You can swipe any cell to the left to delete any counter that you want.
3. To increase a counter, simply tap + in the desired counter cell.
4. Same to decrease, tap - in the desired cell.<br/>

All of these is demonstrated in the following video:<br/>
[![Kontwapp demo](http://img.youtube.com/vi/KKejYXYabz0/0.jpg)](https://www.youtube.com/watch?v=KKejYXYabz0 "Kontwapp demo")

## The project
Kontwapp counts with its own network layer implementation which handles already the most common error types. It can be expanded to any customized errors needed to show to the user.<br />
It has it's own core data model to keep the data stored and add offline functionality in the future.<br />
Other than that, it's a simple app with two screens. One to watch your current counters and another to add any other counter that you'd like.<br />
It also shows the total number of whatever objects or activities you're keeping track of.

## Setup
To setup Kontwapp, simply put the desired API URL in the KontwappAPIURL field included already in the Info.plist file of the project.<br />
After that, you're good to go since there's no other dependencies on the project (that means no pods or other frameworks).

## Room for improvement
1. The API has the limitation that it can only increase or decrease one counter at a time which can make the UI awkward. To solve this we could implement a better endpoint which takes several counters at a time and an update in their count. Not really increasing or decreasing but just editing the count number and we could sync with the server later.
2. We could also add sections so you can better organize the counters that you're keeping track of.
3. CoreData seems like an overkill right now just persisting the data offline with no apparent reason but it can unlock better functionality and user experience in the future by letting anyone use it even without internet. It can sync with the server later.
