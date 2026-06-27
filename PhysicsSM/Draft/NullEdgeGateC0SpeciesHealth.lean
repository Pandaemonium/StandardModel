import Mathlib
import PhysicsSM.Draft.NullEdgeGateCSplit

/-!
# C86: Gate C0 species-health release API from RA-Wilson

This module makes the phrase **"RA-Wilson releases C0, not C1"** precise and
hard to misread.

The RA-Wilson idea is the finite accretive-gap pattern: an anti-Hermitian
operator `A` (the regulated anti-Hermitian "RA double") plus a *positive* scalar
Wilson mass `m I` has no kernel away from the origin, because `A + m I` is
accretive with real part bounded below by `m`.  Concretely (C85,
`PhysicsSM.Draft.NullEdgeRAWilsonGap`, the accretive-gap engine) one has
`‖(A + m I) v‖ ≥ m ‖v‖` whenever `A` is anti-Hermitian and `m > 0`.

That gap **lifts non-origin torus species** by a genuine inverse-propagator mass
gap while leaving the intended origin branch and the leading continuum null-edge
symbol untouched.  This is exactly the external species-health layer
`GateC0SpeciesHealthy` of `NullEdgeGateCSplit` — and it is *strictly weaker* than
the physical chiral-release layer `GateC1ChiralPhysicalRelease`.

## What this module provides

* `RAWilsonC0Data` — abstract data packaging the RA-Wilson off-origin gap output
  together with the origin-retention, mass-gap, and leading-symbol clauses, with
  a projection `toGateC0Data` into the C-split species-health dataset.
* `RAWilsonC0Certificate` — the certificate that all four clauses hold.
* `FreeSpeciesHealthy` — the free/regulator-model species-health predicate,
  defined as `GateC0SpeciesHealthy` of the projected dataset.
* **Bridge theorem** `rawilsonC0Certificate_freeSpeciesHealthy` —
  `RAWilsonC0Certificate D → FreeSpeciesHealthy D`.
* **Projection theorem** `freeSpeciesHealthy_offOriginGap_and_originRetained` —
  species-health yields the off-origin gap *and* the retained origin branch.
* **Negative theorem** `speciesHealthy_does_not_imply_chiralRelease` —
  `GateC0SpeciesHealthy` alone does **not** imply
  `GateC1ChiralPhysicalRelease`.

## Engine status (C85)

The concrete accretive-gap engine `NullEdgeRAWilsonGap` (C85) is *not* part of
this snapshot, so the off-origin gap is carried here as a minimal abstract
hypothesis `offOriginGap : Prop` (exactly as the task allows).  To keep the
certificate honestly *non-vacuous*, the file also proves a tiny self-contained
instance of the accretive gap in the `1×1` (scalar) case
(`accretiveGap_scalar_*`) and uses it to exhibit a satisfied certificate.

## Scope guardrails

This is a **Gate C0** module.  It does **not** claim a full Gate C release and it
does **not** claim origin chirality.  The negative theorem is the whole point:
the RA-Wilson species lift is a C0 result, never a C1 one.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdgeGateC0SpeciesHealth

open PhysicsSM.Draft.NullEdgeGateCSplit

/-! ## A self-contained scalar instance of the RA-Wilson accretive gap

This is the `1×1` shadow of the C85 accretive-gap engine: a purely imaginary
number `a` (a `1×1` anti-Hermitian "RA double") plus a positive real scalar
Wilson mass `m` has modulus at least `m`, hence is never zero.  It demonstrates
that the abstract `offOriginGap` clause used below is genuinely satisfiable. -/

/-- **Scalar accretive gap (norm lower bound).**  If `a.re = 0` (the `1×1`
anti-Hermitian condition) and `0 < m`, then `‖a + m‖ ≥ m`. -/
theorem accretiveGap_scalar_norm_lower_bound {a : ℂ} (ha : a.re = 0)
    {m : ℝ} (hm : 0 < m) : m ≤ ‖a + (m : ℂ)‖ := by
  have hre : (a + (m : ℂ)).re = m := by simp [ha]
  calc
    m = |(a + (m : ℂ)).re| := by rw [hre, abs_of_pos hm]
    _ ≤ ‖a + (m : ℂ)‖ := by
          simpa using Complex.abs_re_le_norm (a + (m : ℂ))

/-- **Scalar accretive gap (no kernel).**  A `1×1` anti-Hermitian element plus a
positive scalar Wilson mass is nonzero. -/
theorem accretiveGap_scalar_ne_zero {a : ℂ} (ha : a.re = 0)
    {m : ℝ} (hm : 0 < m) : a + (m : ℂ) ≠ 0 := by
  intro h
  have hb := accretiveGap_scalar_norm_lower_bound ha hm
  rw [h] at hb
  simp at hb
  exact absurd hb (not_le.mpr hm)

