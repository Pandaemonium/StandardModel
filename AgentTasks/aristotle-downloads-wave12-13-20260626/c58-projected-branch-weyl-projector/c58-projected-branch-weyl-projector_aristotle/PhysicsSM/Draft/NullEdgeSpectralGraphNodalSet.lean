import Mathlib
import PhysicsSM.Draft.TetrahedralHighMomentumNullBranch
import PhysicsSM.Draft.NullEdgeFlavoredChirality

/-!
# C43/C44: Spectral-graph nodal classification of the flat tetrahedral null-edge symbol

Aristotle Gate C Route B deliverable.  This module classifies part of the
**determinant-zero / nodal set** of the flat tetrahedral retarded dual-soldered
null-edge Dirac symbol, going beyond the finite `{0,π}^4` corner data of
`PhysicsSM.Draft.TetrahedralNullBranch`.

The strategy is the spectral-graph / DFT viewpoint flagged by Yumoto–Misumi
(arXiv:2112.13501, *Lattice fermions as spectral graphs*): the zero-eigenvalue
locus of a lattice-fermion symbol is read off from the scalar dispersion
`p(q)²`, and the high-symmetry corners are special points of an extended
zero-locus rather than isolated nodes.  We keep the Lean statements fully
self-contained: the only object used is the already-proven scalar quadratic
form `qform` (= the mostly-minus Lorentzian symbol square `p(q)²`, see
`TetrahedralNullBranch.pSq_mink_eq_qform`).

## Conventions (inherited, `docs/CONVENTIONS.md`)

* Retarded phase vector `uₐ(q) = exp(i qₐ) - 1`.
* `p(q)² = uᵀ G⁻¹ u = qform u = -3/4 · Σ uₐ² + 1/4 · (Σ uₐ)²`.
* `det D₊(q) = 0 ⇔ p(q)² = 0` for the four-component null slash.

## What is proved here

* `qform_one_zero_three_equal`: the **mechanism** of the nodal cancellation.  If
  one edge component of `u` is `0` and the other three are equal (to any common
  complex value `v`), then `p(q)² = qform u = 0`.  (`(3v)² = 3·(3v²)`.)
* `branchLine_pSq_eq_zero` (**main target**): for each high branch `a`, the line
  `qₐ = 0`, `q_b = π + t` for `b ≠ a` has `p(q)² = 0` for **all** real `t`.  So
  the high branch is not an isolated determinant zero: it lies on an exact
  one-parameter determinant-zero curve.
* `branchLine_mink_eq_zero`: the same statement for the genuine mostly-minus
  Minkowski square `mink (pCov ·)`, via `pSq_mink_eq_qform`.
* `threePiBranch_on_branchLine`: the `t = 0` point of branch `a`'s line is the
  three-`π` corner `tasteCorner a` (the high-momentum null branch).
* `origin_on_branchLine`: the `t = π` point of every branch line is the origin
  `u = 0` (coefficient-zero null point).  So all four nodal curves pass through
  the origin.
* `branchLine_extended` / `branchLine_corner_ne_origin`: the curve is genuinely
  extended — it contains two distinct null points (the nonzero high corner and
  the origin), so the high branch is **not** an isolated zero.
* `null_corner_on_some_branchLine`: every `{0,π}^4` null corner (origin or a
  three-`π` corner) lies on one of the four branch lines, linking the discrete
  corner classification (`count_null = 5`) to the continuous curves.

## Verdict (classification)

The four high-momentum branches are endpoints (`t = 0`) of **exact extended
determinant-zero curves**, each connecting a three-`π` corner to the origin at
`t = π`.  They are therefore **not isolated species**: they are certified
one-dimensional nodal components.  These are proven nodal *components*, not
proven to exhaust the whole zero locus (the complex equation `p(q)² = 0` on the
4-torus is expected to cut out a higher-dimensional sheet containing these
curves; that global statement is **not** formalized here and is flagged as
unresolved).

Consequence for Gate C: before any minimally-doubled *species-count* language is
publication-safe, a **branch-control / species-splitting term** that gaps these
nodal curves away from the origin is required (cf. the `T_lin` proposal,
`T_lin(q) = ½ Σ_a s_a cos qₐ`, working plan §29.5).  Species-count language
applied to the bare symbol is not justified: the zeros form extended curves.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdgeSpectralGraphNodalSet

open Finset Complex
open PhysicsSM.Draft.TetrahedralNullBranch

noncomputable section

/-! ## The general retarded phase vector and the nodal cancellation mechanism -/

