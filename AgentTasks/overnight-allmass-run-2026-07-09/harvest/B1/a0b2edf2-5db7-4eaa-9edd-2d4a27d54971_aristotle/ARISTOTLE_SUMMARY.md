# Summary of changes for run a0b2edf2-5db7-4eaa-9edd-2d4a27d54971
Delivered `RequestProject/Main.lean` (namespace `SuiteB_PathSum`) plus `ARISTOTLE_SUMMARY.md`, all committed and pushed. The build is clean and kernel-checked: no `sorry`/`admit`/`native_decide`/new axioms. Every headline theorem carries an in-file `#guard_msgs (whitespace := lax) in #print axioms …` check confirming the footprint is exactly `[propext, Classical.choice, Quot.sound]` (also independently verified). The only build messages are cosmetic `simp` unused-argument lint notes (false positives — removing the flagged args breaks the proofs).

Definitions: `outer` (|u⟩⟨v|), `rhoDir a psi Om = ∑_{h,h'} a h · conj(a h') · Om h h' • |psi h⟩⟨psi h'|`, kernels `onesKer`/`deltaKer`, `wedge` (2×2 Plücker), `Psi`, and the coherence family `OmegaT t = (1−t)·ones + t·delta`.

Targets proved:
1. `rho_dir_hermitian`, `rho_dir_psd` (for any Hermitian, PSD kernel); plus `rho_dir_trace` (general trace formula) and `rho_dir_decohered_trace_one` (trace = 1 in the decohered, normalized case).
2. `coherent_is_pure` — with the all-ones kernel `rhoDir = |Ψ⟩⟨Ψ|` and `det = 0` (unconditional); `coherent_purity` (`tr(ρ²) = (tr ρ)²`) and `coherent_linear_entropy_zero` (`S_lin = 1 − tr(ρ²) = 0` under normalization `tr ρ = 1`).
3. `decohered_mass_two` — the |H|=2 closed form `det = |a₀|²|a₁|²|ψ₀∧ψ₁|²`; `decohered_mass_eq_disagreement` — the general finite-sum identity `det = ∑_{h<h'} |a h|²|a h'|²|ψ_h∧ψ_h'|²` (via the reusable `sum_pair_split`).
4. `decohered_family_det` — `det ρ(t) = t(2−t)·D` with `D = |a₀|²|a₁|²|ψ₀∧ψ₁|² ≥ 0`; `mass_monotone_in_decoherence` — `det ρ(0) = 0` and `t ↦ (det ρ(t)).re` is `MonotoneOn [0,1]`.

Non-degeneracy witness: `witnessA` (a₀=a₁=½+½i, so |a|²=½, ∑=1) and `witnessPsi` (ψ₀=(1,0), ψ₁=(3/5,4/5), unit and non-collinear — `witness_wedge_ne_zero` gives wedge 4/5≠0). `witness_decohered_det` gives the specific nonzero rational `det = 4/25`.

Honest normalization note (in the summary file): "mass² = det rhoDir" is the normalization-robust invariant. The trace is not universally 1 under the given definition — it equals 1 automatically only in the decohered case, and equals ‖Ψ‖² in the coherent case (which need not be 1 even when ∑|a h|²=1). Hence the linear-entropy statement is given with an explicit `tr ρ = 1` hypothesis, while `det = 0` and all determinant identities hold regardless of normalization; under `∑|a h|²=1` (as in the witness), `det rhoDir` is mass² directly.

# Suite B rung B1 — path-sum semantics: mass is retained which-direction information

All results live in `RequestProject/Main.lean`, namespace `SuiteB_PathSum`.
The file is kernel-checked: no `sorry`/`admit`/`native_decide`/new axiom. Every
headline theorem has an in-file `#guard_msgs (whitespace := lax) in #print axioms …`
check confirming the footprint is **exactly `[propext, Classical.choice, Quot.sound]`**.

## Setup

A finite family of "direction states" `psi : H → (Fin 2 → ℂ)` (points on the
Bloch/celestial `ℂ²`), amplitudes `a : H → ℂ`, and a coherence kernel
`Om : H → H → ℂ`, assemble the path-conditioned visible direction operator

```
rhoDir a psi Om = ∑_{h,h'} (a h * conj (a h') * Om h h') • |psi h⟩⟨psi h'|
```

where `outer u v = |u⟩⟨v|` has entries `u i * conj (v j)` (`outer`, `rhoDir`).
The two extreme kernels are `onesKer` (all-ones, full coherence) and `deltaKer`
(Kronecker identity, full decoherence). The squared 2×2 Plücker/wedge is
`wedge u v = u 0 * v 1 - u 1 * v 0`, with `|u ∧ v|² = normSq (wedge u v)`.

## Targets delivered

