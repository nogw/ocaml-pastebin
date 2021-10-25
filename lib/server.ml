open Opium

type message = {
  id: string;
  message: string;
} [@@deriving yojson]

let get_message _req = 
  Response.of_plain_text "Hello World" |> Lwt.return

let post_message _req = 
  Response.of_plain_text "Hello World" |> Lwt.return

let init_server = 
  App.empty 
  |> App.get "/message/:id" get_message
  |> App.post "/message" post_message
  |> App.run_multicore