<!--Since Last Upload (July-19)-->
<!--Use Beautify Extension-->
<!--add bramCal-->

<!DOCTYPE html>
<html lang="en">

<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <!--tag to make IE use its modern rendering engine-->
    <!--honestly this webpage is put together from a bunch of stackoverflow questions so my browsing history would be more helpful than my comments-->
    <!--i.redd.it/g68apg56e7a11.jpg-->
    <script src="https://cdn.rawgit.com/mholt/PapaParse/master/papaparse.min.js" type="text/javascript"></script>
    <!-- reader for CSV files-->
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>
    <!--    These are for the drop down and typing for asset numbers-->
    <title>Asset Finder</title>
</head>

<body>
    <p id="title">Asset Finder</p>
    <p>Find Assets by using the Asset Number or Asset Description</p>
    <!--    the 3 input fields are in a table so it aligns better-->
    <table>
        <tr>
            <td id="col1">
                <p>Site ID:</p>
            </td>
            <td id="col2">
                <!--    drop down menu for site selector        -->
                <select id="siteID" onchange="ChangeSite()">
                    <option value="BA">BA: Calgary</option>
                    <option value="CA">CA: Kankakee</option>
                    <option value="GA">GA: Wilmington</option>
                    <option value="GC">GC: Sumas</option>
                    <option value="GE">GE: Ashcroft</option>
                    <option value="GH">GH: Hawkesbury</option>
                    <option value="GI">GI: Madoc</option>
                    <option value="GK">GK: IG Brampton</option>
                    <option value="GR">GR: BramCal</option>
                    <option value="GS">GS: Sylacauga</option>
                    <option value="GV">GV: Texas/Southwest</option>
                    <option value="PBM">PBM: Senica/Sloviakia</option>
                </select>
            </td>
        </tr>
        <tr>
            <td id="col1">
                <p>Asset Number:</p>
            </td>
            <td id="col2">
                <!--Input box & dropdown for asset number-->
                <select class="js-tags" id="AssetList" style="width: 90%"></select>
            </td>
            <td id="col3">
                <button id="submitButt" disabled=true onclick="findAsset(true)">Submit</button>
            </td>
            <td id="col4" onclick="toolTip(1)">
                <!--a tool tip hidden in a question mark-->
                <div class="help-tip">
                    <p>Enter Asset Number:<br>e.g., S2100</p>
                </div>
            </td>
        </tr>
        <tr>
            <td id="col1">
                <p>Asset Description:</p>
            </td>
            <td id="col2">
                <div id="DescBox"><input type="text" id="assetDesc" oninput="buttonEnableDesc()"></div>
                <!--input box called buttonEnable function when text changes on user input-->
            </td>
            <td id="col3">
                <button id="submitDesc" disabled=true onclick="findAsset(false)">Submit</button>
                <!--    the submit button, defaults to disabled-->
            </td>
            <td id="col4" onclick="toolTip(2)">
                <div class="help-tip">
                    <p>Enter keywords to look for in the Description</p>
                </div>
            </td>
        </tr>

    </table>

    <p id="result">Press the ? mark for tips</p>
    <!--    thing for results output, this text will be filled using javascript below-->

</body>

