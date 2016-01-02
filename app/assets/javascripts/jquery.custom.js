$.fn.pulse = function(options) {

    var options = $.extend({
        times: 3,
        duration: 250
    }, options);

    var period = function(callback) {
        $(this).animate({opacity: 0}, options.duration, function() {
            $(this).animate({opacity: 1}, options.duration, callback);
        });
    };
    return this.each(function() {
        var i = +options.times, self = this,
        repeat = function() { --i && period.call(self, repeat) };
        period.call(this, repeat);
    });
};

$.fn.highlight = function() {
   $(this).each(function() {
        var el = $(this);
        el.before("<div/>")
        el.prev()
            .width(el.width())
            .height(el.height())
            .css({
                "position": "absolute",
                "background-color": "#ffff99",
                "opacity": ".9"   
            })
            .fadeOut(500);
    });
}
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

$.setsortHeader = function() {
  return $('table.sortable th').click(function(event) {
    $('th.active').removeClass('active').removeClass('sortasc').removeClass('sortdesc');
    sort = $(this).attr('data-sort');
    order = toggleOrder();
  });
}

function toggleOrder() {
  return order == 'asc' ? 'desc' : 'asc';
}

function getPageNo() {
  return parseInt($('.pagination em').text());
}

function getSortedPage() {}

function add_score_ref(score_id) {
  $.ajax({
    url: '/score_refs/new/' + score_id,
    dataType: 'html',
    success: function(response) {
      console.log(response);
      $('#score_refs').show();
      $('#score_refs').append(response);
      $('#new_score_ref_button').hide();
      $('#add_new_score_ref').fadeIn();
    }
  });
}

function add_score_item(score_id) {
  $.ajax({url: '/score_items/new/' + score_id,
    dataType: 'html',
    success: function(response) {
      console.log(response);
      $('#score_items').append(response);
      $('#score_items').show();
      $('#new_score_item_button').hide();
      $('#add_new_score_item').show();
  }})
}

function create_score_ref(score_id) {
  var params = $('#add_new_score_ref :input').serialize();
  params.id = score_id;
  console.log(params);
  $.ajax({url: '/score_refs/create/' + score_id, 
    data: params,
    dataType: 'html',
    method: 'post',
    success: function(response) {
      console.log(response);
      $('#score_refs').append(response);
        $('#create_score_ref_button').remove();
        $('#add_new_score_ref').remove();
        // page.insert_html :bottom, 'score_refs', :partial => 'scores/score_ref'
        $('#new_score_ref_button').show()  
  }})
}

function create_score_item(score_id) {
  console.log('create_score_item');
  var params = $('#add_new_score_item :input').serialize();
  $.ajax({url: '/score_items/create/' + score_id,
    data: params,
    dataType: 'html',
    method: 'post',
    success: function(response) {
      console.log(response);
      $('#score_items').show();
      $('#score_items').append(response);
      $('#new_score_item_button').hide();
      $('#add_new_score_item').fadeIn();
  }})
}


function remove_new_score_item() {
  $('#add_new_score_ref').remove()  //remove both rows for new score ref and the create/cancel buttons            
  $('#create_score_ref_button').remove()
  $('#new_score_ref_button').show();
}

function destroy_score_ref(score_ref_id, title) {
  if (confirm('Vil du fjerne denne fra scoren ' + title + '?')) { 
    $.ajax({url: '/score_refs/' + score_ref_id, dataType: 'json', type: 'delete',
      success: function() {
        $('#score_ref_' + score_ref_id).fadeOut();
      }
    });
    return false; 
    // new Ajax.Updater('score_ref_76', 'https://www.cbcl-sdu.dk/score_refs/76', {asynchronous:true, evalScripts:true, method:'delete'});}; 
    // new Ajax.Updater('score_ref_76', 'https://www.cbcl-sdu.dk/score_refs/76', {asynchronous:true, evalScripts:true, method:'delete'});}; 
  }
}

function destroy_score_item(score_item_id, title) {
  if (confirm('Vil du fjerne denne fra scoren ' + title + '?')) { 
    $.ajax({url: '/score_items/' + score_item_id, dataType: 'json', type: 'delete',
      success: function() {
        $('#score_item_' + score_item_id).fadeOut();
      }
    });
  return false; 
    // new Ajax.Updater('score_item_76', 'https://www.cbcl-sdu.dk/score_items/76', {asynchronous:true, evalScripts:true, method:'delete'});}; 
    // new Ajax.Updater('score_item_76', 'https://www.cbcl-sdu.dk/score_items/76', {asynchronous:true, evalScripts:true, method:'delete'});}; 
  }
}

function cancel_score_item() {
  $('#add_new_score_item').html('')//  # remove both rows for new score ref and the create/cancel buttons            
  $('#create_score_item_button').html('')
  $('#new_score_item_button');
}

function cancel_score_ref() {
  $('#add_new_score_ref').html('')//  # remove both rows for new score ref and the create/cancel buttons            
  $('#create_score_ref_button').html('')
  $('#new_score_ref_button');
}
