function InitialiseInputs($container) {
	var $inputs = $container.find("input[type='text']");

	if ($inputs.length > 0) {
		$inputs.each(function(index, element) {
			if (element.value.length > 0) {
				$(element).addClass("open");
			}
		});


		$inputs.focus(function(e) {
			var $input = $(e.currentTarget);
			$input.addClass("open");
		});

		$inputs.blur(function(e) {
			var $input = $(e.currentTarget);
			if ($input.val().length === 0) {
				$input.removeClass("open");
			}
		});
	}
}