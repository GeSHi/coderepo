jQuery.fn.check = function(mode) {
  // if mode is undefined, use 'on' as default
  var mode = mode || 'on';

  return this.each(function() {
    switch(mode) {
      case 'on':
        this.checked = true;
        break;
      case 'off':
        this.checked = false;
        break;
      case 'toggle':
        this.checked = !this.checked;
        break;
    }
  });
};
