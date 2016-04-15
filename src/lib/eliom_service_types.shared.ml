(* Ocsigen
 * http://www.ocsigen.org
 * Copyright (C) 2016 Vasilis Papavasileiou
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, with linking exception;
 * either version 2.1 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
*)

(* This module only contains types. It exists to avoid repeating the
   GADT "formalization" in multiple signatures and modules. *)

type get = Get_method
type put = Put_method
type post = Post_method
type delete = Delete_method

type co = Co
type non_co = Non_co

type ext = Ext
type non_ext = Non_ext

type http = Http_ret
type appl = Appl_ret

type 'a ocaml = Ocaml_ret of 'a
type 'a non_ocaml = Non_ocaml_ret of 'a

type reg = Reg
type non_reg = Non_reg

type ('r, 'e) rt =
  | Ocaml  : ('r ocaml, ext) rt
  | Http   : (http non_ocaml, ext) rt
  | Appl   : (appl non_ocaml, non_ext) rt
  (* FIXME! temporary to get current registration modules
     working. REMOVE! *)
  | Unsafe : ('a, ext) rt

type ('get, 'tipo, 'gn) params =
  ('get, 'tipo, 'gn) Eliom_parameter.params_type
  constraint 'tipo = [< `WithSuffix | `WithoutSuffix ]

(**
   - 0-th param : method
   - params 1-4 : GET and POST param types
   - param 5    : with/without suffix
   - param 6    : method for fallback service
   - param 7    : non-unit only for the Post (g, p) case when g != unit ;
                  used to force unit GET parameters when needed
*)
type (_, _, _, _, _, _, _, _) meth =

  | Get : ('gp, 'tipo, 'gn) params ->

    (get, 'gp, 'gn, unit, unit, 'tipo, get, unit) meth

  | Post : ('gp, 'tipo, 'gn) params *
           ('pp, [`WithoutSuffix], 'pn) params ->

    (post, 'gp, 'gn, 'pp, 'pn, 'tipo, get, 'gp) meth

  | Put : ('gp, 'tipo, 'gn) params ->

    (put, 'gp, 'gn, unit, unit, 'tipo, put, unit) meth

  | Delete : ('gp, 'tipo, 'gn) params ->

    (delete, 'gp, 'gn, unit, unit, 'tipo, delete, unit) meth

(** Like [meth] but without the auxilliary parameters; used to query
    about the service method from outside. *)
type _ which_meth =
  | Get'    : get which_meth
  | Post'   : post which_meth
  | Put'    : put which_meth
  | Delete' : delete which_meth