1. **Genuine density operator.**
   - `rho_dir_hermitian` — `rhoDir` is Hermitian for any Hermitian kernel
     (`conj (Om h h') = Om h' h`).
   - `rho_dir_psd` — `rhoDir` is positive-semidefinite for any Hermitian **and**
     PSD kernel (`∀ z, 0 ≤ ∑_{h,h'} conj (z h) * Om h h' * z h'`), via the
     substitution `z h = conj (a h * ⟨psi h | x⟩)`.
   - `rho_dir_trace` — general trace formula
     `tr rhoDir = ∑_{h,h'} a h * conj (a h') * Om h h' * ⟨psi h' | psi h⟩`.
   - `rho_dir_decohered_trace_one` — in the decohered case, with unit directions
     (`∑_i |psi h i|² = 1`) and normalized amplitudes (`∑_h |a h|² = 1`),
     `tr rhoDir = 1`. (See the normalization note below on why trace-1 is *not*
     universal.)

2. **Coherent = pure (massless).**
   - `coherent_is_pure` — with `onesKer`, `rhoDir = |Ψ⟩⟨Ψ|` where
     `Ψ = ∑_h a h • psi h` (`Psi`), hence rank ≤ 1 and `det rhoDir = 0`
     unconditionally. Vanishing determinant is the robust "massless" statement.
   - `coherent_purity` — the normalization-free purity identity
     `tr(ρ²) = (tr ρ)²`.
   - `coherent_linear_entropy_zero` — the linear entropy `S_lin = 1 − tr(ρ²) = 0`
     holds once the state is normalized (`tr ρ = 1`, i.e. `‖Ψ‖ = 1`).

3. **Decohered mass = which-direction disagreement.**
   - `decohered_mass_two` — the |H| = 2 anchor in full closed form:
     `det rhoDir = |a 0|² |a 1|² |psi 0 ∧ psi 1|²`.
   - `decohered_mass_eq_disagreement` — the general finite-sum identity
     `det rhoDir = ∑_{h < h'} |a h|² |a h'|² |psi h ∧ psi h'|²`
     (with `[LinearOrder H]` to give meaning to `h < h'`). Proved from
     `rhoDir_delta_eq`, the pair-splitting lemma `sum_pair_split`
     (`∑_{h,g} G = ∑_h G h h + ∑_{h<g} (G h g + G g h)`), the vanishing of the
     diagonal, and the pointwise identity `G h g + G g h = |a h|²|a g|²|ψ_h∧ψ_g|²`.

4. **Mass monotone in decoherence (two histories).**
   - `decohered_family_det` — along `OmegaT t = (1−t)·ones + t·delta` the
     determinant is `det ρ(t) = t (2 − t) · D`, with
     `D = |a 0|² |a 1|² |psi 0 ∧ psi 1|² ≥ 0`.
   - `mass_monotone_in_decoherence` — `det ρ(0) = 0` (coherence hides mass) and
     `t ↦ (det ρ(t)).re` is `MonotoneOn (Set.Icc 0 1)`. Reading: decohering hidden
     histories can only create mass.

## Mandatory non-degeneracy witness

`witnessA` uses `a 0 = a 1 = ½ + ½·i` (so `|a h|² = ½`, `∑ |a h|² = 1`, all
rational) and `witnessPsi` uses `psi 0 = (1, 0)`, `psi 1 = (3/5, 4/5)` — unit
vectors that are **non-collinear** (`witness_wedge_ne_zero` shows the wedge is
`4/5 ≠ 0`). On this fixture:

```
witness_decohered_det :  det (rhoDir witnessA witnessPsi deltaKer) = 4/25
```

a specific **nonzero rational** value, so target 3 is not established only on a
collapsed/collinear family. (Value: `½ · ½ · (4/5)² = ¼ · 16/25 = 4/25`.)

## Honest normalization note on "mass² = det rhoDir"

The determinant is the normalization-robust invariant throughout, and we take
the (unnormalized) mass² to be `det rhoDir`.

- The **trace is not universally 1.** With the definition as given,
  `tr rhoDir = ∑_{h,h'} a h conj(a h') Om h h' ⟨psi h'|psi h⟩` (`rho_dir_trace`).
  This equals 1 automatically in the **decohered** case
  (`rho_dir_decohered_trace_one`), but in the **coherent** case it is
  `‖Ψ‖² = ‖∑_h a h psi h‖²`, which can differ from 1 even when `∑ |a h|² = 1`
  and the `psi h` are unit vectors (e.g. all `psi h` equal gives `‖Ψ‖² = |∑ a h|²`).
  So `rhoDir` is a genuine **trace-1** density operator exactly when this effective
  coherence equals 1 — always for `deltaKer`, and for `onesKer` precisely when
  `Ψ` is a unit vector.
- Consequently the **linear entropy** statement `S_lin = 1 − tr(ρ²) = 0` for the
  coherent state is stated with the explicit normalization hypothesis `tr ρ = 1`
  (`coherent_linear_entropy_zero`); the normalization-free content is
  `tr(ρ²) = (tr ρ)²` (`coherent_purity`) together with the unconditional
  `det = 0` (`coherent_is_pure`).
- Because `det` scales homogeneously in the weights `|a h|²`, all determinant
  identities (targets 2–4 and the witness) hold **regardless of normalization**;
  they express mass² up to the overall scale fixed by `∑ |a h|²`. Under the
  standard normalization `∑ |a h|² = 1` (as in the witness), `det rhoDir` is the
  mass² directly.
