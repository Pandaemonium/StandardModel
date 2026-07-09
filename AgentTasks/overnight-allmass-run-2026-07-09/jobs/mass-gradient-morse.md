# claude-mass-gradient-morse — masslessness is the critical manifold of the disagreement functional; the Hessian's positive direction is the mass (SciLean gradient/variational port)

## Context (blind to any repo; self-contained finite calculus, Mathlib only)

Port the variational-calculus / gradient+Hessian view (as in the SciLean differentiable-programming
program: gradients, adjoints, Hessians, variational derivatives) -- reference/provenance, NOT an import
(version-pinned). The mass^2 of a two-null-edge state is a smooth DISAGREEMENT FUNCTIONAL of the two
celestial directions. This port gives its VARIATIONAL characterization: masslessness is exactly the
CRITICAL MANIFOLD (gradient = 0), and the HESSIAN is positive-semidefinite with its single positive
direction being precisely the relative motion that GENERATES mass -- a finite Morse-theoretic reading
distinct from action-stationarity (which varies the action, not the mass functional).

## The model (finite, real; 2 rational celestial parameters)

Two null edges given by celestial slopes `s, t : R` (edge_i = `(1, s)`, `(1, t)`). Disagreement /
mass^2 functional `g s t = (t - s)^2` (the squared wedge `(1)(t) - (s)(1)`). Gradient
`grad g = (dg/ds, dg/dt)`. Hessian `H = [[d2/ds2, d2/dsdt],[d2/dtds, d2/dt2]]` (constant `2x2`).

## Targets (real; HasDerivAt/ring/norm_num/fin_cases; NO transcendental, NO Complex, NO nlinarith deg>=3)

1. `partials`: via `HasDerivAt`, `dg/ds = -2*(t - s)` (t fixed) and `dg/dt = 2*(t - s)` (s fixed).
   The gradient is `grad = (-2(t-s), 2(t-s))`. Both by `HasDerivAt` on the quadratic (const-add, pow,
   const_mul), `ring` to normalize.
2. `critical_iff_massless` (payload): the gradient vanishes IFF the edges are collinear IFF massless:
   `grad g s t = 0 <-> s = t <-> g s t = 0`. (`-2(t-s)=0 and 2(t-s)=0 <-> t=s <-> (t-s)^2=0`.) The
   massless set `{s = t}` is exactly the critical manifold of the disagreement functional. Explicit.
3. `hessian_psd_mass_direction` (payload): the Hessian is the constant matrix `H = !![2,-2;-2,2]`
   (from the second partials, via `HasDerivAt` of the first partials). Prove: `H` is positive
   SEMIdefinite; its KERNEL is the diagonal `![1,1]` (`H *v ![1,1] = 0` -- both edges rotating together,
   no relative disagreement, the flat/massless direction), and it is strictly POSITIVE on the
   antidiagonal `![1,-1]` (`![1,-1] . (H *v ![1,-1]) = 8 > 0` -- the relative motion that generates
   mass). So the one nonzero Hessian eigen-direction IS the mass-generating relative motion.
4. `morse_mass_verdict`: package -- mass^2 is a variational disagreement functional whose critical
   manifold is exactly masslessness (`grad = 0 <-> collinear`), a degenerate minimum along the common-
   rotation direction (Hessian kernel `![1,1]`) and a strict minimum along the relative-motion direction
   (Hessian positive on `![1,-1]`); mass grows quadratically in the relative celestial displacement.
   Honest scope: a finite 2-parameter rational avatar; the Hessian is constant (the functional is exactly
   quadratic here); provenance = SciLean gradient/Hessian variational calculus. Not a claim about
   physical mass values.

MANDATORY non-degeneracy: explicit evaluations -- `grad g 3 3 = 0` (massless, s=t=3), `grad g 1 4 =
(-6, 6) != 0` (massive), `g 1 4 = 9`; `H *v ![1,1] = ![0,0]` (flat dir), `![1,-1] . (H *v ![1,-1]) = 8`
(mass dir). All in-theorem.

## Constraints (HARD -- buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only (SciLean is a REFERENCE, not
an import). Footprint exactly [propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace
:= lax) in #print axioms <thm>` on every headline. REAL scalars, `HasDerivAt` for partials + explicit
`2x2` rational Hessian matrix + `mulVec`/`dotProduct`; ring/norm_num/fin_cases; NO Real.sqrt/cos/sin, NO
Complex, NO nlinarith deg>=3. Build under 3 min. Deliver RequestProject/Main.lean (namespace
MassGradientMorse) + ARISTOTLE_SUMMARY.md WITH the SciLean provenance line.
