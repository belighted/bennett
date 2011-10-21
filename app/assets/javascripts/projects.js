function reload_projects(params){
  reload_resource("/projects.js", "#projects-summary", params);
}

function reload_builds(params){
  var url = "/projects/"+params["id"]+".js";
  reload_resource(url, "#builds-list", params);
}