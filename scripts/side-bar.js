// JavaScript Document

$("#ascensorFloor1").delegate("#side-bar", "mouseover", function() {
	$(this).animate({
		right: 0,
		width: "slow"
	}, 1000);
	$(this).css("cursor", "pointer");			
});
$("#ascensorFloor1").delegate("#side-bar", "click", function() {
	$(this).animate({
		right: -420,
		width: "slow"
	}, 750);			
});