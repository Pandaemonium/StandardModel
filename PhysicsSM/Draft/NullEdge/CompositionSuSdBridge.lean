import PhysicsSM.Draft.NullEdge.CompositionWeakLaddersRight
import PhysicsSM.Draft.NullEdge.CompositionWeakLadders
import PhysicsSM.Algebra.Furey.MinimalLeftIdeal

/-!
# Rank-one structure theorems: the omega-nest towers collapse to ONE ladder

**Status: STRUCTURE THEOREM LAYER (CORRECTION 8 route A resolution,
pre-registered in the S2b design note 2026-07-18).** Free-`z` kernel probes
revealed, and this file proves for ARBITRARY `z`:

1. **Tower collapse**: `hatOmega = hatOmegaRbDag` and
   `hatOmegaDag = hatOmegaRb` as global operator identities on all of
   `C (x) O`. The left triple-creation nest `alpha1 (alpha2 (alpha3 z))`
   EQUALS the right daggered nest `((z alpha1') alpha2') alpha3'` - the
   "two towers" built this session are ONE rank-one ladder pair.
2. **Rank one**: `hatOmegaRbDag z = phi(z) . vIdemStar` and
   `hatOmegaRb z = psi(z) . vIdem` with explicit C-linear functionals
   `phi(z) = -(z.re.c7 + z.im.c0) + (z.re.c0 - z.im.c7) i`,
   `psi(z) = (z.im.c0 - z.re.c7) - (z.re.c0 + z.im.c7) i`.
   Both nests read ONLY the head-plane coordinates
   `{re.c0, re.c7, im.c0, im.c7}` and land ONLY on the idempotent lines
   `C vIdemStar` / `C vIdem`.
3. **Plane identification**: `nuState = i . vIdemStar` - the left-tower mode
   plane `span{v, nu}` IS the idempotent plane `span{v, v*}`.

**Consequences (honest no-go, subsumes both probe batteries):** a rank-one
operator sends every state to a multiple of ONE fixed state, so the images of
any two states are collinear. `TPlusEnd`'s abstract table (`1,2,3 -> 4,5,6`,
three linearly independent images) is therefore unrealizable by these nests on
ANY packaging of states - single-ideal, doubled `Su (+) Sd`, or otherwise.
This closes CORRECTION 8 route A negatively by structure, not state-by-state:
the earlier Jbar zeros and the route-A battery zeros below are corollaries.
The isospin action on COLOURED states must come from operators with colour
support - exactly the eq-37 `B_j = i e7 | beta_j` layer already validated in
`CompositionCl10Probe` (the `Mix11` witness has colour content). The
head-plane su(2)/CAR/chirality results of the composition tower are untouched:
they live where the action is.

All theorems here are kernel-checked over free variables (no probes, no
`n a t i v e _ d e c i d e`); axiom guards at the bottom.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CompositionSuSdBridge

open PhysicsSM.Algebra.Octonion.ComplexOctonion
open PhysicsSM.Algebra.Furey.LadderOperators
open PhysicsSM.Draft.NullEdge.DixonWeakCARTau3 (vIdem vIdemStar)
open PhysicsSM.Draft.NullEdge.CompositionWeakLaddersRight
open PhysicsSM.Draft.NullEdge.CompositionWeakLadders

set_option maxHeartbeats 64000000
set_option maxRecDepth 20000

/-- The coefficient functional of the raising nest: `phi(z)` is the complex
number `-(z.re.c7 + z.im.c0) + (z.re.c0 - z.im.c7) i`. C-linear in `z`. -/
def phi (z : ComplexOctonion) : ℂ :=
  ⟨-(z.re.c7 + z.im.c0), z.re.c0 - z.im.c7⟩

/-- The coefficient functional of the lowering nest: `psi(z)` is the complex
number `(z.im.c0 - z.re.c7) - (z.re.c0 + z.im.c7) i`. C-linear in `z`. -/
def psi (z : ComplexOctonion) : ℂ :=
  ⟨z.im.c0 - z.re.c7, -(z.re.c0 + z.im.c7)⟩

