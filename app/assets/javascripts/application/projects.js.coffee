class window.Projects
  reload_projects: (params) ->
    resource = new Resource()
    resource.reload("/projects.js", "#projects-summary", params)

  reload_builds : (params) ->
    resource = new Resource()
    url = "/projects/"+params["id"]+".js"
    resource.reload(url, "#builds-list", params)

$ ->
  $('select.right-role-select, select.invitation-role-select').change (e) ->
    $(e.target).closest('form').submit()