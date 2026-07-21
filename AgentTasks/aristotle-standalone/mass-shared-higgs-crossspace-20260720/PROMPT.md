# Audit/no-go job: is the shared-Higgs composition possible without an arbitrary cross-space conversion map? (gate A1 falsifier)

Type: no-go / obstruction analysis (deliverable: a rigorous report plus any
self-contained Mathlib-only Lean lemma or counterexample). This is the
INDEPENDENT adversarial half of the AFPL shared-Higgs-data theorem (gate A1);
its purpose is to test the "one vacuum datum generates three mass sectors"
claim, NOT to build the constructive theorem. Assume the constructive claim may
be false.

## The exact repository split (verbatim)

The three mass sectors currently live on DIFFERENT carrier spaces:

- **Gauge-boson mass** (`GaugeMassGram`): vacuum `phi0 : EuclideanSpace ℂ (Fin 2)
  = single 0 1`; generators `generatorMatrix a : Matrix (Fin 2) (Fin 2) ℂ`;
  mass matrix `gaugeMassMatrix a b = ⟨T_a phi0, T_b phi0⟩` on `Fin 2`;
  `diagonal_zero_iff_stabilizer` gives the photon.
- **Higgs radial mass** (`HiggsDoubletRadialCurvature`): field
  `radialDoubletField v h : Fin 2 → ℂ`; `radialMassSquared lam v = 2 * lam * v^2`
  on the SAME `Fin 2` doublet space.
- **Fermion mass** (`YukawaTurnAmplitude`): turn `Y ⊗ₖ 1_spin` on
  `Fin n × Fin 4` (flavor ⊗ Dirac), with `Y : Matrix (Fin n) (Fin n) ℂ` a FREE
  matrix that does NOT reference `phi0` or `v` at all.

## The obstruction question

The gauge and radial sectors share the single vacuum datum `v` (both on `Fin 2`).
The fermion sector's mass `flavorMassTerm Y = Y ⊗ 1` is built from an
independently supplied `Y` on `Fin n × Fin 4`, with NO map to the `Fin 2`
vacuum. The A1 claim is "one supplied vacuum datum `H0` and one potential
generate fermion maps `M_f = Y_f H0`, gauge Gram, and radial Hessian in one
convention-locked model."

Determine precisely:

1. Can a single convention-locked structure carry `(v, {T_a}, lam, Y_f)` such
   that the fermion map `M_f = Y_f · H0` factors THROUGH the same `Fin 2` vacuum
   `H0` used by the gauge Gram and radial Hessian — WITHOUT introducing a free
   cross-space conversion map between `Fin 2` and `Fin n × Fin 4` beyond the
   declared free parameters `(Y_f, lam, couplings)`?
2. Or is such a cross-space conversion (an embedding/contraction
   `Fin 2 ↔ Fin n × Fin 4`) UNAVOIDABLE and itself a free choice — in which case
   the "one architecture" language is too loose and the missing
   convention/representation bridge is the real content?

The correct positive result exposes EVERY supplied quantity (`v`, `Y_f`, `lam`,
couplings) in the statement and proves the three sectors are coupled
consequences of the single vacuum `v`. The correct negative result is a no-go:
the fermion sector cannot be tied to the `Fin 2` vacuum without an independent
map, so `M_f = Y_f H0` uses `H0` only as a scalar `v` and `Y_f` remains fully
free (making "shared data" mean only "shares the scalar `v`", not the vacuum
VECTOR).

## Success criteria (any one)

- A clean shared-data structure + composition theorem in which the fermion map
  genuinely factors through the vacuum VECTOR, not merely its norm `v`.
- A no-go: prove the fermion map can depend on the vacuum only through the scalar
  `v = ‖H0‖`, so `Y_f` is an irreducible free parameter and the three sectors
  share only the scalar — a precise, honest weakening of the A1 claim.
- A concrete counterexample: two convention-locked models with identical
  `(v, {T_a}, lam)` but different fermion sectors, proving `Y_f` is not fixed by
  the shared vacuum.

Deliverable: the analysis with exact statements and any Mathlib-only Lean lemma.
Do NOT modify or assume access to the repository's private modules; work from
the definitions above. Report axioms for anything proved.
