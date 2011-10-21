function reload_builds(){
	var builds = $.map($('.build-status-line'), function(e){ return e.id })
	var page = $('.pagination .current').text()
  $.ajax({
    url: "/builds",
    data: { builds: builds, page: page },
    dataType: 'html',
    success: function(data, textStatus) {
	    $('#builds-list').html(data);
    }
  });
}

setInterval(reload_builds, 2000);