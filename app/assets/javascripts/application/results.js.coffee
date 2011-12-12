class window.Results
  reload: (params) ->
    resource = new Resource()
    url = "/projects/"+params["project_id"]+"/builds/"+params["build_id"]+"/results/"+params["id"]+".js";
    resource.reload(url, "#result-details", params)