var update_state = function (region, done) {
  'use strict';

  var country = $('span#' + region + 'country .select2').select2('val');
  var state_select = $('span#' + region + 'state select.select2');
  var state_input = $('span#' + region + 'state input.state_name');



  $.get(Spree.routes.states_search + '?country_id=' + country, function (data) {
    var states = data.states;

    if (states.length > 0) {
      state_select.html('');
      var states_with_blank = [{
        name: '',
        id: ''
      }].concat(states);

      $.each(states_with_blank, function (pos, state) {
        var opt = $(document.createElement('option'))
          .prop('value', state.id)
          .html(state.name);
        state_select.append(opt);
      });
      state_select.prop('disabled', false).show();
      state_select.select2();
      state_input.hide().prop('disabled', true);

    } else {
      state_input.prop('disabled', false).show();
      state_select.select2('destroy').hide();
    }

    if(done) done();
  });
};

var update_constituency = function (region, done) {
    'use strict';

    var constituency_select = $('span#' + region + 'constituency select.select2');
    var state = $('span#state .select2').select2('val');

    // Spree.routes.constituencies = '/api/v1/get_constituencies';

    //$.get(Spree.routes.constituencies + '?state_id=' + state, function (data) {

    $.ajax({
        url: '/get_constituencies',
        data: {state_id: state},
        method: 'GET',
        success: function (data) {
            var constituencies = data.constituencies;

            console.log(constituencies)
            if (constituencies.length > 0) {
                constituency_select.html('');
                var constituencies_with_blank = [{
                    name: '',
                    id: ''
                }].concat(constituencies);

                $.each(constituencies_with_blank, function (pos, state) {
                    console.log(state)
                    var opt = $(document.createElement('option'))
                        .prop('value', state.id)
                        .html(state.name);
                    constituency_select.append(opt);
                });
                constituency_select.prop('disabled', false).show();
                constituency_select.select2();

            } else {
                //state_input.prop('disabled', false).show();
                constituency_select.select2('destroy').hide();
            }

            if(done) done();
        }
    });

};


var update_location = function (region, done) {
    'use strict';

    var location_select = $('span#' + region + 'location select.select2');
    var constituency = $('span#constituency .select2').select2('val');

    $.ajax({
        url: '/get_locations',
        data: {constituency_id: constituency},
        method: 'GET',
        success: function (data) {
            var locations = data.locations;

            console.log(locations)

            if (locations.length > 0) {
                location_select.html('');
                var locations_with_blank = [{
                    name: '',
                    id: ''
                }].concat(locations);

                $.each(locations_with_blank, function (pos, state) {
                    console.log(state)
                    var opt = $(document.createElement('option'))
                        .prop('value', state.id)
                        .html(state.name);
                    location_select.append(opt);
                });
                location_select.prop('disabled', false).show();
                location_select.select2();

            } else {
                //state_input.prop('disabled', false).show();
                location_select.select2('destroy').hide();
            }

            if(done) done();
        }
    });

};