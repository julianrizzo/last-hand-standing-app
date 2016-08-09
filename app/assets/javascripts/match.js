function InitialiseMatch($container) {
	var $countdown = $container.find(".ui-countdown");

	CreateCountdown($countdown, 10).done(() => {
		$countdown.text("OUT OF TIME");
	});
}



		
