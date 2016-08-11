function CreateCountdown($element, startingSeconds) {
	var def = $.Deferred();

	var currentSeconds = startingSeconds;
	var currentMilliSeconds = 0;
	var inDanger = false;

	var timer = setInterval(function () {

		if (currentSeconds >= 0) {
			currentMilliSeconds--;

			if (currentMilliSeconds <= 0) {
				currentMilliSeconds = 60;
				currentSeconds--;
			}

			if (!inDanger && currentSeconds <= 3) {
				inDanger = true;
				$element.addClass("danger");
			}

			var milli = currentMilliSeconds < 10 ? "0" + currentMilliSeconds : currentMilliSeconds;

			$element.text(currentSeconds + ":" + milli);
		} else {
			clearInterval(timer);
			def.resolve();
		}

	}, 10);

	return def.promise();
}