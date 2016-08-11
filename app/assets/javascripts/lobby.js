function InitialiseLobby($container) {
	$container.find(".ui-play").click(function() {
		SendMessage("play", {})
	});
}