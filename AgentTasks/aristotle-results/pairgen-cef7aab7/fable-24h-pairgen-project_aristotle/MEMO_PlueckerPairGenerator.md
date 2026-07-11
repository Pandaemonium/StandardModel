# Memo — The pair kick as the (phase-corrected) half-pulse of a Hermitian quartic generator

**Lane:** E, P3 item 1. **Target:** kernel-only Lean 4 (Lean 4.28.0, Mathlib v4.28.0),
standard three axioms only (`propext`, `Classical.choice`, `Quot.sound`), no `native_decide`,
no `sorry`/`admit`.

**Files**
- `context/PlueckerQuarticInteraction.lean` — the supplied context module, **imported and left
  unmodified**.
- `PhysicsSM/Draft/NullEdge/FiniteCARFockBasic.lean`, `PhysicsSM/Spinor/PluckerMass.lean` —
  the two upstream modules the context file imports. They were absent from the delivered project,
  so the context file did not build. They are reconstructed here (clean-room, occupation basis /
  Jordan–Wigner sign convention) exactly so the delivered context file compiles verbatim; every
  context theorem and every context `#guard_msgs` axiom guard passes unchanged.
- `context/PlueckerPairGenerator.lean` — the deliverable, namespace
  `PhysicsSM.Draft.NullEdge.PlueckerPairGenerator`.

## Result

Working on the finite four-mode Fock space `Fock (Fin 4) = Finset (Fin 4) → ℂ` with the module's
`pairForward`, `pairBackward`, `pairKick`, `fockInner`, `lowPair = {0,1}`, `highPair = {2,3}`:

- `Kop z ψ = z • pairForward ψ + conj z • pairBackward ψ` (definitionally the module's
  `quarticPairTransfer z`; on the pair sector its matrix is `[[0, z],[conj z, 0]]`).
- `Uop c s z m` = closed form of `exp(-i α Kop z)` at `cos = c`, `sin = s`, `|z| = m`.

| ID | Lean name | Statement (verified) |
|----|-----------|----------------------|
| T1 | `generator_hermitian` | `fockInner (Kop z ψ) φ = fockInner ψ (Kop z φ)` |
| T2 | `generator_cubed` | `Kop z (Kop z (Kop z ψ)) = (z * conj z) • Kop z ψ` (finite closure `K³ = |z|² K`) |
| T3 | `group_law` | `Uop c₁ s₁ z m (Uop c₂ s₂ z m ψ) = Uop (c₁c₂−s₁s₂) (s₁c₂+c₁s₂) z m ψ` (angle addition, pure algebra) |
| T4 | `unitary` | `fockInner (Uop c s z m ψ) (Uop c s z m φ) = fockInner ψ φ` given `m² = z·conj z`, `m>0`, `c²+s²=1` |
| —  | `unit_coefficient` | `(z/m)·conj(z/m) = 1` under `m² = z·conj z`, `m>0` |
| —  | `unit_coefficient_naive` | `(-i z/m)·conj(-i z/m) = 1` (the `|u|=1` sub-claim of T5) |
| T5 | `halfpulse_low`, `halfpulse_high`, `halfpulse_off`, `naive_halfpulse_false` | corrected identification — see below |
| T6 | `witness_unitary`, `witness_halfpulse_low`, `witness_halfpulse_high`, `witness_phase_eq` | all-rational `z = 3+4i`, `m = 5`, `(c,s)=(4/5,3/5)` |
| T7 | `negative_control_value`, `negative_control_input`, `negative_control_not_unitary` | `(c,s)=(1,1)` breaks unitarity |

## Kill condition TRIGGERED — T5 as stated is false (exact sign mismatch)

The submitted headline was `Uop 0 1 z m = pairKick (-i z/m)`. **This is false.** The module's
`pairKick u` fixes the reverse (high → low) amplitude to be the *conjugate* of the forward
(low → high) amplitude — i.e. `pairKick u` is a **Hermitian** reflection with matrix
`[[0, u],[conj u, 0]]`. The true quarter pulse is

  `Uop 0 1 z m  =  -i · Kop z / m`,   matrix `[[0, -i z/m],[-i conj z/m, 0]]`,

which is **anti**-Hermitian: its reverse amplitude is the *negative* conjugate of its forward one.
Hence no `pairKick u` equals `Uop 0 1 z m`. Concretely, evaluated on `basisVec lowPair` at
`highPair`:

- `Uop 0 1 z m` gives `-i · conj z / m`;
- `pairKick (-i z/m)` gives `conj(-i z/m) = +i · conj z / m`.

The mismatch is exactly a sign (`+i` vs `-i`) in the reverse amplitude. This is proved as
`naive_halfpulse_false` (for `z ≠ 0`, `m > 0`).

### Corrected identification (proved)

On the pair sector the quarter pulse equals `pairKick` **up to the expected global phase `i`**:

- `halfpulse_low`  : `Uop 0 1 z m ψ lowPair  = -i · pairKick (z/m) ψ lowPair`
- `halfpulse_high` : `Uop 0 1 z m ψ highPair = -i · pairKick (z/m) ψ highPair`
- `halfpulse_off`  : `Uop 0 1 z m ψ S = ψ S` for `S ∉ {lowPair, highPair}` (both fix the complement)

with `z/m` a **unit** phase (`unit_coefficient`). So the honest statement is: the pair kick
`pairKick (z/m)` (a Hermitian unit-modulus reflection) is the quarter-period exponential
half-pulse of the finite Hermitian even quartic CAR generator `Kop z`, differing only by the
global phase `i` between a Hermitian reflection and the anti-Hermitian pulse it generates.
The naive coefficient `-i z/m` is the source of the sign error: it has the right modulus
(`unit_coefficient_naive`) but the wrong phase convention for `pairKick`'s conjugate slot.

## Verified constants (witness)

- `z = 3 + 4i`, `m = 5`, `m² = 25 = z·conj z`, `|z| = 5`.
- Normalized phase `z/m = (3+4i)/5`, which equals the module's own `witnessUnitPhase`
  (`witness_phase_eq`); `|z/m| = 1`.
- Rotation coefficients `(c,s) = (4/5, 3/5)`, `c² + s² = 16/25 + 9/25 = 1`; unitarity holds
  (`witness_unitary`).
- Quarter pulse at the witness: `Uop 0 1 (3+4i) 5 = -i · pairKick witnessUnitPhase` on the pair
  sector (`witness_halfpulse_low`, `witness_halfpulse_high`).
- Negative control `(c,s) = (1,1)` (so `c² + s² = 2 ≠ 1`), `ψ = basisVec lowPair`:
  output inner product `= 2` (`negative_control_value`), input `= 1` (`negative_control_input`),
  hence not unitary (`negative_control_not_unitary`).

## Boundary (state plainly)

This upgrades E's "supplied interaction" honestly: the pair kick is not an arbitrary gate but
(a global phase times) the exact exponential half-pulse of a finite Hermitian even quartic CAR
generator. It does **NOT** derive the generator `Kop` from the free walk — `Kop` remains a
supplied coupling. What is established is purely the algebraic ladder T1–T7 above.

## Axiom footprint

Every headline theorem depends only on `[propext, Classical.choice, Quot.sound]`, enforced at
build time by `#guard_msgs`/`#print axioms` at the end of `context/PlueckerPairGenerator.lean`.
No `native_decide`, no `sorry`/`admit`, no added `axiom` or `@[implemented_by]`.