/-- The general retarded phase vector `uₐ(q) = exp(i qₐ) - 1` for arbitrary real
edge phases `q : Fin 4 → ℝ` (the corner vectors `cornerU` are the special case
`qₐ ∈ {0, π}`). -/
def phaseU (q : Fin 4 → ℝ) (a : Fin 4) : ℂ :=
  Complex.exp (Complex.I * (q a : ℂ)) - 1

/-- **Nodal cancellation mechanism.**  If one edge component of `u` vanishes and
the other three are equal to a common value `v`, then the Lorentzian symbol
square `p(q)² = qform u` vanishes: `-3/4·(3v²) + 1/4·(3v)² = 0`.  This is the
spectral-graph reason the high branches sit on extended zero-curves. -/
theorem qform_one_zero_three_equal (a : Fin 4) (v : ℂ) (u : Fin 4 → ℂ)
    (hu : ∀ b, u b = if b = a then 0 else v) : qform u = 0 := by
  rw [qform_eq]
  have h2 : (∑ b, (u b) ^ 2) = 3 * v ^ 2 := by
    rw [Fin.sum_univ_four]; fin_cases a <;> simp_all <;> ring
  have h1 : (∑ b, u b) = 3 * v := by
    rw [Fin.sum_univ_four]; fin_cases a <;> simp_all <;> ring
  rw [h1, h2]; ring

/-! ## The exact nodal curve through each high branch -/

/-- The branch line for branch `a`: `qₐ = 0` and `q_b = π + t` for `b ≠ a`. -/
def branchLinePhase (a : Fin 4) (t : ℝ) (b : Fin 4) : ℝ :=
  if b = a then 0 else Real.pi + t

/-- The retarded phase vector along branch `a`'s line. -/
def branchLineU (a : Fin 4) (t : ℝ) : Fin 4 → ℂ := phaseU (branchLinePhase a t)

/-- Component values on the branch line: `0` at the distinguished edge `a`, and
`exp(i(π+t)) - 1` on the other three edges. -/
theorem branchLineU_apply (a : Fin 4) (t : ℝ) (b : Fin 4) :
    branchLineU a t b =
      if b = a then 0 else (Complex.exp (Complex.I * ((Real.pi + t : ℝ) : ℂ)) - 1) := by
  unfold branchLineU phaseU branchLinePhase
  split_ifs with h
  · simp
  · rfl

/-- **Main target `branchLine_pSq_eq_zero`.**  For each high branch `a`, the
exact line `qₐ = 0`, `q_b = π + t` (`b ≠ a`) is determinant-zero for **all**
real `t`: `p(q)² = qform(u) = 0`.  The high branch is therefore an endpoint of
an extended nodal curve, not an isolated zero. -/
theorem branchLine_pSq_eq_zero (a : Fin 4) (t : ℝ) : qform (branchLineU a t) = 0 :=
  qform_one_zero_three_equal a (Complex.exp (Complex.I * ((Real.pi + t : ℝ) : ℂ)) - 1)
    (branchLineU a t) (branchLineU_apply a t)

/-- The same statement for the explicit mostly-minus Minkowski square of the
spacetime symbol covector `p(q)_μ = Σₐ uₐ αᵃ_μ`: the branch line is a genuine
Lorentzian-null curve. -/
theorem branchLine_mink_eq_zero (a : Fin 4) (t : ℝ) :
    mink (pCov (branchLineU a t)) = 0 := by
  rw [pSq_mink_eq_qform]; exact branchLine_pSq_eq_zero a t

/-! ## Special points: the high corner (`t = 0`) and the origin (`t = π`) -/

/-- **`threePiBranch_on_branchLine`.**  The `t = 0` point of branch `a`'s line is
the three-`π` corner `tasteCorner a` — the high-momentum null branch. -/
theorem threePiBranch_on_branchLine (a : Fin 4) :
    branchLineU a 0 = cornerU (PhysicsSM.Draft.NullEdgeFlavoredChirality.tasteCorner a) := by
  funext b
  rw [branchLineU_apply, cornerU_apply]
  unfold PhysicsSM.Draft.NullEdgeFlavoredChirality.tasteCorner
  by_cases h : b = a
  · simp [h]
  · simp only [h, if_false, add_zero, decide_not]
    rw [mul_comm, Complex.exp_pi_mul_I]; norm_num

/-- **`origin_on_branchLine`.**  The `t = π` point of *every* branch line is the
origin `u = 0` (the coefficient-zero null point): `q_b = π + π = 2π ≡ 0`.  All
four nodal curves pass through the origin. -/
theorem origin_on_branchLine (a : Fin 4) : branchLineU a Real.pi = 0 := by
  funext b
  rw [branchLineU_apply]
  split_ifs with h
  · rfl
  · simp only [Pi.zero_apply]
    push_cast
    rw [show Complex.I * (Real.pi + Real.pi : ℂ) = (2 * Real.pi) * Complex.I by ring,
      Complex.exp_two_pi_mul_I]
    ring

