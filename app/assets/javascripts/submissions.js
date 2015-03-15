var minutes;
var seconds;
var request_button;
var submit_button;
var inner_html;
var active = false;

function pad2(n){
    return n > 9 ? "" + n: "0" + n;
}

// Demo: countdown(600, $('a#submission-button'));
function countdown($time, $request_button, $submit_button) {
  request_button = $request_button;
  submit_button = $submit_button;

  if(active == true)
    return;

  active = true;

  // $time: number of seconds
  // $request_button: a Bootstrap button (<a>)
  $request_button.removeClass('btn-success').addClass('btn-default');
  inner_html = $request_button.html();

  minutes = Math.floor($time / 60);
  seconds = $time % 60;

  request_button.html("Valid for " + pad2(minutes) + ":" + pad2(seconds) + " (click to redownload)");
  submit_button.fadeIn();
  setTimeout(update, 1000);
}

function update() {
  if(seconds != 0) {
    seconds--;
  }
  else if(minutes != 0) {
    minutes--;
    seconds = 59;
  }
  else {
    request_button.removeClass('btn-default').addClass('btn-success');
    request_button.html(inner_html);
    submit_button.fadeOut();
    active = false;
    return;
  }
  
  request_button.html("Valid for " + pad2(minutes) + ":" + pad2(seconds) + " (click to redownload)");
  //console.log(minutes + ":" + seconds);
  setTimeout(update, 1000);
}

// +-----------------------------------------------------------------+
// |  Functions for sending submitted output files                   |
// +-----------------------------------------------------------------+
