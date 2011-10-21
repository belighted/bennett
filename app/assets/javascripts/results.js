function reload_result(params){
  var url = "/projects/"+params["project_id"]+"/builds/"+params["build_id"]+"/results/"+params["id"]+".js";
  reload_resource(url, "#result-details", params);
}