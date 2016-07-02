$(document).on('page:change', function() {
  'use strict';

  var $index = $('main');
  var $form = $index.find('form');
  var $submit = $form.find('.submit-xlsx-file');
  var $file_name_description = $form.find('.file-name-description');
  var $input_file = $form.find('#xlsx').on('change', change_selected_file);

  function change_selected_file() {
    var file_name = extract_file_name($input_file.val());
    var not_empty = !!file_name;

    $submit.attr('disabled', !not_empty);

    $file_name_description
      .text(not_empty ? file_name : 'No valid file was selected')
      .toggleClass('text-danger', !not_empty)
      .toggleClass('text-success', not_empty);
  }

  function extract_file_name(full_name) {
    if (!full_name)
      return null;

    return full_name.trim().replace(/^(.*?)([^\\|\/]+\.xlsx)?$/i, '$2')
  }
});