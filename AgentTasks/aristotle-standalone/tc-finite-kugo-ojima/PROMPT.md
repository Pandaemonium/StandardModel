# PROOF JOB: finite Kugo-Ojima (nilpotent charge cohomology is nondegenerate)

Lean 4 + Mathlib. Finite-dimensional linear algebra over C on an indefinite
Hermitian form. No sorry, no new axioms, no native_decide; axiom footprint
within [propext, Classical.choice, Quot.sound]. Namespace
`PhysicsSM.Draft.NullEdge.Carrier.KugoOjima`; `import Mathlib` only.
Deliverable: one file `FiniteKugoOjima.lean`. The included context file
(CarrierIndexProtection.lean) shows house style only - do not import it.

## Setting

`V := EuclideanSpace C (Fin n)`; a fundamental symmetry
`J : V →ₗ[C] V` with `LinearMap.adjoint J = J` and `J ∘ₗ J = LinearMap.id`;
the Krein form `B x y := inner C x (J y)`; the Krein adjoint of
`A : V →ₗ[C] V` is `A# := J ∘ₗ (LinearMap.adjoint A) ∘ₗ J`.

## Targets (in order)

1. **`krein_adjoint_pairing`.** `B (A x) y = B x (A# y)` for all x y (two-line
   unfold via `LinearMap.adjoint_inner_left/right` and `J∘J = id`).
2. **`orthoB_ker_eq_range` (the workhorse).** For any A:
   `{x | ∀ v ∈ LinearMap.ker A, B v x = 0} = LinearMap.range A#`
   as submodules (define the left side as a `Submodule`, the B-orthogonal of
   the kernel). Finite-dimensional proof: one inclusion from target 1; the
   other by dimension count (`finrank` of a B-orthogonal complement, using
   nondegeneracy of B from J invertible - prove
   `finrank (orthoB S) = n - finrank S` for the NONDEGENERATE ambient form
   as a lemma, or route through `Submodule.orthogonal` of the twisted inner
   product `⟪x, y⟫_J := inner x (J y)` if that is cleaner; document the
   route chosen).
3. **`finite_kugo_ojima` (the headline).** If `Q : V →ₗ[C] V` satisfies
   `Q ∘ₗ Q = 0` and `Q# = Q`, then:
   (a) `LinearMap.range Q ≤ LinearMap.ker Q`;
   (b) the radical of B restricted to `ker Q` equals `range Q`:
       `{x ∈ ker Q | ∀ v ∈ ker Q, B v x = 0} = range Q` (as submodules of
       ker Q or of V - state it the cleanest way, but the mathematical
       content must be exactly this);
   (c) hence the induced form on the quotient `(ker Q) / (range Q)` is
       nondegenerate (state via: for every x in ker Q not in range Q there
       is y in ker Q with `B y x ≠ 0`).
4. **`descent_unitary` (feeds the dynamics chain).** If additionally
   `U : V →ₗ[C] V` is J-unitary (`U# ∘ₗ U = LinearMap.id`) and commutes with
   Q, then U preserves `ker Q` and `range Q`, and the induced map on the
   quotient preserves the induced form (statement at the "for all
   representatives" level is fine).

## Provenance for docstrings

Finite-dimensional skeleton of the Kugo-Ojima quartet mechanism (Kugo-Ojima,
Prog. Theor. Phys. Suppl. 66 (1979)); clean-room from linear algebra; the
statement that quartet completeness is automatic in finite dimensions (the
radical of the restricted form is EXACTLY the image of the charge) is the
point of the file - say so in the module docstring, and note that POSITIVITY
of the induced form is deliberately NOT claimed (separate open problem).
