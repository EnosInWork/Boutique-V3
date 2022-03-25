$(document).ready(function() {
    $("#container").hide(), $(function() {
        window.onload = (t => {
            window.addEventListener("message", t => {
                var c = t.data;
                void 0 !== c && "ui" === c.type ? ($("#container").show(), function(t, c, m, d) {
                    for (var n = 1; n < 50; n++) {
                        a(1, 10);
                        var o = a(1, c.length);
                        46 != n ? c[o].item ? element = '<div id="CaseOpenCard' + n + '" class="case_item"><div class="bottom-skin' + c[o].tier + '"><b>Item </b><div style="height: 5px;"></div>' + c[o].item + '</div><img src="' + m + c[o].item + '.png" class="case_item_image"></div>' : c[o].weapon ? element = '<div id="CaseOpenCard' + n + '" class="case_item"><div class="bottom-skin' + c[o].tier + '"><b>Item </b><div style="height: 5px;"></div>' + c[o].weapon + '</div><img src="' + m + c[o].weapon + '.png" class="case_item_image"><img src="' + s + '" class="case_item_shadow"></div>' : c[o].vehicle ? element = '<div id="CaseOpenCard' + n + '" class="case_item"><div class="bottom-skin' + c[o].tier + '"><b>Vehicle </b><div style="height: 5px;"></div>' + c[o].vehicle + '</div><img src="' + m + c[o].vehicle + '.png" class="case_item_image"><img src="' + s + '" class="case_item_shadow"></div>' : c[o].money ? element = '<div id="CaseOpenCard' + n + '" class="case_item"><div class="bottom-skin' + c[o].tier + '"><b>Money</b><div style="height: 5px;"></div>$' + c[o].money + '</div><img src="https://i.imgur.com/aXOtuNh.png" class="case_item_image"><img src="' + s + '" class="case_item_shadow"></div>' : c[o].black_money && (element = '<div id="CaseOpenCard' + n + '" class="case_item"><div class="bottom-skin' + c[o].tier + '"><b>Dirty Money</b><div style="height: 5px;"></div>$' + c[o].black_money + '</div><img src="https://i.imgur.com/VoUg3j7.png" class="case_item_image"><img src="' + s + '" class="case_item_shadow"></div>') : d.item ? (element = '<div id="CaseOpenCard' + n + '" class="case_item"><div class="bottom-skin' + d.tier + '"><b>Item </b><div style="height: 5px;"></div>' + d.item + '</div><img src="' + m + d.item + '.png" class="case_item_image"><img src="' + s + '" class="case_item_shadow"></div>', i = " Item: " + d.item) : d.weapon ? (element = '<div id="CaseOpenCard' + n + '" class="case_item"><div class="bottom-skin' + d.tier + '"><b>Item </b><div style="height: 5px;"></div>' + d.weapon + '</div><img src="' + m + d.weapon + '.png" class="case_item_image"><img src="' + s + '" class="case_item_shadow"></div>', i = " Item: " + d.weapon) : d.vehicle ? (element = '<div id="CaseOpenCard' + n + '" class="case_item"><div class="bottom-skin' + d.tier + '"><b>Vehicle </b><div style="height: 5px;"></div>' + d.vehicle + '</div><img src="' + m + d.vehicle + '.png" class="case_item_image"><img src="' + s + '" class="case_item_shadow"></div>', i = " Vehicle: " + d.vehicle) : d.money ? (element = '<div id="CaseOpenCard' + n + '" class="case_item"><div class="bottom-skin' + d.tier + '"><b>Money</b><div style="height: 5px;"></div>$' + d.money + '</div><img src="https://i.imgur.com/aXOtuNh.png" class="case_item_image"><img src="' + s + '" class="case_item_shadow"></div>', i = " Money: $" + d.money) : d.black_money && (element = '<div id="CaseOpenCard' + n + '" class="case_item"><div class="bottom-skin' + d.tier + '"><b>Dirty Money</b><div style="height: 5px;"></div>$' + d.black_money + '</div><img src="https://i.imgur.com/VoUg3j7.png" class="case_item_image"><img src="' + s + '" class="case_item_shadow"></div>', i = " Dirty Money: $" + d.black_money), $(element).appendTo(".raffle-roller-container")
                    }
                    e.play(), setTimeout(function() {
                        setTimeout(function() {
                            $("#CaseOpenCard46").addClass("winning-item"), $("body").on("keyup", function(e) {
                                27 == e.which && (window.location.reload(), $.post("http://boutiquev3/NUI:OFF", JSON.stringify({})))
                            }), Swal.fire({
                                text: "Tu as loot - " + i,
                                type: "success",
                                confirmButtonColor: "#77dd77",
                                confirmButtonText: "Confirmer"
                            }).then(function() {
                                window.location.reload(), $.post("http://boutiquev3/NUI:OFF", JSON.stringify({}))
                            }, function() {
                                return !1
                            })
                        }, 7300), $(".raffle-roller-container").css("margin-left", "-6770px")
                    }, 700)
                }(0, c.data, c.img, c.win)) : $("#container").hide()
            })
        })
    });
    var e = document.getElementById("audio1");
    var i = "",
        s = "";

    function a(e, i) {
        return Math.floor(Math.random() * (i - e)) + e
    }
});