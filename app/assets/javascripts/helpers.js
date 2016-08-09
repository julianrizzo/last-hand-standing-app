function CreateCountdown($element, startingSeconds) {
	var def = $.Deferred();

	var currentSeconds = startingSeconds;
	var currentMilliSeconds = 0;

	var timer = setInterval(function () {

		if (currentSeconds > 0) {
			currentMilliSeconds--;

			if (currentMilliSeconds <= 0) {
				currentMilliSeconds = 60;
				currentSeconds--;
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