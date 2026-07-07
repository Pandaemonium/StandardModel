import Mathlib

/-!
# Q08 `L-Q8-8` / T-P3: a corrected scattering-vertex DAG

`CheckerboardCrossingNonvacuous.lean` established the honest negative result
`naive_LGV_reduction_false`: on the pre-registered site-lattice checkerboard
transfer operator the two-particle amplitude is `X^3 - X`, so the naive unsigned
Lindstrom-Gessel-Viennot (LGV) reduction "signed amplitude = direct
(non-crossing) family" is false.  The diagnosis there was precise: turns are
in-place chirality flips, so a crossing pair crosses at a mid-edge light-cone
point, not at a shared lattice vertex.  The vertex-intersection LGV involution
therefore has nothing to act on, and the crossing survives.

This module builds the corrected object the strategy report calls for: a finite,
time-directed scattering-vertex (brick-wall) DAG in which crossing corresponds
to a shared vertex `m`.  On it the LGV swap-tails-at-the-shared-vertex map is a
genuine weight-preserving bijection, so the crossing contribution cancels the
intersecting direct family, leaving the signed amplitude equal to the sum over
vertex-disjoint direct families.  Crucially this cancellation is nonvacuous:
both a crossing system and an intersecting direct system exist and are
individually nonzero.

## What is proved

* `lgv_crossing_cancels`: reusable abstract LGV core for finite direct and
  crossing path-system families equipped with a weight-preserving bijection
  between crossing systems and intersecting direct systems.
* A concrete brick-wall DAG on vertices `s1`, `s2`, `m`, `t1`, `t2` with one
  scattering vertex `m`, bypass weights `p`, `q`, and scattering weight `s`.
* `scatter_det_eq_directMinusCross`: the determinant of the one-particle
  propagator equals the direct-family sum minus the crossing-family sum.
* `crossing_shares_m`, `mm_shares_m`, `nonintersecting_are_disjoint`: the
  crossing/shared-vertex property that the naive checkerboard lacks.
* `scatter_LGV_reduction_true`: the corrected nonvacuous T-P3 theorem.
* `scatter_crossing_nonvacuous`: with `s = X` over `ℚ[X]`, the crossing family
  and intersecting direct family are both `X^4` and cancel.
* `naive_no_crossing_swap`: if crossing systems are nonempty but intersecting
  direct systems are empty, no LGV swap bijection can exist.

Claim boundary: this is finite graph/path algebra.  It does not say that the
pre-registered checkerboard already satisfies LGV; it proves a corrected
scattering-vertex DAG does, and records the structural obstruction to applying
the same theorem to the naive checkerboard.

Provenance: clean-room finite formalization from Aristotle project
`ne-q08-scattering-vertex-dag-lgv-compatible-model-strategy-20260707`, successor
to `CheckerboardCrossingNonvacuous.lean` (`L-Q8-4+`), targeting `L-Q8-8` / T-P3.
-/

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.Carrier.ScatteringVertexDAG

variable {R : Type*} [CommRing R]

/-! ## The reusable abstract LGV core -/

