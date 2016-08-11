function InitialiseLobby($container) {
	$container.find(".ui-play").click(function() {
		socket.send("play");
	});
}