/-! ## The branch lines are genuinely extended (not isolated zeros) -/

/-- The two distinguished nodal points on branch `a`'s line are distinct: the
nonzero high corner (`t = 0`) differs from the origin (`t = π`). -/
theorem branchLine_corner_ne_origin (a : Fin 4) :
    branchLineU a 0 ≠ branchLineU a Real.pi := by
  rw [threePiBranch_on_branchLine, origin_on_branchLine]
  exact (threePi_null _ (PhysicsSM.Draft.NullEdgeFlavoredChirality.tasteCorner_count a)).2

/-- **Extended nodal curve.**  For every branch `a` the determinant-zero set
contains the whole one-parameter curve `t ↦ branchLineU a t`, and that curve is
non-degenerate: it carries two distinct null points (the high corner at `t = 0`
and the origin at `t = π`).  Hence the high branch is **not** an isolated zero. -/
theorem branchLine_extended (a : Fin 4) :
    (∀ t : ℝ, qform (branchLineU a t) = 0) ∧ branchLineU a 0 ≠ branchLineU a Real.pi :=
  ⟨branchLine_pSq_eq_zero a, branchLine_corner_ne_origin a⟩

/-! ## Linking the discrete corner classification to the continuous curves -/

open PhysicsSM.Draft.NullEdgeFlavoredChirality in
/-- Every `{0,π}^4` null corner (origin `k = 0` or a three-`π` corner `k = 3`,
the five corners counted by `count_null`) lies on one of the four branch lines:
a three-`π` corner is the `t = 0` point of its branch, and the origin is the
`t = π` point of branch `0`.  This ties the discrete corner table to the
continuous nodal curves. -/
theorem null_corner_on_some_branchLine (s : Fin 4 → Bool)
    (hs : cornerCount s = 0 ∨ cornerCount s = 3) :
    ∃ (a : Fin 4) (t : ℝ), cornerU s = branchLineU a t := by
  rcases hs with hs | hs;
  · exact ⟨ 0, Real.pi, by rw [ origin_on_branchLine, corner_origin s hs |>.1 ] ⟩;
  · -- Since `cornerCount s = 3`, exactly one edge `a` has `s a = false`.
    obtain ⟨a, ha⟩ : ∃ a : Fin 4, s a = false ∧ ∀ b : Fin 4, b ≠ a → s b = true := by
      revert hs; simp only [cornerCount, Fin.sum_univ_four]; revert s; decide
    use a, 0;
    convert threePiBranch_on_branchLine a |> Eq.symm using 2;
    ext b; by_cases hb : b = a <;> simp +decide [ *, tasteCorner ] ;

/-! ## Summary -/

/-- **C43/C44 classification summary.**  For every high branch `a`:

* the exact line `qₐ = 0`, `q_b = π + t` is determinant-zero for all `t`
  (`branchLine_pSq_eq_zero`), equivalently Minkowski-null
  (`branchLine_mink_eq_zero`);
* its `t = 0` point is the three-`π` high corner and its `t = π` point is the
  origin (`threePiBranch_on_branchLine`, `origin_on_branchLine`);
* the curve is genuinely extended, carrying two distinct null points, so the
  high branch is not an isolated zero (`branchLine_corner_ne_origin`).

Hence the determinant zeros form **extended nodal curves**, and minimally-doubled
species-count language on the bare symbol is unjustified without a branch-control
term. -/
theorem nodal_classification_summary :
    (∀ (a : Fin 4) (t : ℝ),
        qform (branchLineU a t) = 0 ∧ mink (pCov (branchLineU a t)) = 0) ∧
    (∀ a : Fin 4,
        branchLineU a 0 = cornerU (PhysicsSM.Draft.NullEdgeFlavoredChirality.tasteCorner a)) ∧
    (∀ a : Fin 4, branchLineU a Real.pi = 0) ∧
    (∀ a : Fin 4, branchLineU a 0 ≠ branchLineU a Real.pi) :=
  ⟨fun a t => ⟨branchLine_pSq_eq_zero a t, branchLine_mink_eq_zero a t⟩,
    threePiBranch_on_branchLine, origin_on_branchLine, branchLine_corner_ne_origin⟩

end

end NullEdgeSpectralGraphNodalSet
end Draft
end PhysicsSM
