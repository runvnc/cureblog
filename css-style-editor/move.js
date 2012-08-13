var vToolboxInitialYLocation;
var oBox;

function initialize_toolbox_variables(){
	oBox = document.getElementById("tool_box_area");
	vToolboxInitialYLocation = findPosY(oBox);
	if (document.createEvent) {
		var tptEvent = document.createEvent("Events");
		tptEvent.initEvent("tptChanged", false, false, window, null);
		document.dispatchEvent(tptEvent);
	}
}

function move_box(){
	var top = (document.documentElement && document.documentElement.scrollTop) ? document.documentElement.scrollTop : document.body.scrollTop;

	if(top > vToolboxInitialYLocation){
		oBox.style.marginTop = (top - vToolboxInitialYLocation+10)+"px";
	}else{
		oBox.style.marginTop = "0px";
	}
	
}

function findPosY(obj) {
	var curleft = curtop = 0;
	if (obj.offsetParent) {
		curleft = obj.offsetLeft
		curtop = obj.offsetTop
		while (obj = obj.offsetParent) {
			curleft += obj.offsetLeft
			curtop += obj.offsetTop
		}
	}
	return curtop;
}