# AssetRedirect

Documentation

This webpage generates related links by using the asset number and siteID

In DNA the hyperlink to this webpage should be:

http://operations.connect.na.local/support/Reliability/ReliabilityShared/Pages/AssetRedirect.aspx/?cheese=GH=&cheestNum=S2010=&mobile=0

With the siteID between '=' after cheese and asset number between '=' after cheeseNum. The mobile=0 part makes sharepoint only serve this page.

To added links to be generated see example below:

To add this link 
http://nscandacssrs1/ReportServer?/Maximo/Asset%20Spare%20Parts&paramSiteID=GS&paramAssetNum=C7102

We would use
text += "<li id=\"redLink\"><a href=\"http://nscandacssrs1/ReportServer?/Maximo/Asset%20Spare%20Parts&paramSiteID=" + siteID + "&paramAssetNum=" + assetN + "\">" + "RedLink" + "</a></li>";
in our javascript code

"<li id=\"redLink\"><a href=\"
    This part of the string sets the id of the hyperlink to "redlink" the id is usefully for the css that we will apply to get a border with color
    
\" is used to add quotation marks to the string itself since a normal " would just end the string, \ is called an escape character

the + sign is used to add two strings to each other so "http://nscandacssrs1/ReportServer?/Maximo/Asset%20Spare%20Parts&paramSiteID=" + siteID adds the string contained in the siteID variable to the other string

"RedLink" is the text thats displayed for the link

CSS
    #redLink {
        border-style: solid;
        border-width: medium;
        border-color: red;
    }
    
This is the CSS used to make the border box, you can change the color check CSS color names here
https://www.rapidtables.com/web/css/css-color.html
you can also use RGB or Hex Code to specify the colors if more are needed

the you would use 
border-color: #FFE4E1;
or
border-color: rgb(255,228,225);

# AssetFinder
#TODO (probs never)
