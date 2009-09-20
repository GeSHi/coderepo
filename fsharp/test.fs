#light

open System

/* 99% of examples from http://tomasp.net/ */

let tuple = (42, "Hello world!")
let (num, str) = tuple

// Declaration of the 'Expr' type
  type Expr = 
  | Binary   of string * Expr * Expr
  | Variable of string 
  | Constant of int;;


let rec eval x =
    match x with
    | Binary(op, l, r) ->
        let (lv, rv) = (eval l, eval r)
        if   (op = "+") then lv + rv 
        elif (op = "-") then lv - rv 
        else failwith "Unknonw operator!"
    | Variable(var) -> 
        getVariableValue var
    | Constant(n) ->
        n;;


// Declaration of a record type
type Product = { Name:string; Price:int }

// Constructing a value of the 'Product' type
let p = { Name="Test"; Price=42; };;

// Creating a copy with different 'Name'
let p2 = { p with Name="Test2" };;


let nums = [1; 2; 3; 4; 5];;
let rec sum list = 
    match list with
    | h::tail -> (sum tail) + h
    | [] -> 0


let createAdder n = (fun arg -> n + arg);;

let odds = List.filter (fun n -> n % 2 <> 0) [1; 2; 3; 4; 5];;

(fst >> String.uppercase) ("Hello world", 123);;

// Imperative factorial calculation
let n = 10
let mutable res = 1
for n = 2 to n do
    res <- res * n    
res

let arr = [| 1 .. 10 |]

[ for (name, age) in people -> name ];;

let rec generateWords letters start len =
    seq { for l in letters do
            let word = (start ^ l)
            if len = 1 then
              yield  word
            if len > 1 then
              yield! generateWords letters word (len-1) }


type MyCell(n:int) =
  let mutable data = n + 1
  do  printf "Creating MyCell(%d)" n

  member x.Data 
    with get()  = data
    and  set(v) = data <- v
    
  member x.Print() = 
    printf "Data: %d" data
    
  override x.ToString() = 
    sprintf "(Data: %d)" data
    
  static member FromInt(n) = 
    MyCell(n)


type AnyCell = 
  abstract Value : int with get, set
  abstract Print : unit -> unit

type ImplementCell(n:int) =
  let mutable data = n + 1  
  interface AnyCell with
    member x.Print() = printf "Data: %d" data
    member x.Value 
      with get() = data 
      and set(v) = data <- v


let newCell n =
    let data = ref n
    { new AnyCell with
      member x.Print() = printf "Data: %d" (!data)
      member x.Value 
        with get() = !data
        and set(v) = data:=v };;

let (|Commutative|_|) x =
    match x with
    | Binary(s, e1, e2) when (s = "+") || (s = "*") -> Some(s, e1, e2)
    | _ -> None;;


let rec equal e1 e2 = 
    match e1, e2 with
    | Commutative(o1, l1, r1), Commutative(o2, l2, r2) ->
       (o1 = o2) && (equal l1 r2) && (equal r1 l2)
    | _ -> e1 = e2;;

let task = 
  async {
    let! x = System.Threading.Thread.AsyncSleep(0)
    return 5
  }