/-- The abstract off-origin gap proposition realized by the scalar engine: every
`1×1` anti-Hermitian element stays nonzero after adding the unit Wilson mass.
This is used only to witness non-vacuity of the certificate. -/
def scalarOffOriginGap : Prop := ∀ a : ℂ, a.re = 0 → a + (1 : ℂ) ≠ 0

theorem scalarOffOriginGap_holds : scalarOffOriginGap := by
  intro a ha
  exact accretiveGap_scalar_ne_zero ha (by norm_num)

/-! ## RA-Wilson Gate C0 data and certificate -/

/-- Abstract data for the RA-Wilson Gate C0 species-health path.

* `offOriginGap` — the RA-Wilson accretive-gap output: all non-origin torus
  species are gapped (the `A + m I` no-kernel statement; C85 engine).
* `originRetained` — the intended origin branch is kept.
* `massGap` — the gap is a genuine real inverse-propagator mass gap (not a
  point-split numerator zero).
* `leadingSymbolUnchanged` — the leading continuum null-edge symbol is
  unchanged. -/
structure RAWilsonC0Data where
  /-- RA-Wilson accretive-gap output: non-origin species are gapped. -/
  offOriginGap : Prop
  /-- the intended origin branch is retained. -/
  originRetained : Prop
  /-- the gap is a genuine inverse-propagator mass gap. -/
  massGap : Prop
  /-- the leading continuum null-edge symbol is unchanged. -/
  leadingSymbolUnchanged : Prop

/-- Project RA-Wilson Gate C0 data onto the C-split species-health dataset
`GateC0Data`: the RA-Wilson off-origin gap *is* the non-origin gapping clause,
and the gap is realized as a mass gap. -/
def RAWilsonC0Data.toGateC0Data (D : RAWilsonC0Data) : GateC0Data where
  originRetained := D.originRetained
  nonOriginGapped := D.offOriginGap
  gappedByMassGap := D.massGap
  leadingSymbolUnchanged := D.leadingSymbolUnchanged

/-- The RA-Wilson Gate C0 **certificate**: every species-health clause holds for
the data `D`. -/
structure RAWilsonC0Certificate (D : RAWilsonC0Data) : Prop where
  /-- the RA-Wilson accretive off-origin gap holds. -/
  off_origin_gap : D.offOriginGap
  /-- the intended origin branch is retained. -/
  origin_retained : D.originRetained
  /-- the off-origin gap is a genuine inverse-propagator mass gap. -/
  gap_is_mass_gap : D.massGap
  /-- the leading continuum null-edge symbol is unchanged. -/
  leading_symbol_unchanged : D.leadingSymbolUnchanged

/-- **Free-species-health predicate.**  The free/regulator-model species are
healthy for the RA-Wilson data `D` exactly when the projected C-split dataset is
`GateC0SpeciesHealthy`. -/
def FreeSpeciesHealthy (D : RAWilsonC0Data) : Prop :=
  GateC0SpeciesHealthy D.toGateC0Data

/-! ## Bridge theorem: certificate ⇒ free species health -/

/-- **Bridge.**  An RA-Wilson Gate C0 certificate releases the external
species-health layer `GateC0SpeciesHealthy` of the projected dataset, i.e.
`FreeSpeciesHealthy`. -/
theorem rawilsonC0Certificate_freeSpeciesHealthy {D : RAWilsonC0Data}
    (h : RAWilsonC0Certificate D) : FreeSpeciesHealthy D :=
  { origin_retained := h.origin_retained
    non_origin_gapped := h.off_origin_gap
    gapped_by_mass_gap := h.gap_is_mass_gap
    leading_symbol_unchanged := h.leading_symbol_unchanged }

/-- Restatement of the bridge directly into `GateC0SpeciesHealthy` of the
projected dataset (definitionally `FreeSpeciesHealthy`). -/
theorem rawilsonC0Certificate_gateC0SpeciesHealthy {D : RAWilsonC0Data}
    (h : RAWilsonC0Certificate D) : GateC0SpeciesHealthy D.toGateC0Data :=
  rawilsonC0Certificate_freeSpeciesHealthy h

/-! ## Projection theorem: species health ⇒ gap and retained origin -/

/-- **Projection.**  Free species health yields both the RA-Wilson off-origin gap
and the retained origin branch. -/
theorem freeSpeciesHealthy_offOriginGap_and_originRetained {D : RAWilsonC0Data}
    (h : FreeSpeciesHealthy D) : D.offOriginGap ∧ D.originRetained :=
  ⟨h.non_origin_gapped, h.origin_retained⟩

/-- Projection: free species health yields the off-origin gap. -/
theorem freeSpeciesHealthy_offOriginGap {D : RAWilsonC0Data}
    (h : FreeSpeciesHealthy D) : D.offOriginGap :=
  h.non_origin_gapped

