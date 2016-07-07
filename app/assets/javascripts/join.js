function InitialiseJoin($container) {
    var $form = $container.find("#joinform");
    var $button = $container.find("#joinbutton");

    $button.click(function() {
        $form.submit();
    });
}