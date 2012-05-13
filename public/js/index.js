(function() {

  $(function() {
    return now.ready(function() {
      return now.dbfind('backups', function(backups) {
        var b, li, outp, _i, _len, _results;
        console.log('I found the backups');
        outp = '';
        $('#backups').html('<ul id="bulist"></ul>');
        _results = [];
        for (_i = 0, _len = backups.length; _i < _len; _i++) {
          b = backups[_i];
          li = $("<li class=\"restore\">" + b.col + " " + b.modified + " " + b.status + "</li>");
          li.data('_id', b._id);
          li.click(function() {
            return now.dbrestore(li.data('_id'));
          });
          _results.push($('#bulist').append(li));
        }
        return _results;
      });
    });
  });

}).call(this);