/-- **Rank-one structure of the daggered right nest**: for every `z`,
`hatOmegaRbDag z = phi(z) . vIdemStar`. The nest reads only the head-plane
coordinates of `z` and lands on the complex line through `vIdemStar`. -/
theorem hatOmegaRbDag_rank_one (z : ComplexOctonion) :
    hatOmegaRbDag z = phi z • vIdemStar := by
  unfold hatOmegaRbDag phi
  ext <;>
    simp [alpha1_dag, alpha2_dag, alpha3_dag, vIdemStar,
      ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

/-- **Rank-one structure of the plain right nest**: for every `z`,
`hatOmegaRb z = psi(z) . vIdem`. -/
theorem hatOmegaRb_rank_one (z : ComplexOctonion) :
    hatOmegaRb z = psi z • vIdem := by
  unfold hatOmegaRb psi
  ext <;>
    simp [alpha1, alpha2, alpha3, vIdem,
      ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

/-- **Tower collapse, raising side**: the LEFT creation nest
`alpha1 (alpha2 (alpha3 z))` equals the RIGHT daggered nest
`((z alpha1') alpha2') alpha3'` for every `z`. The two towers are one. -/
theorem hatOmega_eq_hatOmegaRbDag (z : ComplexOctonion) :
    hatOmega z = hatOmegaRbDag z := by
  unfold hatOmega hatOmegaRbDag
  ext <;>
    simp [alpha1, alpha2, alpha3, alpha1_dag, alpha2_dag, alpha3_dag,
      ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

/-- **Tower collapse, lowering side**: `hatOmegaDag z = hatOmegaRb z`. -/
theorem hatOmegaDag_eq_hatOmegaRb (z : ComplexOctonion) :
    hatOmegaDag z = hatOmegaRb z := by
  unfold hatOmegaDag hatOmegaRb
  ext <;>
    simp [alpha1, alpha2, alpha3, alpha1_dag, alpha2_dag, alpha3_dag,
      ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

/-- Rank-one structure of the left creation nest (corollary of the collapse). -/
theorem hatOmega_rank_one (z : ComplexOctonion) :
    hatOmega z = phi z • vIdemStar := by
  rw [hatOmega_eq_hatOmegaRbDag, hatOmegaRbDag_rank_one]

/-- Rank-one structure of the left annihilation nest. -/
theorem hatOmegaDag_rank_one (z : ComplexOctonion) :
    hatOmegaDag z = psi z • vIdem := by
  rw [hatOmegaDag_eq_hatOmegaRb, hatOmegaRb_rank_one]

/-- **Plane identification**: the left-tower excited mode `nuState` is
`i . vIdemStar` - the mode plane and the idempotent plane coincide. -/
theorem nuState_eq_I_smul_vIdemStar :
    nuState = Complex.I • vIdemStar := by
  unfold nuState
  ext <;>
    simp [alpha1, alpha2, alpha3, vIdem, vIdemStar, Complex.I,
      ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

/-- Collinearity: every image of the raising nest lies on `C vIdemStar`. -/
theorem hatOmegaRbDag_image_collinear (z : ComplexOctonion) :
    ∃ c : ℂ, hatOmegaRbDag z = c • vIdemStar :=
  ⟨phi z, hatOmegaRbDag_rank_one z⟩

open PhysicsSM.Algebra.Furey.MinimalLeftIdeal in
/-- **Route-A battery, corollary form** (pre-registered outcome: ROUTE A
DEAD). The daggered nest annihilates all three Su-excited states - their
head-plane coordinates vanish, so `phi = 0`. With the earlier Jbar zeros this
completes the kill condition: one-sided omega-nests cannot implement the
doubled-packaging `T_+` either. -/
theorem probe_RbDag_su_excited :
    hatOmegaRbDag v1 = 0 ∧ hatOmegaRbDag v4 = 0 ∧ hatOmegaRbDag nu = 0 := by
  refine ⟨?_, ?_, ?_⟩ <;>
    rw [hatOmegaRbDag_rank_one] <;>
    · rw [show phi _ = 0 by
        simp [phi, PhysicsSM.Algebra.Furey.MinimalLeftIdeal.v1,
          PhysicsSM.Algebra.Furey.MinimalLeftIdeal.v4,
          PhysicsSM.Algebra.Furey.MinimalLeftIdeal.nu]
        norm_num [Complex.ext_iff]]
      exact zero_smul ℂ _

open PhysicsSM.Algebra.Furey.MinimalLeftIdeal in
/-- Route-A battery, plain-nest side: `hatOmegaRb` annihilates the
COLOUR-excited states `v1`, `v4` (`psi = 0` on them). `nu` is deliberately
NOT in this list - it lies IN the head plane (`nu = i . vIdemStar`), see the
next theorem. -/
theorem probe_Rb_su_excited :
    hatOmegaRb v1 = 0 ∧ hatOmegaRb v4 = 0 := by
  refine ⟨?_, ?_⟩ <;>
    rw [hatOmegaRb_rank_one] <;>
    · rw [show psi _ = 0 by
        simp [psi, PhysicsSM.Algebra.Furey.MinimalLeftIdeal.v1,
          PhysicsSM.Algebra.Furey.MinimalLeftIdeal.v4]
        norm_num [Complex.ext_iff]]
      exact zero_smul ℂ _

open PhysicsSM.Algebra.Furey.MinimalLeftIdeal in
/-- The head-plane exception, computed honestly: `psi(nu) = 1`, so
`hatOmegaRb nu = vIdem`. This is the tower collapse seen on states - the
LEFT-tower atom `hatOmegaDag nuState = vIdem` re-derived through the RIGHT
nest's rank-one formula. `nu` is not a colour excitation; it is the second
basis vector of the head plane itself. -/
theorem hatOmegaRb_nu : hatOmegaRb nu = vIdem := by
  rw [hatOmegaRb_rank_one]
  rw [show psi nu = 1 by
    simp [psi, PhysicsSM.Algebra.Furey.MinimalLeftIdeal.nu]
    norm_num [Complex.ext_iff]]
  exact one_smul ℂ _

/-- **Grading collapse**: `hatTau3R = -hatTau3` as global operators -
immediate from the tower collapse, since
`hatTau3R = Rb RbDag - RbDag Rb = hatOmegaDag hatOmega - hatOmega hatOmegaDag`.
The two towers' isospin gradings are literal negatives, explaining the
opposite orientations observed on the head plane
(`hatTau3 vIdem = -vIdem` vs `hatTau3R vIdem = vIdem`). -/
theorem hatTau3R_eq_neg_hatTau3 (z : ComplexOctonion) :
    hatTau3R z = -(hatTau3 z) := by
  unfold hatTau3R hatTau3
  rw [← hatOmega_eq_hatOmegaRbDag z, ← hatOmegaDag_eq_hatOmegaRb (hatOmega z),
    ← hatOmegaDag_eq_hatOmegaRb z, ← hatOmega_eq_hatOmegaRbDag (hatOmegaDag z)]
  abel

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionSuSdBridge.hatTau3R_eq_neg_hatTau3' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionSuSdBridge.hatTau3R_eq_neg_hatTau3

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionSuSdBridge.hatOmegaRbDag_rank_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionSuSdBridge.hatOmegaRbDag_rank_one

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionSuSdBridge.hatOmega_eq_hatOmegaRbDag' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionSuSdBridge.hatOmega_eq_hatOmegaRbDag

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionSuSdBridge.hatOmegaDag_eq_hatOmegaRb' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionSuSdBridge.hatOmegaDag_eq_hatOmegaRb

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionSuSdBridge.nuState_eq_I_smul_vIdemStar' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionSuSdBridge.nuState_eq_I_smul_vIdemStar

/-- info: 'PhysicsSM.Draft.NullEdge.CompositionSuSdBridge.probe_RbDag_su_excited' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CompositionSuSdBridge.probe_RbDag_su_excited

end PhysicsSM.Draft.NullEdge.CompositionSuSdBridge
