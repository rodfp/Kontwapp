# Kontwapp

## Brief description
Kontwapp is an app that allows you to keep track of anything that you can count. Just add a counter with a name and start having fun.

## The project
Kontwapp counts with it's own network layer implementation which handles already the most common error types. It can be expanded to any customized errors needed to show to the user.<br />
It has it's own core data model to keep the data stored and add offline functionality in the future.<br />
Other than that, it's a simple app with two screens. One to watch your current counters and another to add any other counter that you'd like.<br />
It also shows the total number of whatever objects or activities you're keeping track of.

## Setup
To setup Kontwapp, simply put the desired API URL in the KontwappAPIURL field included already in the Info.plist file of the project.<br />
After that, you're good to go since there's no other dependencies on the project (that means no pods or other frameworks). 

## Room for improvement
The API has the limitation that it can only increase or decrease 
