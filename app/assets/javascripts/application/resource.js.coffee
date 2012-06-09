class window.Resource
  reload: (url, element, params) ->
    setTimeout(
      () =>
        $("#autoreload-status").addClass("loading")
        $.ajax
          url: url
          data: params
          dataType: "html"
          ifModified: true
          success: (data, textStatus) =>
            if(textStatus == "success")
              $(element).html(data)
            $("#autoreload-status").html("Refreshed at <span>"+new Date().toTimeString().split(" ")[0]+"</span>")
            $("#autoreload-status").removeClass("aloading").removeClass("hide")
            @reload(url, element, params)
          error: () =>
            setTimeout(() =>
              @reload(url, element, params)
            , 2000)
      , 3000)