<script type="application/javascript">
    var start;
    var arrayExist = false;
    var siteData;
    var convertCase = false;
    var lCaseDesc;

    //this sets the asset number box as both drop down and input
    $(".js-tags").select2({
        tags: true
    });

    //this calls the button enable function when the asset number is changed
    $(".js-tags").on('change', function() {
        //        console.log("changed");
        buttonEnable();
    })

    function ChangeSite() { //reset parts of the sheet when the siteID is changed
        //    we save the array generated from the CSV file so we dont have to generate it everytime we search, but it needs to be cleared if the user changes sites
        arrayExist = false;
        //we also convert the description to lowercase so save that array too
        convertCase = false;
        //removes all entries for the drop down asset list
        for (var i = AssetList.options.length - 1; i >= 0; i--) {
            AssetList.remove(i);
        }

        var siteCSV = "/support/Reliability/ReliabilityShared/Pages/".concat(siteID.value, ".csv");

        //check to see if .csv file exists for the site, runs code to populate drop down if exists
        $.ajax({
            url: siteCSV,
            type: 'HEAD',
            error: function() {
                console.log("The File is Not Feeling So Good Mr. Stark");
                document.getElementById("result").innerHTML = "Database file for this site cannot be found, Please contact Reliability Department";
            },
            success: function() {
                console.log("File is Good");
                document.getElementById("result").innerHTML = "<ul><li>Loading Assets List..... Please Wait</li></ul>";
                readCSV(siteCSV, loadAssetDrop);
                document.getElementById("result").innerHTML = "Press the ? mark for tips";
            }
        });
    }

    function toolTip(tipNum) {
        //    also show the tool tip written in the results section cause sometimes it does not pop up on ishits
        if (tipNum == 1) {
            document.getElementById("result").innerHTML = "<p>Enter Asset Number: e.g., S2100</p>"
        } else {
            document.getElementById("result").innerHTML = "<p>Enter keywords to look for in the Description</p>"
        }
    }

    function buttonEnableDesc() {
        //    console.log (assetDesc.value);
        //    enable the description submit button when the field is not blank
        if (assetDesc.value == "") {
            document.getElementById("submitDesc").disabled = true;
        } else {
            document.getElementById("submitDesc").disabled = false;
        }
    }

    function buttonEnable() { //enable the button when a valid asset number is inputted
        //    console.log(AssetList.value);
        //    AssetList.value = AssetList.value.toUpperCase();
        var patt = new RegExp("[A-Z][0-9]{4}"); //check if input is right format
        var str = AssetList.value;
        var result = patt.test(str);
        if (result == true && str.length == 5) {
            document.getElementById("submitButt").disabled = false;
            console.log("enable");
        } else {
            document.getElementById("submitButt").disabled = true;
            console.log("disable");
        }
    }

    function findAsset(IsNumAsset) {
        //    depending on type of search call the functions required
        start = Date.now();
        document.getElementById("result").innerHTML = "<ul><li>Searching..... Please Wait</li></ul>";
        //siteID, assetNum can be used
        if (arrayExist) {
            if (IsNumAsset) {
                loopAssets(siteData);
            } else {
                loopAssetDesc(siteData);
            }
        } else {
            console.log("Array Problem");
        }
    }


    function readCSV(url, callback) { //reads csv into an array using papaparse libary
        url = "/support/Reliability/ReliabilityShared/Pages/" + siteID.value + ".csv";
        console.log("Start CSV");
        Papa.parse(url, {
            download: true,
            complete: function(results) {
                arrayExist = true;
                console.log("Finished Parsing Array");
                siteData = results.data.slice(0);
                callback(results.data, true);
            }
        });
    }
    //the logic for finding the asset based on number or keywords is the same as the one in excel so just read those comments
    function loopAssetDesc(data) {
        var temp = assetDesc.value.toLowerCase(); //converting to lower case should be faster since most letters are lower case
        temp = temp.trim();

        if (temp.length == 0) { //if input is only spaces
            document.getElementById("result").innerHTML = "<ul><li>Invalid Input...</li></ul>";
        } else {

            var assetD = temp.split(" ");
            var foundA = false;
            var foundB = false;
            var keywords = assetD.length;

            var text = "<ul>"; //gonna make a list

            if (!convertCase) {
                //convert everything to lower case, only runs once for the same site
                lCaseDesc = new Array(keywords);
                var n = data.length;
                convertCase = true;
                for (i = 0; i < n - 1; i++) {
                    lCaseDesc[i] = data[i][1].toLowerCase();
                }
                console.log("Done Case Conversion");
            }

            var n = data.length;
            for (var i = 0; i < n - 1; i++) {
                //        console.log (i);
                foundA = false;
                for (j = 0; j < keywords; j++) { //find the keyword
                    if (lCaseDesc[i].indexOf(assetD[j]) == -1) {
                        foundA = false;
                    } else {
                        foundA = true;
                    }
                    if (foundA == false) { //exit if one word does not match
                        j = keywords + 1;
                    }
                }

                if (foundA == true) {
                    foundB = true;
                    //we essentially write the results in a html style list and set the result object to the string we are creating
                    text += "<li>" + data[i][0] + ": " + data[i][1] + "</br>";
                    text += "<a href=\"" + data[i][2] + "\">" + data[i][4] + "</a></li>";
                }
            }
            if (foundB == false) {
                text += "<li>Asset not found. Please check Site ID and Asset Number</li>";
                text += "<li>If Asset is new, make sure the database has been updated by Reliability Department</li>";
            }
            text += "</ul>";
            document.getElementById("result").innerHTML = text;
            console.log(Date.now() - start); //return time takes for search
        }
    }


    function loopAssets(data) { //loops through the assets and output rows in array with the right asset number
        var assetN = AssetList.value;
        var foundA = false;
        document.getElementById("result").innerHTML = "<ul><li>Searching..... Please Wait</li></ul>";
        var text = "<ul>"; //gonna make a list
        var n = data.length;
        for (i = 0; i < n - 1; i++) {
            if (assetN == data[i][0]) {
                text += "<li>" + data[i][0] + ": " + data[i][1] + "</br>";
                text += "<a href=\"" + data[i][2] + "\">" + data[i][4] + "</a></li>";
                foundA = true;
            }
        }
        if (!foundA) {
            text += "<li>Asset not found. Please check Site ID and Asset Number</li>";
            text += "<li>If Asset is new, make sure the database has been updated by Reliability Department</li>";
        }
        text += "</ul>";
        document.getElementById("result").innerHTML = text;
        console.log(Date.now() - start);
    }

    function loadAssetDrop(data) {
        //adds the entries for the asset numbers drop down menu
        var lastAsset;
        var n = data.length;
        data.sort();
        var select = document.getElementById("AssetList");
        var fragment = document.createDocumentFragment();
        for (i = 0; i < n - 1; i++) {
            if (lastAsset != data[i][0]) {
                var opt = data[i][0];
                var el = document.createElement("option");
                el.textContent = opt;
                el.value = opt;
                fragment.appendChild(el); //add them to this variable
                lastAsset = opt;
            }
        }
        select.appendChild(fragment); //now add everything to the dropdown at once
        console.log("Finished loading assets");
        if (window.location.search.indexOf("cheeseNum") != -1) {
            var cheeseNum = window.location.search.split('=')[3]; //get assetNum
            console.log(cheeseNum);
            //just in case they arent uppercase
            AssetList.value = cheeseNum.toUpperCase();
            document.getElementById("submitButt").disabled = false;
            findAsset(true);
        }
    }


    document.addEventListener('DOMContentLoaded', function() { //set to siteID equal to the variable in the URL ...?cheese=GK case insensitive
        //this runs as soon as the site has been loaded
        var paraURL = window.location.search
        if (paraURL.indexOf("cheese") != -1) {
            var cheese = window.location.search.split('=')[1];
            siteID.value = cheese.toUpperCase();
        }

        ChangeSite();
        if (window.innerHeight > window.innerWidth) {
            document.getElementById("result").innerHTML = "This Page is best viewed in landscape mode";
        }
    }, false);
