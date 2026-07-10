# Summary of changes for run b1f97869-c5a9-4df5-8ce2-4c6cf791c043
Implemented the total-variation / distinguishability "mass" port in `RequestProject/Main.lean` (namespace `TVDistinguishabilityMass`), depending on Mathlib only. Provenance: the TV / data-processing core is ported from the `testing-lower-bounds` package (RemyDegenne/testing-lower-bounds) as a reference, not an import — recorded in `ARISTOTLE_SUMMARY.md`.

Model (finite, rational): `IsProb` probability vectors on `Fin n`; `TV p q = (1/2)∑|pᵢ−qᵢ|`; `ColStoch` column-stochastic coarse-graining maps with action `applyK`; `wedge`/`mass` (Plücker determinant) on `Fin 2`.

Headline theorems, each with an in-file `#guard_msgs (whitespace := lax) in #print axioms …` audit:
- `tv_bounds`: `0 ≤ TV ≤ 1`; `TV = 0 ↔ p = q`; `TV = 1 ↔ disjoint support`.
- `dpi_total_variation`: `TV (K p) (K q) ≤ TV p q` for column-stochastic `K`, via the finite L¹ contraction lemma `l1_contraction` (Finset triangle inequality + column sums = 1).
- `mass_is_distinguishability`: for the explicit rational 2-outcome Bloch readout model, `TV p q = mass p q`, `TV = 0 ↔ wedge = 0`, and `wedge = 0 ↔ p = q` (distinguishability vanishes ⇔ collinear ⇔ massless).
- `distinguishability_verdict`: packaged dictionary (mass = data-processing-monotone TV distinguishability; 0 for collinear, in [0,1], monotone under coarse-graining, strictly decreased by the collapse map).

Non-degeneracy witnesses in-theorem: `witness_collinear` (p=q=(1,0), TV=0, mass=0), `witness_distinguishable` ((1,0) vs (0,1), TV=1, mass=1), and `witness_strict_dpi` (collapse map gives TV 0 < 1), plus `collapse_colStoch`.

Verification: `lake build` succeeds with no warnings or errors; no `sorry`/`admit`/`native_decide`/new axioms. Each headline's footprint is exactly `[propext, Classical.choice, Quot.sound]` (kernel-checked by the in-file guards). Everything is committed and pushed.

# TV-distinguishability mass

**Provenance (reference, NOT an import):** the total-variation / data-processing
core is ported from the `testing-lower-bounds` package
(https://github.com/RemyDegenne/testing-lower-bounds — KL/Rényi/f-divergence,
total variation, DeGroot testing, data-processing inequality). This project is
version-pinned to that repository for provenance only; it depends on **Mathlib
alone**, not on `testing-lower-bounds`.

## What is proved (`RequestProject/Main.lean`, namespace `TVDistinguishabilityMass`)

The *mass* of a two-null-edge state is modelled as the total-variation
**distinguishability** of the two null-direction readouts: collinear directions
are indistinguishable (massless), disjoint/orthogonal directions are perfectly
distinguishable (maximal). Everything is finite and rational (`ℚ`, `Finset.sum`,
`abs`); there is no `Real.log`/`sqrt` and no `Complex`.

### Model
- `IsProb p` — rational probability vector on `Fin n` (`0 ≤ pᵢ`, `∑ pᵢ = 1`).
- `TV p q = (1/2) ∑ᵢ |pᵢ − qᵢ|` — L¹ total variation.
- `ColStoch K` — column-stochastic rational coarse-graining `Fin m ← Fin n`.
- `applyK K p = fun i => ∑ⱼ Kᵢⱼ pⱼ` — action of a coarse-graining.
- `wedge p q = p₀q₁ − p₁q₀`, `mass p q = |wedge p q|` — Plücker/wedge on `Fin 2`.

### Headline theorems (each with an in-file `#print axioms` audit)
1. **`tv_bounds`** — `0 ≤ TV p q ≤ 1`; `TV p q = 0 ↔ p = q` (indistinguishable);
   `TV p q = 1 ↔ DisjointSupport p q` (perfectly distinguishable).
2. **`dpi_total_variation`** — data-processing: `TV (K p) (K q) ≤ TV p q` for any
   column-stochastic `K`. Proved via the finite L¹ contraction
   `l1_contraction` (`Finset` triangle inequality + column-stochasticity):
   `∑ᵢ |∑ⱼ Kᵢⱼ dⱼ| ≤ ∑ᵢ ∑ⱼ Kᵢⱼ|dⱼ| = ∑ⱼ (∑ᵢ Kᵢⱼ)|dⱼ| = ∑ⱼ |dⱼ|`.
3. **`mass_is_distinguishability`** — for the explicit rational Bloch/celestial
   `2`-outcome readout model: `TV p q = mass p q`, `TV p q = 0 ↔ wedge = 0`, and
   `wedge = 0 ↔ p = q`. So distinguishability vanishes ⇔ the edges are collinear
   ⇔ mass is zero (massless), and grows with the wedge magnitude (massive).
4. **`distinguishability_verdict`** — packaged dictionary: mass = the
   data-processing-monotone TV distinguishability; `0` for collinear (massless),
   in `[0,1]`, monotone under coarse-graining, and strictly decreased by the
   total-collapse map on a distinguishable pair.

### Non-degeneracy witnesses (explicit rationals, in-theorem)
- `witness_collinear` — `p = q = (1,0)`: `TV = 0`, `mass = 0` (massless).
- `witness_distinguishable` — `p = (1,0)`, `q = (0,1)`: `TV = 1`, `mass = 1`.
- `witness_strict_dpi` — the collapse map `collapse : Fin 1 → Fin 2 → ℚ`
  (`collapse_colStoch`) sends the distinguishable pair to `TV = 0 < 1`, a strict
  drop.

## Verification
`lake build` succeeds cleanly. Every headline is kernel-checked with footprint
exactly `[propext, Classical.choice, Quot.sound]`, verified in-file by
`#guard_msgs (whitespace := lax) in #print axioms …`. No `sorry`/`admit`,
no `native_decide`, no new axioms, no `@[implemented_by]`.
