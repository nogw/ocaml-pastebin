open Opium

type message = {
  id: string;
  message: string;
} [@@deriving yojson]

let connection_pg_url = "postgresql://postgres:password@localhost:5432"

exception Query_Error of string

let ( let* ) = Lwt.bind

let pool = 
  match Caqti_lwt.connect_pool ~max_size: 10 (Uri.of_string connection_pg_url) with
  | Ok pool -> pool
  | Error error -> failwith (Caqti_error.show error)

let dispatch f =
  let* result = Caqti_lwt.Pool.use f pool in
  match result with
  | Ok data -> Lwt.return data
  | Error error -> Lwt.fail (Query_Error (Caqti_error.show error))

let () = dispatch (Queries.ensure_table_exists ()) |> Lwt_main.run

let get_message _req = 
  Response.of_plain_text "Hello World" |> Lwt.return

let post_message _req = 
  Response.of_plain_text "Hello World" |> Lwt.return

let init_server = 
  App.empty 
  |> App.get "/message/:id" get_message
  |> App.post "/message" post_message
  |> App.run_multicore