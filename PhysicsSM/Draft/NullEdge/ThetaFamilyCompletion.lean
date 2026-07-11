/-
ThetaFamilyCompletion.lean — Paper C "theta-family wave 2" completion.

Kernel-only (standard three axioms; NO native_decide anywhere in this file).
Extends the namespace of `context/ThetaFamilyProtection.lean`
(`PhysicsSM.Draft.NullEdge.ThetaFamilyProtection`) with:

* T1 `atlas_two_charts_family` — the kernel + all-θ replacement of the
  fixed-angle native_decide atlas: every two-wall field is self-adjoint in at
  least one of the two charts.
* T2 the symbolic positional IFF (`M13_selfadj_iff`, `M02_selfadj_iff`) with
  the entry witnesses (`M13_antisymm_entry`, `M02_antisymm_entry`).  Step-1 gate
  PASSED (see the memo `THETA_FAMILY_COMPLETION_MEMO.md`): every nonzero entry
  of `M13 − M13ᵀ` is `±(signB (b 0) + signB (b 2))·sin θ`, and every nonzero
  entry of `M02 − M02ᵀ` is `±(signB (b 1) + signB (b 3))·sin θ`.
* T3 `Wth_eq_landed` — the landed-fixture pin: at the fixture angle
  (`cos θ₀ = 4/5`, `sin θ₀ = 3/5`) the θ-family walk equals the landed rational
  walk `Wof b` cast to `ℝ`.
* T4 dictionary compat one-liners (`wallCount_compat`, `loneAt_compat`,
  `fixedSingleton_compat`) in the `CGGSVWZDictionary` namespace.
-/
/-
Provenance: Aristotle job 189d6bd6 (fable-24h-thetafamily2), harvested
2026-07-11 ~12:45 PDT; memo at
`AgentTasks/aristotle-results/thetafamily2-189d6bd6/.../THETA_FAMILY_COMPLETION_MEMO.md`.
Statements integrated UNCHANGED except this header (imports already use
project paths). KERNEL-ONLY throughout (standard three axioms, no
native_decide; verified per-deliverable by the job and re-pinned in the
aggregate guard). Contents: the kernel all-theta two-chart atlas
(atlas_two_charts_family); the SYMBOLIC positional iff for both charts
(M13/M02_selfadj_iff: self-adjoint iff (sign-sum) * sin theta = 0, with
the complete 16-entry antisymmetric-part table in the memo - the gate
passed, no entrywise luck); the landed-fixture transport pin
(Wth_eq_landed: at cos = 4/5, sin = 3/5 the theta-walk equals the landed
rational walkQ fixture under Rat.cast); and the three dictionary
helper-compat lemmas.
-/
import Mathlib
import PhysicsSM.Draft.NullEdge.ModeInvariantHalfWinding
import PhysicsSM.Draft.NullEdge.HalfPeriodInvariant
import PhysicsSM.Draft.NullEdge.PinnedMirrorChart
import PhysicsSM.Draft.NullEdge.CGGSVWZDictionary
import PhysicsSM.Draft.NullEdge.ThetaFamilyProtection

open Matrix

namespace PhysicsSM.Draft.NullEdge.ThetaFamilyProtection

open PhysicsSM.Draft.NullEdge.ModeInvariantHalfWinding

set_option maxHeartbeats 8000000

/-! ## T1.  Kernel + all-θ atlas: two charts cover every two-wall field. -/

