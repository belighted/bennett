class window.Resource
  reload: (url, element, params) ->
    setInterval(
      () ->
        $("#autoreload-status").addClass("loading")
        $.ajax
          url: url
          data: params
          dataType: "html"
          ifModified: true
          success: (data, textStatus) ->
            if(textStatus == "success")
              $(element).html(data)
            $("#autoreload-status").html("Refreshed at "+new Date().toTimeString().split(" ")[0])
            $("#autoreload-status").removeClass("loading")
      ,
      2000
    )