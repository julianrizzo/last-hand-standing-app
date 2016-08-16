function InitialiseInputs($container) {
	var $inputs = $container.find("input[type='text']");

	if ($inputs.length > 0) {
		// if the input has text already in it, move the label
		$inputs.each(function(index, element) {
			var $input = $(element);
			var $label = $input.siblings("label");

			if ($input.val().length > 0) {
				$label.addClass("open");
			}
		});

		// when the input gains focus, move the label
		$inputs.focus(function(e) {
			var $input = $(e.currentTarget);
			var $label = $input.siblings("label");
			
			$label.addClass("open");
		});

		// whent eh input loses focus, if nothing was entered, put back the label
		$inputs.blur(function(e) {
			var $input = $(e.currentTarget);
			var $label = $input.siblings("label");
			
			if ($input.val().length === 0) {
				$label.removeClass("open");
			}
		});
	}
}