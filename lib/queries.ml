type message = { message : string } [@@deriving yojson]
type message_stored = { id: string; message : string } [@@deriving yojson]

let ensure_table_exists =
  [%rapper
    execute
    {sql|
      CREATE TABLE IF NOT EXISTS pastebins (
        id uuid PRIMARY KEY NOT NULL,
        message VARCHAR
      )
    |sql}
  ]

let insert =
  [%rapper
    get_one
    {sql|
      INSERT INTO pastebins (id, message)
      VALUES (%string{id}, %string{message});
      SELECT SCOPE_IDENTITY
    |sql}
  ]

let select =
  [%rapper
    get_one
    {sql|
      SELECT @string{message}
      FROM pastebins
      WHERE id = %string{id}
    |sql}
    record_out
  ]