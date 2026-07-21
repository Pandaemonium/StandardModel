import PhysicsSM.Draft.NullEdge.CompositionIdealRepContent

/-!
# The isospin-grading search (eq-36 follow-up)

**Context.** `CompositionIdealRepContent` (previous run, all proven) shows
the `adT3` grading of the four ideal operators is the NUMBER-OPERATOR
pattern `(0, +1, +1, +2)` for `(vwHat, X1, X2, X3)` - not the eq-36 isospin
doublet pattern `(0, +1, -1, 0)`. Diagnosis: the rank-one closed forms mean
both `betaHat`s raise toward the `nu`-line, so the `tau_3` adjoint counts
weak content additively. The paper's intended grading must come from a
DIFFERENT operator whose adjoint separates `X1` (up-type) from `X2`
(down-type).

**Task.** For each candidate `G` below, compute the adjoint action
`adG G' d = G (G' d) - G' (G d)` on the four operators (same technique as
the previous run: rank-one closed forms + `R`-slot algebra + the local
`phi`/`psi` API), and STATE the resulting grading vector as four kernel
theorems. Then:

- if some candidate realizes `(0, +1, -1, 0)`, name it prominently;
- if none does, prove the true grading vectors and REPORT the obstruction
  pattern (that is a fully acceptable honest outcome).

Candidates (all definable from the in-scope machinery):

1. `G_R (d) = Complex.I • R3 d` - the quaternionic `i_3` right-rotation
   (the H-side isospin direction; `R3` anticommutes with `R1`/`R2`).
2. `G_PL (d) = co hatTau3 (PL d)` - the chirally projected weak grading
   (the landed Fig-4 `T_3`).
3. `G_mix (d) = (1/2 : ℂ) • (co hatTau3 d) + (1/2 : ℂ) • (Complex.I • R3 d)`
   - the half-sum (weak tau plus H-rotation - the "total T3" candidate).

You may add further candidates from the same operator family if the three
fail in an informative way (e.g. relative sign flips between `X1` and `X2`
under `G_R` suggest a specific combination); document any addition.

Constraints: no new axioms, no n a t i v e _ d e c i d e, standard axiom
set; keep the four operator definitions EXACTLY as in the imported module;
statements for the found gradings must be equalities `adG ... d = c • (...)`
with explicit scalar literals.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.IsospinGradingSearch

-- Candidate definitions and grading theorems: TO BE COMPLETED (see the
-- module docstring; the previous run's proof technique applies verbatim).

end PhysicsSM.Draft.NullEdge.IsospinGradingSearch
