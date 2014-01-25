  $.setAjaxPagination = function(update_id) {
    return $('.pagination a').click(function(event) {
      $('.pagination a').off('click');
      event.preventDefault();
      $('#spinner').fadeIn();
      $.ajax({
        type: 'GET',
        url: $(this).attr('href'),
        dataType: 'html',
        success: (function(response) {
          $(update_id).html(response);
          $('#spinner').fadeOut();
          $.setAjaxPagination(update_id);
        })
      });
      return false;
    });
  };

$.getHtml = function(url, update_fn) {
  $.ajax({
          url: url,
          dataType: 'html',
          success: update_fn
        });
}