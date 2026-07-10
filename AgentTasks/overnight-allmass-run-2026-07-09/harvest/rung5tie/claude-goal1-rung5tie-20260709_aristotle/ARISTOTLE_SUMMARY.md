# Summary of changes for run 7f8d8ea2-5eb1-48f0-98c1-c6fd898b162d
Delivered `RequestProject/Main.lean` (namespace `Goal1Rung5Tie`) plus `ARISTOTLE_SUMMARY.md`, closing the honest gap in the seed's rung 5 by computing the channel budget of the **actual** rung-3 bound eigenvector rather than a posited witness. The module builds in-project (~25s; full `lake build` clean) with no `sorry`/`admit`/`native_decide`/new axiom, exact rational arithmetic only (no `Real.sqrt`/`sin`/`cos`), and axiom footprint verified in-file as exactly `[propext, Classical.choice, Quot.sound]` on every headline theorem.

What is proved, reusing the seed's rung-2/3 data verbatim (`H2 dW kW`, `dW=(0,1,7)`, `kW=4`, ground energy `-1`):
- `bound_eigenvector`: the explicit rational eigenvector `v = (2,1,0)` with `H2 dW kW *ᵥ v = (-1)•v` and `v ≠ 0`.
- `channel_split`: the actual Hamiltonian splits as `H2 = H_A + H_C + H_T` with aperture `H_A = freeH2 dW`, closure `H_C = interaction kW` (the seed's attractive closure interaction), turn `H_T = 0`.
- `bound_budget_from_eigenvector`: shares `b_X = ⟨v,H_X v⟩/⟨v,H2 v⟩` are the exact rationals `b_A = -11/5`, `b_C = 16/5`, `b_T = 0`, summing to `1`, with the mandatory eigenvalue-consistency `⟨v,H2 v⟩ = -1·⟨v,v⟩` (`= -5 = -1·5`).

Result — an honest determination. For the true ground state the closure **share** is `b_C = 16/5 ≥ 0` (`closure_share_nonneg`): binding is NOT realized as a negative closure share. This is precisely the task's sanctioned "Kill" — the modelled `b_C < 0` of the seed does not survive being tied to the eigenvector. The file also records the transparent reason: the closure **energy** is genuinely negative, `⟨v,H_C v⟩ = -16 < 0` (`closure_energy_neg`, binding is closure-driven at the energy level), but the total energy `⟨v,H2 v⟩ = -5` is itself negative, so normalizing flips the share sign. I verified computationally that over all ±1 diagonal signature expectations `b_C ∈ {16/5, 0}`, never negative — any expectation diagonal in the eigenbasis gives `b_C = 16/5` identically, so `b_C < 0` is only reachable by a re-posited (eigenbasis-off-diagonal) metric. The budget is thus computed from `v`, not posited, and the honest, non-rigged outcome is `b_C ≥ 0`.

Build note: `seeds/CarrierMassBudget.lean` is a reference-only seed importing an external module (`PhysicsSM.…`) absent from this repo, so it cannot compile here; it is left untouched on disk and the default build glob targets the buildable seed `Goal1Hadron` (the dependency) plus the new `RequestProject` library.

# Goal I rung-5 tie — channel budget of the ACTUAL rung-3 bound eigenvector

Deliverable: `RequestProject/Main.lean` (namespace `Goal1Rung5Tie`), building on the
landed seed `seeds/Goal1Hadron.lean` (namespace `Goal1Hadron`). Kernel-checked,
Mathlib-only, exact rational arithmetic. No `sorry`/`admit`/`native_decide`/new
axiom; no `Real.sqrt`/`sin`/`cos`. Builds in-project in well under 3 minutes
(the deliverable module elaborates in ~25s).

## What the gap was

Seed rung 5 (`Goal1Hadron.rung5_signed_budget`) shows a signed channel budget
`b_A = 3/2, b_C = -1/2, b_T = 0` (sum `1`, negative closure share `b_C < 0`) — but
as a **modelled witness** (hand-built blocks `QAb, QCb`, an indefinite Krein
trace), **not** computed from the rung-3 bound eigenvector. This task closes that
gap by computing the budget of the *actual* ground state.

## What was proved (everything computed from rung 3, nothing posited)

Reusing the seed's rung-2/3 data verbatim: `H2 dW kW` with `dW = (0,1,7)`,
`kW = 4`, i.e. `H2 = [[1,-4,0],[-4,7,0],[0,0,8]]`, ground energy `-1`.

1. `bound_eigenvector` — the explicit **rational** eigenvector
   `v = (2, 1, 0)` of `H2 dW kW` for the ground eigenvalue `-1`:
   `H2 dW kW *ᵥ v = (-1) • v` and `v ≠ 0`, by direct computation.

2. `channel_split` — the split of the *actual* Hamiltonian
   `H2 = H_A + H_C + H_T` with
   - `H_A = freeH2 dW` (aperture: free two-body pair energies `diag(1,7,8)`),
   - `H_C = interaction kW` (closure: the attractive closure interaction κ),
   - `H_T = 0` (turn).

3. `bound_budget_from_eigenvector` — the budget as normalized state expectations
   `b_X = ⟨v, H_X v⟩ / ⟨v, H2 v⟩`:
   - **eigenvalue consistency (mandatory):** `⟨v, H2 v⟩ = -1 · ⟨v, v⟩`
     (here `⟨v, H2 v⟩ = -5`, `⟨v, v⟩ = 5`);
   - the three shares are the **exact rationals**
     `b_A = -11/5`, `b_C = 16/5`, `b_T = 0`;
   - they **sum to `1`**;
   - the **closure share is `b_C = 16/5 ≥ 0`** (`closure_share_nonneg`);
   - the closure **energy** is negative: `⟨v, H_C v⟩ = -16 < 0`
     (`closure_energy_neg`).

## The result is the *Kill*, and it is a real result

The actual bound eigenvector's **closure share is `b_C = 16/5 ≥ 0`** — it is **not**
negative. This is exactly the "Kill" outcome named in the task
("the bound eigenvector's actual closure share is `≥ 0`"): binding is **not**
realized as a negative closure *share* for the true ground state, so the modelled
`b_C < 0` reading of `rung5_signed_budget` does **not** survive being honestly tied
to the eigenvector.

Why the sign is `+`, made transparent in the file:
- The closure **energy** `⟨v, H_C v⟩ = -16` is genuinely **negative** — binding
  *is* closure-driven at the energy level (the aperture energy is `+11`, and
  `+11 + (-16) = -5 = -1·⟨v,v⟩`, the bound energy).
- But the **total** energy `⟨v, H2 v⟩ = -5` is itself negative, so dividing by it
  **flips** the normalized *share* to positive: `b_C = -16 / -5 = 16/5 > 0`.
- Robustness: a scan over all `±1` diagonal (signature) expectations `diag(a,b,c)`
  gives `b_C ∈ {16/5, 0}`, **never negative**. Any diagonal-in-the-eigenbasis
  expectation yields `b_C = 16/5` identically; only an eigenbasis-**off-diagonal**
  (i.e. re-posited) metric could force `b_C < 0`. Hence `b_C ≥ 0` is the honest,
  non-rigged outcome for the true ground state, whereas the seed's `b_C < 0` was an
  artifact of the hand-chosen indefinite witness.

## Axiom footprint

Verified in-file with `#guard_msgs (whitespace := lax) in #print axioms …` on the
headline theorems `bound_eigenvector`, `bound_budget_from_eigenvector`,
`closure_share_nonneg`; each depends on exactly
`[propext, Classical.choice, Quot.sound]`.

## Build note

`seeds/CarrierMassBudget.lean` is a reference-only seed that imports an external
module (`PhysicsSM.…`) absent from this repo and therefore cannot compile here. It
is left untouched on disk; `lakefile.toml`'s default build glob targets only the
buildable seed `Goal1Hadron` (the deliverable's dependency) plus the new
`RequestProject` library, so `lake build` is clean.
