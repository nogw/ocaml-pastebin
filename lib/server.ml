open Opium

let ( let* ) = Lwt.bind

let get_message _req = 
  Response.of_plain_text "Hello World" |> Lwt.return

let post_message req = 
  let* req_json = Request.to_json_exn req in
  let req_message =
    match Storage.message_of_yojson req_json with
    | Ok message -> message
    | Error error -> failwith error
  in
  let* () = Storage.insert req_message in
  Lwt.return (Response.make ~status:`OK ())  

let init_server = 
  App.empty 
  |> App.get "/message/:id" get_message
  |> App.post "/message" post_message
  |> App.run_multicore