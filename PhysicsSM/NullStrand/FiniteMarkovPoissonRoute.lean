/-
# Finite Markov SLLN route and stopped-node Bessel proxy (Aristotle Wave 8, Job F)

This file is **self-contained** and imports **only** `Mathlib`.  It develops the
*finite/discrete shadow* of two probabilistic facts that the continuous-time
literature establishes for Bell-type QFT and Bohmian node avoidance:

* the Poisson-equation + martingale-CLT route to a strong law of large numbers
  for additive functionals of a Markov chain (Glynn–Meyn / Meyn–Tweedie);
* node inaccessibility for `|Ψ|²`-distributed processes, governed by an effective
  Bessel dimension (Berndl–Dürr–Goldstein–Peruzzi–Zanghì,
  arXiv:quant-ph/9503013; existence/non-explosion: Georgii–Tumulka,
  arXiv:math/0312294).

Everything proved here is exact finite/real-analysis.  The genuinely
continuous-time statements (continuous-time generator Dynkin martingale, SDE
node inaccessibility) are **not** faked: they are recorded as precise charter
notes explaining the statement and the missing Mathlib API.

## Main results

* `finiteMarkov_poissonEquation_telescope_discrete` — exact telescoping of the
  centered additive functional into a boundary term plus a martingale-difference
  sum.
* `finiteMarkov_additive_average_telescope_bound` — the bounded-endpoint form
  bounding the empirical average by `2B/n` plus the normalized martingale term.
* `finiteCTMC_poissonEquation_charter` — honest handoff note for the
  continuous-time generator version.
* `besselDimension_nodeThreshold_integralProxy` — the radial integral criterion
  `r ↦ r^{1-δ}` is non-integrable near `0` iff `δ ≥ 2`, for the effective Bessel
  dimension `δ = d_perp + α`.
* `nodeInaccessibility_besselCriterion_charter` — honest handoff note for the
  full SDE node-inaccessibility statement.
-/
import Mathlib

open MeasureTheory Set Finset

namespace PhysicsSM.NullStrand.FiniteMarkovPoissonRoute

/-! ## Discrete-time finite Markov Poisson route -/

/--
**Discrete Poisson-equation telescoping identity.**

Let `P` be a finite stochastic matrix on a finite state space `State`, with
invariant law `π`.  Let `f` be a (bounded) observable, `c := π • f = ∑ₓ πₓ fₓ`
its stationary mean, and let `g` solve the *Poisson equation* on the zero-mean
subspace,
`(I − P) g = f − (π • f) • 1`, i.e. pointwise `f x − c = g x − (P g) x`,
where `(P g) x = ∑_y P x y · g y` is `Matrix.mulVec`.

Then, along any trajectory `X : ℕ → State`, the centered additive functional
telescopes:
`∑_{k<n} (f(Xₖ) − c) = (g(X₀) − g(Xₙ)) + ∑_{k<n} (g(X_{k+1}) − (P g)(Xₖ))`.

