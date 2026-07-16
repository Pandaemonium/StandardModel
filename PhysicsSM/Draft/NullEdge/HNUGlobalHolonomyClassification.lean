import PhysicsSM.Draft.NullEdge.AntiperiodicHNU

/-!
# HNU global-frame holonomy classification

This module separates a uniform basis change from a physically different
projector schedule. It provides a small projector-pair API, proves single-step
unitary conjugation laws, and proves the product law when the same frame `G` is
used for every substep.

## The verdict (all proved below)

* **Gauge invariance / control.** A *global* (uniform) frame change conjugates the whole holonomy;
  since the HNU holonomy is the *central* element `-1`
  (`hnu_holonomy`), every global frame change fixes it: `hnu_holonomy_gauge_invariant`.  A pure
  basis conjugation therefore **cannot** remove the `-1`.  This is the required separation of
  gauge/basis conjugation from a physically different holonomy.

* **Not a universal obstruction.** The `-1` is not forced by having a nontrivial reflection on
  every substep. The explicit alternating-axis list has every
  reflection nontrivial (`alt_refl_ne_one`, `alt_refl_ne_neg_one`, and each is a genuine
  `sectorRefl`, `sigma1_is_sectorRefl`/`sigma2_is_sectorRefl`) yet its holonomy is the *identity*
  center element `+1` (`alt_holonomy`). The central `-1` is therefore a property
  of the specific HNU axis ordering and signs, not a universal consequence of
  using nontrivial reflections.

* **The sharp separation.** Removing the `-1` is not achievable by
  pure gauge: `alt_not_global_gauge_of_hnu` proves there is *no* global unitary conjugation carrying
  the HNU reflection list to the alternating list, precisely because such a conjugation would fix the
  two different central elements. The alternating list is a physically
  different projector sequence, not a transported HNU frame.

* **What the determinant cannot see.**  The determinant of the holonomy is `+1` for *both* lists
  (`hnu_holonomy_det`, `alt_holonomy_det`): the `SU(2)` membership is frame-independent and cannot
  distinguish the sectors.  The distinguishing invariant is the trace / center element
  (`hnu_holonomy_trace = -2` vs `alt_holonomy_trace = 2`).

Scope: `prod_conj` uses one uniform `G`. This module does not prove a
schedule-indexed varying-frame telescope. With varying frames, intermediate
link cocycles remain and require a separate theorem. Nothing here cancels a
zero/pi sector or proves locality, anomaly inflow, bulk-edge correspondence,
primitive-null support, or a 3+1 completion.

Provenance: clean-room integration of Aristotle project
`e9a3645d-b658-46fe-b761-5b260df7ddad`, task
`c538c705-e7e8-4bba-b80d-f8e9dcdee58d`, independently reviewed by interactive
Claude/Opus on 2026-07-13. The reviewer approved the global-gauge and
classification subset and explicitly rejected a varying-frame reading.
-/

open Matrix Complex
open PhysicsSM.Draft.NullEdge.HNUExactCore
open PhysicsSM.Draft.NullEdge.AntiperiodicHNU

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HNUGlobalHolonomyClassification

/-- Complementary orthogonal idempotents in a ring. -/
structure ProjPair (R : Type*) [Ring R] where
  P : R
  Q : R
  idemP : P * P = P
  idemQ : Q * Q = Q
  orthPQ : P * Q = 0
  orthQP : Q * P = 0
  complete : P + Q = 1

/-- A self-adjoint complementary projector pair. -/
structure OrthProjPair (R : Type*) [Ring R] [StarRing R] extends ProjPair R where
  saP : star P = P
  saQ : star Q = Q

/-- Unit-modulus shift phase used by the selected coarse update. -/
def ph (theta : Real) : Complex := Complex.exp (theta * Complex.I)

/-- Projector-conditioned selected update. -/
def coarse {R : Type*} [Ring R] [Algebra Complex R]
    (d : ProjPair R) (k : Real) : R := ph k • d.P + d.Q

/-! ## Part A. The sector reflection of a projector pair -/

variable {R : Type*} [Ring R]

/-- The **sector reflection** `S = P - Q = 2P - 1` of a complementary projector pair: the center of
the antiperiodic mechanism, `+1` on the moved sector and `-1` on the held sector. -/
def sectorRefl (d : ProjPair R) : R := d.P - d.Q

