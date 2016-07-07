function InitialiseCreate($container) {
    var $form = $container.find("#createform");
    var $code = $container.find("#code");
    var $create = $container.find(".ui-create");

    $form.submit(function() {
        $code.val(GenerateCode());
    });

    $create.click(function() {
        $form.submit();
    });
}

function GenerateCode() {
    var code = "";
    for (var i = 0; i < 4; i ++) {
        var ascii = GetRandNumber(65, 90);
        code += String.fromCharCode(ascii);
    }

    return code;
}

function GetRandNumber(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
}