The first summand is a bounded boundary (endpoint) term; the second is the
sum `Mₙ` of the increments `Dₖ = g(X_{k+1}) − (P g)(Xₖ)`, which — under the
Markov property with one-step kernel `P` and `(P g)(x) = 𝔼[g(X_{k+1}) | Xₖ = x]` —
is a **martingale-difference sum** w.r.t. the natural filtration (each `Dₖ` has
zero conditional mean).  The telescoping identity itself is purely algebraic and
needs only the pointwise Poisson equation; the `stochastic`/`invariant`
hypotheses are recorded because they are what give the increments their
martingale-difference meaning and make `c` the stationary mean `π • f`.
-/
theorem finiteMarkov_poissonEquation_telescope_discrete
    {State : Type*} [Fintype State]
    (P : Matrix State State ℝ) (π f g : State → ℝ) (c : ℝ)
    (_hstoch : ∀ x, ∑ y, P x y = 1)
    (_hinv : ∀ y, ∑ x, π x * P x y = π y)
    (_hc : c = ∑ x, π x * f x)
    (hpoisson : ∀ x, f x - c = g x - (P.mulVec g) x)
    (X : ℕ → State) (n : ℕ) :
    ∑ k ∈ Finset.range n, (f (X k) - c)
      = (g (X 0) - g (X n))
        + ∑ k ∈ Finset.range n, (g (X (k + 1)) - (P.mulVec g) (X k)) := by
  have hstep : ∀ k,
      f (X k) - c
        = (g (X k) - g (X (k + 1))) + (g (X (k + 1)) - (P.mulVec g) (X k)) := by
    intro k
    rw [hpoisson (X k)]; ring
  calc
    ∑ k ∈ Finset.range n, (f (X k) - c)
        = ∑ k ∈ Finset.range n,
            ((g (X k) - g (X (k + 1))) + (g (X (k + 1)) - (P.mulVec g) (X k))) :=
          Finset.sum_congr rfl (fun k _ => hstep k)
    _ = (∑ k ∈ Finset.range n, (g (X k) - g (X (k + 1))))
          + ∑ k ∈ Finset.range n, (g (X (k + 1)) - (P.mulVec g) (X k)) :=
          Finset.sum_add_distrib
    _ = (g (X 0) - g (X n))
          + ∑ k ∈ Finset.range n, (g (X (k + 1)) - (P.mulVec g) (X k)) := by
          rw [Finset.sum_range_sub' (fun k => g (X k)) n]

/--
**Bounded-endpoint form of the telescoping identity (algebraic SLLN bound).**

Under the hypotheses of `finiteMarkov_poissonEquation_telescope_discrete`, if the
Poisson solution `g` is bounded by `B` (`|g x| ≤ B` for all `x`), then for every
`n ≥ 1` the empirical average of the centered observable is controlled by a
boundary term of order `1/n` plus the normalized martingale term:
`| (1/n) ∑_{k<n} (f(Xₖ) − c) | ≤ 2B/n + |Mₙ|/n`,
where `Mₙ = ∑_{k<n} (g(X_{k+1}) − (P g)(Xₖ))`.

This is the exact algebraic identity behind the SLLN: the boundary term vanishes
as `n → ∞`, and a martingale strong law applied to `Mₙ/n` (a.s. `→ 0` under the
usual variance growth conditions) yields `(1/n) ∑ (f(Xₖ) − c) → 0` a.s.  The a.s.
limit is left to the continuous-time/probabilistic charter below; the bound
itself is established here for arbitrary trajectories.
-/
theorem finiteMarkov_additive_average_telescope_bound
    {State : Type*} [Fintype State]
    (P : Matrix State State ℝ) (π f g : State → ℝ) (c B : ℝ)
    (hstoch : ∀ x, ∑ y, P x y = 1)
    (hinv : ∀ y, ∑ x, π x * P x y = π y)
    (hc : c = ∑ x, π x * f x)
    (hpoisson : ∀ x, f x - c = g x - (P.mulVec g) x)
    (hg : ∀ x, |g x| ≤ B)
    (X : ℕ → State) (n : ℕ) (hn : 0 < n) :
    |(∑ k ∈ Finset.range n, (f (X k) - c)) / (n : ℝ)|
      ≤ 2 * B / (n : ℝ)
        + |∑ k ∈ Finset.range n, (g (X (k + 1)) - (P.mulVec g) (X k))| / (n : ℝ) := by
  have hnpos : (0 : ℝ) < (n : ℝ) := by exact_mod_cast hn
  set M := ∑ k ∈ Finset.range n, (g (X (k + 1)) - (P.mulVec g) (X k)) with hM
  have hid :
      ∑ k ∈ Finset.range n, (f (X k) - c) = (g (X 0) - g (X n)) + M :=
    finiteMarkov_poissonEquation_telescope_discrete P π f g c hstoch hinv hc
      hpoisson X n
  have hbnd : |g (X 0) - g (X n)| ≤ 2 * B := by
    have h0 := abs_le.mp (hg (X 0))
    have hn' := abs_le.mp (hg (X n))
    rw [abs_le]; constructor <;> linarith
  have htri : |(g (X 0) - g (X n)) + M| ≤ 2 * B + |M| :=
    (abs_add_le _ _).trans (add_le_add hbnd le_rfl)
  calc
    |(∑ k ∈ Finset.range n, (f (X k) - c)) / (n : ℝ)|
        = |(g (X 0) - g (X n)) + M| / (n : ℝ) := by
          rw [hid, abs_div, abs_of_pos hnpos]
    _ ≤ (2 * B + |M|) / (n : ℝ) := by gcongr
    _ = 2 * B / (n : ℝ) + |M| / (n : ℝ) := by rw [add_div]

/--
**Charter (handoff note): continuous-time finite Markov Poisson equation.**

This is an honest charter, **not** a theorem.  It records the continuous-time
generator analogue of `finiteMarkov_poissonEquation_telescope_discrete` and the
Mathlib API that is currently missing to state and prove it rigorously.

Statement to be formalized.  Let `X` be a continuous-time Markov chain on a
finite state space with infinitesimal generator (rate matrix) `Q` (row sums `0`),
stationary law `π` (`π Q = 0`), bounded observable `f`, and stationary mean
`c = π • f`.  Let `g` solve the generator Poisson equation
  `-Q g = f - c • 1`   (pointwise: `-(Q g)(x) = f x - c`).
Then the **Dynkin martingale**
  `M_t = g(X_t) - g(X_0) - ∫₀ᵗ (Q g)(X_s) ds`
is a martingale, and on the Poisson solution this rewrites as
  `∫₀ᵗ (f(X_s) - c) ds = g(X_0) - g(X_t) + M_t`,
the exact continuous-time telescoping, whence
  `(1/t) ∫₀ᵗ (f(X_s) - c) ds → 0`  a.s.  (ergodic / SLLN limit).

Missing Mathlib API (as of this toolchain).  Mathlib has discrete-time martingales
and an optional-sampling / a.s.-convergence theory, but it lacks:
(1) a continuous-time finite-state Markov process with its generator `Q` and the
    transition semigroup `exp(tQ)`;
(2) Dynkin's formula / the carré-du-champ martingale `M_t` as above with a proof
    that it is an `L²` martingale;
(3) a continuous-time martingale SLLN (`M_t / t → 0` a.s.).
The discrete-time shadow above (`finiteMarkov_*_telescope_*`) is the faithful,
fully-proved finite analogue; the continuous-time version is deferred until the
generator/semigroup and continuous-time martingale convergence API exist.
-/
def finiteCTMC_poissonEquation_charter : String :=
  "Continuous-time finite Markov Poisson charter. Setup: CTMC with generator Q " ++
  "(row sums 0), stationary π (πQ=0), bounded f, c=π•f, Poisson solution g with " ++
  "-Q g = f - c•1. Dynkin martingale M_t = g(X_t) - g(X_0) - ∫₀ᵗ (Qg)(X_s) ds, " ++
  "giving ∫₀ᵗ (f(X_s)-c) ds = g(X_0) - g(X_t) + M_t and (1/t)∫₀ᵗ(f-c) → 0 a.s. " ++
  "Missing Mathlib API: (1) continuous-time finite-state Markov process + " ++
  "generator/semigroup exp(tQ); (2) Dynkin's formula and the L² Dynkin " ++
  "martingale; (3) continuous-time martingale SLLN (M_t/t → 0 a.s.). The " ++
  "discrete-time telescoping in this file is the faithful proved shadow."

/-! ## Stopped-node Bessel proxy (real-analysis criterion) -/

/--
**Effective Bessel dimension node-threshold integral proxy.**

Near a node, a radial weight `ρ ~ r^α` together with a perpendicular dimension
`d_perp` produces an *effective Bessel dimension* `δ = d_perp + α`.  Whether the
node (the origin `r = 0`) is accessible is governed by the radial integral
`∫₀ r^{1-δ} dr` (the scale-function/speed-measure integrand from the Feller
boundary classification of a Bessel-type process of dimension `δ`).

This proxy theorem proves the exact criterion: the integrand `r ↦ r^{1-δ}` is
**non-integrable** on a punctured neighbourhood `(0, ε)` of the node iff
`δ ≥ 2`.  Divergence of `∫₀ r^{1-δ} dr` is precisely the analytic signature of an
*inaccessible* (entrance, non-reachable) boundary, so the node is inaccessible
exactly when `δ ≥ 2` — recovering the classical Bessel transience/dimension
threshold.

(The full statement that an actual diffusion a.s. never reaches the node is the
SDE statement recorded in `nodeInaccessibility_besselCriterion_charter`; the
integral criterion here is the rigorous real-analysis proxy.)
-/
theorem besselDimension_nodeThreshold_integralProxy
    (d_perp : ℕ) (α ε : ℝ) (hε : 0 < ε) (δ : ℝ) (hδ : δ = (d_perp : ℝ) + α) :
    ¬ IntegrableOn (fun r : ℝ => r ^ (1 - δ)) (Ioo 0 ε) ↔ 2 ≤ δ := by
  subst hδ
  rw [intervalIntegral.integrableOn_Ioo_rpow_iff hε]
  constructor
  · intro h
    by_contra hc
    push_neg at hc
    exact h (by linarith)
  · intro h hlt
    linarith

/--
**Charter (handoff note): SDE node-inaccessibility statement.**

This is an honest charter, **not** a theorem.  It records the full
stochastic-differential-equation node-inaccessibility statement whose
real-analysis proxy is `besselDimension_nodeThreshold_integralProxy`, and the
Mathlib API currently missing to prove it.

Statement to be formalized.  Let `R_t = ‖X_t - x_node‖` be the radial distance of
a `|Ψ|²`-equivariant diffusion `X_t` from a node `x_node` where the guiding wave
function vanishes to leading radial order `r^α` with perpendicular dimension
`d_perp`, so that `R_t` is (to leading order) a Bessel-type process of effective
dimension `δ = d_perp + α`:
  `dR_t = ((δ - 1)/(2 R_t)) dt + dB_t`.
Then for `δ ≥ 2` the origin is **inaccessible**: starting from `R_0 > 0`,
`ℙ[∃ t ≥ 0, R_t = 0] = 0` (the process a.s. never hits the node), and the
diffusion does not explode (Georgii–Tumulka existence/non-explosion).  This is the
node-avoidance / equivariance result of Berndl–Dürr–Goldstein–Peruzzi–Zanghì.

Missing Mathlib API (as of this toolchain).  Mathlib lacks:
(1) existence/uniqueness of strong solutions of (one-dimensional) SDEs with the
    singular drift `(δ-1)/(2r)` and Bessel processes themselves;
(2) Feller boundary classification linking the divergence of `∫₀ r^{1-δ} dr`
    (proved here) to a.s. non-attainment of the boundary;
(3) hitting-time / first-passage theory for diffusions.
The integral criterion `besselDimension_nodeThreshold_integralProxy` is the
faithful, fully-proved real-analysis proxy: non-integrability of `r^{1-δ}` near
`0` (equivalently `δ ≥ 2`) is exactly the Feller test that classifies the node as
an inaccessible boundary.
-/
def nodeInaccessibility_besselCriterion_charter : String :=
  "SDE node-inaccessibility charter. Setup: radial process R_t = ‖X_t - x_node‖ " ++
  "of a |Ψ|²-equivariant diffusion near a node with weight r^α and perpendicular " ++
  "dimension d_perp, so R_t is Bessel-type of dimension δ = d_perp + α, " ++
  "dR_t = ((δ-1)/(2 R_t)) dt + dB_t. Claim: for δ ≥ 2 the origin is inaccessible, " ++
  "ℙ[∃ t, R_t = 0] = 0, and no explosion (Georgii–Tumulka; Berndl–Dürr–Goldstein–" ++
  "Peruzzi–Zanghì). Missing Mathlib API: (1) SDE strong solutions with singular " ++
  "drift (δ-1)/(2r) / Bessel processes; (2) Feller boundary classification tying " ++
  "divergence of ∫₀ r^{1-δ} dr to a.s. boundary non-attainment; (3) hitting-time " ++
  "theory. The integral proxy in this file is the faithful proved real-analysis " ++
  "criterion."

end PhysicsSM.NullStrand.FiniteMarkovPoissonRoute
