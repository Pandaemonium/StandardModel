import PhysicsSM.NullStrand

/-!
# NullStrand.Audit.DuplicateNames

Generated **base-name collision gate** for the trusted NullStrand surface.

`Inventory`/`DraftFirewall` catch *renames and deletions* of named declarations,
and the Lean kernel itself rejects two declarations sharing a fully-qualified
name within one import closure. Neither catches the more insidious drift that
motivated the 2026-06-25 de-duplication: two *different* declarations in sibling
namespaces ending in the **same last component** (e.g. the historical
`NullFiber.uniformComponent_bounds_meanNorm` living in both `RegulatorMeanNorm`
and `RegulatorNoGo`). Such a collision compiles, but `open`-ing both namespaces
makes the short name ambiguous and invites silent semantic drift.

This module imports the entire trusted NullStrand root and, at elaboration time,
enumerates every authored declaration under `PhysicsSM.NullStrand` (excluding the
`Audit` subtree and compiler-generated companions such as `rec`, `casesOn`,
`mk`, `injEq`, projection functions, and `eq_*`/`match_*`/`proof_*` lemmas),
groups them by last name component, and **fails the build** if any base name is
shared by two or more distinct declarations that are not on the explicit,
documented `intentionalCollisions` allowlist below.

The allowlist is not a trusted escape hatch: it does not weaken any proof or hide
an assumption. It is a reviewed registry of *known, intentional* short-name
reuses. A genuinely new accidental collision turns into a red build at G0; a
deliberate reuse must be added here (with its exact member set) in the same
commit, which makes the decision visible in review.

Current intentional collisions:

* `minkowskiInner` — `PhysicsSM.NullStrand.minkowskiInner` (on `Minkowski4`,
  the metric of `Conventions`) and
  `PhysicsSM.NullStrand.NullFiber.Barycentric.minkowskiInner` (on `Fin 4 → ℝ`,
  the self-contained barycentric metric). Distinct domains; kept local to avoid
  cross-file coupling.
* `FiniteNullResolution` — `PhysicsSM.NullStrand.NullFiber.Barycentric.FiniteNullResolution`
  (a PMF-style finite null resolution with a barycenter) and
  `PhysicsSM.NullStrand.NullLift.FiniteNullResolution` (the null-lift residual
  current's resolution datum). Distinct structures with distinct fields.

Companion modules: `PhysicsSM.NullStrand.Audit.Inventory`,
`PhysicsSM.NullStrand.Audit.DraftFirewall`,
`PhysicsSM.NullStrand.Audit.CapstoneAxioms`.

Provenance: wave-4 audit-automation hardening, 2026-06-25. No
`s o r r y`/`a x i o m`; pure environment introspection.
-/

namespace PhysicsSM.NullStrand.Audit.DuplicateNames

open Lean Elab Command

/-- Reviewed registry of intentional short-name reuses in the trusted NullStrand
surface, as `(lastComponent, exact member set)`. The audit gate passes a
collision iff its base name appears here *and* its actual member set matches
exactly. -/
def intentionalCollisions : List (Name × List Name) :=
  [ (`minkowskiInner,
      [ `PhysicsSM.NullStrand.minkowskiInner,
        `PhysicsSM.NullStrand.NullFiber.Barycentric.minkowskiInner ]),
    (`FiniteNullResolution,
      [ `PhysicsSM.NullStrand.NullFiber.Barycentric.FiniteNullResolution,
        `PhysicsSM.NullStrand.NullLift.FiniteNullResolution ]),
    (`comp,
      [ `PhysicsSM.NullStrand.BellQFT.DirectionEquivariant.comp,
        `PhysicsSM.NullStrand.BellQFT.PreservesDirectionMarginal.comp ]),
    (`iterate,
      [ `PhysicsSM.NullStrand.BellQFT.DirectionEquivariant.iterate,
        `PhysicsSM.NullStrand.BellQFT.PreservesDirectionMarginal.iterate ]) ]

/-- Reviewed registry of **accidental** short-name duplicates that already exist
in the trusted tree and are tracked for de-duplication (see the manifest
reconciliation plan, `Sources/NullStrand_Audit_Plan.md`). Listing them here keeps
the gate green on the *current baseline* while still failing the build on any
*new* duplicate; the goal is for this list to shrink to `[]`, not grow.

Status (wave 5, 2026-06-25): **empty** — the only remaining accidental duplicates,
`realPos` / `realPos_nonneg` / `realPos_sub_realPos_neg` (the real positive part
`max z 0` and its elementary lemmas, formerly copied into both
`PhysicsSM.NullStrand.BellQFT.*` and `PhysicsSM.NullStrand.ZigZag.*`), have been
unified into the single shared module `PhysicsSM.NullStrand.RealPositivePart` and
are now resolved everywhere via parent-namespace lookup. No accidental short-name
duplicates remain pending de-duplication. -/
def knownDuplicatesPendingDedup : List (Name × List Name) :=
  []

/-- Last-name components that mark a compiler-generated companion declaration. -/
private def autoSuffix : Array String := #[
  "casesOn", "rec", "recOn", "mk", "noConfusion", "noConfusionType", "injEq",
  "inj", "sizeOf", "sizeOf_spec", "ctorIdx", "below", "brecOn", "binductionOn",
  "ofNat", "eq_def", "toCtorIdx", "fst", "snd", "congr_simp", "congr"]

