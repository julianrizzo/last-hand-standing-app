function InitialiseMatch($container) {
	var $match = $container.find(".ui-match");
	var defaultOption = $match.data("default");
	
	var $countdown = $container.find(".ui-countdown");

	var hasChosen = false;

	CreateCountdown($countdown, 15).done(function() {
		if (hasChosen == false) {
			$countdown.text("OUT OF TIME");

            ShowWaiting($container);
            SendChoice(defaultOption);
		} else {
            $countdown.text("PLAYER SELECTED SOMETHING");
        }
	});

	var $options = $container.find(".ui-option");

	$options.click(function(e) {
		hasChosen = true;
		var $option = $(e.currentTarget);
		var option = $option.data("option");

        ShowWaiting($container);
        SendChoice(option);
	});
}

function SendChoice(choice) {
	var data = {
		choice: choice
	};

	SendMessage("submitChoice", data);
}

function ShowWaiting($container) {
    var $match = $container.find(".ui-match");
    var $waiting = $container.find(".ui-waiting");

    $match.addClass("hidden");
    $waiting.removeClass("hidden");
}
