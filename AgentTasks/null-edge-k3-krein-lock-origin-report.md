# K3: Origin of the Krein branch lock — report

**Status:** complete, kernel-checked (Lean 4 / Mathlib, toolchain v4.28.0).
**Module:** `PhysicsSM/Draft/NullEdgeKreinLockOrigin.lean`
(namespace `PhysicsSM.Draft.NullEdgeKreinLockOrigin`).
**Imported into:** `PhysicsSMDraft.lean`.
**Axioms of the bundled verdict `k3_verdict`:** `propext`, `Classical.choice`,
`Quot.sound` (no `sorry`, no extra axioms, no `native_decide`).

## Question

C65 (`NullEdgeCanonicalSpeciesSelector`) proved the physical-species selector is
canonical **relative to the locked Krein-sign data**, and is *not* determined by
chirality / taste / energy / grading alone. K3 asks the deeper question: can the
Krein-sign **assignment itself** be derived from a deeper structure
(retarded/advanced sheet orientation, causal orientation, preferred covector,
charge-conjugation/reflection, or the dual-soldered frame convention)?

## Answer (one line)

**No-go.** The branch Krein-sign assignment is *not* derivable from the currently
formalized data. It equals the branch diagonal of the chosen fundamental symmetry
`J`, and every structural relation the tree records for the modeled metric
`kreinJ` (self-adjoint involution preserving the branch decomposition and the
chirality grading) is satisfied by fundamental symmetries carrying **any** of the
`2⁴` sign patterns. The locked pattern `(+,-,+,-)` is fixed only by an external
**sheet/causal orientation** choice; supplying that one datum (`OrientationLocked`)
forces the canonical `{0,2}` selector and re-feeds C65.

## What actually fixes the Krein signs

By the C22 definition, the branch Krein signature is

```
branchKreinSig a = tr(J · P_a),   J = kreinJ.
```

So the Krein-sign assignment is *exactly* the diagonal of the chosen fundamental
symmetry on the branch corners `(a,a)`. "Deriving the Krein lock" means deriving
`kreinJ`'s branch diagonal from deeper data; a "no-go" means exhibiting an
equally-valid fundamental symmetry — one preserving every formalized structural
relation — that carries a different branch pattern.

A *fundamental symmetry* (Krein metric) is intrinsically only a **self-adjoint
involution**. The full list of structural relations the tree records for `kreinJ`
is captured by `IsBranchFundamentalSymmetry J`:

* involution: `J * J = 1`;
* self-adjoint (real form): `Jᵀ = J`;
* preserves the branch decomposition: `J * P_a = P_a * J` for all `a`;
* preserves the spacetime-chirality grading: `J * Γ_s = Γ_s * J`.

`kreinJ` satisfies all four (`kreinJ_isFund`). These are exactly the data
available about the Krein metric in the current tree.

## What is proved

1. **Orientation flip** — `negKreinJ_isFund`, `negKreinJ_pattern`,
   `negKreinJ_selector_eq`: `-kreinJ` is *also* a branch fundamental symmetry, but
   flips every branch Krein sign `(+,-,+,-) → (-,+,-,+)`, moving the retained
   maximal Krein-positive sector from `{0,2}` to `{1,3}`. The flip `J ↦ -J` is the
   exchange of the two doubling sheets (retarded ↔ advanced / positive ↔ negative
   energy): the global orientation of the fundamental symmetry is a free sign.

2. **Total freedom of the pattern** — `Jof`, `Jof_isFund`, `Jof_pattern`,
   `krein_pattern_totally_free`: for *every* sign assignment `ε : Fin 4 → ℝ` with
   `ε a ∈ {±1}` there is a branch fundamental symmetry `Jof ε` realizing it:
   `tr(Jof ε · P_a) = ε a`. Hence the branch Krein pattern is **completely
   unconstrained** by the formalized structural relations — all `2⁴` patterns
   occur, including the degenerate `(+,+,+,+)` (no Krein indefiniteness at all)
   and every `2+2` split (the C45/C46 species modulus).

