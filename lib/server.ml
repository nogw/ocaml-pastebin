open Opium

type message = {
  id: Uuidm.t;
  message: string;
} [@@deriving yojson]

let get_message req = req

let post_message req = req'

let init_server = 
  App.empty 
  |> App.get "/message/:id" get_message
  |> App.post "/message" post_message
  |> App.run_multicore