/-- **T1 `atlas_two_charts_family`.**  For every real `θ` and every two-wall
field `b` (`wallCount b = 2`), the walk is self-adjoint in the `{1,3}` chart or
in the `{0,2}` chart.  This is the body of `modes_persist` minus the engine
step (`two_wall_chart` dispatch + `M13_selfadj_of` / `M02_selfadj_of`): the
kernel, all-θ replacement of the fixed-angle `native_decide` atlas. -/
theorem atlas_two_charts_family (theta : ℝ) (b : Fin 4 → Bool)
    (hb : PhysicsSM.Draft.NullEdge.HalfPeriodInvariant.wallCount b = 2) :
    M13 theta b = (M13 theta b)ᵀ ∨ M02 theta b = (M02 theta b)ᵀ := by
  rcases two_wall_chart b hb with h | h
  · exact Or.inl (M13_selfadj_of theta b ((signB_add_eq_zero_iff _ _).2 h))
  · exact Or.inr (M02_selfadj_of theta b ((signB_add_eq_zero_iff _ _).2 h))

/-! ## T2.  The symbolic positional IFF (Step-1 gate PASSED). -/

/-- **T2 entry witness, chart `{1,3}`.**  The distinguishing antisymmetric
entry, in exact closed form. -/
theorem M13_antisymm_entry (theta : ℝ) (b : Fin 4 → Bool) :
    (M13 theta b - (M13 theta b)ᵀ) 0 1
      = -(signB (b 0) + signB (b 2)) * Real.sin theta := by
  unfold M13 Wth shiftR coinR BfixR
  simp [Matrix.sub_apply, Matrix.transpose_apply, Matrix.mul_apply, Fintype.sum_prod_type,
    Fin.sum_univ_two, Fin.sum_univ_four]
  ring

/-- **T2 IFF, chart `{1,3}`.**  `M13` is self-adjoint exactly when the
reflection-fixed sites `0,2` cancel *against* `sin θ`:
`(signB (b 0) + signB (b 2))·sin θ = 0` (i.e. `b 0 ≠ b 2` **or** the massless
boundary `sin θ = 0`).  Subsumes the fixture iff and the T5 controls. -/
theorem M13_selfadj_iff (theta : ℝ) (b : Fin 4 → Bool) :
    M13 theta b = (M13 theta b)ᵀ ↔ (signB (b 0) + signB (b 2)) * Real.sin theta = 0 := by
  constructor
  · intro hEq
    have key := M13_antisymm_entry theta b
    rw [sub_eq_zero.mpr hEq, Matrix.zero_apply] at key
    linarith [key]
  · intro h
    unfold M13 Wth shiftR coinR BfixR
    ext i j; fin_cases i <;> fin_cases j <;>
      simp [Matrix.mul_apply, Matrix.transpose_apply, Fintype.sum_prod_type, Fin.sum_univ_two] <;>
      first
        | linear_combination h
        | linear_combination -h

/-- **T2 entry witness, chart `{0,2}`.** -/
theorem M02_antisymm_entry (theta : ℝ) (b : Fin 4 → Bool) :
    (M02 theta b - (M02 theta b)ᵀ) 0 1
      = -(signB (b 1) + signB (b 3)) * Real.sin theta := by
  unfold M02 Wth shiftR coinR Bfix0R
  simp [Matrix.sub_apply, Matrix.transpose_apply, Matrix.mul_apply, Fintype.sum_prod_type,
    Fin.sum_univ_two, Fin.sum_univ_four]
  ring

/-- **T2 IFF, chart `{0,2}`** (mirror of `M13_selfadj_iff` on sites `1,3`). -/
theorem M02_selfadj_iff (theta : ℝ) (b : Fin 4 → Bool) :
    M02 theta b = (M02 theta b)ᵀ ↔ (signB (b 1) + signB (b 3)) * Real.sin theta = 0 := by
  constructor
  · intro hEq
    have key := M02_antisymm_entry theta b
    rw [sub_eq_zero.mpr hEq, Matrix.zero_apply] at key
    linarith [key]
  · intro h
    unfold M02 Wth shiftR coinR Bfix0R
    ext i j; fin_cases i <;> fin_cases j <;>
      simp [Matrix.mul_apply, Matrix.transpose_apply, Fintype.sum_prod_type, Fin.sum_univ_two] <;>
      first
        | linear_combination h
        | linear_combination -h