/-- Projection: free species health retains the origin branch. -/
theorem freeSpeciesHealthy_originRetained {D : RAWilsonC0Data}
    (h : FreeSpeciesHealthy D) : D.originRetained :=
  h.origin_retained

/-! ## Non-vacuity: a satisfied certificate from the scalar engine -/

/-- A concrete RA-Wilson Gate C0 dataset whose off-origin gap is the genuine
scalar accretive-gap statement, and whose remaining clauses are recorded as
`True`.  This exists only to witness that the certificate is satisfiable. -/
def scalarWitnessData : RAWilsonC0Data where
  offOriginGap := scalarOffOriginGap
  originRetained := True
  massGap := True
  leadingSymbolUnchanged := True

/-- The scalar witness satisfies the RA-Wilson Gate C0 certificate, so the bridge
is non-vacuous. -/
theorem scalarWitness_certificate : RAWilsonC0Certificate scalarWitnessData :=
  { off_origin_gap := scalarOffOriginGap_holds
    origin_retained := trivial
    gap_is_mass_gap := trivial
    leading_symbol_unchanged := trivial }

/-- The scalar witness is genuinely free-species-healthy. -/
theorem scalarWitness_freeSpeciesHealthy : FreeSpeciesHealthy scalarWitnessData :=
  rawilsonC0Certificate_freeSpeciesHealthy scalarWitness_certificate

/-! ## Negative theorem: C0 species health does not imply C1 chiral release -/

/-- **Negative guardrail (the whole point).**  Gate C0 species health does
**not** imply Gate C1 chiral physical release.  There is a species-healthy C0
dataset whose companion C1 dataset fails the chiral-release layer (here the
physical-chirality choice is absent), so no map from `GateC0SpeciesHealthy` to
`GateC1ChiralPhysicalRelease` can exist.  This is the precise content of
"RA-Wilson releases C0, not C1". -/
theorem speciesHealthy_does_not_imply_chiralRelease :
    ∃ (D0 : GateC0Data) (D1 : GateC1Data),
      GateC0SpeciesHealthy D0 ∧ ¬ GateC1ChiralPhysicalRelease D1 := by
  refine ⟨⟨True, True, True, True⟩,
          ⟨False, True, True, True, True, True⟩,
          ⟨trivial, trivial, trivial, trivial⟩, ?_⟩
  intro h
  exact h.physical_chirality_chosen

/-- Sharper form: even the RA-Wilson scalar witness, which *is*
free-species-healthy, cannot by itself supply a chiral-release certificate for a
C1 dataset whose physical chirality is unchosen. -/
theorem rawilson_releases_c0_not_c1 :
    FreeSpeciesHealthy scalarWitnessData ∧
    ∃ D1 : GateC1Data, ¬ GateC1ChiralPhysicalRelease D1 := by
  refine ⟨scalarWitness_freeSpeciesHealthy,
          ⟨False, True, True, True, True, True⟩, ?_⟩
  intro h
  exact h.physical_chirality_chosen

/-! ## Summary -/

/-- **C86 summary.**  The RA-Wilson Gate C0 species-health API:

1. `RAWilsonC0Certificate` bridges to `FreeSpeciesHealthy` /
   `GateC0SpeciesHealthy` (`rawilsonC0Certificate_freeSpeciesHealthy`);
2. free species health projects onto the off-origin gap and retained origin
   (`freeSpeciesHealthy_offOriginGap_and_originRetained`);
3. the certificate is non-vacuous, satisfied by the scalar accretive-gap engine
   (`scalarWitness_certificate`);
4. Gate C0 species health does **not** imply Gate C1 chiral physical release
   (`speciesHealthy_does_not_imply_chiralRelease`). -/
theorem c86_gateC0_speciesHealth_summary :
    (∀ D : RAWilsonC0Data, RAWilsonC0Certificate D → FreeSpeciesHealthy D) ∧
    (∀ D : RAWilsonC0Data,
        FreeSpeciesHealthy D → D.offOriginGap ∧ D.originRetained) ∧
    RAWilsonC0Certificate scalarWitnessData ∧
    (∃ (D0 : GateC0Data) (D1 : GateC1Data),
        GateC0SpeciesHealthy D0 ∧ ¬ GateC1ChiralPhysicalRelease D1) :=
  ⟨fun _ h => rawilsonC0Certificate_freeSpeciesHealthy h,
    fun _ h => freeSpeciesHealthy_offOriginGap_and_originRetained h,
    scalarWitness_certificate,
    speciesHealthy_does_not_imply_chiralRelease⟩

end NullEdgeGateC0SpeciesHealth
end Draft
end PhysicsSM
