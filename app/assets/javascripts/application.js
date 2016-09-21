// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require bootstrap-datepicker
//= require jquery_nested_form
//= require_tree .

$(document).ready(function () {
    $('#user_payment_table').DataTable({
        "columnDefs": [
            {"width": "9%", "targets": 0},
            {"width": "7%", "targets": 2},
            {"width": "7%", "targets": 3},
            {"width": "7%", "targets": 4},
            {"width": "13%", "targets": 5},
        ],
        "order": [[0, "desc"]]
    });
});

$(document).ready(function () {
    $('.datepicker').datepicker({
        format: "yyyy-mm-dd",
        todayHighlight: true
    });
});


$(document).ready(function () {
    change_total();
});

// Dynamically updates the totals for the view.
function change_total() {
    var total = 0.0;

    // Setup user totals hash.
    var user_totals = [];
    $("td[id*='user_total']").each(function (i, el) {
        var id = $(el).attr('id').split("_")[2];
        user_totals[id] = 0.0;
    });

    // For each shopping_item.
    $("input[id$='price']").each(function (i, el) {
        var id = $(el).attr('id').split("_")[5];

        // Check which checkboxes are checked. 
        var checked_array = [];
        $("input[id*='" + id + "_payees']").each(function (i, el) {
            if ($(el).is(':checked')) {
                checked_array.push(el);
            }
        });

        // Add to user totals.
        var val = $("input[id$='" + id + "_price']")[0].value / checked_array.length;
        if ($.isNumeric(val)) {
            $.each(checked_array, function (i, el) {
                var checked_id = $(el).attr('id').split("_").slice(-1)[0];
                user_totals[checked_id] += parseFloat(val);
            });
        }

        // Add to grand total.
        if ($.isNumeric(el.value)) {
            total += parseFloat(el.value);
        }
    });

    // Set grand total.
    $('#total').html(total.toFixed(2));

    // Set user totals.
    for (var key in user_totals) {
        $('#user_total_' + key).html(user_totals[key].toFixed(2));
    }
}
