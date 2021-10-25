let connection_pg_url = "postgresql://postgres:postgres@localhost:5432"

type message = { message : string } [@@deriving yojson]
type message_stored = { id: string; message : string } [@@deriving yojson]
type message_id = { id: string } [@@deriving yojson]

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

let insert ({ message }: message) =
  let id = Uuidm.create(`V4) |> Uuidm.to_string in
  dispatch ( Queries.insert { id; message } )
  |> Lwt.return

let select id = 
  let* message = dispatch (Queries.select ~id) in
  message |> Lwt.return

let () = dispatch (Queries.ensure_table_exists ()) |> Lwt_main.run