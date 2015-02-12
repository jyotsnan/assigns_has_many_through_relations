// Call this jQuery plugin on a text input field used to filter a ul as the user types
$.fn.quickListFilter = function(options) {
  options = $.extend({
    item: 'li'
  }, options);
  
  return this.each(function() {
    var filter = $(this),
        target = filter.data('target'),
        items = $(target).find(options.item);

    function filterList() {
      items.each(function() {
        var regex = new RegExp(filter.val(), 'i'),
            li = $(this).parent('li');

        if (regex.test(this.innerText)) {
          li.slideDown(200);
        } else {
          li.slideUp(200);
        }
      });
    }

    filter.on('keyup', function(e) {
      if (e.which === 27) { filter.val(null); }
      filterList();
    });
  });
}

// Call this jQuery plugin on an element that you want to show 
// when the target element has scrollbars, and hide if no scrollbars.
// Useful for a down arrow scroll indicator.
$.fn.hideWhenNoScrollBars = function() {
  return this.each(function() {
    var el = $(this),
        target = $(el.data('target'));

    function hideWhenNoScrollbars(target, el) {
      if (target.scrollHeight > target.clientHeight) { // has vertical scrollbars
        el.show();
      } else {
        el.hide();
      }
    }

    $(window).on('resize', function() {
      hideWhenNoScrollbars(target[0], el);      
    });

    hideWhenNoScrollbars(target[0], el);
  });
}

$(function() {
  $('.quick-filter').quickListFilter({ item: 'li label, li a' });
  $('.hide-when-no-scrollbars').hideWhenNoScrollBars();

  // For the (Un)Assign All buttons. Will check all the options and then submit the form.
  $('.check-all-boxes').click(function(e) {
    e.preventDefault();

    var target = this.dataset.target,
        checkMe = $(target);

    checkMe.attr('checked', true);
    $(this).parents('form').submit();
    return false;
  })
});
