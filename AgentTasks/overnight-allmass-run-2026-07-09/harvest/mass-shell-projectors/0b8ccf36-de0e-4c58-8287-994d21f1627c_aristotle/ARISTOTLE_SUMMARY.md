# Summary of changes for run 0b8ccf36-de0e-4c58-8287-994d21f1627c
Delivered `RequestProject/Main.lean` (namespace `MassShellProjectors`) plus `ARISTOTLE_SUMMARY.md`. The file builds cleanly, kernel-checked, with no `sorry`/`admit`/`native_decide` and no new axioms; Mathlib only; purely rational 4×4 matrices (no `Complex`, no `Real.sqrt/cos/sin`, no `nlinarith`).

Model (PhysLean Dirac-rep, real g0/g3 in the (t,z) plane → rational): `g0 = diag(1,1,-1,-1)`, `g3 = !![0,0,1,0; 0,0,0,-1; -1,0,0,0; 0,1,0,0]`, `pslash E kz = E•g0 − kz•g3`, energy projectors `Lp = (1/2m)•(pslash+m•1)`, `Lm = (1/2m)•(m•1−pslash)`.

Proved (each headline carries an in-file `#guard_msgs (whitespace := lax) in #print axioms`, all reporting exactly `[propext, Classical.choice, Quot.sound]`):
- `pslash_sq`: `pslash² = (E²−kz²)•1` (= m²•1 on shell).
- `projectors_complete`: `Lp + Lm = 1`.
- `projectors_idempotent`: `Lp² = Lp` and `Lm² = Lm` (payload, via `pslash² = m²•1` on shell).
- `projectors_orthogonal`: `Lp·Lm = 0` and `Lm·Lp = 0` (payload).
- `projector_ranks`: `trace Lp = 2` and `trace Lm = 2`.
- `massless_singular`: the finite identity `2m•Lp = pslash + m•1`, with the docstring recording honestly that `Lp` itself carries the `1/2m` factor and diverges as `m→0`, so `Λ±` are defined only for `m ≠ 0` — the energy split needs the mass, unlike the chirality split which survives `m=0`.
- `mass_shell_projector_verdict`: packages completeness + idempotence + orthogonality + ranks for all on-shell `(E,kz,m)` with `m ≠ 0`, plus the mandatory explicit witness `E=5, kz=3, m=4` (`pslash² = 16•1`, `Lp` a genuine projector with `trace = 2`, `Lp ≠ 0`, `Lp ≠ 1`).

Proof technique: `pslash_sq`, completeness, ranks, and the witness inequalities are entrywise (`fin_cases`/`simp`/`field_simp`/`ring`); idempotence/orthogonality use a matrix-level reduction (`simp only` normalizing products + `pslash_sq` + on-shell substitution, closed by `module`), then the scalar `1/2m` bookkeeping via `field_simp`.

`ARISTOTLE_SUMMARY.md` includes the PhysLean provenance line (convention from PhysLean `spaceTime.gamma` / Dirac representation, real (t,z) avatar; the physical energy split is imported Dirac theory, realized here as finite kernel-checked matrix algebra). All changes committed and pushed.

# claude-mass-shell-projectors — energy projectors `Λ± = (pslash ± m)/2m`

All results live in `RequestProject/Main.lean`, namespace `MassShellProjectors`.
The file builds cleanly (kernel-checked, no `sorry`/`admit`/`native_decide`, no new axioms),
uses **Mathlib only**, and is a purely rational 4×4 matrix development (no `Complex`, no
`Real.sqrt/cos/sin`, no `nlinarith`).

## Model

PhysLean Dirac-representation gammas, both **real**, restricted to the `(t,z)` plane so everything
is rational:

* `g0 = diag(1,1,-1,-1)`
* `g3 = !![0,0,1,0; 0,0,0,-1; -1,0,0,0; 0,1,0,0]`
* `pslash E kz = E • g0 − kz • g3`
* `Lp E kz m = (1/(2m)) • (pslash + m•1)`  (positive-energy projector `Λ₊`)
* `Lm E kz m = (1/(2m)) • (m•1 − pslash)`  (negative-energy projector `Λ₋`)

On-shell relation: `E² − kz² = m²` with `m ≠ 0`.

## Results (all headline theorems carry an in-file `#print axioms` check)

1. `pslash_sq` — `pslash² = (E² − kz²) • 1` (`= m² • 1` on shell).
2. `projectors_complete` — `Λ₊ + Λ₋ = 1`.
3. `projectors_idempotent` — `Λ₊² = Λ₊` and `Λ₋² = Λ₋`.
4. `projectors_orthogonal` — `Λ₊ Λ₋ = 0` and `Λ₋ Λ₊ = 0`.
5. `projector_ranks` — `trace Λ₊ = 2` and `trace Λ₋ = 2` (two positive- and two negative-energy states).
6. `massless_singular` — the finite identity `2m • Λ₊ = pslash + m•1`; the docstring records honestly
   that `Λ₊` itself carries the `1/2m` factor and so diverges as `m → 0`, which is why `Λ±` are
   defined only for `m ≠ 0` — the energy split needs the mass, unlike the chirality split
   `P_{L,R} = (1 ∓ γ⁵)/2` which survives `m = 0`.
7. `mass_shell_projector_verdict` — the package: completeness + idempotence + orthogonality + ranks
   for all on-shell `(E,kz,m)` with `m ≠ 0`, together with the mandatory explicit non-degeneracy
   witness `E = 5, kz = 3, m = 4` (`m² = 16`, `pslash² = 16 • 1`, `Λ₊` a genuine projector with
   `trace Λ₊ = 2`, and `Λ₊ ≠ 0`, `Λ₊ ≠ 1`).

## Axiom footprint

Every headline theorem reports exactly `[propext, Classical.choice, Quot.sound]`, verified in-file by
`#guard_msgs (whitespace := lax) in #print axioms <thm>`.

## PhysLean provenance

The gamma-matrix convention is that of PhysLean `PhysLean.Relativity.Spinors` / `spaceTime.gamma`
(the Dirac representation, with real `g0`, `g3`), here restricted to the `(t,z)` plane as a rational
avatar. The physical fact that `(pslash + m)` is the Dirac-propagator numerator and that `Λ±` split
the spinor by sign of energy on the mass shell is imported Dirac theory; the algebraic content
(complete pair of orthogonal idempotents, rank 2 each, singular as `m → 0`) is realized here as a
finite, kernel-checked matrix computation.
