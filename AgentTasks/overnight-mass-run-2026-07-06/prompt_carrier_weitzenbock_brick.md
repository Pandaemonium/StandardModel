Deliver a self-contained Lean 4 (Mathlib) file establishing the ALGEBRAIC KEYSTONE
of the null-edge Weitzenbock carrier program: null Clifford nilpotency and the
resulting "mass is relational = zero edge-diagonal" identity. This is Move-1's first
finite brick (see AgentTasks/overnight-mass-run-2026-07-06/FABLE_STEER.md sec 0-1).

Create a NEW standalone module `PhysicsSM/Draft/NullEdge/Carrier/NullNilpotentSquare.lean`
(namespace `PhysicsSM.Draft.NullEdge.Carrier`). Import ONLY `Mathlib`. Check with
`lake env lean <yourfile>`. If a broader `lake build` stalls, SKIP it and return the
best `lake env lean`-typechecking file plus a report. NO `sorry`/`admit`/`axiom`/
`native_decide` in the final theorems.

## Mathematical content (prove exactly these, kernel-checked)

Work over a commutative field/ring `R` (use `ℝ` if that is easiest) with a module `V`
and a quadratic form `Q : QuadraticForm R V`. Use Mathlib's `CliffordAlgebra Q` and
`CliffordAlgebra.ι Q : V ->ₗ[R] CliffordAlgebra Q`.

1. `null_clifford_sq_zero` (the masslessness of a lone null edge): for `v : V` with
   `Q v = 0`, `(CliffordAlgebra.ι Q v) ^ 2 = 0`. (Mathlib: `CliffordAlgebra.ι_sq_scalar`
   gives `(ι Q v)^2 = algebraMap R _ (Q v)`; substitute `Q v = 0`.) Also give the
   `mul_self` form `ι Q v * ι Q v = 0`.

2. `nullSoldered_square_offDiagonal` (the relational-mass identity - THE headline): let
   `E` be a `Fintype` (the null edges), `alpha : E -> V` a family of NULL vectors
   (`hα : ∀ e, Q (alpha e) = 0`), and `x : E -> R` scalar coefficients (the abstract
   difference-operator weights). Define the soldered element `D0 := ∑ e, x e • ι Q (alpha e)`.
   Prove that its square has NO diagonal term:
     `D0 ^ 2 = ∑ e, ∑ f ∈ Finset.univ.erase e, (x e * x f) • (ι Q (alpha e) * ι Q (alpha f))`.
   Equivalently prove the two-step form:
     (a) `D0 ^ 2 = ∑ e, ∑ f, (x e * x f) • (ι Q (alpha e) * ι Q (alpha f))`  (expand the
         square of a finite sum; scalars are central so they factor out), and
     (b) the diagonal terms vanish: for each `e`, `(x e * x e) • (ι Q (alpha e) * ι Q (alpha e)) = 0`
         (immediate from theorem 1), hence the `f = e` summands drop and (a) reduces to
         the off-diagonal sum.
   State the final off-diagonal identity as the headline theorem.

3. `lone_edge_massless` (interpretation corollary, honest one-liner): with a single edge
   (`E := Fin 1` or a one-element family), `D0 ^ 2 = 0`. The square of a single null-
   soldered generator vanishes - a lone lightlike excitation carries no (algebraic) mass.

## Honesty / scope (put in the module docstring)

This is the ALGEBRA-LEVEL skeleton of the discrete Weitzenbock decomposition
`D^#D = Q_A + Q_C + Q_T + E`: it proves the keystone `c(alpha)^2 = 0` (null Clifford
nilpotency) and the resulting zero-diagonal of the soldered square - i.e. every term of
the square is a PAIRWISE relation between DISTINCT null edges ("mass is relational" as
literal matrix/algebra structure). It is NOT yet the full carrier: there is no gauge-
covariant difference operator (the `x e` are commuting scalar stand-ins for `∇_e`), no
Krein `#`-adjoint, no potential `Phi`, and no 2-complex/plaquette (closure) structure -
those are the later bricks. Label it a finite algebraic identity, draft-trust.

## Deliverable

The self-contained file + a report: exact theorem names, what is PROVED vs the modeled
scalar-∇ simplification, and the axiom footprint (aim `[propext, Classical.choice,
Quot.sound]` or fewer; theorem 1 may be axiom-free). Report any `sorry` explicitly.
