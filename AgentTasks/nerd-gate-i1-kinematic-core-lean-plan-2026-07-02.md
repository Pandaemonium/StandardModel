# Gate I1 kinematic core: Lean formalization plan

Date: 2026-07-02.
Track: night/slack (zero interference with the Gate C1 critical path).
Provenance: `Sources/NERD_2.md` sections 1 and 3, `Sources/NERD_3.md` A1-A2,
`Sources/NERD_4.md` sections 3-4 (build order adopted from the external
review's disposition ledger). Nothing below is Lean-checked yet.
Paper target: P2 ("Relativistic kinematics as quantum information on the
2x2 PSD cone, formally verified").

## Scope and conventions

Everything in this plan is finite-dimensional matrix algebra over `Complex`:
2x2 Hermitian matrices, 2xn spinor matrices, determinants, eigenvalues,
matrix exponentials. No operator theory, no modular theory beyond finite
dimensions, no lattice content.

Conventions (all consistent with the locked repo conventions):

- Mostly-minus signature `p^2 = (p^0)^2 - |p|^2` (locked in
  `docs/CONVENTIONS.md`).
- Soldering: `P = p^0 I + p . sigma` with the standard Pauli matrices;
  `det P = p^2`. Future-pointing means `p^0 >= |p|` (PSD).
- Spinor bracket: `<lambda mu> = eps_ab lambda^a mu^b` with `eps` the
  2x2 antisymmetric symbol; fix `eps_12 = +1` once and record it in the
  module docstring (sign flips propagate to nothing below, but the choice
  must be explicit).
- Language discipline: `det P` statements are frame-invariant; normalized
  `rho = P / tr P` statements are frame-dependent. Say "Plucker norm /
  unnormalized concurrence" for the invariant object; never claim frame
  invariance for `det rho`.

Proposed location: `PhysicsSM/Draft/NullEdge/GateI1/` (sibling of `GateC1`),
draft-trust until the full stack builds and is semantically reviewed.
Suggested modules:

```text
GateI1/Soldering.lean            I1.1-I1.4
GateI1/CauchyBinetMass.lean      I1.5-I1.6
GateI1/StiefelSplitting.lean     I1.7, U(2) factorization lemmas
GateI1/NormalizedDictionary.lean I1.8
GateI1/FirstOrderBridge.lean     I1.9
GateI1/BoostGibbs.lean           A1.1-A1.4
GateI1/MinkowskiDeterminant.lean A2
GateI1/DeterminantLineClock.lean I3.5
```

## Build order (adopted verbatim from the v2.1 disposition ledger)

Each item lists the target statement and its proof skeleton. Search Mathlib
and PhysLean before defining anything (lean-explore with
`packages=["Physlib"]` for PhysLean; `lean_loogle`/`lean_leansearch` for
Mathlib). PhysLean has Pauli-matrix and special-relativity material that may
already cover I1.1.

1. **I1.1 soldering determinant.**
   `det (p0 * 1 + px * sigma1 + py * sigma2 + pz * sigma3) = p0^2 - (px^2 + py^2 + pz^2)`.
   Direct `Matrix.det_fin_two` computation.

2. **I1.2 PSD characterization.**
   `P` PSD iff `p0 >= |p|`; eigenvalues are `p0 + |p|` and `p0 - |p|`.
   Hermitian 2x2 eigenvalue formula via trace/determinant.

3. **I1.3 rank dichotomy.** For `P` PSD nonzero:
   `rank P = 1 iff det P = 0` (future-null), `rank P = 2 iff det P > 0`
   (future-timelike).

4. **I1.4 rank-one factorization.** `P` PSD with `det P = 0`, `P != 0`,
   iff `P = lambda lambda^dagger` for some nonzero `lambda : Fin 2 -> C`
   (column spinor), unique up to phase.

5. **I1.5 Cauchy-Binet mass identity.** For `L : Matrix (Fin 2) (Fin n) C`:
   `det (L * L^dagger) = sum_{i < j} |bracket (col i) (col j)|^2`
   where `bracket lambda mu = lambda 0 * mu 1 - lambda 1 * mu 0`.
   Check whether Mathlib's `Matrix.det_mul` / Cauchy-Binet infrastructure
   covers the rectangular case; if not, the 2xn case is a finite sum over
   2-element subsets and can be proved directly.

6. **I1.6 kinematic cross-check (state it in the paper and in Lean).**
   Each column gives a future-null `p_i = lambda_i lambda_i^dagger`, and
   `|bracket lambda_i lambda_j|^2 = det (p_i + p_j) = 2 p_i . p_j`.
   So I1.5 is exactly `m^2 = (sum p_i)^2 = sum_{i<j} 2 p_i . p_j` with null
   diagonal terms vanishing. This paragraph inoculates against both "this is
   just (sum p)^2" and "this is numerology": it is both, exactly.

7. **I1.7 Stiefel splitting theorem.** For `P` positive definite 2x2 and
   `n >= 2`: `L L^dagger = P` iff `L = P^(1/2) V` with `V V^dagger = I_2`.
   The fiber is the Stiefel manifold `St_2(C^n)`; for `n = 2` it is `U(2)`.
   Proof: `V := P^(-1/2) L`. Needs the PSD square root for 2x2 positive
   definite matrices (Mathlib has `Matrix.PosSemidef.sqrt`).

8. **I1.8 normalized dictionary.** For `rho = P / tr P = (I + v . sigma)/2`:
   eigenvalues `(1 +- v)/2`; `det rho = m^2 / (4 E^2)`;
   `tr rho^2 = (1 + v^2)/2`; `2 (1 - tr rho^2) = m^2 / E^2`;
   concurrence of the canonical purification `= m / E`;
   `S(rho) = H_2((1+v)/2)` (binary entropy; if Shannon entropy of a
   two-point distribution is awkward in Mathlib, state the eigenvalue facts
   and define `H_2` locally).
   Frame bookkeeping lemma: the normalized state knows only `m/E`; the scale
   lives in unnormalized `P` (`m = E * C`).

9. **I1.9 first-order bridge.** In the chiral (2x2 block) representation:
   `P Pbar = det(P) I` where `Pbar = p0 I - p . sigma`, hence
   `(gamma . P)^2 = det(P) 1` on 4-component spinors. One line after the
   block algebra is set up; load-bearing for the narrative (it is why
   `det P = Phi^dagger Phi` is an on-shell constraint, not a tautology).

10. **A1 boost-Gibbs form.** For `E = m cosh eta`, `|p| = m sinh eta`:
    `P = m * exp (eta * (phat . sigma))` (needs `(phat . sigma)^2 = I` and
    the 2x2 exponential; Mathlib `Matrix.exp` or direct
    `cosh + sinh * (phat . sigma)` form).
    Corollaries: eigenvalue ratio `e^(2 eta)` (Doppler = detailed balance);
    `-log rho` proportional to the boost generator plus a constant
    (finite Bisognano-Wichmann shadow); entropy-velocity relation (item 8).

11. **A2 Minkowski determinant inequality.** For 2x2 PSD `A`, `B`:
    `sqrt (det (A + B)) >= sqrt (det A) + sqrt (det B)`,
    equality iff `B` is proportional to `A` (comoving momenta).
    Search Mathlib for an existing determinant superadditivity or
    Minkowski-inequality lemma before proving. Corollary: mass
    superadditivity `m(P1 + P2) >= m1 + m2` for future-causal momenta;
    language: "kinematic superadditivity gap", not "binding energy".

12. **I3.5 determinant-line clock.** If `L(tau) = exp(-i m tau) L(0)` (any
    linear construction of the split from a rest-frame plane wave), then
    `L(tau) L(tau)^dagger = L(0) L(0)^dagger` (the momentum sees nothing)
    while `det L(tau) = exp(-2 i m tau) det L(0)`: the clock fiber rotates
    at zitterbewegung frequency `2m`.

13. **U(2) = spin x clock factorization.** Three finite lemmas:
    `U(2) / SU(2)` is isomorphic to `U(1)` (via `det`); the surjection
    `SU(2) x U(1) -> U(2)` has kernel `{(I,1), (-I,-1)}` (`Z_2`); and on
    the minimal-split fiber the `SU(2)` factor is the little group (spin
    frame) while the residual `U(1)` is the determinant line (item 12).
    Mathlib group-theory infrastructure for unitary groups
    (`Matrix.unitaryGroup`, `Matrix.specialUnitaryGroup`) should carry this.

## What is deliberately NOT in scope

- No thermal-time claims: the statement "the modular flow of the momentum
  state is the physical clock" is false at rest and withdrawn (v2.1). I3.5
  is the theorem; "proper time = det-line holonomy / 2m" is a labeled
  postulate that belongs in prose, not in Lean.
- No Gate I2 modular theory (finite Tomita) in this package; it is a
  separate small gate after I1 lands.
- No lattice, overlap, or C1 content. This stack must not import GateC1
  modules and must not touch the C1 critical path.

## Execution notes

- Aristotle packaging: focused standalone Mathlib-only packages (do NOT
  submit full-repo; the project build spends the budget before proof
  search). Suggested clusters: (I1.1-I1.6), (I1.7 + factorization),
  (I1.8 + A1), (A2), (I1.9 + I3.5). Generate a context pack with
  `Scripts/aristotle/make_context_pack.py` for each nontrivial submission.
- Semantic review: after integration, run the standard semantic audit
  (`Scripts/autonomous_loop/send_claude_review.py` with `--source-file` for
  every declaration under review). The known semantic risks here are: sign
  of `eps`; "future-pointing" hypotheses silently dropped; normalized vs
  unnormalized determinant confusion; and eigenvalue-order ambiguity in
  I1.2/I1.8.
- Check Lean-QuantumInfo and PhysLean for existing entropy/fidelity/DPI
  layers before defining anything information-theoretic (also feeds Q1).
- Definition of done: all modules build under the pinned toolchain with no
  placeholder tokens, axiom audit clean, semantic review passed, and a
  mapping table from Lean names to the P2 paper's numbered claims recorded
  in this file.