3. **No-go statement** — `krein_assignment_no_go`: there exist two branch
   fundamental symmetries (`kreinJ` and `-kreinJ`) satisfying *all* formalized
   structural relations yet inducing *different* retained sectors. So the
   Krein-sign assignment is **not derivable** from the currently formalized data.

4. **Conditional derivation that feeds C65** — `OrientationLocked`,
   `orientationLocked_selector`, `orientationLocked_feeds_c65`: the single missing
   datum is a **sheet-orientation lock** declaring which branch pattern the
   fundamental symmetry carries (`branchKreinPattern J = branchKreinSig`). Under
   it the maximal Krein-positive selector is forced to the canonical `{0,2}` pair,
   re-feeding C65 with the orientation datum made explicit. This makes precise
   that C65's "locked Krein data" is *exactly* a sheet-orientation convention,
   nothing deeper.

5. **Verdict** — `k3_verdict`: bundles (3), (2), and (4).

## Survey of the candidate "deeper structures"

The task named five candidate structures from which the Krein lock might be
derived. None currently pins `kreinJ`'s branch diagonal:

* **Retarded/advanced sheet orientation, causal orientation, positive/negative
  energy:** these are precisely what the global flip `J ↦ -J` of (1) toggles. They
  *are* the missing orientation datum (`OrientationLocked`), not a derivation of
  it — choosing the retarded sheet is choosing the sign.
* **Charge-conjugation / reflection structure:** the formalized reflection
  operators (`NullEdgeP2BranchReflection`/`Orientation`: `R = P₊ − P₋`,
  trace `0`, determinant `−1`) and the mass-shell candidate
  `J = m⁻¹ D = P₊ − P₋` (`NullEdgeSuperDiracKreinCore`) are themselves only fixed
  up to the sign of `m` (which sheet is "positive"), so they reproduce the same
  free sign rather than removing it.
* **Dual-soldered frame convention:** the dual-soldered architecture
  (`NullSolderFrameFoundations`) constrains the Clifford symbol / kinetic block,
  not the fundamental-symmetry sign on the branch corners.

No formalized structure currently supplies the orientation datum; hence the
no-go. Supplying a kernel-level causal-orientation operator that canonically
fixes `tr(J · P_a)` on a reference branch (plus a relation tying the remaining
branches to it) would upgrade this no-go to a derivation — that is the precise
open hook.

## Gate impact

* **Gate C release (C59):** **unaffected.** Gate C consumes the Krein data as a
  locked input; once the orientation is fixed, `{0,2}` is canonical (C65) and the
  `ProjectedGateCRelease` certificate is unchanged.
* **Gate F prediction language:** any prediction naming the literal physical pair
  `{0,2}` without declaring the sheet orientation as locked input inherits the
  full `2⁴`-pattern freedom of (2), in particular the global flip of (1).
  Predictions phrased structurally ("the retained sector is the maximal
  Krein-positive pair for the chosen retarded sheet") are safe; predictions by
  literal branch labels are conventional.
* **Convention / provenance:** the Krein lock is a **convention** (sheet/causal
  orientation), not a theorem of the currently formalized data.

## Conventions

- Carrier `Idx = Fin 4 × Fin 4 = (Dirac) × (taste)`; branches indexed by
  `Fin 4`; branch projector `P_a` = rank-one projector onto corner `(a,a)`.
- Chirality pattern `g5 = (+,+,-,-)` (Dirac factor); Krein pattern
  `branchKreinSig = (+,-,+,-)` (taste-parity, on branch corners), both reused
  from `NullEdgeFlavoredChirality` / `NullEdgeBranchKreinSignatures` (C22).
- Fundamental symmetry = self-adjoint involution preserving the branch
  decomposition and the chirality grading (`IsBranchFundamentalSymmetry`).
- Selector = maximal Krein-positive sector of `J`
  (`kreinSelectorOf J a = decide (tr(J · P_a) = 1)`), reusing the C65/K2 form.

## What remains conditional

The canonicity of the Krein assignment is conditional on a sheet/causal
orientation lock. Whether a *deeper* formalized structure can supply that
orientation canonically is open and **not** resolved here; the no-go shows it
cannot come from the currently formalized self-adjoint-involution + grading data
alone.