/-- A sector reflection is an involution: `S * S = 1`. -/
theorem sectorRefl_sq (d : ProjPair R) : sectorRefl d * sectorRefl d = 1 := by
  unfold sectorRefl
  rw [mul_sub, sub_mul, sub_mul, d.idemP, d.orthPQ, d.orthQP, d.idemQ, ← d.complete]
  abel

/-! ## Part B. Inter-step unitary frame transport by conjugation

A frame transport is a unitary `G` (`star G * G = 1`, `G * star G = 1`) acting on projector pairs by
conjugation by `G`. This realizes one instance of the requested transport relation:
the transported pair `conjPair G _ _ d` is the pair at the next step. -/

section StarRing
variable {S : Type*} [Ring S] [StarRing S]

/-- **Frame transport of a projector pair** by a unitary `G`, using conjugation
on both projectors. This is a single-step co-moving frame relation. -/
def conjPair (G : S) (hG : star G * G = 1) (hG' : G * star G = 1) (d : OrthProjPair S) :
    OrthProjPair S where
  P := G * d.P * star G
  Q := G * d.Q * star G
  idemP := by
    have h := d.idemP
    calc G * d.P * star G * (G * d.P * star G)
        = G * d.P * (star G * G) * d.P * star G := by noncomm_ring
      _ = G * (d.P * d.P) * star G := by rw [hG]; noncomm_ring
      _ = G * d.P * star G := by rw [h]
  idemQ := by
    have h := d.idemQ
    calc G * d.Q * star G * (G * d.Q * star G)
        = G * d.Q * (star G * G) * d.Q * star G := by noncomm_ring
      _ = G * (d.Q * d.Q) * star G := by rw [hG]; noncomm_ring
      _ = G * d.Q * star G := by rw [h]
  orthPQ := by
    have h := d.orthPQ
    calc G * d.P * star G * (G * d.Q * star G)
        = G * d.P * (star G * G) * d.Q * star G := by noncomm_ring
      _ = G * (d.P * d.Q) * star G := by rw [hG]; noncomm_ring
      _ = 0 := by rw [h]; noncomm_ring
  orthQP := by
    have h := d.orthQP
    calc G * d.Q * star G * (G * d.P * star G)
        = G * d.Q * (star G * G) * d.P * star G := by noncomm_ring
      _ = G * (d.Q * d.P) * star G := by rw [hG]; noncomm_ring
      _ = 0 := by rw [h]; noncomm_ring
  complete := by
    have h := d.complete
    calc G * d.P * star G + G * d.Q * star G
        = G * (d.P + d.Q) * star G := by noncomm_ring
      _ = G * star G := by rw [h, mul_one]
      _ = 1 := hG'
  saP := by
    have h := d.saP
    rw [StarMul.star_mul, StarMul.star_mul, star_star, h, mul_assoc]
  saQ := by
    have h := d.saQ
    rw [StarMul.star_mul, StarMul.star_mul, star_star, h, mul_assoc]

/-- **Transport law for the complement reflection.**  The sector reflection transports by
conjugation by the same unitary. -/
theorem sectorRefl_conj (G : S) (hG : star G * G = 1) (hG' : G * star G = 1) (d : OrthProjPair S) :
    sectorRefl (conjPair G hG hG' d).toProjPair = G * sectorRefl d.toProjPair * star G := by
  show G * d.P * star G - G * d.Q * star G = G * (d.P - d.Q) * star G
  noncomm_ring

/-- **Telescoping backbone.**  A product of conjugated operators is the conjugate of the product:
This is the exact transport law for both the selected endpoint and complement
holonomy under a *global* frame change. -/
theorem prod_conj (G : S) (hG : star G * G = 1) (hG' : G * star G = 1) (Ss : List S) :
    (Ss.map (fun s => G * s * star G)).prod = G * Ss.prod * star G := by
  induction Ss with
  | nil => simp [hG']
  | cons hd tl ih =>
    simp only [List.map_cons, List.prod_cons, ih]
    have : G * hd * star G * (G * tl.prod * star G)
          = G * hd * (star G * G) * tl.prod * star G := by noncomm_ring
    rw [this, hG]
    noncomm_ring

/-- Conjugation fixes the central element `-1`. Only one unitarity direction is needed. -/
theorem neg_one_conj (G : S) (hG' : G * star G = 1) : G * (-1 : S) * star G = -1 := by
  rw [mul_neg_one, neg_mul, hG']

/-- Conjugation fixes the central element `+1`. -/
theorem one_conj (G : S) (hG' : G * star G = 1) : G * (1 : S) * star G = 1 := by
  rw [mul_one, hG']

end StarRing

/-! ## Part C. Transport of the co-moving selected update

The selected substep in its co-moving frame is `coarse d k = e^{ik}•P + Q` (moves `P`, holds `Q`).
It transports by the *same* conjugation as the reflection, so the selected endpoint transforms by a
pure conjugation under a global frame change. -/

section Algebra
variable {S : Type*} [Ring S] [StarRing S] [Algebra ℂ S]

/-- **Transport law for the selected update.**  `coarse` transforms by conjugation:
The conjugated projector pair gives the conjugated coarse update. -/
theorem coarse_conj (G : S) (hG : star G * G = 1) (hG' : G * star G = 1) (d : OrthProjPair S)
    (k : ℝ) :
    coarse (conjPair G hG hG' d).toProjPair k = G * coarse d.toProjPair k * star G := by
  show ph k • (G * d.P * star G) + G * d.Q * star G = G * (ph k • d.toProjPair.P + d.toProjPair.Q) * star G
  rw [mul_add, add_mul, mul_smul_comm, smul_mul_assoc]

end Algebra

/-! ## Part D. The HNU axis schedule and its central complement holonomy

The eight HNU sector reflections, in equation (5) order (rightmost substep acts
first), are the signed Pauli list below. Their ordered product is the central
element `-1`. -/

/-- The eight HNU sector reflections in schedule order. -/
def hnuRefls : List M2 := [-σ1, -σ3, -σ2, σ3, σ1, -σ3, σ2, σ3]

/-- **The HNU complement holonomy is the central element `-1`.**  (Same content as
`AntiperiodicHNU.prodS_eq_neg_one`, packaged as a list product.) -/
theorem hnu_holonomy : hnuRefls.prod = -1 := by
  simp only [hnuRefls, σ1, σ2, σ3, List.prod_cons, List.prod_nil]
  norm_num [Matrix.mul_fin_two]
  ext i j; fin_cases i <;> fin_cases j <;> simp

/-- **Gauge invariance / fixed-frame control.**  Every *global* unitary frame change `G` fixes the
HNU complement holonomy at the central `-1`: a pure basis conjugation cannot remove it. -/
theorem hnu_holonomy_gauge_invariant (G : M2) (hG : star G * G = 1) (hG' : G * star G = 1) :
    (hnuRefls.map (fun s => G * s * star G)).prod = -1 := by
  rw [prod_conj G hG hG' hnuRefls, hnu_holonomy, neg_one_conj G hG']

/-- The HNU holonomy has trace `-2` (the center element `-1`). -/
theorem hnu_holonomy_trace : hnuRefls.prod.trace = -2 := by
  rw [hnu_holonomy]; simp

/-- The HNU holonomy has determinant `+1`: it lies in `SU(2)`.  The determinant is
frame-independent and does **not** detect the sector. -/
theorem hnu_holonomy_det : hnuRefls.prod.det = 1 := by
  rw [hnu_holonomy]; simp [Matrix.det_fin_two]

/-! ## Part E. A different reflection schedule with identity holonomy

The alternating-axis frame has a nontrivial reflection on every substep, yet its holonomy is the
identity center element `+1`.  Hence the central `-1` is **not** a universal obstruction of the
transported-frame mechanism: it is specific to the HNU axis ordering/signs. -/

/-- The alternating axis-one/axis-two reflection list. -/
def altRefls : List M2 := [σ1, σ2, σ1, σ2, σ1, σ2, σ1, σ2]

/-- **The alternating holonomy is the identity center element `+1`**, with a
nontrivial reflection on every substep. -/
theorem alt_holonomy : altRefls.prod = 1 := by
  simp only [altRefls, σ1, σ2, List.prod_cons, List.prod_nil]
  norm_num [Matrix.mul_fin_two]
  ext i j; fin_cases i <;> fin_cases j <;> simp

/-- The alternating holonomy has trace `+2` (the center element `+1`), in contrast to the HNU
holonomy's `-2`. -/
theorem alt_holonomy_trace : altRefls.prod.trace = 2 := by
  rw [alt_holonomy]; simp

/-- The alternating holonomy also has determinant `+1`: the determinant cannot distinguish it from
the HNU holonomy. -/
theorem alt_holonomy_det : altRefls.prod.det = 1 := by
  rw [alt_holonomy]; simp

/-! ### The alternating reflections are genuine, nontrivial sector reflections -/

/-- A Pauli `+`-frame: `P = P⁺(s)`, `Q = P⁻(s)` for an involutive Hermitian `s`.  Its sector
reflection is exactly `s`. -/
def pauliPlusPair (s : M2) (hs : s * s = 1) (hh : sᴴ = s) : OrthProjPair M2 where
  P := Pplus s
  Q := Pminus s
  idemP := Pplus_idem hs
  idemQ := Pminus_idem hs
  orthPQ := Pplus_mul_Pminus hs
  orthQP := Pminus_mul_Pplus hs
  complete := Pplus_add_Pminus s
  saP := by rw [Matrix.star_eq_conjTranspose, Pplus_herm hh]
  saQ := by rw [Matrix.star_eq_conjTranspose, Pminus_herm hh]

/-- The Pauli `+`-frame has sector reflection `s`. -/
theorem sectorRefl_pauliPlusPair (s : M2) (hs : s * s = 1) (hh : sᴴ = s) :
    sectorRefl (pauliPlusPair s hs hh).toProjPair = s := by
  show Pplus s - Pminus s = s
  simp only [Pplus, Pminus]
  match_scalars <;> ring

/-- The first Pauli matrix is a genuine sector reflection. -/
theorem sigma1_is_sectorRefl :
    sectorRefl (pauliPlusPair σ1 σ1_sq σ1_herm).toProjPair = σ1 :=
  sectorRefl_pauliPlusPair σ1 σ1_sq σ1_herm

/-- The second Pauli matrix is a genuine sector reflection. -/
theorem sigma2_is_sectorRefl :
    sectorRefl (pauliPlusPair σ2 σ2_sq σ2_herm).toProjPair = σ2 :=
  sectorRefl_pauliPlusPair σ2 σ2_sq σ2_herm

/-- The first Pauli reflection is not the identity. -/
theorem sigma1_ne_one : σ1 ≠ (1 : M2) := by
  intro h; have := congrFun (congrFun h 0) 0; simp [σ1] at this

/-- The first Pauli reflection is not minus the identity. -/
theorem sigma1_ne_neg_one : σ1 ≠ (-1 : M2) := by
  intro h; have := congrFun (congrFun h 0) 0; simp [σ1] at this

/-- The second Pauli reflection is not the identity. -/
theorem sigma2_ne_one : σ2 ≠ (1 : M2) := by
  intro h; have := congrFun (congrFun h 0) 0; simp [σ2] at this

/-- The second Pauli reflection is not minus the identity. -/
theorem sigma2_ne_neg_one : σ2 ≠ (-1 : M2) := by
  intro h; have := congrFun (congrFun h 0) 0; simp [σ2] at this

/-- Every reflection in the alternating list is nontrivial. -/
theorem alt_refl_nontrivial :
    ∀ s ∈ altRefls, s ≠ (1 : M2) ∧ s ≠ (-1 : M2) := by
  intro s hs
  simp only [altRefls, List.mem_cons, List.not_mem_nil, or_false] at hs
  rcases hs with h | h | h | h | h | h | h | h <;> subst h <;>
    exact ⟨by first | exact sigma1_ne_one | exact sigma2_ne_one,
           by first | exact sigma1_ne_neg_one | exact sigma2_ne_neg_one⟩

/-! ### The sharp separation: flattening the holonomy is not a pure gauge -/

/-- **The sharpened finite theorem.**  There is *no* global unitary frame change carrying the HNU
reflection list to the alternating list.  Equivalently: the central `-1` of the HNU complement
holonomy cannot be removed by any pure basis conjugation; a frame that flattens it to `+1` must be a
genuinely different projector sequence, not a rebasing of the HNU schedule. -/
theorem alt_not_global_gauge_of_hnu :
    ¬ ∃ G : M2, star G * G = 1 ∧ G * star G = 1 ∧
        altRefls = hnuRefls.map (fun s => G * s * star G) := by
  rintro ⟨G, hG, hG', hmap⟩
  have h1 : altRefls.prod = -1 := by
    rw [hmap]; exact hnu_holonomy_gauge_invariant G hG hG'
  rw [alt_holonomy] at h1
  have h00 := congrFun (congrFun h1 0) 0
  simp only [Matrix.one_apply_eq, Matrix.neg_apply] at h00
  exact absurd h00 (by norm_num)

/-! ## Part F. Verdict and controls -/

/-- **The global-frame holonomy verdict.** Packaged conjunction of the finite facts:

* the HNU complement holonomy is the central `-1`, fixed by every global frame change (gauge
  invariance / control): `hnu_holonomy`, `hnu_holonomy_gauge_invariant`;
* an explicit different reflection schedule with a nontrivial reflection on every substep has
  holonomy `+1`
  (`alt_holonomy`, `alt_refl_nontrivial`): the `-1` is not a universal obstruction;
* the two holonomies share the determinant `+1` (frame-independent) but differ in trace / center
  element (`hnu_holonomy_det`, `alt_holonomy_det`, `hnu_holonomy_trace`, `alt_holonomy_trace`);
* removing the `-1` is not a pure gauge (`alt_not_global_gauge_of_hnu`). -/
theorem global_holonomy_verdict :
    hnuRefls.prod = -1 ∧
    (∀ G : M2, star G * G = 1 → G * star G = 1 →
      (hnuRefls.map (fun s => G * s * star G)).prod = -1) ∧
    altRefls.prod = 1 ∧
    (∀ s ∈ altRefls, s ≠ (1 : M2) ∧ s ≠ (-1 : M2)) ∧
    hnuRefls.prod.det = 1 ∧ altRefls.prod.det = 1 ∧
    hnuRefls.prod.trace = -2 ∧ altRefls.prod.trace = 2 ∧
    (¬ ∃ G : M2, star G * G = 1 ∧ G * star G = 1 ∧
        altRefls = hnuRefls.map (fun s => G * s * star G)) :=
  ⟨hnu_holonomy, fun G hG hG' => hnu_holonomy_gauge_invariant G hG hG',
    alt_holonomy, alt_refl_nontrivial, hnu_holonomy_det, alt_holonomy_det,
    hnu_holonomy_trace, alt_holonomy_trace, alt_not_global_gauge_of_hnu⟩

/-- **Fixed-frame control (noncommuting projector obstruction).**  A single global rank-one selector
cannot be simultaneously aligned with the axis-changing HNU schedule: the first and third axis projectors do
not commute (re-exported from `AntiperiodicHNU.selector_noncommute`). This is the fixed-frame
obstruction that motivates the separate varying-frame successor theorem. -/
theorem fixed_frame_selector_obstruction : ¬ Commute (Pplus σ1) (Pplus σ3) :=
  PhysicsSM.Draft.NullEdge.AntiperiodicHNU.selector_noncommute

end PhysicsSM.Draft.NullEdge.HNUGlobalHolonomyClassification

/-!
## Build-enforced assumption-footprint guards

Each headline theorem depends only on a subset of Lean/Mathlib's standard three
principles.
-/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUGlobalHolonomyClassification.sectorRefl_sq' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUGlobalHolonomyClassification.sectorRefl_sq
/-- info: 'PhysicsSM.Draft.NullEdge.HNUGlobalHolonomyClassification.sectorRefl_conj' depends on axioms: [propext] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUGlobalHolonomyClassification.sectorRefl_conj
/-- info: 'PhysicsSM.Draft.NullEdge.HNUGlobalHolonomyClassification.prod_conj' depends on axioms: [propext] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUGlobalHolonomyClassification.prod_conj
/-- info: 'PhysicsSM.Draft.NullEdge.HNUGlobalHolonomyClassification.coarse_conj' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUGlobalHolonomyClassification.coarse_conj
/-- info: 'PhysicsSM.Draft.NullEdge.HNUGlobalHolonomyClassification.hnu_holonomy' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUGlobalHolonomyClassification.hnu_holonomy
/-- info: 'PhysicsSM.Draft.NullEdge.HNUGlobalHolonomyClassification.hnu_holonomy_gauge_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUGlobalHolonomyClassification.hnu_holonomy_gauge_invariant
/-- info: 'PhysicsSM.Draft.NullEdge.HNUGlobalHolonomyClassification.alt_holonomy' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUGlobalHolonomyClassification.alt_holonomy
/-- info: 'PhysicsSM.Draft.NullEdge.HNUGlobalHolonomyClassification.alt_refl_nontrivial' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUGlobalHolonomyClassification.alt_refl_nontrivial
/-- info: 'PhysicsSM.Draft.NullEdge.HNUGlobalHolonomyClassification.alt_not_global_gauge_of_hnu' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUGlobalHolonomyClassification.alt_not_global_gauge_of_hnu
/-- info: 'PhysicsSM.Draft.NullEdge.HNUGlobalHolonomyClassification.global_holonomy_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUGlobalHolonomyClassification.global_holonomy_verdict
