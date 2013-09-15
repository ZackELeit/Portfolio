// JavaScript Document
$('#portfolio').ascensor({
	AscensorName: 'ascensor',
	ChildType: 'section',
	AscensorFloorName: 'Design | Web/Game Programming | Mobile Development | About | Home | Contact',
	Time: 1500,
	Easing: 'easeInOutCubic',
	WindowsOn: 5,
	Direction: 'chocolate',
	AscensorMap: '1|1 & 1|2 & 1|3 & 2|1 & 2|2 & 2|3',
	KeyNavigation: false,
	Queued: false,
	QueuedDirection: "x"
});
(function(){

	var button = document.getElementById('cn-button'),
    wrapper = document.getElementById('cn-wrapper');

    //open and close menu when the button is clicked
	var open = false;
	button.addEventListener('click', handler, false);

	function handler(){
	  if(!open){
	    this.innerHTML = "Close";
	    classie.add(wrapper, 'opened-nav');
	  }
	  else{
	    this.innerHTML = "Menu";
		classie.remove(wrapper, 'opened-nav');
	  }
	  open = !open;
	}
	function closeWrapper(){
		classie.remove(wrapper, 'opened-nav');
	}

})();