/-- **Abstract LGV crossing-cancellation.**  Let `D`, `C` be finite index types
for the direct and crossing path systems, with weights `w : D -> R` and
`u : C -> R`.  Let `inter d` say that the direct system `d` is intersecting.
A weight-preserving bijection `swap : C ≃ {d // inter d}` is precisely the
Lindstrom-Gessel-Viennot swap-tails-at-the-first-shared-vertex map.  Under this
hypothesis the signed amplitude collapses to the sum over non-intersecting
direct families. -/
theorem lgv_crossing_cancels
    {D C : Type*} [Fintype D] [Fintype C]
    (w : D → R) (u : C → R)
    (inter : D → Prop) [DecidablePred inter]
    (swap : C ≃ {d : D // inter d})
    (hw : ∀ c, u c = w (swap c)) :
    (∑ d, w d) - (∑ c, u c) =
      ∑ d ∈ Finset.univ.filter (fun d => ¬ inter d), w d := by
  have hcross : (∑ c, u c) = ∑ d ∈ Finset.univ.filter (fun d => inter d), w d := by
    calc
      (∑ c, u c) = ∑ c, w (swap c) := by simp [hw]
      _ = ∑ d : {d : D // inter d}, w d.1 :=
        (Fintype.sum_equiv swap _ _ (fun c => rfl))
      _ = ∑ d ∈ Finset.univ.filter (fun d => inter d), w d :=
        (Finset.sum_subtype _ (fun x => by simp [Finset.mem_filter]) _).symm
  rw [hcross, ← Finset.sum_filter_add_sum_filter_not Finset.univ (fun d => inter d) w]
  ring

/-! ## The concrete brick-wall scattering DAG -/

/-- Vertices of the brick-wall scattering DAG. -/
inductive V | s1 | s2 | m | t1 | t2
  deriving DecidableEq, Fintype, Repr

open V

/-- Edge weight of the brick-wall scattering DAG, with `0` where there is no
edge. -/
def ew (p q s : R) : V → V → R
  | s1, t1 => p
  | s2, t2 => q
  | s1, m  => s
  | s2, m  => s
  | m,  t1 => s
  | m,  t2 => s
  | _,  _  => 0

/-- Product of edge weights along a walk, represented as a list of vertices. -/
def pw (p q s : R) : List V → R
  | []          => 1
  | [_]         => 1
  | a :: b :: r => ew p q s a b * pw p q s (b :: r)

/-- A vertex is shared by two walks if it appears in both. -/
def shares (a b : List V) : Prop := ∃ v : V, v ∈ a ∧ v ∈ b

/-! ### The six relevant paths and their weights -/

theorem pw_bypass11 (p q s : R) : pw p q s [s1, t1] = p := by simp [pw, ew]
theorem pw_bypass22 (p q s : R) : pw p q s [s2, t2] = q := by simp [pw, ew]
theorem pw_scatter11 (p q s : R) : pw p q s [s1, m, t1] = s * s := by simp [pw, ew]
theorem pw_scatter22 (p q s : R) : pw p q s [s2, m, t2] = s * s := by simp [pw, ew]
theorem pw_cross12 (p q s : R) : pw p q s [s1, m, t2] = s * s := by simp [pw, ew]
theorem pw_cross21 (p q s : R) : pw p q s [s2, m, t1] = s * s := by simp [pw, ew]

/-! ## Direct and crossing path systems -/

/-- The four direct systems: each factor is either the bypass path or the
scattering path. -/
inductive DSys | dd | dm | md | mm
  deriving DecidableEq, Fintype, Repr

/-- The single crossing system: `s1 -> m -> t2` paired with
`s2 -> m -> t1`. -/
inductive CSys | x
  deriving DecidableEq, Fintype, Repr

/-- Weight of a direct system: the product of its two path weights. -/
def wD (p q s : R) : DSys → R
  | .dd => p * q
  | .dm => p * (s * s)
  | .md => (s * s) * q
  | .mm => (s * s) * (s * s)

/-- Weight of the crossing system: the product of its two path weights. -/
def wC (s : R) : CSys → R
  | .x => (s * s) * (s * s)

/-- A direct system is intersecting iff its two paths share a vertex, which
happens exactly for `mm`, where both paths pass through `m`. -/
def interD : DSys → Prop
  | .mm => True
  | _   => False

instance : DecidablePred (interD) := by
  intro d
  cases d <;> unfold interD <;> infer_instance

/-! ### Crossing iff shared vertex, the property the naive checkerboard lacks -/

/-- The crossing system's two paths share the scattering vertex `m`. -/
theorem crossing_shares_m : shares [s1, m, t2] [s2, m, t1] :=
  ⟨m, by simp, by simp⟩

/-- The unique intersecting direct system `mm` also shares `m`. -/
theorem mm_shares_m : shares [s1, m, t1] [s2, m, t2] :=
  ⟨m, by simp, by simp⟩

/-- The three non-intersecting direct systems are genuinely vertex-disjoint. -/
theorem nonintersecting_are_disjoint :
    (¬ shares [s1, t1] [s2, t2]) ∧
    (¬ shares [s1, t1] [s2, m, t2]) ∧
    (¬ shares [s1, m, t1] [s2, t2]) := by
  refine ⟨?_, ?_, ?_⟩ <;>
  · rintro ⟨v, hv1, hv2⟩
    fin_cases v <;> simp_all

/-! ## Weights come from the DAG paths -/

theorem wD_dd_eq (p q s : R) :
    wD p q s .dd = pw p q s [s1, t1] * pw p q s [s2, t2] := by
  rw [pw_bypass11, pw_bypass22]
  rfl

theorem wD_dm_eq (p q s : R) :
    wD p q s .dm = pw p q s [s1, t1] * pw p q s [s2, m, t2] := by
  rw [pw_bypass11, pw_scatter22]
  rfl

theorem wD_md_eq (p q s : R) :
    wD p q s .md = pw p q s [s1, m, t1] * pw p q s [s2, t2] := by
  rw [pw_scatter11, pw_bypass22]
  rfl

theorem wD_mm_eq (p q s : R) :
    wD p q s .mm = pw p q s [s1, m, t1] * pw p q s [s2, m, t2] := by
  rw [pw_scatter11, pw_scatter22]
  rfl

theorem wC_x_eq (p q s : R) :
    wC s .x = pw p q s [s1, m, t2] * pw p q s [s2, m, t1] := by
  rw [pw_cross12, pw_cross21]
  rfl

/-! ## The one-particle propagator and its determinant -/

/-- One-particle propagator entries obtained by summing path weights. -/
def ee (p q s : R) : Fin 2 → Fin 2 → R
  | 0, 0 => p + s * s
  | 0, 1 => s * s
  | 1, 0 => s * s
  | 1, 1 => q + s * s

/-- Auxiliary: the direct family sum expanded. -/
theorem sum_wD (p q s : R) :
    (∑ d, wD p q s d) = p * q + p * (s * s) + (s * s) * q + (s * s) * (s * s) := by
  rw [show (Finset.univ : Finset DSys) = {DSys.dd, DSys.dm, DSys.md, DSys.mm} from by decide]
  simp [wD]
  ring

/-- Auxiliary: the crossing family sum. -/
theorem sum_wC (s : R) : (∑ c, wC s c) = (s * s) * (s * s) := by
  rw [show (Finset.univ : Finset CSys) = {CSys.x} from by decide]
  simp [wC]

/-- The determinant of the one-particle propagator equals the direct-family
sum minus the crossing-family sum: the ordinary expansion of the `2 x 2` LGV
determinant. -/
theorem scatter_det_eq_directMinusCross (p q s : R) :
    (Matrix.of (ee p q s)).det = (∑ d, wD p q s d) - (∑ c, wC s c) := by
  rw [Matrix.det_fin_two, sum_wD, sum_wC]
  simp only [Matrix.of_apply, ee]
  ring

/-! ## The corrected LGV involution and the true T-P3 -/

/-- The swap-tails-at-`m` involution as a weight-preserving bijection between
the crossing family and the intersecting direct families. -/
def swapEq : CSys ≃ {d : DSys // interD d} where
  toFun _ := ⟨DSys.mm, trivial⟩
  invFun _ := CSys.x
  left_inv := fun c => by cases c; rfl
  right_inv := fun d => by
    obtain ⟨d, hd⟩ := d
    cases d <;> first | rfl | exact hd.elim

theorem swapEq_weight (p q s : R) : ∀ c, wC s c = wD p q s (swapEq c) := by
  intro c
  cases c
  rfl

/-- **Corrected, nonvacuous T-P3.**  On the scattering-vertex DAG the signed
two-particle amplitude equals the sum over vertex-disjoint direct families.
The crossing contribution cancels the intersecting direct family via `swapEq`. -/
theorem scatter_LGV_reduction_true (p q s : R) :
    (Matrix.of (ee p q s)).det
      = ∑ d ∈ Finset.univ.filter (fun d => ¬ interD d), wD p q s d := by
  rw [scatter_det_eq_directMinusCross]
  exact lgv_crossing_cancels (wD p q s) (wC s) interD swapEq (swapEq_weight p q s)

/-- The vertex-disjoint direct-family sum, computed explicitly:
`p*q + p*s^2 + s^2*q`. -/
theorem scatter_nonintersecting_sum (p q s : R) :
    (∑ d ∈ Finset.univ.filter (fun d => ¬ interD d), wD p q s d)
      = p * q + p * (s * s) + (s * s) * q := by
  rw [show (Finset.univ.filter (fun d => ¬ interD d)) =
    {DSys.dd, DSys.dm, DSys.md} from by decide]
  simp [wD]
  ring

/-- The corrected amplitude in closed form: `det = p*q + p*s^2 + s^2*q`. -/
theorem scatter_amplitude_closed (p q s : R) :
    (Matrix.of (ee p q s)).det = p * q + p * (s * s) + (s * s) * q := by
  rw [scatter_LGV_reduction_true, scatter_nonintersecting_sum]

/-! ## Nonvacuity witness over `ℚ[X]`, with `s = X` -/

open Polynomial

/-- **Nonvacuity.**  With `s = X` over `ℚ[X]`, the crossing family and the
intersecting direct family are both nonzero (`X^4`) and equal, so the LGV
cancellation is genuine. -/
theorem scatter_crossing_nonvacuous :
    wC (X : Polynomial ℚ) .x = X^4 ∧
    wD (1 : Polynomial ℚ) 1 X .mm = X^4 ∧
    wC (X : Polynomial ℚ) .x = wD (1 : Polynomial ℚ) 1 X (swapEq .x) := by
  refine ⟨by simp [wC]; ring, by simp [wD]; ring, ?_⟩
  simp [wC, wD, swapEq]

/-- Sanity value over `ℚ[X]`: with unit bypass weights and scatter weight
`s = X`, the corrected two-particle amplitude is `1 + 2*X^2`. -/
theorem scatter_amplitude_ratQ :
    (Matrix.of (ee (1 : Polynomial ℚ) 1 X)).det = 1 + 2 * X^2 := by
  rw [scatter_amplitude_closed]
  ring

/-! ## Kill condition: why the naive checkerboard cannot host this involution -/

/-- Abstract kill condition: if the crossing family is nonempty but the
intersecting direct family is empty, then no swap bijection exists, so
`lgv_crossing_cancels` is inapplicable and the crossing term cannot cancel. -/
theorem naive_no_crossing_swap
    {D C : Type*} [Nonempty C]
    (inter : D → Prop) (hempty : ¬ ∃ d, inter d) :
    IsEmpty (C ≃ {d : D // inter d}) := by
  refine ⟨fun e => ?_⟩
  have : IsEmpty {d : D // inter d} := ⟨fun d => hempty ⟨d.1, d.2⟩⟩
  exact this.elim (e (Classical.arbitrary C))

end PhysicsSM.Draft.NullEdge.Carrier.ScatteringVertexDAG
