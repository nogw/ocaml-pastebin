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
    execute
    {sql|
      INSERT INTO pastebins (id, message)
      VALUES (%string{id}, %string{message})
    |sql}
    record_in
  ]

let select =
  [%rapper
    get_opt
    {sql|
      SELECT @string{id}, @string{message}
      FROM pastebins
      WHERE id = %string{id}
    |sql}
  ]