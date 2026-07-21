import PhysicsSM.Draft.NullEdge.FullFockPairExponential
import PhysicsSM.Draft.NullEdge.PairActiveSectorExponential

/-!
# Paper E gate: the canonical pair evolution is an exact operator exponential

Target statements for the Aristotle job `pair-exponential-bridge-20260718`.

Context.  `FullFockPairExponential` proves (zero holes, axiom-guarded) that
the matrix exponential of its LOCAL sixteen-dimensional generator
`KopMatrix z` equals its LOCAL closed form `Uop` on every occupation
coordinate (`exp_mulVec_eq_Uop`).  Its own scope note records the missing
step: `KopMatrix`/`Uop` are local redeclarations, NOT the canonical live
objects `PlueckerPairGenerator.Kop` / `PlueckerPairGenerator.Uop` used by
`PairActiveSectorExponential` and the Paper E manuscript.  "Structural
similarity is not an API bridge."  This module states the exact bridge and
the composed canonical theorem, closing that gap.

Type note: the canonical Fock space is `Fock (Fin 4) = Finset (Fin 4) → ℂ`
(check the exact definition in `FiniteCARFockBasic`); the local `Occ`/`Fock`
of `FullFockPairExponential` should be definitionally the same carrier.  If
a transport map is genuinely needed, define the explicit equiv, state the
bridge through it, and record that prominently.

Pre-registered honesty license: if a bridge equality fails (a genuine
mismatch between local and canonical definitions - e.g. a sign, ordering,
or normalization difference), prove the corrected relation (with the exact
mismatch factor) instead, rename accordingly, and record it prominently:
an exact mismatch report is a success outcome.  Every `s o r r y` below is
a documented Aristotle handoff hole.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.PairExponentialCanonicalBridge

open PhysicsSM.Draft.NullEdge

/-- **Bridge 1.**  The local generator matrix acts (by `mulVec`) exactly as
the canonical quartic pair generator `Kop`. -/
theorem kopMatrix_mulVec_eq_Kop (z : ℂ) (psi : FullFockPairExponential.Fock) :
    (FullFockPairExponential.KopMatrix z).mulVec psi
      = PlueckerPairGenerator.Kop z psi := by
  convert PlueckerPairGenerator.Kop_eq_quartic z psi using 1;
  ext S
  simp +decide [PlueckerPairGenerator.Kop_apply, FullFockPairExponential.KopMatrix,
    Matrix.mulVec, dotProduct, Finset.sum_ite]
  split_ifs <;> simp_all +decide [ Finset.sum_filter ];
  · exact Or.inl rfl;
  · exact Or.inl rfl;
  · simp_all +decide [PlueckerQuarticInteraction.lowPair,
      PlueckerQuarticInteraction.highPair, FullFockPairExponential.lowPair,
      FullFockPairExponential.highPair]

/-- **Bridge 2.**  The local closed-form evolution equals the canonical
`Uop` at every parameter point. -/
theorem uop_local_eq_canonical (c s : ℝ) (z : ℂ) (m : ℝ)
    (psi : FullFockPairExponential.Fock) :
    FullFockPairExponential.Uop c s z m psi
      = PlueckerPairGenerator.Uop c s z m psi := by
  unfold FullFockPairExponential.Uop PlueckerPairGenerator.Uop; aesop;

/-- **Composed canonical theorem (the Paper E gate).**  The canonical pair
evolution at angle `a` is the exact matrix exponential of the canonical
generator: `exp (-(a) • i • Kop-matrix)` applied to `psi` equals
`Uop (cos (a‖z‖)) (sin (a‖z‖)) z ...` in the canonical API.  State via the
local exponential theorem `exp_mulVec_eq_Uop` composed with bridges 1-2;
keep the exact parameter correspondence used there (read its statement and
mirror it canonically). -/
theorem canonical_pair_evolution_is_exponential (z : ℂ) (a : ℝ) (hz : z ≠ 0)
    (psi : FullFockPairExponential.Fock) :
    (NormedSpace.exp
        ((-(a : ℂ) * Complex.I) • FullFockPairExponential.KopMatrix z)).mulVec psi
      = PlueckerPairGenerator.Uop (Real.cos (a * ‖z‖)) (Real.sin (a * ‖z‖)) z ‖z‖ psi := by
  convert FullFockPairExponential.exp_mulVec_eq_Uop z a hz psi using 1

end PhysicsSM.Draft.NullEdge.PairExponentialCanonicalBridge

/-! ## Axiom-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PairExponentialCanonicalBridge.kopMatrix_mulVec_eq_Kop' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PairExponentialCanonicalBridge.kopMatrix_mulVec_eq_Kop

/-- info: 'PhysicsSM.Draft.NullEdge.PairExponentialCanonicalBridge.uop_local_eq_canonical' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PairExponentialCanonicalBridge.uop_local_eq_canonical

/-- info: 'PhysicsSM.Draft.NullEdge.PairExponentialCanonicalBridge.canonical_pair_evolution_is_exponential' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.PairExponentialCanonicalBridge.canonical_pair_evolution_is_exponential
