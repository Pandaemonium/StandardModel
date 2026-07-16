# Information-theory / quantum-entropy spine index (as of 2026-07-12)

Navigation reference for the finite information-theory results landed in the
AFPL run. Every row is a kernel-checked declaration (axioms
`[propext, Classical.choice, Quot.sound]` unless a grade note says otherwise).
Grades: **[T]** trusted-style kernel theorem in the draft lane; all rows here are
draft-trust with `#print axioms` guards. No physics claim; these are finite
mathematics infrastructure for the DYN-MODULAR modular-selection story and the
gravity-DPI line.

## Classical / distribution level

| Result | Declaration | File |
|---|---|---|
| Finite Gibbs inequality (`D >= 0`) + equality | `relEntropy_nonneg`, `relEntropy_eq_zero_iff` | `FiniteGibbsInequality.lean` |
| Log-sum inequality | `log_sum_inequality` | `LogSumInequality.lean` |
| Classical Shannon subadditivity | `shannon_subadditivity` | `ShannonSubadditivity.lean` |
| Classical strong subadditivity (+controls) | `ClassicalStrongSubadditivity*` | `ClassicalStrongSubadditivity.lean` |
| Classical data-processing inequality | `FiniteClassicalDPI` | `FiniteClassicalDPI.lean` |
| Pinsker inequality | `PinskerInequality` | `PinskerInequality.lean` |
| Collision (Renyi-2) `<=` Shannon | `collision_le_shannon` | `CollisionShannonEntropy.lean` |
| Max-entropy uniqueness (uniform) | `FiniteUniformMaxEntropy` | `FiniteUniformMaxEntropy.lean` |
| **Max-entropy / Gibbs variational principle** | `gibbs_maximizes_entropy` | `GibbsVariational.lean` (+ `GibbsVariationalControls`) |
| Gibbs free-energy variational lower bound | `gibbs_free_energy_lower` | `GibbsFreeEnergy.lean` |

## Operator / matrix level (CFC-free spectral)

| Result | Declaration | File |
|---|---|---|
| Von Neumann entropy `<= log d` | `VonNeumannEntropyBound` | `VonNeumannEntropyBound.lean` |
| Purity bounds `1/d <= Tr(rho^2) <= 1` | `PurityBounds` | `PurityBounds.lean` |
| Operator Renyi-2 bound `S(rho) >= -log Tr(rho^2)` | `vonNeumann_ge_neg_log_purity` | `VNEntropyPurity.lean` |
| Commuting quantum Klein `S(rho||sigma) >= 0` | `qKlein_nonneg` | `QuantumKleinShared.lean` |
| **General non-commuting quantum Klein** `S(rho||sigma) >= 0` | `qKlein_nonneg` | `GeneralQuantumKlein.lean` |
| CFC-free spectral matrix log | `logHermitian` | `GeneralQuantumKlein.lean` |
| Entropy trace identity `Tr(rho log rho) = sum lam log lam` | `entropy_trace_eq_sum` | `GeneralQuantumKlein.lean` |
| Doubly-stochastic scalar Klein core | `scalar_klein`, `cross_trace_eq_sum` | `GeneralQuantumKlein.lean` |
| **General-N operator max-entropy bound** `S(rho) <= -Tr(rho log g)` | `vonNeumann_le_cross_entropy` | `GeneralMaxEntropy.lean` |
| Klein equality, forward half `qRelEntropy rho rho = 0` | `qRelEntropy_self_eq_zero` | `GeneralMaxEntropy.lean` |

## DYN-MODULAR max-entropy program (three levels)

- **Distribution:** `GibbsVariational.gibbs_maximizes_entropy` (general finite `N`,
  non-hollow via `GibbsVariationalControls`).
- **Qubit operator (INTEGRATED, codex-accepted):**
  `DYNModularMaxEntCapstone.dyn_modular_operator_S2_capstone` (5 conjuncts:
  entropy bound + uniqueness + `= gibbsState(Bz 1)` + `= exp(-modHam)` + the
  actual `modFlow` equality). Scope: `Fin 2`, Bloch-parameterized.
- **General-N operator:** `GeneralMaxEntropy.vonNeumann_le_cross_entropy`
  (bound form; from the general Klein). Removes the `Fin 2` restriction.

## Bridges (qubit operator-S2)

- Entropy: `QubitEntropyBridge.pairEntropy_eq_vonNeumannEntropy` (+ canonical
  corollary `..._canonical`).
- Gibbs: `QubitGibbsBridge.pairBloch_zero_eq_gibbsState` (via
  `ThermalBzEuler.gibbs_bz_closed_form` + `Real.tanh_artanh`).

## Open successors (not yet landed)

1. **General Klein equality case** `qRelEntropy = 0 <-> rho = sigma` -> full
   general-N max-entropy UNIQUENESS. Forward half landed
   (`qRelEntropy_self_eq_zero`); backward needs the equality case of
   `ConcaveOn.le_map_sum` (strict Jensen) + a Birkhoff-type doubly-stochastic
   rigidity argument. Prepared standalone `GeneralKleinEquality` (typechecks,
   submission held for codex fleet coordination).
2. **General-N max-entropy at fixed energy** `S(rho) <= S(gibbs)` with the
   `g = exp(-beta H)/Z` energy identification (needs `logHermitian(g) = -beta H -
   log Z` co-diagonal plumbing).
3. **Universal-rho qubit wrapper** (arbitrary Hermitian PSD trace-one qubit,
   via `pairBloch_surjective`) -- codex `dyn-universal-rho` in flight.
4. **Mathlib upstream** of `logHermitian` / `entropy_trace_eq_sum` /
   `qKlein_nonneg` -- Director decision DQ-008.

## Provenance

Index compiled by claude 2026-07-12 from the run ledger. Reference only; changes
no grade and introduces no claim. All file paths are under
`PhysicsSM/Draft/NullEdge/`.
