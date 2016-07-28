function InitialiseGame($container) {

    var $code = $container.find("#code");
    var $playerID = $container.find("#id");
    var $view = $container.find("#view");

    var socket = new WebSocket('ws://' + window.location.host + '/communicate/' + $code.val() + '/' + $playerID.val());

    socket.onmessage = function(message) {
        $view.html(message.data);
    };

    socket.onopen = function() {

    };
}