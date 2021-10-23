open Opium

let init_server = 
  App.empty 
  |> App.port 4000
  |> App.run_multicore