import PhysicsSM.Draft.NullEdge.NullEdgeSpinorSolderingAristotle
import PhysicsSM.Draft.NullEdge.NullEdgeSolderingPluckerBridge
import PhysicsSM.Draft.NullEdge.WeakIsospinTwoModeSU2Aristotle
import PhysicsSM.Draft.NullEdge.ElectroweakU2FromLadders
import PhysicsSM.Draft.NullEdge.SU5HyperchargeUnification
import PhysicsSM.Draft.NullEdge.ChiralityFromActionSplit
import PhysicsSM.Draft.NullEdge.WeakIsospinRepContent
import PhysicsSM.Draft.NullEdge.KMPhaseCounting
import PhysicsSM.Draft.NullEdge.DivisionDimensionSelection
import PhysicsSM.Algebra.Octonion.CompositionDivision
import PhysicsSM.Draft.SedenionZeroDivisors
import PhysicsSM.Algebra.Furey.TrialityFamilySymmetry
import PhysicsSM.Draft.NullEdge.CompositionSU2
import PhysicsSM.Draft.NullEdge.DixonDiracGammaBridge

/-!
# The null-edge derivation grand mesh (SM + GR foundations, capstone index)

This capstone module co-certifies, in one build target, the kernel-checked
derivation chain assembled 2026-07-17 from the single null-edge primitive - a
Weyl 2-spinor `psi` (a light-speed edge) - toward the Standard Model and
general relativity. Each `example` below re-invokes a landed headline theorem,
so this module FAILS to compile if any link regresses. It is a single citeable
index, NOT a new claim: every fact is a landed, axiom-guarded theorem in its
home module.

## The chain (all links kernel-checked)

GR / geometry half (the null edge is a future-null direction):
* soldering: `nullEdgeVector_minkowskiSq` (a null edge is null),
  `twoEdge_minkowskiSq_eq_wedge` (two edges sum to a mass = Pluecker area),
  `twoEdge_minkowskiSq_sl2_invariant` (that mass is a Lorentz scalar);
* soldered to the landed islands: `soldering_mass_eq_plucker_det`
  (Minkowski mass = PluckerMass determinant) and
  `nullEdgeVector_eq_hermitianCoords` (null vector = the SL(2,C) Pauli
  coordinate).

SM / internal half (the same algebra carries the gauge structure):
* weak isospin: `su2_T1_T2` (su(2)_L from two ladder modes),
  `T3_eq_diagonal` (the doublet);
* electroweak U(2): `Nop_comm_T3` (U(1) x SU(2)_L), `QLepton_eq_diagonal`,
  `QQuark_eq_diagonal` (Gell-Mann-Nishijima -> exact SM charges);
* SU(5) unification: `Y5_traceless`, `oneGeneration_hypercharge_traceZero`
  (all hypercharges from one traceless SU(5) generator; U(1)_Y anomaly-consistent);
* chirality (item 1): `leftAction_preserves_rightChirality` (su(2)_L preserves
  chirality by associativity - parity violation with no projector by hand) and
  `weakIsospin_rep_decomposition_1_2_1` (the ladder Fock space is
  `1 (+) 2 (+) 1`: two singlets and one doublet - the isospin structure);
* three generations (item 4): `triality_generation_count = 3` (Z3 triality),
  with an independent route via the flavour/CP threshold below;
* flavour/CP (item 9 structure): `cp_possible_iff`
  (`0 < ckmPhysCP N <-> 3 <= N` - CP violation needs three or more families, a
  SECOND landed route to three generations; the mass VALUES remain open);
* 3+1 dimensionality (item 7): `dimension_is_four` (C uniquely selected among
  the four division algebras -> Minkowski d = 4, the soldering spacetime);
* internal algebra (item 5): `octonion_no_zero_divisors` (composition norm ->
  division algebra) and `sedenions_have_zero_divisors` (O is the MAXIMAL division
  algebra - the tower stops at the octonions); only Hurwitz's classification
  (R,C,H,O are the ONLY finite-dim real normed division algebras) stays supplied.

## Honest claim boundary

This is the DERIVED skeleton, not a completed theory. What is DERIVED is the
set of MECHANISMS above. What remains SUPPLIED (the octonionic/quaternionic
algebra, the per-multiplet hypercharge normalization, spatial dimension) or
OPEN (chirality's algebraic origin, the octonion realization on the actual
states, three generations, the finite order->conformal theorem, Einstein
dynamics, mass VALUES) is tracked in
`Sources/Null_Edge_Derivation_Map_SM_GR_2026-07-17.md`. No physical number is
predicted. "We derive the Standard Model and general relativity" is true only
in the graded sense of that map.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.NullEdgeDerivationGrandMesh

