/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

/-! Build-only fragment appended to the unchanged retained exporter before its main.
The assembled program additionally imports Lean.AutoDecl and Mathlib.Lean.Meta.Simp.
This audit reports compiled facts; Python owns historical/source/policy comparison.
-/

open Lean

namespace CurrentAudit

def field (value : Json) (key : String) : IO Json :=
  RetainedExport.liftResult (value.getObjVal? key)

def stringField (value : Json) (key : String) : IO String := do
  RetainedExport.liftResult ((← field value key).getStr?)

def arrayField (value : Json) (key : String) : IO (Array Json) := do
  RetainedExport.liftResult ((← field value key).getArr?)

def isLocal (name : Name) : Bool := name.getRoot == `LeanInfoTheory

def sortedNames (names : Array Name) : Array Name :=
  names.qsort fun a b => a.toString < b.toString

def namesJson (names : Array Name) : Json := toJson ((sortedNames names).map Name.toString)

def localModules (env : Environment) : Array Name :=
  sortedNames (env.allImportedModuleNames.filter isLocal)

def ownerOf (env : Environment) (name : Name) : IO Name := do
  let some idx := env.getModuleIdxFor? name
    | throw (IO.userError s!"missing imported owner for {name}")
  return env.allImportedModuleNames[idx]!

def pairsJson (pairs : Array (Name × Name)) : Json :=
  toJson ((pairs.qsort fun a b => a.1.toString < b.1.toString).map fun (name, owner) =>
    Json.mkObj [("name", .str name.toString), ("owner", .str owner.toString)])

def inCore (env : Environment) (action : CoreM α) : IO α :=
  action.toIO' { fileName := "CurrentAudit", fileMap := default } { env }

def localConstantPairs (env : Environment) : IO (Array (Name × Name)) := do
  -- Pinned ModuleData.constNames enumerates its kernel constants
  -- (Environment.lean:109-126); finalizeImport populates the actual constant
  -- map from exactly these arrays (2334-2347). extraConstNames are IR-only.
  -- Walk actual local modules, never a requested declaration list, and verify
  -- environment membership/ownership before applying the unchanged classifier.
  unless env.header.moduleData.size == env.allImportedModuleNames.size do
    throw (IO.userError "compiled module data/name coverage mismatch")
  let mut result := #[]
  let mut seen : NameSet := {}
  for h : idx in *...env.header.moduleData.size do
    let owner := env.allImportedModuleNames[idx]!
    if isLocal owner then
      let data := env.header.moduleData[idx]
      unless data.constNames.size == data.constants.size do
        throw (IO.userError s!"compiled constant/name coverage mismatch in {owner}")
      for name in data.constNames do
        unless env.contains name do
          throw (IO.userError s!"compiled module constant missing from environment: {name}")
        unless (← ownerOf env name) == owner do
          throw (IO.userError s!"compiled module/environment owner mismatch for {name}")
        unless seen.contains name do
          seen := seen.insert name
          result := result.push (name, owner)
  return result

def classifyPublic (env : Environment) : IO (Array (Name × Name)) := do
  let constants ← localConstantPairs env
  inCore env do
    let mut result := #[]
    for (name, owner) in constants do
      if !(← isAutoDeclOrPrivate_Internal name) then
        result := result.push (name, owner)
    return result

def pathRecord (buildRoot : System.FilePath) (moduleName : Name) : IO Json := do
  let found ← findOLean moduleName
  let resolved ← IO.FS.realPath found
  let expected ← IO.FS.realPath
    (buildRoot / (moduleName.toString.replace "." "/" ++ ".olean"))
  unless resolved == expected do
    throw (IO.userError s!"foreign local olean for {moduleName}: resolved {resolved}, expected {expected}")
  return Json.mkObj [("module", .str moduleName.toString),
    ("resolved", .str resolved.toString), ("expected", .str expected.toString)]

def checkPaths (buildRoot : System.FilePath) (env : Environment)
    (supported : Array Name) : IO Unit := do
  for moduleName in localModules env do
    unless supported.contains moduleName do
      throw (IO.userError s!"unexpected local module in compiled environment: {moduleName}")
    let _ ← pathRecord buildRoot moduleName

def importsJson (env : Environment) (moduleName : Name) : IO Json := do
  let some idx := env.getModuleIdx? moduleName
    | throw (IO.userError s!"focused module absent from its environment: {moduleName}")
  let imports := env.header.moduleData[idx]!.imports.map (·.module)
  return Json.mkObj [("local", namesJson (imports.filter isLocal)),
    ("external", namesJson (imports.filter fun name => !isLocal name))]

def focusedPublic (env full : Environment) (publicNames : NameSet) : IO (Array (Name × Name)) := do
  let mut result := #[]
  for (name, owner) in ← localConstantPairs env do
    -- Classify every actual local constant using the extension-loaded full
    -- environment. An unexpected constant/owner cannot disappear by filtering.
    unless full.contains name do
      throw (IO.userError s!"focused import contains a constant absent from the full umbrella: {name}")
    unless (← ownerOf full name) == owner do
      throw (IO.userError s!"focused/full owner mismatch for {name}")
    if publicNames.contains name then result := result.push (name, owner)
  return result

def loadWithExtensions (moduleName : Name) : IO Environment := do
  -- These are the documented frontend initialization calls. Imports are strictly
  -- sequential and extension-loaded environments are not manually freed.
  unsafe enableInitializersExecution
  importModules #[{ module := moduleName }] {} (loadExts := true)

def focusedSimpNames (env : Environment) (declarations : Array (Name × Name)) : IO (Array Name) := do
  -- Pinned Lean sets typed importedEntries even when loadExts is false
  -- (Environment.lean:2376). Reuse only the registered simp importer's pure
  -- reconstruction (SimpTheorems.lean:732; ScopedEnvExtension.lean:61,265),
  -- without initializing/mutating environment extensions or executing initializers.
  -- Its borrowed entries and resulting SimpTheorems remain inside focusedAudit's
  -- ownership callback; only compressed JSON text leaves that callback.
  let ext := Lean.Meta.simpExtension.ext
  let imported := (ext.toEnvExtension.getState env).importedEntries
  unless imported.size == env.allImportedModuleNames.size do
    throw (IO.userError "focused simp imported-entry coverage mismatch")
  let state ← ext.addImportedFn imported { env, opts := {} }
  let [scope] := state.stateStack
    | throw (IO.userError "unexpected focused simp import state stack")
  let mut result := #[]
  for (name, _) in declarations do
    if scope.state.contains name then result := result.push name
  return result

def focusedAudit (moduleName : Name) (full : Environment) (publicNames : NameSet)
    (supported : Array Name) (buildRoot : System.FilePath) : IO Json := do
  -- withImportModules owns and releases an extension-OFF environment. Only a
  -- freshly allocated compressed JSON string escapes its callback; no Name,
  -- Expr, Environment or imported-region object is returned to the caller.
  let encoded ← unsafe withImportModules #[{ module := moduleName }] {} fun env => do
    checkPaths buildRoot env supported
    let declarations ← focusedPublic env full publicNames
    let result := Json.mkObj [("imports", ← importsJson env moduleName),
      ("closure", namesJson (localModules env)),
      ("declarations", pairsJson declarations),
      ("simp", namesJson (← focusedSimpNames env declarations))]
    return result.compress
  RetainedExport.liftResult (Json.parse encoded)

def aliasPairs (env : Environment) : Array (Name × Name) :=
  (getAliasState env).fold (fun result aliasName targets =>
    if aliasName.getPrefix == `LeanInfoTheory then
      targets.foldl (fun result target => result.push (aliasName, target)) result
    else result) #[]