/-- True for declarations that are compiler-generated companions we should ignore
when looking for authored base-name collisions. -/
private def isAuthored (env : Environment) (n : Name) (ci : ConstantInfo) : Bool := Id.run do
  if ci.isUnsafe then return false
  if n.isInternal then return false
  match ci with
  | .ctorInfo .. | .recInfo .. => return false
  | _ => pure ()
  if (env.getProjectionFnInfo? n).isSome then return false
  let baseStr := n.componentsRev.head!.toString
  if autoSuffix.contains baseStr then return false
  if baseStr.startsWith "eq_" || baseStr.startsWith "match_"
      || baseStr.startsWith "proof_" then return false
  return true

/-- The generated collision gate. Errors (fails the build) on any unexpected
base-name collision among authored `PhysicsSM.NullStrand` declarations. -/
elab "#audit_nullstrand_basename_collisions" : command => do
  let env ← getEnv
  let root := `PhysicsSM.NullStrand
  let audit := `PhysicsSM.NullStrand.Audit
  let mut groups : Std.HashMap Name (Array Name) := {}
  for (n, ci) in env.constants.toList do
    if !root.isPrefixOf n then continue
    if audit.isPrefixOf n then continue
    if !isAuthored env n ci then continue
    let base := n.componentsRev.head!
    groups := groups.insert base ((groups.getD base #[]).push n)
  -- index both allowlists for exact-membership comparison
  let allow : Std.HashMap Name (List Name) :=
    (intentionalCollisions ++ knownDuplicatesPendingDedup).foldl
      (fun m (b, ns) => m.insert b ns) {}
  let mut unexpected : Array MessageData := #[]
  for (base, arr) in groups.toList do
    if arr.size < 2 then continue
    let actual := (arr.toList.map (·.toString)).mergeSort (· ≤ ·)
    match allow[base]? with
    | some expected =>
        let expectedStr := (expected.map (·.toString)).mergeSort (· ≤ ·)
        if actual != expectedStr then
          unexpected := unexpected.push
            m!"allowlisted base `{base}` member set drifted:\n    expected {expected}\n    actual   {arr.toList}"
    | none =>
        unexpected := unexpected.push
          m!"unexpected base-name collision `{base}`: {arr.toList}"
  unless unexpected.isEmpty do
    throwError "NullStrand base-name collision audit failed:\n{MessageData.joinSep unexpected.toList "\n"}"
  logInfo m!"NullStrand base-name collision audit: {intentionalCollisions.length} intentional collision(s), {knownDuplicatesPendingDedup.length} known duplicate(s) pending de-duplication, no unexpected collisions."

#audit_nullstrand_basename_collisions

end PhysicsSM.NullStrand.Audit.DuplicateNames
