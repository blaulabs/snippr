$(function snipprTardisScope() {
  'use strict';
  var tardis = $('#snippr_tardis');

  tardis.find('button.warp').on('click', function (e) {
    e.preventDefault();
    window.location.href = '?snippr_tardis=' + encodeURIComponent(tardis.find('.interval').val());
  });

  tardis.find('button.reset').on('click', function (e) {
    e.preventDefault();
    window.location.href = '?snippr_tardis=0';
  });

  tardis.find('.tardis').on('click', function (e) {
    e.preventDefault();
    tardis.find('.content').toggle();
  });
});
