/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

import Lean

/-! Build-only, fail-closed structural export of the pinned retained API. -/

open Lean

namespace RetainedExport

def nameJson : Name → Json
  | .anonymous => .arr #[.str "anonymous"]
  | .str parent part => .arr #[.str "str", nameJson parent, .str part]
  | .num parent part => .arr #[.str "num", nameJson parent, toJson part]

def levelJson : Level → Except String Json
  | .zero => pure (.arr #[.str "zero"])
  | .succ u => return .arr #[.str "succ", ← levelJson u]
  | .max u v => return .arr #[.str "max", ← levelJson u, ← levelJson v]
  | .imax u v => return .arr #[.str "imax", ← levelJson u, ← levelJson v]
  | .param n => pure (.arr #[.str "param", nameJson n])
  | .mvar _ => .error "unresolved universe metavariable"

def binderJson : BinderInfo → Json
  | .default => .str "explicit"
  | .implicit => .str "implicit"
  | .strictImplicit => .str "strictImplicit"
  | .instImplicit => .str "instanceImplicit"

def exprJson (expr : Expr) (depth : Nat := 0) : Except String Json := do
  match expr with
  | .bvar i =>
    if i < depth then return .arr #[.str "bvar", toJson i]
    else throw "unbound de Bruijn index"
  | .fvar _ => throw "unresolved free variable"
  | .mvar _ => throw "unresolved expression metavariable"
  | .sort u => return .arr #[.str "sort", ← levelJson u]
  | .const n levels =>
    return .arr #[.str "const", nameJson n, toJson (← levels.mapM levelJson)]
  | .app fn arg =>
    return .arr #[.str "app", ← exprJson fn depth, ← exprJson arg depth]
  | .lam name type body info =>
    return .arr #[.str "lambda", nameJson name, binderJson info,
      ← exprJson type depth, ← exprJson body (depth + 1)]
  | .forallE name type body info =>
    return .arr #[.str "forall", nameJson name, binderJson info,
      ← exprJson type depth, ← exprJson body (depth + 1)]
  | .letE name type value body nondep =>
    return .arr #[.str "let", nameJson name, toJson nondep,
      ← exprJson type depth, ← exprJson value depth, ← exprJson body (depth + 1)]
  | .lit (.natVal n) => return .arr #[.str "natLiteral", toJson n]
  | .lit (.strVal s) => return .arr #[.str "stringLiteral", .str s]
  | .mdata _ _ => throw "expression metadata requires an explicitly reviewed encoding"
  | .proj typeName index value =>
    return .arr #[.str "projection", nameJson typeName, toJson index, ← exprJson value depth]
termination_by expr

def liftResult (result : Except String α) : IO α :=
  match result with
  | .ok value => pure value
  | .error message => throw (IO.userError message)

def exportEntry (env : Environment) (entry : Json) : IO Json := do
  let requested ← liftResult ((← liftResult (entry.getObjVal? "name")).getStr?)
  let sourceKind ← liftResult ((← liftResult (entry.getObjVal? "kind")).getStr?)
  let sourceOwner ← liftResult ((← liftResult (entry.getObjVal? "module")).getStr?)
  let name := requested.toName
  let some info := env.find? name | throw (IO.userError s!"missing retained declaration: {requested}")
  let some moduleIdx := env.getModuleIdxFor? name
    | throw (IO.userError s!"missing owner: {requested}")
  let owner := env.allImportedModuleNames[moduleIdx]!.toString
  unless owner == sourceOwner do
    throw (IO.userError s!"owner mismatch for {requested}: {sourceOwner} / {owner}")
  let compiledKind ← match info with
    | .thmInfo _ => pure "theorem"
    | .defnInfo _ => pure "definition"
    | _ => throw (IO.userError s!"unsupported retained declaration kind: {requested}")
  let type ← match exprJson info.type with
    | .ok value => pure value
    | .error message => throw (IO.userError s!"{requested}: {message}")
  return Json.mkObj [
    ("name", .str requested), ("source_kind", .str sourceKind),
    ("compiled_kind", .str compiledKind), ("owner", .str owner),
    ("universe_parameters", toJson (info.levelParams.map nameJson)), ("type", type)]

end RetainedExport

def main (args : List String) : IO Unit := do
  let [manifestPath] := args
    | throw (IO.userError "usage: lake env lean --run ExportRetained.lean <frozen-manifest.json>")
  let manifest ← RetainedExport.liftResult (Json.parse (← IO.FS.readFile manifestPath))
  let entries ← RetainedExport.liftResult
    ((← RetainedExport.liftResult (manifest.getObjVal? "declarations")).getArr?)
  if entries.isEmpty then throw (IO.userError "empty retained manifest")
  initSearchPath (← findSysroot)
  let env ← importModules #[{ module := `LeanInfoTheory.Shannon }] {}
  let records ← entries.mapM (RetainedExport.exportEntry env)
  let output := Json.mkObj [("schema", .str "lean-info-theory.retained-types.v1"),
    ("declarations", .arr records)]
  IO.println output.compress
