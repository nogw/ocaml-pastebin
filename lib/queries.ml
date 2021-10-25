type message = {
  id: string;
  message: string;
} [@@deriving yojson]

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

let create_pastebin =
  [%rapper
    execute
    {sql|
      INSERT INTO pastebins (id, message)
      VALUES (%string{id}, %string{message})
    |sql}
    record_in
  ]

let get_pastebin =
  [%rapper
    get_opt
    {sql|
      SELECT @string{id}, @string{message}
      FROM pastebins
      WHERE id = %string{id}
    |sql}
  ]