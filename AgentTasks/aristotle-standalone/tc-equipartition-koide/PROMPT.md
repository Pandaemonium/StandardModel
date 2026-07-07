# PROOF JOB: the equipartition sum rule (trace algebra; self-contained)

Lean 4 + Mathlib. One theorem family, pure finite linear algebra over C, no
analysis, no spectral theory in the core statements. No sorry, no new axioms,
no native_decide; axiom footprint within [propext, Classical.choice,
Quot.sound]. Namespace `PhysicsSM.Draft.NullEdge.Carrier.Equipartition`;
`import Mathlib` only. Docstrings on all public declarations. Deliverable:
one file `EquipartitionSumRule.lean`.

## Targets (in order; the file is complete when 1-3 compile, 4-5 are bonus)

Setting: `V : Type*` = `Fin n` with `n > 0`; matrices `Matrix (Fin n) (Fin n) C`.
Let `M = d • (1 : Matrix ...) + H` with `d : R` (real, embedded in C), `H`
Hermitian (`H.IsHermitian`) with ZERO DIAGONAL (`∀ i, H i i = 0`).

1. **`trace_sq_eq` (the core identity).** If
   `(n : R) * d^2 = (Matrix.trace (H * H)).re` (equivalently the squared
   Frobenius norm of H, which for Hermitian H is real - prove that as a
   lemma: `(trace (H*H)).im = 0` and `(trace (H*H)).re = Σ_{i,j} ‖H i j‖^2`),
   then
   `Matrix.trace (M * M) = (2 / (n : C)) * (Matrix.trace M)^2`.
   Proof route: `trace M = n * d`; `trace (M*M) = n * d^2 + trace (H*H)`
   (the cross terms vanish because H has zero diagonal); substitute.
2. **`sum_rule` (the Koide-shape corollary, spectral form).** With
   `hM : M.IsHermitian`, eigenvalues `λ k := hM.eigenvalues k` (real), and
   the hypothesis of target 1: `Σ_k (λ k)^2 = (2 / n) * (Σ_k λ k)^2`.
   (Bridge: `trace M = Σ eigenvalues`, `trace (M*M) = Σ eigenvalues^2` for
   Hermitian M - use Mathlib's `Matrix.IsHermitian.trace_eq_sum_eigenvalues`
   and the spectral theorem API; if the squared version is missing, prove it
   via `M = U D U*`.)
3. **`koide_reading` (conditional interpretation form).** If additionally all
   eigenvalues are positive, then with `m k := (λ k)^2`:
   `(Σ_k m k) / (Σ_k Real.sqrt (m k))^2 = 2 / n`
   (using `Real.sqrt ((λ k)^2) = λ k` for positive λ).
4. **`pointwise_soldering` (companion).** If `d` is replaced by a vertex
   function `dv : Fin n → R` (M = diagonal dv + H) with
   `∀ i, (dv i)^2 = Σ_j ‖H i j‖^2` (pointwise soldering), then
   `Σ_i (dv i)^2 = (trace (H*H)).re` automatically, and
   `trace (M*M) = 2 * Σ_i (dv i)^2` with
   `(Σ m)/(Σ sqrt m)^2 ≥ 2/n` and equality iff dv is constant
   (finite Cauchy-Schwarz: `Matrix.trace M = Σ dv`, then
   `(Σ dv)^2 ≤ n * Σ dv^2`).
5. **`triangle_instance`.** The n = 3 instance of target 3 stated explicitly
   (the physics-facing form; docstring may note it is the Koide combination
   Q = 2/3, with the physics reading kept entirely in prose).

## Provenance note for docstrings

Clean-room formalization of a finite trace identity (elementary); the physics
reading (Koide's charged-lepton relation as 45-degree equipartition between a
uniform diagonal "turn" channel and an off-diagonal "hop" channel) must stay
in the module docstring as prose, never in a theorem name or statement. Cite:
Y. Koide, Phys. Rev. D 28 (1983) 252 and R. Foot, hep-ph/9402242 as the
empirical/geometric background.
