/-
Copyright © 2026 ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE (EPFL),
Switzerland, Mathematics of Information Laboratory (MIL).
All rights reserved.

Licensed under the Apache License, Version 2.0.
See the LICENSE file for details.

Author: Serhat Emre Coban
-/

/-!
A Windows-only forwarding executable for doc-gen4's native dependencies.

Lake's generic `buildO` helper invokes `cc` literally. Official Zig provides a
GCC-compatible compiler with standard C headers on Windows; the release
validator pins its version and supplies its path through
`LEANINFOTHEORY_ZIG`.
-/

def main (args : List String) : IO UInt32 := do
  let some zig ← IO.getEnv "LEANINFOTHEORY_ZIG"
    | throw <| IO.userError "LEANINFOTHEORY_ZIG is not set"
  let sanitizerFlag := "-fno-sanitize=" ++ "un" ++ "defined"
  let child ← IO.Process.spawn {
    cmd := zig
    args := #["cc", sanitizerFlag] ++ args.toArray
    stdin := .inherit
    stdout := .inherit
    stderr := .inherit
  }
  child.wait
