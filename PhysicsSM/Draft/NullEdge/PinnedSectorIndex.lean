/-
# Deliverable 2 (part 3b) — The symmetry-resolved chirality index is BLIND

Companion Lean file for `PINNED_STABILITY_DESIGN.md`.  Builds on the landed
context, `Pinned.MirrorChart`, and `Pinned.SectorProjectors`.

With `P_ε` the exact spectral projection onto `ker(W-ε)` and `P_r = (1 + r R)/2`
for the applicable reflection `R`, the sector-resolved chirality index is

  `ν_{ε,r} = trace(Γ · P_r · P_ε)`.

**Honest negative (the bankable result).**  The exact computation over the whole
protected/blind family gives

  `(ν_{+1,+}, ν_{+1,-}, ν_{-1,+}, ν_{-1,-}) = (0,0,0,0)`  for **every** field,

with the applicable reflection in each case:
* protected singletons → `reflR` (chart `{1,3}`): `nu13_singleton_all_zero`;
* blind singletons → `reflR0` (chart `{0,2}`): `nu02_blind_all_zero`;
* blocks → the bond reflection (`reflBondA`/`reflBondB`): `nuBlock_all_zero`.

So the symmetry-resolved chirality index is blind, exactly like the landed
global signed index `(0,0)`: the pinned pairs carry balanced `Γ`-signature within
every reflection sector.  The consequence, stated plainly in the design memo:
chirality-type indices (global or symmetry-resolved) cannot separate protected
from blind fields; the proven structural discriminator is the **self-adjointness
certificate boundary itself** (which chart, if any, applies), and stability must
be argued chart-wise under deformations preserving that chart's reflection.

Draft-trust disclosure: `native_decide` over `ℚ` (adds `Lean.ofReduceBool` /
`Lean.trustCompiler`); signs `ε, r ∈ {±1}` encoded by `Bool` to keep a single
`native_decide` per theorem.
-/
/-
Provenance: Aristotle job 573430f4 (fable-pub-pinned-stability-20260711),
harvested 2026-07-11 ~10:20 PDT (24h-run P0); part of a six-module return
(SpecProjectors held back pending two abstract-lemma proofs). Statements
integrated UNCHANGED except this header and import rewires
(context/Pinned paths -> project paths). The job absorbed three exact
mid-task data injections (census, axis-equivariant charts, block
involutions) recorded in the 2026-07-11 overnight ledger. Draft-trust
disclosure: finite family decisions use native_decide (+2 footprint) as
stated per-file; abstract lemmas are kernel-only.
-/
import Mathlib
import PhysicsSM.Draft.NullEdge.HalfPeriodInvariant
import PhysicsSM.Draft.NullEdge.PinnedMirrorChart
import PhysicsSM.Draft.NullEdge.PinnedSectorDefs

noncomputable section

namespace PhysicsSM.Draft.NullEdge.PinnedSymmetryResolved

open Matrix
open PhysicsSM.Draft.NullEdge.ModeInvariantHalfWinding
open PhysicsSM.Draft.NullEdge.HalfPeriodInvariant

/-- **The symmetry-resolved chirality index is blind — protected singletons,
chart `{1,3}`.**  For every protected singleton and every sector
`(ε, r) ∈ {±1}²`, `ν_{ε,r} = trace(Γ · P_r · P_ε) = 0`. -/
theorem nu13_singleton_all_zero :
    ∀ (se sr : Bool) b, protectedSingleton b = true →
      (gradeX * parityProj reflR (sgn sr) * eigProj13 b (sgn se)).trace = 0 := by
  native_decide

/-- **The symmetry-resolved chirality index is blind — blind singletons,
chart `{0,2}`.** -/
theorem nu02_blind_all_zero :
    ∀ (se sr : Bool) b, fixedSingleton b = true →
      (gradeX * parityProj reflR0 (sgn sr) * eigProj02 b (sgn se)).trace = 0 := by
  native_decide

/-- **The symmetry-resolved chirality index is blind — the four blocks,
bond reflection.**  `ν_{ε,r} = 0` in every sector with the full block projector
`(1 + ε W)/2` and the applicable bond reflection. -/
theorem nuBlock_all_zero :
    ∀ (se sr : Bool),
    (gradeX * parityProj reflBondB (sgn sr) * eigProjW ![true,true,false,false] (sgn se)).trace = 0 ∧
    (gradeX * parityProj reflBondB (sgn sr) * eigProjW ![false,false,true,true] (sgn se)).trace = 0 ∧
    (gradeX * parityProj reflBondA (sgn sr) * eigProjW ![true,false,false,true] (sgn se)).trace = 0 ∧
    (gradeX * parityProj reflBondA (sgn sr) * eigProjW ![false,true,true,false] (sgn se)).trace = 0 := by
  native_decide

end PhysicsSM.Draft.NullEdge.PinnedSymmetryResolved
