import Mathlib
import PhysicsSM.Draft.SpinCoherentProjectorAristotle

/-!
# Draft.SpinCoherentCollapseAristotle

Aristotle handoff (wave 2): the general collapse and rank-one structure of
the spin coherent projectors of
`PhysicsSM.Draft.SpinCoherentProjectorAristotle` (whose targets were proved
in wave 1 and are available sorry-free).

## Mathematical intent

WP3 of `Sources/Luminal_Motion_Checkerboard_Research_Program.md`, second
stage.  The wave-1 file proved the sandwich collapse
`P(a) P(b) P(a) = ((1 + a.b)/2) P(a)` and the Bargmann triple-trace.  The
master fact behind both is that `P(a)` is a *rank-one* projector
`v_a v_a^dagger`, so that for **any** matrix `M`:

`P(a) M P(a) = tr (P(a) M) . P(a)`.

This single identity collapses an arbitrary-length projector chain
`P(a_1) M_1 P(a_2) M_2 ... P(a_1)` into a product of Bargmann traces times
`P(a_1)` -- the algebraic engine that reduces the spin transport along any
closed null polygon to scalar holonomy factors.  The explicit rank-one
witness (a spin coherent state in a chart) and the antipodal
orthogonality/completeness relations round out the projector calculus.

Validated numerically (including with arbitrary non-Hermitian `M`) in
`Scripts/oracle/validate_checkerboard.py`; the oracle justifies the
statements, not the proofs.

## Conventions

Same as the wave-1 file: `spinProjector a = (1/2)(1 + sigma . a)` on
`Matrix (Fin 2) (Fin 2) C`; `dot3`/`cross3` Euclidean; norm hypotheses
`dot3 a a = 1` are stated exactly where needed.

## Proof guidance

- Available sorry-free from the imported wave-1 file:
  `pauliVec_mul_pauliVec` (the master product identity),
  `pauliVec_conjTranspose`, `spinProjector_conjTranspose`,
  `trace_spinProjector`, `spinProjector_mul_self`, `det_spinProjector`,
  `spinProjector_sandwich`, `trace_spinProjector_triple`.
- `spinProjector_conj_collapse`: entrywise computation works (`ext`,
  `fin_cases`, `simp [Matrix.mul_apply, Matrix.trace, ...]`, `ring_nf`,
  then `linear_combination` with the unit-norm hypothesis), since a 2x2
  identity with 4 unknown complex entries of `M` is still polynomial.
- `exists_rankOne_spinProjector`: case split on `a 2 = -1` (south pole).
  Off the south pole use the chart
  `v = ![Real.sqrt ((1 + a 2)/2), (a 0 + a 1 * I)/Real.sqrt (2*(1 + a 2))]`;
  the unit-norm hypothesis gives `(a 0)^2 + (a 1)^2 = (1 - a 2)*(1 + a 2)`.
  At the south pole `spinProjector a = vecMulVec ![0,1] (star ![0,1])`
  (note the norm hypothesis forces `a 0 = a 1 = 0` there).
- `trace_spinProjector_pair` follows from `trace_spinProjector_triple`
  with `c = a` and the unit norm of `a`, or directly.
- `spinProjector_add_antipodal` is hypothesis-free linear algebra;
  `spinProjector_mul_antipodal` uses the master product identity and
  `dot3 a a = 1`.

Do not change any definition or statement of the imported wave-1 file.
Helper lemmas are welcome.  The final state should contain no placeholder
proof commands, no new assumptions, and no forbidden declarations.

This is draft code: the statements below contain documented handoff holes
and must not be imported from trusted code until they are eliminated.
-/

noncomputable section

namespace PhysicsSM.Draft.SpinCoherentCollapse

open Matrix Complex
open PhysicsSM.Draft.SpinCoherentProjector

/-! ## Target 1: the general rank-one collapse -/

-- The entrywise expansion of the 2x2 conjugation (with four unknown complex
-- entries of `M`) is a large polynomial normalisation that exceeds the
-- default heartbeat budget.
set_option maxHeartbeats 1600000 in
/--
**General collapse.**  Conjugating any matrix by a unit coherent
projector collapses it to a scalar times the projector, the scalar being
the trace pairing.  This is the algebraic engine that reduces arbitrary
projector chains along null polygons to products of Bargmann scalars.
-/
theorem spinProjector_conj_collapse (a : Fin 3 → ℝ) (ha : dot3 a a = 1)
    (M : Matrix (Fin 2) (Fin 2) ℂ) :
    spinProjector a * M * spinProjector a
      = Matrix.trace (spinProjector a * M) • spinProjector a := by
  -- By definition of spinProjector, we have spinProjector a = ((1:ℂ)/2) • (1 + pauliVec a).
  ext i j; fin_cases i <;> fin_cases j <;> simp [spinProjector, pauliVec];
  · simp +decide [ Matrix.mul_apply, Matrix.trace ] ; ring!;
    unfold pauliX pauliY pauliZ; norm_num [ Complex.ext_iff, sq ] ; ring;
    constructor <;> rw [ show a 0 ^ 2 = 1 - a 1 ^ 2 - a 2 ^ 2 by linarith [ show a 0 * a 0 + a 1 * a 1 + a 2 * a 2 = 1 by exact ha ] ] <;> ring;
  · norm_num [ Matrix.mul_apply, Matrix.trace_fin_two, pauliX, pauliY, pauliZ ] ; ring;
    unfold dot3 at ha; norm_num [ Complex.ext_iff, sq ] at *;
    grind;
  · norm_num [ Matrix.mul_apply, Matrix.trace ] ; ring;
    simp +decide [ pauliX, pauliY, pauliZ ] ; ring;
    rw [ show ( a 2 : ℂ ) ^ 2 = 1 - ( a 0 : ℂ ) ^ 2 - ( a 1 : ℂ ) ^ 2 by norm_cast; rw [ dot3 ] at ha; linear_combination ha ] ; norm_num ; ring;
  · unfold pauliX pauliY pauliZ; norm_num [ Matrix.mul_apply, Matrix.trace_fin_two ] ; ring;
    norm_num [ show ( a 0 : ℂ ) ^ 2 = 1 - ( a 1 ^ 2 + a 2 ^ 2 ) by exact mod_cast by { unfold dot3 at ha; linarith } ] ; ring

