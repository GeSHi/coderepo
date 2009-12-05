$(document).ready(function() {
  // generate markup
  $("#rating").append("Please rate: ");
  
  for ( var i = 1; i <= 5; i++ )
    $("#rating").append("<a href='#'>" + i + "</a> ");
  
  // add markup to container and apply click handlers to anchors
  $("#rating a").click(function(e){
    // stop normal link click
    e.preventDefault();
    
    // send request
    $.post("rate.php", {rating: $(this).html()}, function(xml) {
      // format and output result
      $("#rating").html(
        "Thanks for rating, current average: " +
        $("average", xml).text() +
        ", number of votes: " +
        $("count", xml).text()
      );
    });
  });
});