def aliasesJson (pairs : Array (Name × Name)) : Json :=
  toJson ((pairs.qsort fun a b =>
    if a.1 == b.1 then a.2.toString < b.2.toString else a.1.toString < b.1.toString).map
    fun (aliasName, target) => Json.mkObj
      [("alias", .str aliasName.toString), ("target", .str target.toString)])

def audit (input : Json) : IO Json := do
  let supported ← (← arrayField input "supported_modules").mapM fun value => do
    return (← RetainedExport.liftResult value.getStr?).toName
  let supported := sortedNames supported
  if supported.isEmpty then throw (IO.userError "empty supported module inventory")
  unless supported.contains `LeanInfoTheory && supported.contains `LeanInfoTheory.Shannon do
    throw (IO.userError "supported inventory lacks the root or full umbrella")
  let buildRoot ← IO.FS.realPath (← stringField input "project_build_root")
  -- Resolve every requested local module before importing; validate all observed
  -- local modules again in each actual environment and once at the end.
  let paths ← supported.mapM (pathRecord buildRoot)
  let full ← loadWithExtensions `LeanInfoTheory.Shannon
  checkPaths buildRoot full supported
  let actualModules := localModules full
  let declarations ← classifyPublic full
  let publicNames := declarations.foldl (fun names entry => names.insert entry.1) ({} : NameSet)
  let simp ← inCore full do
    let mut names := #[]
    for (name, _) in declarations do
      if ← Lean.Meta.isInSimpSet `simp name then names := names.push name
    return names
  let mut directImports := []
  let mut closures := []
  let mut focusedDeclarations := []
  let mut focusedSimp := []
  for moduleName in supported do
    let focused ← focusedAudit moduleName full publicNames supported buildRoot
    directImports := directImports ++ [(moduleName.toString, ← field focused "imports")]
    closures := closures ++ [(moduleName.toString, ← field focused "closure")]
    focusedDeclarations := focusedDeclarations ++ [(moduleName.toString, ← field focused "declarations")]
    focusedSimp := focusedSimp ++ [(moduleName.toString, ← field focused "simp")]
  let root ← loadWithExtensions `LeanInfoTheory
  checkPaths buildRoot root supported
  let expectedAliases ← arrayField input "root_exports"
  let mut resolutions := #[]
  for entry in expectedAliases do
    let aliasName := (← stringField entry "alias").toName
    let target ← inCore root (resolveGlobalConstNoOverloadCore aliasName)
    resolutions := resolutions.push (aliasName, target)
  let pathsAfter ← supported.mapM (pathRecord buildRoot)
  unless pathsAfter == paths do throw (IO.userError "local olean resolution changed during audit")
  return Json.mkObj [("schema", .str "lean-info-theory.current-compiled-audit.v1"),
    ("supported_modules", namesJson actualModules), ("declarations", pairsJson declarations),
    ("simp", namesJson simp), ("direct_imports", Json.mkObj directImports),
    ("module_closures", Json.mkObj closures), ("focused_declarations", Json.mkObj focusedDeclarations),
    ("focused_simp", Json.mkObj focusedSimp),
    ("root_closure", namesJson (localModules root)), ("root_exports", aliasesJson (aliasPairs root)),
    ("root_resolutions", aliasesJson resolutions), ("olean_paths", .arr paths)]

end CurrentAudit

def main (args : List String) : IO Unit := do
  let [inputPath] := args | throw (IO.userError "usage: CurrentAudit <audit-input.json>")
  let input ← RetainedExport.liftResult (Json.parse (← IO.FS.readFile inputPath))
  initSearchPath (← findSysroot)
  IO.println (← CurrentAudit.audit input).compress