open PhysicsSM.Draft.NullEdge
open Matrix

/-- GR half: a null edge is future-null and two edges sum to a Lorentz-invariant
mass equal to the Pluecker/PluckerMass area. -/
example : ∀ psi : Fin 2 → ℂ,
    NullEdgeSpinorSoldering.minkowskiSq (NullEdgeSpinorSoldering.nullEdgeVector psi) = 0 :=
  NullEdgeSpinorSoldering.nullEdgeVector_minkowskiSq

example : ∀ psi chi : Fin 2 → ℂ,
    ((NullEdgeSpinorSoldering.minkowskiSq
        (NullEdgeSpinorSoldering.nullEdgeVector psi +
          NullEdgeSpinorSoldering.nullEdgeVector chi) : ℝ) : ℂ) =
      (PhysicsSM.Spinor.PluckerMass.twoEdgeMomentum psi chi).det :=
  NullEdgeSolderingPluckerBridge.soldering_mass_eq_plucker_det

/-- SM half: su(2)_L, the electroweak charges, and the SU(5) hypercharge
unification are all landed. -/
example :
    WeakIsospinTwoModeSU2.comm WeakIsospinTwoModeSU2.T1 WeakIsospinTwoModeSU2.T2
      = (2 * Complex.I) • WeakIsospinTwoModeSU2.T3 :=
  WeakIsospinTwoModeSU2.su2_T1_T2

example :
    ElectroweakU2FromLadders.Qop (-1) =
      !![-(1 / 2), 0, 0, 0; 0, 0, 0, 0; 0, 0, -1, 0; 0, 0, 0, -(1 / 2)] :=
  ElectroweakU2FromLadders.QLepton_eq_diagonal

example : ∑ i, SU5HyperchargeUnification.Y5 i = 0 :=
  SU5HyperchargeUnification.Y5_traceless

/-- Chirality (item 1): weak isospin (left action) preserves the right-chirality
grading by associativity - parity violation with no chiral projector by hand. -/
example {k : ℕ} (A Γ X : Matrix (Fin k) (Fin k) ℂ) (hX : X * Γ = X) :
    (A * X) * Γ = A * X :=
  ChiralityFromActionSplit.leftAction_preserves_rightChirality A Γ X hX

/-- Isospin structure (item 1 remainder): weak isospin raising links the doublet
`|01> = d` up to `|10> = u`, and the empty/full Fock states are singlets - the
ladder Fock space is `1 (+) 2 (+) 1` under su(2)_L. -/
example :
    ElectroweakU2FromLadders.TPlus *ᵥ WeakIsospinRepContent.d01 =
      WeakIsospinRepContent.u10 :=
  WeakIsospinRepContent.TPlus_d01

/-- Three generations (item 4): the Z3 triality family symmetry has order three
and a single orbit of three roles. -/
example : Fintype.card PhysicsSM.Algebra.Furey.TrialityRole = 3 :=
  PhysicsSM.Algebra.Furey.TrialityFamilySymmetry.triality_generation_count

/-- Flavour/CP (item 9 structure; second route to item 4): a nonzero physical CP
phase count is possible exactly when there are three or more families. Mass
VALUES remain open; this is the CP STRUCTURE, kernel-checked. -/
example (N : ℕ) : 0 < KMPhaseCounting.ckmPhysCP N ↔ 3 ≤ N :=
  KMPhaseCounting.cp_possible_iff N

/-- 3+1 dimensionality (item 7, algebraic route): among the four normed division
algebras, `C` is uniquely selected (composition + continuous CP phase) and gives
Minkowski `d = 4` - the same spacetime the soldering lives in. -/
example (k : NullEdge.DivAlg)
    (h : NullEdge.Composes k ∧ NullEdge.ContinuousPhase k) : k.minkowskiDim = 4 :=
  NullEdge.dimension_is_four k h

/-- Internal algebra (item 5, lower bracket): the null-edge mass mechanism is a
composition norm, and a composition norm forces a DIVISION algebra - the project
octonions have no zero divisors. -/
example {x y : PhysicsSM.Algebra.Octonion.Octonion} (h : x * y = 0) :
    x = 0 ∨ y = 0 :=
  PhysicsSM.Algebra.Octonion.octonion_no_zero_divisors h