/-! ## T3.  Landed-fixture pin. -/

/-- The θ-family shift is the landed rational shift, cast to `ℝ`. -/
theorem shiftR_eq_shiftQ_cast :
    shiftR = (ModeInvariantHalfWinding.shiftQ).map (Rat.cast : ℚ → ℝ) := by
  ext i j
  simp only [shiftR, ModeInvariantHalfWinding.shiftQ, Matrix.of_apply, Matrix.map_apply]
  split_ifs <;> simp

/-- At the fixture angle, the θ-family coin is the landed rational coin. -/
theorem coinR_eq_coinQ_cast (theta0 : ℝ) (hc : Real.cos theta0 = 4 / 5)
    (hs : Real.sin theta0 = 3 / 5) (b : Fin 4 → Bool) :
    coinR theta0 b
      = (ModeInvariantHalfWinding.coinQ ModeInvariantHalfWinding.cW
          (PhysicsSM.Draft.NullEdge.HalfPeriodInvariant.sField b)).map (Rat.cast : ℚ → ℝ) := by
  ext i j
  simp only [coinR, ModeInvariantHalfWinding.coinQ, Matrix.of_apply, Matrix.map_apply,
    ModeInvariantHalfWinding.cW, PhysicsSM.Draft.NullEdge.HalfPeriodInvariant.sField, signB]
  split_ifs <;> push_cast <;> simp_all <;> ring

/-- **T3 `Wth_eq_landed`.**  At any angle `θ₀` with `cos θ₀ = 4/5` and
`sin θ₀ = 3/5` (the `3-4-5` fixture cosine and sine magnitude), the θ-family
walk `Wth θ₀ b` equals the landed rational fixture walk `Wof b` cast to `ℝ`,
for every sign field `b`.  This is the referee pin: the θ-family result contains
the landed fixture at the fixture angle. -/
theorem Wth_eq_landed (theta0 : ℝ) (hc : Real.cos theta0 = 4 / 5)
    (hs : Real.sin theta0 = 3 / 5) (b : Fin 4 → Bool) :
    Wth theta0 b
      = (PhysicsSM.Draft.NullEdge.HalfPeriodInvariant.Wof b).map (Rat.cast : ℚ → ℝ) := by
  have hcast : (Rat.cast : ℚ → ℝ) = ⇑(Rat.castHom ℝ) := rfl
  rw [Wth, PhysicsSM.Draft.NullEdge.HalfPeriodInvariant.Wof, ModeInvariantHalfWinding.walkQ,
    shiftR_eq_shiftQ_cast, coinR_eq_coinQ_cast theta0 hc hs b, hcast,
    Matrix.map_mul, Matrix.map_mul]

end PhysicsSM.Draft.NullEdge.ThetaFamilyProtection

/-! ## T4.  Dictionary compat hygiene (kernel `decide`). -/

namespace PhysicsSM.Draft.NullEdge.CGGSVWZDictionary

/-- The local `wallCount` helper agrees with the landed `HalfPeriodInvariant`
one on all inputs. -/
theorem wallCount_compat :
    ∀ b, wallCount b = PhysicsSM.Draft.NullEdge.HalfPeriodInvariant.wallCount b := by
  decide

/-- The local `loneAt` helper agrees with the landed `HalfPeriodInvariant` one
on all inputs. -/
theorem loneAt_compat :
    ∀ b i, loneAt b i = PhysicsSM.Draft.NullEdge.HalfPeriodInvariant.loneAt b i := by
  decide

/-- The local `fixedSingleton` helper agrees with the landed
`HalfPeriodInvariant` one on all inputs. -/
theorem fixedSingleton_compat :
    ∀ b, fixedSingleton b = PhysicsSM.Draft.NullEdge.HalfPeriodInvariant.fixedSingleton b := by
  decide

end PhysicsSM.Draft.NullEdge.CGGSVWZDictionary
