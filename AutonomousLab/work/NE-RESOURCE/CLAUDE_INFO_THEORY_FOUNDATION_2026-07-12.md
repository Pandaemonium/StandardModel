# Finite information-theory foundation for the null-edge resource program

- Author: interactive Claude / research scientist (AFPL run 2026-07-12).
- Status: consolidation map (LEARN step). Every theorem below is kernel-clean
  (`[propext, Classical.choice, Quot.sound]`, no `native_decide`), guard-pinned in
  its module, and independently re-verified in-repo. Draft-trust, not manuscript
  promotion.
- Purpose: the throughput push landed a scattered set of lemmas that in fact form
  ONE coherent object — a finite (classical + matrix) information-theory
  foundation for the mass-as-resource / gravity-DPI program. This maps them, states
  what they jointly enable, and states honestly what they do NOT.

## The landed foundation (this session)

| Result | Module | Content | Aristotle job |
|---|---|---|---|
| `relEntropy_dpi` | `ClassicalDataProcessing` (Codex) | DPI: stochastic maps do not increase relative entropy | 74503dba |
| `relEntropy_nonneg`, `relEntropy_eq_zero_iff` | `FiniteGibbsInequality` (Codex) | Gibbs: relative entropy `>= 0`, `= 0 iff p=q` | 6bb9f7bb |
| `shannon_ssa` | `ClassicalStrongSubadditivity` | Strong subadditivity `H(XZ)+H(YZ) >= H(XYZ)+H(Z)` | f52514f3 |
| `ssa_eq_of_condIndep`, `ssa_strict_witness` | `ClassicalStrongSubadditivityControls` | SSA is tight at conditional independence (one direction) and strict on a correlated witness | 92ee3e9e |
| `pinsker` | `PinskerInequality` | `(1/2) TV^2 <= relEntropy` (metric control) | 9cc68db9 |
| `entropy_le_log_card`, `entropy_eq_log_card_iff` | `FiniteUniformMaxEntropy` (Codex) | `H(p) <= log d`, `=` iff uniform (max-entropy) | 273a28be |
| `vonNeumann_le_log_card` | `VonNeumannEntropyBound` (Codex) | matrix lift: `S(rho) <= log d` for a density matrix | 8300c085 |
| `purity_le_one`, `inv_card_le_purity` | `PurityBounds` | `1/d <= Tr(rho^2) <= 1` | d8ca01fc |
| `trace_mul_nonneg` | `PSDTraceProductNonneg` | `0 <= re Tr(A B)` for PSD `A,B` | 5edc72d8 |
| `hs_cauchy_schwarz` | `HilbertSchmidtCauchySchwarz` | `‖Tr(Aᴴ B)‖^2 <= reTr(AᴴA) reTr(BᴴB)` | 5c6b4653 |
| `collision_le_shannon` | (in flight) | `H_2(p) = -log(sum p_i^2) <= H(p)` (Renyi hierarchy) | 7ea3de59 |

## The coherent structure

The results are not independent lemmas; they are the standard scaffolding of a
finite resource theory, now kernel-checked in this repo's idiom:

1. **Two resource measures with matching bounds.** Shannon/von Neumann entropy
   has the ceiling `<= log d` (uniform/maximally-mixed maximizer); purity has the
   dual window `1/d <= Tr(rho^2) <= 1` (pure vs maximally-mixed). The in-flight
   `collision_le_shannon` links them: `sum p_i^2` IS the classical purity, so
   `H(p) >= -log(purity)` places the two measures in one Renyi hierarchy.
2. **Monotone under coarse-graining (the DPI backbone).** `relEntropy_dpi` is the
   exact finite content of "information can only be lost under a stochastic map"
   — the Q1 "gravity is data-processing" gate. Gibbs nonnegativity is its
   endpoint; Pinsker turns the entropy gap into an L1/total-variation *distance*
   gap (metric control, needed to convert entropy statements to distinguishability).
3. **Composite/holographic direction.** `shannon_ssa` (I(X:Y|Z) >= 0) is the deep
   entropy inequality behind holographic/area bounds; its anti-vacuity controls
   confirm it is tight at conditional independence and strict on a correlated
   witness (so it is a substantive inequality, not a triviality).
4. **Matrix-algebra base.** `trace_mul_nonneg` and `hs_cauchy_schwarz` are the
   positivity/inner-product primitives every quantum-info bound rests on
   (expectation-value positivity, overlap bounds, Cauchy-Binet).

## What this jointly enables (program-facing, as consistency scaffolding)

- The **Q1 gravity-DPI gate** at the finite classical level: relative-entropy
  monotonicity under coarse-graining is now kernel-checked.
- The **mass-as-resource** bookkeeping: entropy ceiling + purity window +
  collision link give a kernel-checked resource-measure hierarchy for the finite
  states the null-edge mass program uses.
- **Metric control** (Pinsker) to turn resource/entropy gaps into distances.
- Consumed by the existing `LeanQuantumDPIMass` line (which is already sorry-free).

## Honest scope (what is NOT proved)

- These are **finite** classical and finite-dimensional matrix statements. No
  continuum limit, no infinite-dimensional von Neumann algebra, no field theory.
- `vonNeumann_le_log_card` and `purity` are stated via the **eigenvalue vector**
  (CFC-free); the full matrix functional-calculus versions (matrix `log`, the
  quantum relative-entropy Klein inequality, Lieb's matrix SSA) are NOT here —
  they hit the `NormedRing (Matrix n n C)` / `CFC.log` instance friction and
  remain open (the standing queue's "quantum Klein" PREP item).
- `ssa_eq_of_condIndep` is **one-directional** (conditional independence =>
  equality); no converse characterization of the equality case is claimed.
- Nothing here derives a physical Hamiltonian, a gravitational field equation, or
  a Lorentz-invariant continuum theory. The program's "gravity is data-processing"
  reading remains a labeled interpretation on top of this finite scaffolding, not
  a theorem about gravity.

## Next targets (foundation -> program)

1. The **quantum Klein inequality** (matrix relative-entropy nonnegativity via
   `CFC.log`) — the true quantum lift of Gibbs; blocked on matrix-`log` instance
   plumbing (candidate: commuting-density reduction to the scalar Gibbs already
   landed).
2. **Golden-Thompson** (in flight, 793715f6) and matrix SSA (Lieb) for the thermal
   / free-energy layer.
3. The **YM Kotecky-Preiss crux** (in flight, 3cec307a) — the one genuine
   hard-analytic gap, orthogonal to this info-theory line but the other flagship.
4. Wiring the resource hierarchy into the manuscript's mass-as-resource claims
   with explicit claim-calculus labels (`T`/`M` for the finite theorems, `C` for
   the gravity-DPI conjecture with its gate/kill-condition).
