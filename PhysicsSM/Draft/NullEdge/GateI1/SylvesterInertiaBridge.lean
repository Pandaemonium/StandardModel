import Mathlib
import PhysicsSM.Draft.NullEdge.GateI1.MultiTimeEmbedding

/-!
# Q10 Sylvester-inertia frustrated triple bridge

This module bridges the finite *diagonal-signature* multi-time frustrated null
triple of `MultiTimeEmbedding.lean` (which is itself the lift of the fixed
`(2,2)` integer witness of `SignatureSelection.lean`) to a *basis-free*
Sylvester-inertia statement about arbitrary real quadratic forms.

## What the diagonal theorem says

`MultiTimeEmbedding.multitime_frustrated_triple` works with a *diagonal* sign
vector `s : Fin n → ℝ` and the coordinate form `sigDot s x y = ∑ k, s k x k y k`,
witnessing the split `(+,+,-,-)` block on four chosen coordinates.  This is a
coordinate/diagonal statement.

## The bridge proved here

Sylvester's law of inertia (`QuadraticForm.equivalent_one_zero_neg_one_weighted_sum_squared`
and friends in Mathlib) says every real quadratic form on a finite-dimensional
space is, after a linear change of coordinates, a weighted sum of squares with
weights in `{-1, 0, 1}`.  The genuine, basis-free content of the diagonal
obstruction is therefore:

* `bilin_frustrated_triple` : **any** symmetric real bilinear form `B` that
  carries a `B`-orthogonal system of four vectors with signs `(+,+,-,-)`
  (arbitrary positive/negative diagonal values — Sylvester delivers `±1`)
  contains three `B`-null vectors with pairings `(+,+,-)`.  This is the
  coordinate-independent generalization: no basis, no diagonal assumption.

* `quadraticForm_frustrated_of_orthosystem` : the same statement phrased for a
  `QuadraticForm ℝ V` with pairings taken in its polar form.

* `weightedSumSquares_frustrated_triple` : the coordinate instance for a
  diagonal weighted sum of squares whose weights include two positive and two
  negative entries.

* `quadraticForm_frustrated_of_equivalent` : transport of the coordinate
  instance along a Sylvester isometry, i.e. **any** finite-type quadratic form
  equivalent to a weighted sum of squares with two positive and two negative
  weights contains a frustrated null triple.  This is the Sylvester-inertia
  bridge proper.

* `sigDot_frustrated_triple` / the diagonal recovery: the abstract bilinear
  theorem re-derives the diagonal `MultiTimeEmbedding.sigDot` obstruction,
  confirming the bridge is faithful (no strengthening or weakening of the
  original claim).

## Claim boundary (PROVED finite algebra vs. MEMO physics)

The **finite real-algebra** content is fully proved and kernel-checked below:
the frustrated triple exists for every symmetric bilinear form / quadratic form
whose inertia contains a `(2,2)` block, in a basis-independent way, and this
reduces to the diagonal witness.

The intrinsic numerical theorem below phrases the usual "positive index
`p ≥ 2` and negative index `q ≥ 2`" condition by its basis-free witness form:
there are two-dimensional positive- and negative-definite subspaces.  Mathlib
does not currently expose a named inertia-index API, so the proof uses
Sylvester existence plus elementary one-sided dimension bounds for diagonal
weighted sums of squares.  The *physical* reading (multi-time signatures fail
stable retardation) remains a MEMO-grade interpretation, unchanged from Q10.

Provenance: bridges `MultiTimeEmbedding.lean`, `SignatureSelection.lean`,
`LorentzianTransitivity.lean`, `SplitSignatureMass.lean`;
`AgentTasks/fable_parallel/Q10_answer.md` items L2/L9.
-/

namespace PhysicsSM.Draft.NullEdge.GateI1.SylvesterInertiaBridge

open scoped BigOperators
open QuadraticMap

/-! ## 1. Abstract symmetric bilinear form: the basis-free bridge -/

variable {V : Type*} [AddCommGroup V] [Module ℝ V]