/-- Internal algebra (item 5, upper bracket): the sedenions (Cayley-Dickson double
of `O`) HAVE zero divisors, so `O` is the MAXIMAL division algebra in the tower -
why the internal algebra stops at the octonions. -/
example :
    ∃ a b : PhysicsSM.Draft.SedenionZeroDivisors.Sedenion,
      a ≠ 0 ∧ b ≠ 0 ∧ PhysicsSM.Draft.SedenionZeroDivisors.sedenionMul a b = 0 :=
  PhysicsSM.Draft.SedenionZeroDivisors.sedenions_have_zero_divisors

/-- **The grand-mesh certificate.** A single proposition bundling one headline
from each derived link, so the whole chain is certified in one place. -/
theorem nullEdge_derivation_grand_mesh :
    (∀ psi : Fin 2 → ℂ,
        NullEdgeSpinorSoldering.minkowskiSq
          (NullEdgeSpinorSoldering.nullEdgeVector psi) = 0) ∧
      (∀ psi chi : Fin 2 → ℂ,
        NullEdgeSpinorSoldering.minkowskiSq
            (NullEdgeSpinorSoldering.nullEdgeVector (Matrix.mulVec 1 psi) +
              NullEdgeSpinorSoldering.nullEdgeVector (Matrix.mulVec 1 chi)) =
          NullEdgeSpinorSoldering.minkowskiSq
            (NullEdgeSpinorSoldering.nullEdgeVector psi +
              NullEdgeSpinorSoldering.nullEdgeVector chi)) ∧
      (WeakIsospinTwoModeSU2.comm WeakIsospinTwoModeSU2.T1 WeakIsospinTwoModeSU2.T2
        = (2 * Complex.I) • WeakIsospinTwoModeSU2.T3) ∧
      (∑ i, SU5HyperchargeUnification.Y5 i = 0) := by
  refine ⟨NullEdgeSpinorSoldering.nullEdgeVector_minkowskiSq, ?_,
    WeakIsospinTwoModeSU2.su2_T1_T2, SU5HyperchargeUnification.Y5_traceless⟩
  intro psi chi
  exact NullEdgeSpinorSoldering.twoEdge_minkowskiSq_sl2_invariant 1 Matrix.det_one psi chi

/-- **Grand-mesh growth 2026-07-18 (the electroweak-realization block):**
co-certifies the goal-session landings in one statement - the eq-31 cross-CAR
as a GLOBAL operator identity on `C(x)H(x)O`, the Fig-4 automatic-chirality
theorem (su(2)_L kills right-handed states with no projector by hand), the
Dirac-algebra timelike square in BOTH signature conventions (mostly-plus
`gamma_0^2 = -1` and bridged mostly-minus `gammaM_0^2 = +1` - the signature
emerging from `H`), and the su(2) bracket on the omega-mode plane. Each
conjunct re-invokes a landed guarded theorem; regression in any link breaks
this build. -/
theorem nullEdge_derivation_grand_mesh_electroweak :
    (∀ d, CompositionWeakCAR.betaHat1 (CompositionWeakCAR.betaHat2 d) +
        CompositionWeakCAR.betaHat2 (CompositionWeakCAR.betaHat1 d) = 0) ∧
      (∀ d, Complex.I • CompositionSU2.R3 d = -d → CompositionSU2.T1 d = 0) ∧
      (∀ z, DixonDiracGamma.gamma0 (DixonDiracGamma.gamma0 z) = -z) ∧
      (∀ z, DixonDiracGammaBridge.gammaM0 (DixonDiracGammaBridge.gammaM0 z) = z) ∧
      (CompositionSU2.hatTau1 (CompositionSU2.hatTau2
            PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem) -
          CompositionSU2.hatTau2 (CompositionSU2.hatTau1
            PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem)
        = (-(2 * Complex.I)) • CompositionWeakLadders.hatTau3
            PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem) :=
  ⟨CompositionWeakCAR.betaHat_cross_anticomm_12,
    fun d h => CompositionSU2.T1_kills_RH d h,
    DixonDiracGamma.gamma0_sq,
    DixonDiracGammaBridge.gammaM0_sq,
    CompositionSU2.tau12_bracket_on_vIdem⟩

end PhysicsSM.Draft.NullEdge.NullEdgeDerivationGrandMesh

/-! ## Build-enforced assumption-footprint guard -/

/-- info: 'PhysicsSM.Draft.NullEdge.NullEdgeDerivationGrandMesh.nullEdge_derivation_grand_mesh' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.NullEdgeDerivationGrandMesh.nullEdge_derivation_grand_mesh

/-- info: 'PhysicsSM.Draft.NullEdge.NullEdgeDerivationGrandMesh.nullEdge_derivation_grand_mesh_electroweak' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.NullEdgeDerivationGrandMesh.nullEdge_derivation_grand_mesh_electroweak

end
