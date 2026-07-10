# Summary of changes for run 5e403f2a-4092-42ea-be49-c209730492b5
Delivered `RequestProject/Main.lean` (namespace `NeutrinoDiracMajorana`) and `ARISTOTLE_SUMMARY.md`, formalizing the Dirac/Majorana neutrino distinction as a finite null-edge structure in a self-contained complex 4×4 matrix algebra (Mathlib only).

Model: carrier `Fin 4 → ℂ` with slots 0,1 = particle sector, 2,3 = antiparticle sector. Explicit rational/real matrices: CPT involution `R` (swaps sectors), `Theta v = R·conj v` (antiunitary, involutive — `Theta_involutive`), Dirac mass `MD` (within-sector), Majorana mass `MM` (couples slot 0 to CPT partner slot 2), lepton-number phase generator `Q = diag(1,1,-1,-1)`.

Theorems proved (all kernel-checked):
1. `dirac_two_states` — `MD·psiP = psiDPartner ≠ psiP` and `Θ psiP ≠ psiP`: the Dirac mass links a state to an independent partner and the CPT conjugate is a genuinely new state (two independent zigzags).
2. `majorana_self_conjugate` (payload) — explicit Theta-invariant witness `Θ psiInv = psiInv` with `MM·psiInv ≠ 0`, versus a non-invariant `Θ psiNI ≠ psiNI` annihilated by `MM` (`MM·psiNI = 0`): the Majorana mass lives on the self-conjugate subspace.
3. `lepton_number` — `[MD,Q]=0` (conserved) and `[MM,Q]≠0` (violated), with the explicit nonzero commutator entry `(MM·Q − Q·MM) 0 2 = -2`.
4. `neutrino_verdict` — packages Dirac (two independent zigzags, lepton number conserved) vs Majorana (single self-CPT-conjugate zigzag, lepton number violated); the distinction is whether the CPT-conjugate is a new or the same state.

Verification: no sorry/admit/native_decide/new axioms; every headline has an in-file `#guard_msgs (whitespace := lax) in #print axioms …` confirming footprint exactly `[propext, Classical.choice, Quot.sound]`. Proofs use `fin_cases`/`simp`/`norm_num` on explicit 4×4 matrices; `lean_build` succeeds in ~13s. Scope is stated honestly as a finite structural statement, not a physical prediction. Work committed and pushed.

# Neutrino Dirac/Majorana distinction as a null-edge structure

A finite, self-contained complex `4×4` matrix-algebra model (Mathlib only) that renders
the Dirac-vs-Majorana question as a null-edge structural statement, tied to a landed CPT
operator `Theta` and a lepton-number phase generator `Q`.

All results live in `RequestProject/Main.lean`, namespace `NeutrinoDiracMajorana`.

## Model

Carrier `Fin 4 → ℂ`, with basis slots read as two null-edge zigzags: slots `0,1` =
particle sector (lepton number `+1`), slots `2,3` = antiparticle sector (`-1`).

- `R` — real CPT involution swapping the two sectors (`0↔2`, `1↔3`).
- `Theta v = R · conj v` — the antiunitary CPT operator (`Theta_involutive`: `Θ(Θv)=v`).
- `MD` — Dirac mass, swaps *within* a sector (`0↔1`, `2↔3`).
- `MM` — Majorana mass, couples slot `0` to its CPT partner slot `2`.
- `Q = diag(1,1,-1,-1)` — lepton-number phase generator.

## Theorems

1. `dirac_two_states` — Dirac mass couples `psiP` to an independent partner
   (`MD·psiP = psiDPartner ≠ psiP`), and the CPT conjugate `Θ psiP ≠ psiP` is a new
   state: two independent zigzags.
2. `majorana_self_conjugate` (payload) — explicit `Theta`-invariant witness
   `Θ psiInv = psiInv` on which `MM·psiInv ≠ 0`, versus a non-invariant state
   `Θ psiNI ≠ psiNI` which `MM` annihilates (`MM·psiNI = 0`): the Majorana mass is
   supported on the self-conjugate sector.
3. `lepton_number` — `MD·Q = Q·MD` (lepton number conserved), `MM·Q ≠ Q·MM` (violated),
   with explicit nonzero commutator entry `(MM·Q − Q·MM) 0 2 = -2`.
4. `neutrino_verdict` — packages the above: Dirac = two independent null-edge zigzags
   (lepton number conserved); Majorana = single self-CPT-conjugate zigzag (violated);
   the distinction is whether the CPT-conjugate is a new state or the same one.

## Verification

Kernel-checked, no `sorry`/`admit`/`native_decide`/new axioms. Each headline carries an
in-file `#guard_msgs (whitespace := lax) in #print axioms …` confirming the footprint is
exactly `[propext, Classical.choice, Quot.sound]`. Explicit rational/real `4×4` matrices;
proofs by `fin_cases`/`simp`/`norm_num`. Builds under 3 minutes.

## Honest scope

A finite *structural* statement about the two mass-term types and their CPT/phase
properties. It is not a prediction of the physical neutrino's Dirac-or-Majorana nature
or its mass.