/-! ## Target 2: the explicit rank-one structure -/

/--
**Rank-one witness.**  On the unit sphere the coherent projector is an
explicit outer product `v v^dagger` of a spin coherent state.
-/
theorem exists_rankOne_spinProjector (a : Fin 3 → ℝ) (ha : dot3 a a = 1) :
    ∃ v : Fin 2 → ℂ, spinProjector a = Matrix.vecMulVec v (star v) := by
  by_cases h : a 2 = -1;
  · -- If $a_2 = -1$, then $a_0 = 0$ and $a_1 = 0$.
    have h_zero : a 0 = 0 ∧ a 1 = 0 := by
      unfold dot3 at ha; constructor <;> nlinarith!;
    use ![0, 1];
    ext i j ; fin_cases i <;> fin_cases j <;> simp +decide [ *, spinProjector, pauliVec, pauliX, pauliY, pauliZ ];
    norm_num;
  · use ![Real.sqrt ((1 + a 2) / 2), (a 0 + a 1 * Complex.I) / Real.sqrt (2 * (1 + a 2))];
    ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.vecMulVec, spinProjector, pauliVec ] <;> ring_nf;
    · norm_num [ Complex.ext_iff, sq, pauliX, pauliY, pauliZ ];
      rw [ Real.mul_self_sqrt ] <;> ring <;> norm_num ; nlinarith [ ha, dot3 a a, sq_nonneg ( a 0 ), sq_nonneg ( a 1 ), sq_nonneg ( a 2 ) ];
      unfold dot3 at ha; nlinarith [ sq_nonneg ( a 0 ), sq_nonneg ( a 1 ), sq_nonneg ( a 2 ) ] ;
    · norm_num [ Complex.ext_iff, pauliX, pauliY, pauliZ ];
      norm_num [ sq ] ; ring;
      norm_num [ show Real.sqrt ( 1 + a 2 ) ≠ 0 from ne_of_gt <| Real.sqrt_pos.mpr <| by contrapose! h; linarith [ show a 2 ≥ -1 from by { unfold dot3 at ha; nlinarith! [ sq_nonneg ( a 0 ), sq_nonneg ( a 1 ), sq_nonneg ( a 2 ) ] } ] ];
    · unfold pauliX pauliY pauliZ; norm_num [ Complex.ext_iff, sq ] ; ring;
      norm_num [ mul_assoc, mul_comm, mul_left_comm, ne_of_gt ( Real.sqrt_pos.mpr ( show 0 < 1 + a 2 from by contrapose! h; linarith [ show a 2 ≥ -1 from by { unfold dot3 at ha; nlinarith [ sq_nonneg ( a 0 ), sq_nonneg ( a 1 ), sq_nonneg ( a 2 ) ] } ] ) ) ];
      constructor <;> ring;
    · norm_num [ Complex.ext_iff, sq, pauliX, pauliY, pauliZ ];
      field_simp;
      rw [ Real.sq_sqrt, Real.sq_sqrt, eq_div_iff ] <;> norm_num [ dot3 ] at * <;> cases lt_or_gt_of_ne h <;> nlinarith

/-! ## Target 3: the pair trace (overlap probability) -/

/--
**Pair trace.**  `tr (P(a) P(b)) = (1 + a.b)/2`: the transition
probability between spin coherent states, and the modulus part of the
Bargmann holonomy data.
-/
theorem trace_spinProjector_pair (a b : Fin 3 → ℝ) (ha : dot3 a a = 1) :
    Matrix.trace (spinProjector a * spinProjector b)
      = (((1 + dot3 a b) / 2 : ℝ) : ℂ) := by
  unfold spinProjector;
  unfold pauliVec dot3 at *;
  norm_num [ Matrix.trace, Matrix.mul_apply, pauliX, pauliY, pauliZ ] ; ring;
  norm_num

/-! ## Target 4: antipodal completeness and orthogonality -/

/--
**Completeness.**  The projectors onto antipodal directions resolve the
identity (no norm hypothesis: linear in `a`).
-/
theorem spinProjector_add_antipodal (a : Fin 3 → ℝ) :
    spinProjector a + spinProjector (-a) = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [ spinProjector, pauliVec ] ; ring;
  · ring;
  · ring;
  · ring

/--
**Orthogonality.**  Antipodal coherent projectors annihilate each other
on the unit sphere.
-/
theorem spinProjector_mul_antipodal (a : Fin 3 → ℝ) (ha : dot3 a a = 1) :
    spinProjector a * spinProjector (-a) = 0 := by
  unfold spinProjector;
  simp +decide [ dot3, pauliVec ] at *;
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, pauliX, pauliY, pauliZ ] <;> ring_nf <;> norm_num [ ha ]; all_goals norm_num [ Complex.ext_iff, sq ] at * ; linarith

end PhysicsSM.Draft.SpinCoherentCollapse

end
