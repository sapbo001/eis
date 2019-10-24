	// Gnb Style	
jQuery(function($){
	$(".container section:not("+$("#gnb ul li a.active").attr("href")+")").hide();
	$("#gnb ul li a").click(function(){
		$("#gnb ul li a").removeClass("active");
		$(this).addClass("active");
		$(".container section").hide();
		$($(this).attr("href")).show();
		return false;
	});
});

/*	// Snb Style
jQuery(function($){
	$(".container section:not("+$(".snb ul li a.selected").attr("href")+")").hide();
	$(".snb ul li a").click(function(){
		$(".snb ul li a").removeClass("selected");
		$(this).addClass("selected");
		$(".container section").hide();
		$($(this).attr("href")).show();
		return false;
	});
});*/

	
	// Tab Style
jQuery(function($){
	$("ul.panel li:not("+$("ul.tab li a.selected").attr("href")+")").hide();
	$("ul.tab li a").click(function(){
		$("ul.tab li a").removeClass("selected");
		$(this).addClass("selected");
		$("ul.panel li").hide();
		$($(this).attr("href")).show();
		return false;
	});
});

	// Accordion Style
jQuery(function($){
	$("dl.accor-con dd:not(:first)").css("display","none");
	$("dl.accor-con dt:first").addClass("selected");
	$("dl.accor-con dt").click(function(){
		if($("+dd",this).css("display")=="none"){
			$("dd").slideUp("slow");
			$("+dd",this).slideDown("slow");
			$("dt").removeClass("selected");
			$(this).addClass("selected");
		}
	}).mouseover(function(){
		$(this).addClass("over");
	}).mouseout(function(){
		$(this).removeClass("over");
	});
});

