Deliver a self-contained Lean 4 (Mathlib) file proving Move-1 BRICK 2a of the
null-edge Weitzenbock carrier: with scalar edge weights, the null-soldered square
symmetrizes to EXACTLY the aperture Gram form Q_A - and the closure bivector slot
Q_C is absent precisely because the scalar weights commute (which is the honest
reason gauge-covariant nabla is needed for Q_C). See
`AgentTasks/overnight-mass-run-2026-07-06/FABLE_STEER.md` sec 1 and the landed
brick 1 `PhysicsSM/Draft/NullEdge/Carrier/NullNilpotentSquare.lean`.

Create a NEW module `PhysicsSM/Draft/NullEdge/Carrier/SolderedSquareGram.lean`
(namespace `PhysicsSM.Draft.NullEdge.Carrier`). You MAY import
`PhysicsSM.Draft.NullEdge.Carrier.NullNilpotentSquare` (reuse its `nullSoldered`
definition and `null_clifford_*` lemmas) in addition to `Mathlib`. Check with
`lake env lean <yourfile>`. If a broader `lake build` stalls, SKIP it and return
source. NO `sorry`/`admit`/`axiom`/`native_decide` in the final theorems.

## Mathematical content

Work over a FIELD `R` of characteristic != 2 (so `(2 : R)` is invertible; use `ℝ`
if easiest), module `V`, `Q : QuadraticForm R V`, in `CliffordAlgebra Q`. Recall the
soldered element `nullSoldered Q alpha x = sum e, x e • ι Q (alpha e)` over a
`Fintype E` (from brick 1).

1. `clifford_anticomm_polar` (the polarization keystone): for `a b : V`,
   `ι Q a * ι Q b + ι Q b * ι Q a = algebraMap R _ (QuadraticForm.polar Q a b)`.
   (Mathlib has this - search `CliffordAlgebra.ι_mul_ι_add_swap` or the polar/
   anticommutator lemma; use it directly. `QuadraticForm.polar Q a b = Q(a+b) - Q a
   - Q b` is the associated bilinear content = `2 * g(a,b)`.)

2. `nullSoldered_square_eq_half_gram` (THE headline - the Q_A Gram identity): the
   square of the soldered element equals one-half the full Gram double sum, a SCALAR
   (central) element:
     `nullSoldered Q alpha x ^ 2
        = (2 : R)⁻¹ • ∑ e, ∑ f, (x e * x f) • algebraMap R (CliffordAlgebra Q) (QuadraticForm.polar Q (alpha e) (alpha f))`.
   Proof sketch: expand the square to `∑ e, ∑ f, (x e x f) • (c_e c_f)` (brick 1's
   `nullSoldered_square_expand`); symmetrize - because the scalar weights satisfy
   `x e * x f = x f * x e`, the double sum equals `(2⁻¹) • ∑ e, ∑ f, (x e x f) •
   (c_e c_f + c_f c_e)` (relabel e<->f in one copy); then rewrite each anticommutator
   by `clifford_anticomm_polar`. Note nullity is NOT needed for this identity (it
   holds for any vectors), but for NULL alpha the diagonal `polar Q (alpha e)(alpha e)
   = 2 Q(alpha e) = 0`, so the diagonal drops and the sum is genuinely over distinct
   pairs - state that as a corollary `nullSoldered_square_gram_offDiag` using
   `hα : ∀ e, Q (alpha e) = 0`.

3. `nullSoldered_square_isScalar` (the honest delimiter - why Q_C needs gauge data):
   the soldered square lies in the image of `algebraMap R (CliffordAlgebra Q)` (it is
   a SCALAR / grade-0 element). State it as: there exists `s : R` with
   `nullSoldered Q alpha x ^ 2 = algebraMap R _ s` (take `s = (2⁻¹) * ∑ e, ∑ f,
   x e * x f * QuadraticForm.polar Q (alpha e) (alpha f)`). Interpretation
   (docstring): with COMMUTING scalar weights the closure bivector slot Q_C
   vanishes identically - the square is pure Q_A Gram scalar - so a nontrivial Q_C
   REQUIRES non-commuting (gauge-covariant) weights. This delimits brick 1/2a and
   motivates brick 2 (the 2-complex + covariant nabla).

## Honesty / scope (module docstring)

State: this is still the scalar-nabla skeleton (brick 1's simplification). The
headline identifies the scalar-weight soldered square with the aperture Gram form
Q_A EXACTLY, and proves the Q_C bivector slot is absent under commuting weights -
an honest structural result, NOT the full decomposition (no gauge holonomy, no
Krein #, no potential Phi). Finite Clifford-algebra identity, draft-trust.

## Deliverable

Self-contained file + report: exact theorem names, PROVED vs the modeled scalar-
nabla simplification, and the axiom footprint (aim `[propext, Classical.choice,
Quot.sound]` or fewer). Report any `sorry` explicitly.
