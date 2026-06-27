# D17 — Scalar/gauge null-quadrature and covariant Higgs-gradient reconstruction

**Status:** kernel-checked. New module
`PhysicsSM/Draft/NullEdgeScalarGaugeNullQuadrature.lean`. All theorems build
under the pinned toolchain (Lean v4.28.0 / Mathlib v4.28.0) and depend only on
`propext`, `Classical.choice`, `Quot.sound`.

## What was delivered

Task D17 asked to turn the scalar/gauge null-quadrature bridge into a
kernel-checked theorem (or a precise staged theorem), reusing the existing
null-frame / inverse-Gram API.

1. **Reused the existing API.** The scalar half of Theorem D was already proven
   in `NullEdgeScalarKineticReconstruction.lean`
   (`covector_bilin_reconstruction`, `inverse_gram`,
   `inverse_gram_reconstruction`). The new module imports that file and builds on
   `covector_bilin_reconstruction` rather than re-deriving it. The scalar target
   identity `g^{-1}(ξ,η) = ∑_{a,b} G^{ab} ξ(ℓ_a) η(ℓ_b)` is re-exported as
   `scalar_null_quadrature`.

2. **Exact finite quadrature identity — proven** (not staged). The frame
   definitions are present (dual covector basis `α = ell.dualBasis`, predual null
   edges `ell`), so the identity is the kernel-checked
   `inverse_gram_reconstruction` / `scalar_null_quadrature`.

3. **Gauge/Higgs version with a clean inner-product abstraction — proven.** The
   gauge representation is an arbitrary real module `E` with a bilinear inner
   product `q : E →ₗ[ℝ] E →ₗ[ℝ] ℝ` (no positivity, completeness, or smoothness
   assumed — exactly the minimal data). The covariant differential is a linear
   map `DH : V →ₗ[ℝ] E`, with `∇_a^A H := DH(ℓ_a)`. The new results are:

   * `gaugeNullKinetic B q α ell DH DH' = ∑_{a,b} B(α^a,α^b) q(DH(ℓ_a), DH'(ℓ_b))`
     — the inverse-Gram contraction of two `E`-valued one-forms (the RHS of the
     covariant reconstruction).
   * `gauge_null_quadrature` — the central **frame-independence / reconstruction**
     theorem: the null-edge contraction equals the manifestly frame-independent
     component expansion `∑_{i,j} q(e_i,e_j) · B(H_i, H'_j)`, where
     `H_i := e^i ∘ DH` are the scalar component covectors of the gauge multiplet.
     This is the `E`-valued analogue of `covector_bilin_reconstruction`, and is
     the honest finite-algebraic meaning of the intrinsic object
     `g^{-1}(DH, DH') = (g^{-1} ⊗ q)(DH, DH')`.
   * `gauge_inverse_gram_reconstruction` — the §25.2 identity with `B = g^{-1}`:
     `g^{-1}(DH,DH') = ∑_{a,b} G^{ab} q(∇_a H, ∇_b H')
                     = ∑_{i,j} q(e_i,e_j) g^{-1}(dH_i, dH'_j)`.
   * `gauge_higgs_kinetic_reconstruction` — the documented Higgs corollary
     (`DH = DH'`), i.e. the covariant Higgs-gradient reconstruction.
   * `gauge_kinetic_orthonormal_collapse` — for an orthonormal gauge frame the
     reconstruction reduces to the multiplet sum of scalar reconstructions
     `∑_i B(H_i, H'_i)`, one scalar kinetic term per internal component.
   * `gauge_euclidean_collapse_guardrail` — the guardrail (see below).

   The full gauge theorem (task item 4's "if too much, fall back") was *not* too
   much: the covariant version is proven in full. The only abstraction used is the
   bilinear-form inner product `q`; promoting `q` to a genuine `InnerProductSpace`
   instance is a downstream convenience and would not change the algebra.

## Semantic-alignment note: why this is not "graph Higgs theory with null labels"

The worry the Working Plan (§17.4 guardrail, §25.2) raises is that a null-edge
Higgs action could be *nothing but* an ordinary graph/lattice discretization with
decorative "null" labels on the edges — i.e. the naive positive edge sum
`∑_a |∇_a^A H|^2`. The D17 theorems pin down exactly when that collapse happens
and certify that it does **not** happen for a genuine Lorentzian frame:

* The reconstruction `gauge_higgs_kinetic_reconstruction` produces the full
  bilinear form `∑_{a,b} G^{ab} ⟪∇_a H, ∇_b H⟫`, with `G^{ab}` the inverse-Gram
  weights certified (in the scalar file) to be the literal matrix inverse of the
  null-edge Gram matrix `g_{ab} = g(ℓ_a, ℓ_b)`. The off-diagonal `a ≠ b` cross
  terms carry the Lorentzian signature.

* `gauge_euclidean_collapse_guardrail` proves that the naive positive edge sum
  `∑_a ⟪∇_a H, ∇_a H⟫` is recovered *exactly and only* in the doubly-diagonal
  special case: `G^{ab} = δ^{ab}` **and** an orthonormal gauge frame
  `q(e_i,e_j) = δ_{ij}`. A genuine Lorentzian inverse-Gram matrix is not the
  identity, so its off-diagonal weights survive and the kinetic term is strictly
  richer than any positive edge sum.

* `gauge_kinetic_orthonormal_collapse` isolates the two collapses: the gauge
  index sums diagonally for an orthonormal multiplet, but the spacetime/null
  structure still lives entirely in `B = g^{-1}` and its off-diagonal weights.

So the null substrate does irreducible mathematical work for the gauge/Higgs
kinetics: the Lorentzian inverse-Gram cross terms are what distinguish the
null-edge reconstruction from a Euclidean graph-Higgs sum. This is the bridge
that keeps the Higgs/W/Z story from being merely ordinary graph Higgs theory with
null labels.

## Conventions / hidden-assumption report

* Dual-soldered convention (`docs/NULLSTRAND.md`): the symbol/contraction is
  carried by the dual covectors `α^a = ell.dualBasis a`, never by the diagonal
  flats `ℓ_a^♭`. The reconstruction uses `α^a` and the inverse-Gram weights.
* Nondegeneracy of `g` is encoded as the existence of a raising map
  `sharp : Dual ℝ V →ₗ[ℝ] V` with `g (sharp ξ) v = ξ v`; the inverse metric is
  `g^{-1} = LinearMap.compl₁₂ g sharp sharp`. This is data the caller supplies,
  not an axiom.
* The gauge inner product is an abstract bilinear form `q`; no positivity is
  assumed, so the results hold for indefinite gauge pairings as well.
* No classical-choice-beyond-Mathlib assumptions: all six theorems depend only on
  `propext`, `Classical.choice`, `Quot.sound`.
* This is finite algebra and symbol reconstruction; the smooth continuum limit is
  explicitly out of scope (consistent with the §17.4 staging).
