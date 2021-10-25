open Opium

let ( let* ) = Lwt.bind

let get_message req = 
  let id = Router.param req "id" in
  let* message = Storage.select id in
  message 
  |> [%to_yojson: Queries.message]
  |> Response.of_json 
  |> Lwt.return

let post_message req = 
  let* req_json = Request.to_json_exn req in
  let req_message =
    match Storage.message_of_yojson req_json with
    | Ok message -> message
    | Error error -> failwith error
  in
  let* id = Storage.insert req_message in
  ignore id;
  Response.of_plain_text "ok" |> Lwt.return 
  (* id 
  |> [%to_yojson: Storage.message_id]
  |> Response.of_json 
  |> Lwt.return *)

let init_server = 
  App.empty 
  |> App.get "/message/:id" get_message
  |> App.post "/message" post_message
  |> App.run_multicore