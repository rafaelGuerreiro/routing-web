$(function() {
  'use strict';
  let $index, $form, $submit, $file_name_description, $input_file;

  $index = $('main');
  $form = $index.find('form');
  $submit = $index.find('.submit-xlsx-file');
  $file_name_description = $index.find('.file-name-description');
  $input_file = $index.find('#xlsx').on('change', change_selected_file);

  function change_selected_file() {
    let file_name = extract_file_name($input_file.val());
    let not_empty = !!file_name;

    $submit.attr('disabled', !not_empty);

    $file_name_description
      .text(not_empty ? file_name : 'No valid file was selected')
      .toggleClass('text-danger', !not_empty)
      .toggleClass('text-success', not_empty);
  }

  function extract_file_name(full_name) {
    if (!full_name)
      return null;

    return full_name.trim().replace(/^(.*?)([^\\|\/]+\.xlsx)?$/i, "$2")
  }
});