/--
**Normalized abstract frustrated triple.**  For a symmetric real bilinear form
`B`, an orthogonal system `e0,e1,e2,e3` normalized to signs `(+1,+1,-1,-1)`
carries three `B`-null vectors `a,b,c` with pairings `B a b > 0`, `B b c > 0`,
`B a c < 0`.  The witnesses are the images of the fixed `(2,2)` integer triple
`(1,0,1,0)`, `(3,4,0,5)`, `(0,1,1,0)`.
-/
theorem bilin_frustrated_triple_normalized
    (B : LinearMap.BilinForm ℝ V) (hB : B.IsSymm)
    (e0 e1 e2 e3 : V)
    (h01 : B e0 e1 = 0) (h02 : B e0 e2 = 0) (h03 : B e0 e3 = 0)
    (h12 : B e1 e2 = 0) (h13 : B e1 e3 = 0) (h23 : B e2 e3 = 0)
    (hd0 : B e0 e0 = 1) (hd1 : B e1 e1 = 1)
    (hd2 : B e2 e2 = -1) (hd3 : B e3 e3 = -1) :
    ∃ a b c : V,
      B a a = 0 ∧ B b b = 0 ∧ B c c = 0 ∧
      0 < B a b ∧ 0 < B b c ∧ B a c < 0 := by
  have hs : ∀ x y, B x y = B y x := fun x y => hB.eq x y
  have h10 : B e1 e0 = 0 := by rw [hs]; exact h01
  have h20 : B e2 e0 = 0 := by rw [hs]; exact h02
  have h30 : B e3 e0 = 0 := by rw [hs]; exact h03
  have h21 : B e2 e1 = 0 := by rw [hs]; exact h12
  have h31 : B e3 e1 = 0 := by rw [hs]; exact h13
  have h32 : B e3 e2 = 0 := by rw [hs]; exact h23
  refine ⟨e0 + e2, (3:ℝ)•e0 + (4:ℝ)•e1 + (5:ℝ)•e3, e1 + e2, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;>
  · simp only [map_add, map_smul, LinearMap.add_apply, LinearMap.smul_apply, smul_eq_mul,
      h01, h02, h03, h12, h13, h23, h10, h20, h30, h21, h31, h32, hd0, hd1, hd2, hd3]
    norm_num

/--
**Abstract frustrated triple (general diagonal values).**  For a symmetric real
bilinear form `B`, any `B`-orthogonal system of four vectors with positive,
positive, negative, negative self-pairings (arbitrary magnitudes) carries a
frustrated null triple.  Proof: rescale each vector by the inverse square root
of the magnitude of its self-pairing to reduce to the normalized case.

