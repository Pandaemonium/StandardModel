# Summary of changes for run 2d233ce3-bb2e-440f-9939-f5af405ad525
Delivered `RequestProject/Main.lean` (namespace `DiracVelocityOperator`) proving that the Dirac velocity operator has instantaneous eigenvalues exactly ±1, plus `ARISTOTLE_SUMMARY.md`.

Representation: the standard complex Dirac matrices on `Matrix (Fin 4) (Fin 4) ℂ` with explicit constant entries — `αᵢ = [[0, σᵢ],[σᵢ,0]]` and `β = diag(1,1,-1,-1)`. All proofs are finite matrix algebra (`ext` + `fin_cases` + `simp`/`norm_num`, plus elementary linear algebra for the eigenvector argument); no symbolic complex analysis, no transcendental functions.

Results proved (all requested targets):
1. `alpha_sq_one` — `αᵢ² = 1` for i = 1,2,3, so every eigenvalue satisfies λ² = 1 (λ = ±1: instantaneous speed exactly c).
2. `alpha_traceless` — `tr αᵢ = 0`, forcing the +1 and −1 eigenspaces to have equal dimension 2.
3. `velocity_spectrum` — the packaged spectral statement for α₁: `α₁² = 1`, `tr α₁ = 0`, `α₁ ≠ 1`, `α₁ ≠ -1`, plus an explicit nonzero +1-eigenvector `vplus = (1,0,0,1)` and nonzero −1-eigenvector `vminus = (1,0,0,-1)`. Hence the spectrum is exactly {+1,−1}, each with multiplicity 2.
4. `massless_luminal` — `αᵢ β = -β αᵢ` for each i (the mass term is the chirality-flipping coupling), and α₁ and β share no common eigenvector with nonzero eigenvalues (`α₁ v = a·v ∧ β v = b·v ⟹ a·b = 0 ∨ v = 0`).

Constraints met: no `sorry`/`admit`/`native_decide`/new axioms; each of the four headline theorems carries an in-file `#guard_msgs (whitespace := lax) in #print axioms …` confirming the footprint is exactly `[propext, Classical.choice, Quot.sound]`. The file builds cleanly (no warnings) in-project in well under 3 minutes, verified via a full `lean_build` of `RequestProject.Main` and `#print axioms` checks.

Honest scope (in the docstring and summary): this is the instantaneous velocity operator of a Dirac fermion — its ±c eigenvalues express that the fermion always moves at c internally (Zitterbewegung); the observable drift ⟨α⟩ = p/E is subluminal, a separate fact whose Zitterbewegung-average reconciliation is not treated here, and this does not cover massive bosons.

# Dirac velocity operator: eigenvalues exactly ±1 (always moving at c)

**File:** `RequestProject/Main.lean` — namespace `DiracVelocityOperator`.

Kernel-checked finite matrix algebra proving that the Dirac velocity operator `αᵢ`
(the Heisenberg-picture `dxᵢ/dt = αᵢ`, units `c = 1`) has instantaneous-velocity eigenvalues
**exactly `±1`** — a fundamental fermion is always moving at `c` internally.

## Representation

The standard complex Dirac representation on `Matrix (Fin 4) (Fin 4) ℂ`, with all entries
explicit constants (`0, 1, -1, I, -I`):

- `alpha1 = [[0, σ₁], [σ₁, 0]]`, `alpha2 = [[0, σ₂], [σ₂, 0]]`, `alpha3 = [[0, σ₃], [σ₃, 0]]`
  (Pauli matrices `σ₁, σ₂, σ₃`);
- `beta = diag(1, 1, -1, -1)` (the mass / Dirac-β matrix).

All proofs are finite: `ext` + `fin_cases` + `simp`/`norm_num` on concrete matrices, plus
`ring`-style linear algebra for the eigenvector argument. No symbolic complex analysis, no
`Real.cos`/`sin`/`sqrt`, no high-degree `nlinarith`.

## Results

1. `alpha_sq_one` — `αᵢ² = 1` for `i = 1,2,3`. Every eigenvalue `λ` satisfies `λ² = 1`, i.e.
   `λ = ±1`: the instantaneous internal speed is exactly `c`.
2. `alpha_traceless` — `tr αᵢ = 0`. Together with `λ = ±1` this forces the `+1` and `-1`
   eigenspaces to have equal dimension `2` each, so both signs genuinely occur.
3. `velocity_spectrum` (payload for `α₁`) — bundles `α₁² = 1`, `tr α₁ = 0`, `α₁ ≠ 1`,
   `α₁ ≠ -1`, an explicit nonzero `+1`-eigenvector `vplus = (1,0,0,1)`, and an explicit nonzero
   `-1`-eigenvector `vminus = (1,0,0,-1)`. Hence the spectrum is exactly `{+1, -1}` with
   multiplicity `2` each — both eigenvalues genuinely occur.
4. `massless_luminal` — `αᵢ β = -β αᵢ` for each `i` (the mass term is the chirality-flipping
   coupling), and `α₁`, `β` share no common eigenvector with nonzero eigenvalues
   (`α₁ v = a·v` and `β v = b·v` ⟹ `a·b = 0` or `v = 0`). With `β` absent (`m = 0`) the
   dynamics is diagonal in the velocity eigenbasis (pure `±c` motion); a nonzero mass mixes
   the `+c` and `-c` states.

## Axiom audit

Each headline (`alpha_sq_one`, `alpha_traceless`, `velocity_spectrum`, `massless_luminal`) has
an in-file `#guard_msgs (whitespace := lax) in #print axioms …` check confirming the footprint
is exactly `[propext, Classical.choice, Quot.sound]`. No `sorry`/`admit`/`native_decide` and no
new axioms. The file builds in-project in well under 3 minutes.

## Honest scope

This is the **instantaneous** velocity operator of a Dirac *fermion*; its `±c` eigenvalues say
the fermion is always moving at `c` internally (Zitterbewegung). The **observable** drift
`⟨α⟩ = p/E` is subluminal — a separate fact; the reconciliation via the Zitterbewegung average
is a companion result not treated here. This does not cover massive bosons.
