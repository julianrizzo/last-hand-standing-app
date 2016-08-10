function InitialiseMatch($container) {
	var $default = $container.find(".ui-default");
	var defaultOption = $default.data("default");
	
	var $countdown = $container.find(".ui-countdown");

	CreateCountdown($countdown, 10).done(() => {
		$countdown.text("OUT OF TIME");

		alert("times up, we selected: '" + defaultOption + "' for you");
	});

	var $options = $container.find(".ui-option");

	$options.click((e) => {
		var $option = $(e.currentTarget);
		var option = $option.data("option");

		alert("you selected: '" + option + "'");
	});
}



		
