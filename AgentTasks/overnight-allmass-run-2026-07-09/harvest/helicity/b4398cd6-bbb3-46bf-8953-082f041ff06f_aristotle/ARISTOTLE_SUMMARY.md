# Summary of changes for run b4398cd6-bbb3-46bf-8953-082f041ff06f
Delivered `RequestProject/Main.lean` (namespace `HelicityChirality`) plus `ARISTOTLE_SUMMARY.md`. Kernel-checked, `Mathlib`-only, no `sorry`/`admit`/`native_decide`/new axioms; builds cleanly (~25s). Every headline theorem's axiom footprint is exactly `[propext, Classical.choice, Quot.sound]`, verified in-file with `#guard_msgs (whitespace := lax) in #print axioms <thm>`.

Model (explicit rational 4×4 matrices, chiral basis, one fixed momentum along z, c=1):
- `sigma3` = σ₃ Weyl-block helicity, `h4` = Σ₃ = diag(1,-1,1,-1) full helicity, `g5` = γ₅ = diag(1,1,-1,-1) chirality, `D0` = diag(1,-1,-1,1) massless Dirac Hamiltonian α·p, `Dmass m` = m·[[0,I],[I,0]] mass term βm, `Dtot m` = D0 + Dmass m.

Targets proved:
1. `helicity_ops` / `helicity_sq`: σ₃²=1, tr σ₃=0, Σ₃²=1; the two Weyl blocks carry opposite chirality (g5 e₀=e₀, g5 e₂=-e₂).
2. `massless_helicity_eq_chirality` (payload): at m=0, D0 preserves each chirality block (D0·g5=g5·D0) and commutes with helicity; on every positive-energy propagating mode (D0 v = v, eigenvalue +1≠0) chirality equals helicity (g5 v = h4 v); explicit nonzero modes e₀ (right-handed, +1 helicity) and e₃ (left-handed, -1 helicity).
3. `mass_couples_helicities`: g5·(Dmass m)·g5 = -(Dmass m) (mass flips chirality, mapping +1↔-1 subspaces), with the required explicit nonzero commutator entry [Dtot 1, g5]₀₂ = -2, hence [Dtot 1, g5] ≠ 0.
4. `verdict`: packages the zigzag picture — massless ⇒ chirality = helicity (each Weyl piece a definite-helicity luminal mode); mass ⇒ the two chirality/helicity pieces coupled and swapped.

Honest scope (documented in file and summary): this is a finite one-momentum fermion model. A physics nuance is stated and proved: the true helicity operator Σ₃ remains conserved even with mass (Dtot m·h4 = h4·Dtot m), since helicity is spin along a conserved momentum; what mass actually breaks is chirality conservation, and because chirality = helicity for the massless modes, the chirality-flipping mass term is precisely what couples the opposite-helicity Weyl pieces — which is why the exhibited nonzero commutator is [Dtot 1, g5]. D0 is taken as the Dirac Hamiltonian α·p (block-diagonal in chirality) so that "D0 preserves each chirality block" holds literally. Work committed and pushed.

# Massless: chirality = helicity; mass couples opposite helicities

A self-contained, kernel-checked finite matrix model, `Mathlib` only, in
`RequestProject/Main.lean` (namespace `HelicityChirality`). Everything is explicit rational
(`ℚ`) `4×4` matrices in the chiral (Weyl) basis for a **fermion at one fixed momentum** (along
`z`, unit energy and magnitude, `c = 1`).

## Model

| object | matrix | meaning |
|---|---|---|
| `sigma3` | `!![1,0;0,-1]` | Weyl-block helicity `σ₃` |
| `h4` | `diag(1,-1,1,-1)` | full helicity `Σ₃ = diag(σ₃,σ₃)` |
| `g5` | `diag(1,1,-1,-1)` | chirality `γ₅` (upper block `+1`, lower `-1`) |
| `D0` | `diag(1,-1,-1,1)` | massless Dirac Hamiltonian `α·p = diag(σ·p,-σ·p)` |
| `Dmass m` | `m·[[0,I],[I,0]]` | mass term `β m` (block-off-diagonal in chirality) |
| `Dtot m` | `D0 + Dmass m` | full Dirac Hamiltonian |

## Results (headline theorems)

- `helicity_ops` — `σ₃² = 1`, `tr σ₃ = 0`; the two Weyl blocks carry opposite chirality
  (`g5 e₀ = e₀`, `g5 e₂ = -e₂`). (`helicity_sq`: full `Σ₃² = 1`.)
- `massless_helicity_eq_chirality` (payload) — at `m = 0`: `D0` preserves each chirality block
  (`D0·g5 = g5·D0`) and commutes with helicity (`D0·h4 = h4·D0`); on every positive-energy
  propagating mode (`D0 v = v`, eigenvalue `+1 ≠ 0`) chirality equals helicity (`g5 v = h4 v`);
  explicit modes: `e₀` right-handed / `+1` helicity, `e₃` left-handed / `-1` helicity.
- `mass_couples_helicities` — the mass term flips chirality: `g5·(Dmass m)·g5 = -(Dmass m)`, so it
  maps the `+1` chirality subspace to `-1` and back; hence `[Dtot 1, g5] ≠ 0` with explicit nonzero
  entry `[Dtot 1, g5]₀₂ = -2`.
- `verdict` — the package: massless ⇒ chirality = helicity (each Weyl piece a definite-helicity
  luminal mode); mass ⇒ the two chirality/helicity pieces are coupled and swapped. The zigzag: the
  electron is a left- and a right-helicity massless piece, swapped by mass.

## Honest scope / conventions

- Finite one-momentum model of a **fermion**; not a field theory. Momentum fixed along `z`.
- **Physics nuance made explicit (and proved).** For a free particle with fixed momentum the *true*
  helicity operator `h4 = Σ₃` stays conserved even with mass (`Dtot m · h4 = h4 · Dtot m`, part of
  `mass_couples_helicities`): helicity is spin along the conserved momentum. What mass genuinely
  breaks is **chirality** conservation (`[Dtot 1, g5] ≠ 0`). Because for the massless
  positive-energy modes chirality *equals* helicity, the chirality-flipping mass term is exactly the
  operator coupling the two would-be opposite-helicity Weyl pieces. This is why the exhibited
  nonzero commutator is `[Dtot 1, g5]` (chirality = the helicity label of the massless pieces).
- The massless `D0` is taken as the Dirac **Hamiltonian** `α·p` (block-diagonal in chirality in the
  chiral basis), which makes "`D0` preserves each chirality block" literally true.

## Verification

- Builds under a few minutes; no `sorry`/`admit`/`native_decide`/new axioms; `Mathlib` only;
  proofs use `simp`/`norm_num`/`fin_cases`/`linarith`.
- Axiom footprint of every headline theorem is exactly `[propext, Classical.choice, Quot.sound]`,
  checked in-file by `#guard_msgs (whitespace := lax) in #print axioms <thm>`.
