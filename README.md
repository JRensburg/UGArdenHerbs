# UGArdenHerbs
Hi this is the source code for my app on the App Store, [UGArden Herbs](https://itunes.apple.com/tr/app/ugarden-herbs/id1451324009?mt=8). This is an app used by UGArden to assist them
with everyday production. It's main function is to allow UGArden to digitally update data. Before, they would write everything down on cards and someone would have to go through and manually transfer the information over to Google Sheets.

## The Forms
Production on the farm happens in three major steps, so there are three relevant forms for logging this data. First seeds are planted and the information about this has its own form. 
Then the plants are moved to the fields, harvested, and dried, which is logged in another form. Lastly, the dried herbs are processed and put into a variety of products, which also has an acoompanying form.

### The Drying From
This form is less straightforward than the other two, because herbs are harvested and dried, a process which takes a few days, but data needs to be collected before and after this somewhat lengthy process.
The challenge here is making sure that the data recorded in the second half of the form reflects the same batch of herbs as the first half. 
To solve this problem, the information from the first half of the form is encoded with a QR code and a label is generated containing that code as well as a few descriptions. That label is 
put with the herbs as they dry, and then when the process is complete, workers simply scan the code with the app and then the form is populated with all of that information. 

## Viewing the Data
Another feature of the app is that it allows users to view recently submitted entries and also edit or delete them. This is 
done by creating a stream of entries fetched from the API and binding them to a UITableView. Each of these cells generates a smaller tableview containing specifically that entry's information that is modally presented when the cell is tapped.
This was the most difficult aspect of the project for me to program. 
#### The Data
There is a codable struct data model for each of three forms which allows for the retrieved JSON to easily be converted into data structs for the appropriate data type.
Each of these data types adopts a protocol telling the modal TableView cells how to layout the cells, as well as protocol telling the Edit form how to lay itself out. 
This is a new implementation. before, I would try to track the data type with a selected index and would have to conditionally and forced cast the data types all over the place. 
With the protocols, there is no more type casting, and no more massive switch statements. 
#### Reactive
Using RxSwift, this aspect of the project is set up using reactive programming. Setting up the entire main TableView is as simple
as creating a stream of data objects from the API call and then binding those to the Table View (their adopted protocols tell the cells how to be set up).
I set it up like this initially because I was struggling to understand Reactive programming at work, and figured bringing it into one of my personal projects would help provide some clarity, which it did. 
On the main page I also want the data to refresh after the Edit form is used (so that it can reflect new data) or after an item is deleted. 
The observable pattern makes this very easy.