</script>
<style>
    /*CSS for formatting stuff*/

    .p {
        padding: 0;
        margin: 0;
    }

    body {
        font-family: "Sans-serif";
        font-size: 2em;
        display: inline-table;
        width: 95%;
    }

    input {
        font-family: "Sans-serif";
        font-size: 0.9em;
        /*        margin-bottom: 2%;*/
        width: 90%;
        /*        margin-left: 10%;*/
    }

    select {
        font-family: "Sans-serif";
        font-size: 0.9em;
        width: 90%;
        /*        margin-left: 10%;*/
        /*        margin-bottom: 2%;*/
    }

    table {
        /*        padding-top: 0.5em;*/
        vertical-align: top;
        width: 95%
    }

    button {
        font-family: "Sans-serif";
        font-size: 0.9em;
        /*        margin-left: 100%;*/
    }

    #title {
        text-align: center;
        font-size: 2em;
        margin-top: 0px;
        margin-bottom: 0px;
    }

    #col1 {
        padding-right: 0;
        width: 25%;
    }

    #col2 {
        padding-left: 0%;
        width: 60%;
    }

    #col3 {
        padding-left: 0%;
        width: 10%;
    }

    #col4 {
        padding-left: 0%;
        width: 5%;
    }

    .select2-container .select2-selection--single {
        min-height: 1.2em !important;
    }

    .select2-container--default .select2-selection--single .select2-selection__rendered {
        line-height: 1.2em;
        color: black;
    }

    /*
    .js-example-tags form-control{
        height: 100%;
        width: 100%;
    }
*/

    .help-tip {
        position: relative;
        /*	top: 18px;*/
        /*	right: 18px;*/
        text-align: center;
        background-color: #BCDBEA;
        border-radius: 50%;
        width: 60px;
        height: 60px;
        font-size: 14px;
        line-height: 60px;
        cursor: default;
    }

    .help-tip:before {
        content: '?';
        font-weight: bold;
        font-size: 4em;
        color: #000;

    }

    .help-tip:hover p {
        display: block;
        transform-origin: 0% 0%;
        -webkit-animation: fadeIn 0.3s ease-in-out;
        animation: fadeIn 0.3s ease-in-out;

    }

    .help-tip p {
        display: none;
        text-align: left;
        background-color: #1E2021;
        padding: 10px;
        width: 200px;
        position: relative;
        border-radius: 3px;
        box-shadow: 1px 1px 1px rgba(0, 0, 0, 0.2);
        right: 290%;
        top: -25%;
        color: #FFF;
        font-size: 1.5em;
        line-height: 1.4;
        z-index: 1;
    }

    .help-tip p:before {
        position: absolute;
        content: '';
        width: 0;
        height: 0;
        border: 6px solid transparent;
        border-bottom-color: #1E2021;
        right: 10px;
        top: -12px;
    }

    .help-tip p:after {
        width: 100%;
        height: 40px;
        content: '';
        position: absolute;
        top: -40px;
        left: 0;
    }
</style>

</html>

<!--            var siteURL = [
"http://operations.connect.na.local/support/Reliability/IKOCalgary/CalgaryAssetDocuments",
"http://operations.connect.na.local/support/Reliability/IKOKankakee/KankakeeAssetDocuments",
"http://operations.connect.na.local/support/Reliability/IKOWilmington/PlantAssetDocs",
"http://operations.connect.na.local/support/Reliability/IKOSumas/Sumas Asset Documents",
"http://operations.connect.na.local/support/Reliability/IKOAshcroft/PlantAssetDocs",
"This is empty so i dont care enough to fill it in tbh",
"http://operations.connect.na.local/support/Reliability/IKOHawkesbury/HawkesburyAssetDocuments",
"http://operations.connect.na.local/support/Reliability/IKOMadoc/PlantAssetDocs",
"http://operations.connect.na.local/support/Reliability/IGBrampton/IGBramptonAssetDocuments",
"http://operations.connect.na.local/support/Reliability/IKOSylacauga/SylacaugaAssetDocuments"
"http://operations.connect.na.local/support/Reliability/IKOSouthwest/PlantAssetDocs",
"http://operations.connect.na.local/support/Reliability/IKOSlovakia/PlantAssetDocs",
            ];-->
