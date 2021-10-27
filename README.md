# ocaml-pastebin

## endpoints 

* **url** 
  
  /message/:id

* **method**
  `GET`

* **url params**
  `id=[string]`  

* **sucess response:** 
  * **Code:** 200 <br />
  **Content:** `{ message : "bla bla bla" }` 

* **error response:** 
  * no response (temporary, maybe)
 
------

* **url** 
  
  /message
  
* **method**
  `POST`

* **url params**

  None  

* **data params**

  `{ message: "WOOF WOOF WOOF WOOF" }`  

* **sucess response:** 
  * **Code:** 200 <br />
  **Content:** `{ link : "http:url/id" }` 

* **error response:** 
  * no response (temporary, maybe)