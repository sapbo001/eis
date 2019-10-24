
	// samplebutton
	$(function() {
		$("#samplebutton").click(function(){
		var branches = $("<li><span class='folder'>New Sublist</span><ul>" + 
			"<li><span class='file'>Item1</span></li>" + 
			"<li><span class='file'>Item2</span></li></ul></li>").appendTo("#browser");
		$("#browser").treeview({
			add: branches
		});
	});
	
	// filetree
	$(function() {
		$("#browser").treeview({
	    collapsed: true,
		animated: "fast",
		persist: "cookie"
		});
	});	



});