This is the coordinate-free generalization of
`MultiTimeEmbedding.multitime_frustrated_triple`: no basis and no diagonal form
is assumed, only the existence of a `(2,2)` orthogonal system, which is exactly
what Sylvester's law of inertia provides for a form of inertia `(p,q)` with
`p, q ≥ 2`.
-/
theorem bilin_frustrated_triple
    (B : LinearMap.BilinForm ℝ V) (hB : B.IsSymm)
    (e0 e1 e2 e3 : V)
    (h01 : B e0 e1 = 0) (h02 : B e0 e2 = 0) (h03 : B e0 e3 = 0)
    (h12 : B e1 e2 = 0) (h13 : B e1 e3 = 0) (h23 : B e2 e3 = 0)
    (hd0 : 0 < B e0 e0) (hd1 : 0 < B e1 e1)
    (hd2 : B e2 e2 < 0) (hd3 : B e3 e3 < 0) :
    ∃ a b c : V,
      B a a = 0 ∧ B b b = 0 ∧ B c c = 0 ∧
      0 < B a b ∧ 0 < B b c ∧ B a c < 0 := by
  set p0 := B e0 e0
  set p1 := B e1 e1
  set p2 := B e2 e2
  set p3 := B e3 e3
  refine bilin_frustrated_triple_normalized B hB
    ((Real.sqrt p0)⁻¹ • e0) ((Real.sqrt p1)⁻¹ • e1)
    ((Real.sqrt (-p2))⁻¹ • e2) ((Real.sqrt (-p3))⁻¹ • e3)
    ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;>
    simp only [map_smul, LinearMap.smul_apply, smul_eq_mul, h01, h02, h03, h12, h13, h23]
  · ring
  · ring
  · ring
  · ring
  · ring
  · ring
  · rw [show (Real.sqrt p0)⁻¹ * ((Real.sqrt p0)⁻¹ * p0) = (Real.sqrt p0)⁻¹^2 * p0 by ring,
      inv_pow, Real.sq_sqrt hd0.le]; field_simp
  · rw [show (Real.sqrt p1)⁻¹ * ((Real.sqrt p1)⁻¹ * p1) = (Real.sqrt p1)⁻¹^2 * p1 by ring,
      inv_pow, Real.sq_sqrt hd1.le]; field_simp
  · rw [show (Real.sqrt (-p2))⁻¹ * ((Real.sqrt (-p2))⁻¹ * p2) = (Real.sqrt (-p2))⁻¹^2 * p2 by ring,
      inv_pow, Real.sq_sqrt (by linarith : (0:ℝ) ≤ -p2)]
    rw [inv_mul_eq_div, div_eq_iff (neg_pos.mpr hd2).ne']; ring
  · rw [show (Real.sqrt (-p3))⁻¹ * ((Real.sqrt (-p3))⁻¹ * p3) = (Real.sqrt (-p3))⁻¹^2 * p3 by ring,
      inv_pow, Real.sq_sqrt (by linarith : (0:ℝ) ≤ -p3)]
    rw [inv_mul_eq_div, div_eq_iff (neg_pos.mpr hd3).ne']; ring

/-- Sign-consistency of a two-coloring: same color needs nonnegative pairing,
different color needs nonpositive pairing.  (Same predicate shape as
`MultiTimeEmbedding.signColorOK`.) -/
def signColorOK (ca cb : Bool) (pairing : ℝ) : Prop :=
  if ca = cb then 0 ≤ pairing else pairing ≤ 0

/--
**No retarded/advanced coloring, abstractly.**  Any symmetric real bilinear form
with a `(2,2)` orthogonal system produces null vectors whose three pairing
constraints allow no consistent two-coloring.  This lifts
`MultiTimeEmbedding.multitime_no_retarded_coloring` off the diagonal model.
-/
theorem bilin_no_retarded_coloring
    (B : LinearMap.BilinForm ℝ V) (hB : B.IsSymm)
    (e0 e1 e2 e3 : V)
    (h01 : B e0 e1 = 0) (h02 : B e0 e2 = 0) (h03 : B e0 e3 = 0)
    (h12 : B e1 e2 = 0) (h13 : B e1 e3 = 0) (h23 : B e2 e3 = 0)
    (hd0 : 0 < B e0 e0) (hd1 : 0 < B e1 e1)
    (hd2 : B e2 e2 < 0) (hd3 : B e3 e3 < 0) :
    ∃ a b c : V,
      B a a = 0 ∧ B b b = 0 ∧ B c c = 0 ∧
      ∀ ca cb cc : Bool,
        ¬ (signColorOK ca cb (B a b) ∧
           signColorOK cb cc (B b c) ∧
           signColorOK ca cc (B a c)) := by
  obtain ⟨a, b, c, ha, hb, hc, hab, hbc, hac⟩ :=
    bilin_frustrated_triple B hB e0 e1 e2 e3 h01 h02 h03 h12 h13 h23 hd0 hd1 hd2 hd3
  refine ⟨a, b, c, ha, hb, hc, ?_⟩
  rintro ca cb cc ⟨habOK, hbcOK, hacOK⟩
  have e1' : ca = cb := by
    by_contra hne
    have : B a b ≤ 0 := by simpa [signColorOK, hne] using habOK
    linarith
  have e2' : cb = cc := by
    by_contra hne
    have : B b c ≤ 0 := by simpa [signColorOK, hne] using hbcOK
    linarith
  have : 0 ≤ B a c := by simpa [signColorOK, e1'.trans e2'] using hacOK
  linarith

/-! ## 2. Quadratic forms and Sylvester's law of inertia -/

/-- A quadratic form has a *frustrated null triple* when it carries three null
vectors whose polar pairings realize the frustrated pattern `(+,+,-)`. -/
def FrustratedTriple (Q : QuadraticForm ℝ V) : Prop :=
  ∃ a b c : V,
    Q a = 0 ∧ Q b = 0 ∧ Q c = 0 ∧
    0 < polar Q a b ∧ 0 < polar Q b c ∧ polar Q a c < 0

/--
**Intrinsic bridge for quadratic forms.**  A real quadratic form with a polar-
orthogonal system of four vectors of signs `(+,+,-,-)` has a frustrated null
triple.  Pairings are taken in the polar form; nullity is `Q v = 0`.  This is
the coordinate-free Sylvester-inertia statement.
-/
theorem quadraticForm_frustrated_of_orthosystem
    (Q : QuadraticForm ℝ V) (e0 e1 e2 e3 : V)
    (h01 : polar Q e0 e1 = 0) (h02 : polar Q e0 e2 = 0) (h03 : polar Q e0 e3 = 0)
    (h12 : polar Q e1 e2 = 0) (h13 : polar Q e1 e3 = 0) (h23 : polar Q e2 e3 = 0)
    (hd0 : 0 < Q e0) (hd1 : 0 < Q e1) (hd2 : Q e2 < 0) (hd3 : Q e3 < 0) :
    FrustratedTriple Q := by
  have hsymm : LinearMap.BilinForm.IsSymm (Q.polarBilin) :=
    LinearMap.BilinForm.isSymm_def.mpr (fun x y => polar_comm Q x y)
  have hpb : ∀ x y, Q.polarBilin x y = polar Q x y := fun _ _ => rfl
  have hself : ∀ x, polar Q x x = 2 * Q x := by intro x; rw [polar_self]; ring
  obtain ⟨a, b, c, ha, hb, hc, hab, hbc, hac⟩ :=
    bilin_frustrated_triple Q.polarBilin hsymm e0 e1 e2 e3
      (by rw [hpb]; exact h01) (by rw [hpb]; exact h02) (by rw [hpb]; exact h03)
      (by rw [hpb]; exact h12) (by rw [hpb]; exact h13) (by rw [hpb]; exact h23)
      (by rw [hpb, hself]; linarith) (by rw [hpb, hself]; linarith)
      (by rw [hpb, hself]; linarith) (by rw [hpb, hself]; linarith)
  rw [hpb, hself] at ha hb hc
  rw [hpb] at hab hbc hac
  exact ⟨a, b, c, by linarith, by linarith, by linarith, hab, hbc, hac⟩

/-- Value of a weighted sum of squares on a coordinate indicator. -/
theorem weightedSumSquares_single {ι : Type*} [Fintype ι] [DecidableEq ι]
    (w : ι → ℝ) (i : ι) :
    (weightedSumSquares ℝ w) (Pi.single i 1) = w i := by
  rw [weightedSumSquares_apply]
  simp [Pi.single_apply]

/-- The polar form of a weighted sum of squares vanishes on distinct coordinate
indicators. -/
theorem weightedSumSquares_polar_single {ι : Type*} [Fintype ι] [DecidableEq ι]
    (w : ι → ℝ) (i j : ι) (h : i ≠ j) :
    polar (weightedSumSquares ℝ w) (Pi.single i 1) (Pi.single j 1) = 0 := by
  rw [QuadraticMap.polar, weightedSumSquares_apply, weightedSumSquares_apply,
    weightedSumSquares_apply, ← Finset.sum_sub_distrib, ← Finset.sum_sub_distrib]
  apply Finset.sum_eq_zero
  intro k _
  rcases eq_or_ne k i with rfl | hki
  · simp [h.symm]
  · rcases eq_or_ne k j with rfl | hkj
    · simp [hki]
    · simp [hki, hkj]

/--
**Coordinate instance.**  A diagonal weighted sum of squares whose weights
include two strictly positive and two strictly negative entries (at four
distinct indices) has a frustrated null triple.
-/
theorem weightedSumSquares_frustrated_triple {ι : Type*} [Fintype ι]
    (w : ι → ℝ) (i0 i1 j0 j1 : ι)
    (h01 : i0 ≠ i1) (h02 : i0 ≠ j0) (h03 : i0 ≠ j1)
    (h12 : i1 ≠ j0) (h13 : i1 ≠ j1) (h23 : j0 ≠ j1)
    (hi0 : 0 < w i0) (hi1 : 0 < w i1) (hj0 : w j0 < 0) (hj1 : w j1 < 0) :
    FrustratedTriple (weightedSumSquares ℝ w) := by
  classical
  refine quadraticForm_frustrated_of_orthosystem (weightedSumSquares ℝ w)
    (Pi.single i0 1) (Pi.single i1 1) (Pi.single j0 1) (Pi.single j1 1)
    (weightedSumSquares_polar_single w i0 i1 h01)
    (weightedSumSquares_polar_single w i0 j0 h02)
    (weightedSumSquares_polar_single w i0 j1 h03)
    (weightedSumSquares_polar_single w i1 j0 h12)
    (weightedSumSquares_polar_single w i1 j1 h13)
    (weightedSumSquares_polar_single w j0 j1 h23)
    ?_ ?_ ?_ ?_
  · rw [weightedSumSquares_single]; exact hi0
  · rw [weightedSumSquares_single]; exact hi1
  · rw [weightedSumSquares_single]; exact hj0
  · rw [weightedSumSquares_single]; exact hj1

/--
**Sylvester-inertia bridge (transport form).**  Any quadratic form on `V` that
is isometrically equivalent to a weighted sum of squares whose weights include
two positive and two negative entries has a frustrated null triple.  Combined
with Mathlib's Sylvester law
(`QuadraticForm.equivalent_one_zero_neg_one_weighted_sum_squared`), this covers
every finite-dimensional real quadratic form whose inertia contains a `(2,2)`
block.
-/
theorem quadraticForm_frustrated_of_equivalent {ι : Type*} [Fintype ι]
    (Q : QuadraticForm ℝ V) (w : ι → ℝ)
    (f : QuadraticMap.IsometryEquiv Q (weightedSumSquares ℝ w))
    (i0 i1 j0 j1 : ι)
    (h01 : i0 ≠ i1) (h02 : i0 ≠ j0) (h03 : i0 ≠ j1)
    (h12 : i1 ≠ j0) (h13 : i1 ≠ j1) (h23 : j0 ≠ j1)
    (hi0 : 0 < w i0) (hi1 : 0 < w i1) (hj0 : w j0 < 0) (hj1 : w j1 < 0) :
    FrustratedTriple Q := by
  classical
  -- transport orthonormal-signature vectors back through the isometry
  have hval : ∀ x : ι → ℝ, Q (f.symm x) = weightedSumSquares ℝ w x :=
    fun x => f.symm.map_app x
  have hpol : ∀ x y : ι → ℝ,
      polar Q (f.symm x) (f.symm y) = polar (weightedSumSquares ℝ w) x y := by
    intro x y
    unfold QuadraticMap.polar
    rw [← map_add, f.symm.map_app, f.symm.map_app, f.symm.map_app]
  refine quadraticForm_frustrated_of_orthosystem Q
    (f.symm (Pi.single i0 1)) (f.symm (Pi.single i1 1))
    (f.symm (Pi.single j0 1)) (f.symm (Pi.single j1 1))
    (by rw [hpol]; exact weightedSumSquares_polar_single w i0 i1 h01)
    (by rw [hpol]; exact weightedSumSquares_polar_single w i0 j0 h02)
    (by rw [hpol]; exact weightedSumSquares_polar_single w i0 j1 h03)
    (by rw [hpol]; exact weightedSumSquares_polar_single w i1 j0 h12)
    (by rw [hpol]; exact weightedSumSquares_polar_single w i1 j1 h13)
    (by rw [hpol]; exact weightedSumSquares_polar_single w j0 j1 h23)
    ?_ ?_ ?_ ?_
  · rw [hval, weightedSumSquares_single]; exact hi0
  · rw [hval, weightedSumSquares_single]; exact hi1
  · rw [hval, weightedSumSquares_single]; exact hj0
  · rw [hval, weightedSumSquares_single]; exact hj1

/--
**Sylvester-inertia bridge (existence packaging).**  If a quadratic form is
equivalent to *some* weighted sum of squares carrying two positive and two
negative weights, it has a frustrated null triple.  This is the honest intrinsic
statement of "inertia contains `(2,2)`": the hypothesis is exactly the data
Sylvester's law of inertia produces, and no numerical-invariance lemma is
required.
-/
theorem sylvester_frustrated_triple
    (Q : QuadraticForm ℝ V)
    (h : ∃ (ι : Type) (_ : Fintype ι) (w : ι → ℝ)
           (_ : QuadraticMap.IsometryEquiv Q (weightedSumSquares ℝ w))
           (i0 i1 j0 j1 : ι),
           i0 ≠ i1 ∧ i0 ≠ j0 ∧ i0 ≠ j1 ∧ i1 ≠ j0 ∧ i1 ≠ j1 ∧ j0 ≠ j1 ∧
           0 < w i0 ∧ 0 < w i1 ∧ w j0 < 0 ∧ w j1 < 0) :
    FrustratedTriple Q := by
  obtain ⟨ι, _, w, f, i0, i1, j0, j1,
    h01, h02, h03, h12, h13, h23, hi0, hi1, hj0, hj1⟩ := h
  exact quadraticForm_frustrated_of_equivalent Q w f i0 i1 j0 j1
    h01 h02 h03 h12 h13 h23 hi0 hi1 hj0 hj1

/-! ## 2b. Intrinsic numerical inertia-index bridge (`p ≥ 2`, `q ≥ 2`)

The statements above take the `(2,2)` block, or the Sylvester equivalence with
two positive and two negative weights, as a hypothesis.  The genuinely
intrinsic numerical form is: the positive index is at least `2` and the
negative index is at least `2`.  We render this in the witness form Mathlib can
state directly: subspaces `P` and `N` of dimension at least `2` on which `Q` is
positive- respectively negative-definite.

This needs no external numerical invariance theorem for inertia indices.  The
proof uses Mathlib's Sylvester existence theorem and the elementary one-sided
dimension bounds below for diagonal weighted sums of squares. -/

/-- **Positive-inertia one-sided bound (diagonal model).**  A subspace of the
coordinate space on which a weighted sum of squares is positive definite has
dimension at most the number of strictly positive weights. -/
theorem weightedSumSquares_finrank_le_card_pos {ι : Type*} [Fintype ι]
    (w : ι → ℝ) (P : Submodule ℝ (ι → ℝ))
    (hP : ∀ x ∈ P, x ≠ 0 → 0 < weightedSumSquares ℝ w x) :
    Module.finrank ℝ P ≤ (Finset.univ.filter (fun i => 0 < w i)).card := by
  set S := Finset.filter (fun i => 0 < w i) Finset.univ with hS_def
  set L : (ι → ℝ) →ₗ[ℝ] (S → ℝ) :=
    LinearMap.pi (fun i => LinearMap.proj i.val) with hL_def
  have h_inj : LinearMap.ker (L.comp (Submodule.subtype P)) = ⊥ := by
    rw [LinearMap.ker_eq_bot']
    intro m hm
    specialize hP m m.2
    contrapose! hP
    simp_all +decide [funext_iff, LinearMap.ext_iff]
    exact Finset.sum_nonpos fun i _ =>
      if hi : 0 < w i then by
        simp +decide [hm i hi]
      else by
        nlinarith [mul_self_nonneg (m.val i)]
  have := LinearMap.finrank_range_of_inj (LinearMap.ker_eq_bot.mp h_inj)
  exact this ▸ le_trans (Submodule.finrank_le _) (by simp +decide)

/-- **Negative-inertia one-sided bound (diagonal model).**  A subspace of the
coordinate space on which a weighted sum of squares is negative definite has
dimension at most the number of strictly negative weights. -/
theorem weightedSumSquares_finrank_le_card_neg {ι : Type*} [Fintype ι]
    (w : ι → ℝ) (N : Submodule ℝ (ι → ℝ))
    (hN : ∀ x ∈ N, x ≠ 0 → weightedSumSquares ℝ w x < 0) :
    Module.finrank ℝ N ≤ (Finset.univ.filter (fun i => w i < 0)).card := by
  contrapose! hN
  obtain ⟨x, hxN, hx0⟩ :
      ∃ x ∈ N, x ≠ 0 ∧
        ∀ i ∈ Finset.univ.filter (fun i => w i < 0), x i = 0 := by
    have h_kernel : Module.finrank ℝ (LinearMap.ker
        (LinearMap.pi (fun i : {i : ι | w i < 0} => LinearMap.proj i.val) |>
          LinearMap.comp <| Submodule.subtype N)) > 0 := by
      have := LinearMap.finrank_range_add_finrank_ker
        (LinearMap.pi (fun i : {i : ι | w i < 0} => LinearMap.proj i.val) |>
          LinearMap.comp <| Submodule.subtype N)
      linarith [show Module.finrank ℝ (LinearMap.range
          (LinearMap.pi (fun i : {i : ι | w i < 0} => LinearMap.proj i.val) |>
            LinearMap.comp <| Submodule.subtype N)) ≤
          Finset.card (Finset.filter (fun i => w i < 0) Finset.univ) from
        le_trans (Submodule.finrank_le _) (by simp +decide [Fintype.card_subtype])]
    obtain ⟨x, hx⟩ :
        ∃ x : ↥N, x ∈ LinearMap.ker
          (LinearMap.pi (fun i : {i : ι | w i < 0} => LinearMap.proj i.val) |>
            LinearMap.comp <| Submodule.subtype N) ∧ x ≠ 0 := by
      simpa [Submodule.ne_bot_iff] using h_kernel.ne'
    exact ⟨x, x.2, by simpa using hx.2,
      fun i hi => by simpa using congr_fun hx.1 ⟨i, by simpa using hi⟩⟩
  refine ⟨x, hxN, hx0.1, ?_⟩
  simp +decide [QuadraticMap.weightedSumSquares_apply]
  exact Finset.sum_nonneg fun i _ =>
    if hi : w i < 0 then by
      simp +decide [hx0.2 i (by simpa using hi)]
    else by
      nlinarith [sq_nonneg (x i)]

/-- **Intrinsic Sylvester-inertia bridge (`p ≥ 2`, `q ≥ 2`).**  Let `Q` be a
real quadratic form on a finite-dimensional space.  If there is a subspace `P`
of dimension at least `2` on which `Q` is positive definite and a subspace `N`
of dimension at least `2` on which `Q` is negative definite, then `Q` carries a
frustrated null triple.

This is the fully intrinsic, basis-free, numerical-index form of the bridge:
the hypotheses are exactly `p ≥ 2` and `q ≥ 2` phrased through witnessing
definite subspaces. -/
theorem sylvester_frustrated_triple_of_indices [FiniteDimensional ℝ V]
    (Q : QuadraticForm ℝ V)
    (P N : Submodule ℝ V)
    (hP2 : 2 ≤ Module.finrank ℝ P)
    (hN2 : 2 ≤ Module.finrank ℝ N)
    (hPpos : ∀ x ∈ P, x ≠ 0 → 0 < Q x)
    (hNneg : ∀ x ∈ N, x ≠ 0 → Q x < 0) :
    FrustratedTriple Q := by
  obtain ⟨w, _hw, ⟨f⟩⟩ := Q.equivalent_one_zero_neg_one_weighted_sum_squared
  have h_card_pos : 2 ≤ (Finset.univ.filter (fun i => 0 < w i)).card := by
    have h_card_pos :
        Module.finrank ℝ (Submodule.map f.toLinearEquiv.toLinearMap P) ≤
          (Finset.univ.filter (fun i => 0 < w i)).card := by
      apply weightedSumSquares_finrank_le_card_pos w
        (Submodule.map f.toLinearEquiv.toLinearMap P)
      simp +zetaDelta at *
      intro x hx hx'
      specialize hPpos (f.symm x) hx
      simp_all +decide [QuadraticMap.IsometryEquiv.map_app]
    exact le_trans hP2 (by
      rw [LinearEquiv.finrank_map_eq] at h_card_pos
      exact h_card_pos)
  have h_card_neg : 2 ≤ (Finset.univ.filter (fun i => w i < 0)).card := by
    have h_card_neg :
        Module.finrank ℝ (Submodule.map f.toLinearEquiv.toLinearMap N) ≤
          (Finset.univ.filter (fun i => w i < 0)).card := by
      apply weightedSumSquares_finrank_le_card_neg
      simp +decide
      intro x hx hx'
      specialize hNneg (f.symm x) hx
      simp_all +decide [QuadraticMap.IsometryEquiv.map_app]
    refine le_trans ?_ h_card_neg
    rw [LinearEquiv.finrank_map_eq]
    aesop
  obtain ⟨i0, i1, hi0, hi1, _h_distinct⟩ :
      ∃ i0 i1 : Fin (Module.finrank ℝ V), i0 ≠ i1 ∧ 0 < w i0 ∧ 0 < w i1 := by
    obtain ⟨i0, hi0, i1, hi1, _hne⟩ := Finset.one_lt_card.mp h_card_pos
    use i0, i1
    aesop
  obtain ⟨j0, j1, hj0, hj1, _h_distinct'⟩ :
      ∃ j0 j1 : Fin (Module.finrank ℝ V), j0 ≠ j1 ∧ w j0 < 0 ∧ w j1 < 0 := by
    obtain ⟨j0, hj0, j1, hj1, _h⟩ := Finset.one_lt_card.mp h_card_neg
    use j0, j1
    aesop
  apply quadraticForm_frustrated_of_equivalent Q w f i0 i1 j0 j1
  all_goals try assumption
  · grind
  · grind
  · grind
  · grind

/-! ## 3. Recovery of the diagonal `sigDot` obstruction -/

/-- The diagonal coordinate bilinear form attached to a sign vector,
`x, y ↦ ∑ k, s k (x k)(y k)`, as a genuine `BilinForm`.  Its underlying function
is `MultiTimeEmbedding.sigDot`. -/
noncomputable def sigBilin {n : ℕ} (s : Fin n → ℝ) :
    LinearMap.BilinForm ℝ (Fin n → ℝ) :=
  LinearMap.mk₂ ℝ (fun x y => ∑ k, s k * (x k * y k))
    (by intro x y z; simp only [Pi.add_apply]; rw [← Finset.sum_add_distrib];
        apply Finset.sum_congr rfl; intro k _; ring)
    (by intro a x y; simp only [Pi.smul_apply, smul_eq_mul, Finset.mul_sum];
        apply Finset.sum_congr rfl; intro k _; ring)
    (by intro x y z; simp only [Pi.add_apply]; rw [← Finset.sum_add_distrib];
        apply Finset.sum_congr rfl; intro k _; ring)
    (by intro a x y; simp only [Pi.smul_apply, smul_eq_mul, Finset.mul_sum];
        apply Finset.sum_congr rfl; intro k _; ring)

@[simp] theorem sigBilin_apply {n : ℕ} (s : Fin n → ℝ) (x y : Fin n → ℝ) :
    sigBilin s x y = ∑ k, s k * (x k * y k) := rfl

/-- `sigBilin` agrees with `MultiTimeEmbedding.sigDot`. -/
theorem sigBilin_eq_sigDot {n : ℕ} (s x y : Fin n → ℝ) :
    sigBilin s x y = MultiTimeEmbedding.sigDot s x y := rfl

/-- `sigBilin` is symmetric. -/
theorem sigBilin_isSymm {n : ℕ} (s : Fin n → ℝ) : (sigBilin s).IsSymm := by
  refine LinearMap.BilinForm.isSymm_def.mpr (fun x y => ?_)
  simp only [sigBilin_apply]
  apply Finset.sum_congr rfl; intro k _; ring

/--
**Diagonal recovery.**  The abstract bilinear bridge re-derives the diagonal
`sigDot` frustrated triple of `MultiTimeEmbedding`, confirming the bridge is
faithful: the general theorem specializes to the original diagonal witness with
no change of claim.
-/
theorem sigDot_frustrated_triple {n : ℕ} (s : Fin n → ℝ)
    (i0 i1 j0 j1 : Fin n)
    (h01 : i0 ≠ i1) (h02 : i0 ≠ j0) (h03 : i0 ≠ j1)
    (h12 : i1 ≠ j0) (h13 : i1 ≠ j1) (h23 : j0 ≠ j1)
    (hs0 : s i0 = 1) (hs1 : s i1 = 1) (hs2 : s j0 = -1) (hs3 : s j1 = -1) :
    ∃ a b c : Fin n → ℝ,
      MultiTimeEmbedding.sigQ s a = 0 ∧ MultiTimeEmbedding.sigQ s b = 0 ∧
      MultiTimeEmbedding.sigQ s c = 0 ∧
      0 < MultiTimeEmbedding.sigDot s a b ∧ 0 < MultiTimeEmbedding.sigDot s b c ∧
      MultiTimeEmbedding.sigDot s a c < 0 := by
  classical
  have hsingle : ∀ i j : Fin n,
      sigBilin s (Pi.single i 1) (Pi.single j 1) = if i = j then s i else 0 := by
    intro i j
    rw [sigBilin_apply]
    rcases eq_or_ne i j with rfl | h
    · simp [Pi.single_apply]
    · simp only [if_neg h]
      apply Finset.sum_eq_zero
      intro k _
      rcases eq_or_ne k i with rfl | hki
      · simp [(Ne.symm h)]
      · simp [hki]
  obtain ⟨a, b, c, ha, hb, hc, hab, hbc, hac⟩ :=
    bilin_frustrated_triple_normalized (sigBilin s) (sigBilin_isSymm s)
      (Pi.single i0 1) (Pi.single i1 1) (Pi.single j0 1) (Pi.single j1 1)
      (by rw [hsingle]; simp [h01]) (by rw [hsingle]; simp [h02])
      (by rw [hsingle]; simp [h03]) (by rw [hsingle]; simp [h12])
      (by rw [hsingle]; simp [h13]) (by rw [hsingle]; simp [h23])
      (by rw [hsingle]; simp [hs0]) (by rw [hsingle]; simp [hs1])
      (by rw [hsingle]; simp [hs2]) (by rw [hsingle]; simp [hs3])
  refine ⟨a, b, c, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;>
    first
      | (rw [MultiTimeEmbedding.sigQ, ← sigBilin_eq_sigDot]; assumption)
      | (rw [← sigBilin_eq_sigDot]; assumption)

/-! ## Axiom audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.SylvesterInertiaBridge.bilin_frustrated_triple' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms bilin_frustrated_triple

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.SylvesterInertiaBridge.quadraticForm_frustrated_of_equivalent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms quadraticForm_frustrated_of_equivalent

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.SylvesterInertiaBridge.sylvester_frustrated_triple_of_indices' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sylvester_frustrated_triple_of_indices

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.SylvesterInertiaBridge.sigDot_frustrated_triple' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sigDot_frustrated_triple

end PhysicsSM.Draft.NullEdge.GateI1.SylvesterInertiaBridge
