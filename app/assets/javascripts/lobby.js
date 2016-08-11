function InitialiseLobby($container) {
	var code = $container.find(".ui-code").data("code");
	document.title = "Join: " + code;

	$container.find(".ui-play").click(function() {
		SendMessage("play", {})
	});
}