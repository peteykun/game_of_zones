var minutes;
var seconds;
var link_to_grey;
var inner_html;
var active = false;

function pad2(n){
    return n > 9 ? "" + n: "0" + n;
}

// Demo: countdown(600, $('a#submission-button'));
function countdown($time, $link_to_grey) {
  if(active == true)
    return;

  active = true;

  // $time: number of seconds
  // $link_to_grey: a Bootstrap button (<a>)
  $link_to_grey.removeClass('btn-primary').addClass('btn-warning');
  inner_html = $link_to_grey.html();

  minutes = Math.floor($time / 60);
  seconds = $time % 60;
  link_to_grey = $link_to_grey;

  link_to_grey.html("Valid for " + pad2(minutes) + ":" + pad2(seconds) + " (click to redownload)");
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
    link_to_grey.removeClass('btn-warning').addClass('btn-primary');
    link_to_grey.html(inner_html);
    active = false;
    return;
  }
  
  link_to_grey.html("Valid for " + pad2(minutes) + ":" + pad2(seconds) + " (click to redownload)");
  console.log(minutes + ":" + seconds);
  setTimeout(update, 1000);
}
