# Summary of changes for run 60fd49e5-9ece-4271-a143-bc5c2bf7d37a
Delivered `RequestProject/Main.lean` (namespace `ZigzagWeyl`) plus `ARISTOTLE_SUMMARY.md`, formalizing Penrose's "zigzag" as a finite one-momentum chiral-basis decomposition of the massive Dirac operator. Mathlib only; builds in-project (~45s); no `sorry`/`admit`/`native_decide`/new axioms. Each of the four headline theorems is kernel-checked with footprint exactly `[propext, Classical.choice, Quot.sound]`, verified in-file by `#guard_msgs (whitespace := lax) in #print axioms <thm>`.

Model (explicit real matrices, 2×2 Weyl blocks → 4×4 Dirac):
- `gamma5 = diag(1,1,-1,-1)`; `chiralFlip = [[0,I],[I,0]]`.
- On-shell (scale-4) Weyl symbols `KL = !![0,4;-4,0]`, `KR = -KL`, with `KL*KR = KR*KL = 16·I`; `Dkin = [[0,KR],[KL,0]]`, `Dmass m = m·chiralFlip`, `D m = Dkin + Dmass m`.
- Null light-cone Weyl symbols `KLnull = !![0,0;0,4]`, `KRnull = !![4,0;0,0]` (`σ·p`, `σ̄·p` at `p=(2,0,0,2)`); `Dnull = [[0,KRnull],[KLnull,0]]`.

Theorems:
1. `chiral_grading`: `γ₅² = 1`, `tr γ₅ = 0`, and both mass and kinetic parts are chiral-odd (`γ₅·X·γ₅ = -X`).
2. `massless_decouples` (payload): `D 0 = Dkin`, which anticommutes with `γ₅` (maps +chirality↔−chirality with no within-chirality coupling); exact null relations `KLnull*KRnull = 0` and `KRnull*KLnull = 0`; Weyl symbols genuinely nonzero and distinct.
3. `mass_couples`: `Dmass m ≠ 0` for `m ≠ 0`; mass-shell square `D(m)² = (16 + m²)·I`, instantiated at the 3-4-5 shell `D(3)² = 25·I`.
4. `zigzag_verdict`: packages 1–3.

Honest scope (in the summary): this is a finite single-momentum linear-algebra statement, not the full field theory. Two explicit momentum points are used — a null light-cone point where the Weyl symbols square to zero (massless decoupling into two free null Weyl operators) and an on-shell scale-4 point for the mass-shell square — since a nonzero kinetic² can only appear off the null cone.

# claude-zigzag-weyl — Penrose zigzag: massive Dirac = two null Weyl coupled by mass

## What was proved

All results live in `RequestProject/Main.lean`, namespace `ZigzagWeyl`, as explicit finite
real linear algebra: 2×2 Weyl (chiral) symbols assembled into the 4×4 Dirac operator in the
chiral basis. Every headline theorem is kernel-checked with footprint exactly
`[propext, Classical.choice, Quot.sound]`, verified in-file by
`#guard_msgs (whitespace := lax) in #print axioms <thm>`. No `sorry`/`admit`/`native_decide`,
no new axioms.

### Model (explicit matrices)
- `gamma5 = diag(1,1,-1,-1)` — chirality.
- `chiralFlip = [[0,I],[I,0]]` — the chirality-flipping block used for the mass term.
- On-shell (scale-4) Weyl symbols `KL = !![0,4;-4,0]`, `KR = -KL = !![0,-4;4,0]`, giving
  the clean Clifford relation `KL*KR = KR*KL = 16·I`.
- `Dkin = [[0,KR],[KL,0]]` (block-off-diagonal kinetic part).
- `Dmass m = m · chiralFlip`, and the massive Dirac operator `D m = Dkin + Dmass m`.
- Null (light-cone) Weyl symbols at momentum `p=(2,0,0,2)`: `KLnull = !![0,0;0,4]`,
  `KRnull = !![4,0;0,0]` (the light-cone projectors `σ·p`, `σ̄·p`), and
  `Dnull = [[0,KRnull],[KLnull,0]]`.

### Theorems
1. `chiral_grading` — `γ₅² = 1`, `tr γ₅ = 0`; the mass part and the kinetic part are both
   chiral-odd (`γ₅ · X · γ₅ = -X`). The two Weyl components have opposite chirality and the
   mass flips chirality.
2. `massless_decouples` (payload) — `D 0 = Dkin`, which anticommutes with `γ₅`
   (`γ₅·Dkin = -(Dkin·γ₅)`, same for `Dnull`): the kinetic operator maps the `+1` chirality
   subspace to `-1` and vice versa, with no within-chirality coupling. At the null momentum
   the exact null relations `KLnull*KRnull = 0` and `KRnull*KLnull = 0` hold, so the massless
   operator is two independent free null Weyl operators. The Weyl symbols are shown genuinely
   nonzero and distinct (`KLnull ≠ 0`, `KRnull ≠ 0`, `KLnull ≠ KRnull`, and likewise for
   `KL`, `KR`).
3. `mass_couples` — for `m ≠ 0` the coupling `Dmass m ≠ 0`; the mass-shell square is
   `D(m)² = (16 + m²)·I` (kinetic scale 4 ⇒ kinetic² = 16), instantiated in-theorem at the
   3-4-5 shell `D(3)² = 25·I`. The mass is exactly what lifts the null shell to the massive one.
4. `zigzag_verdict` — packages 1–3 into a single statement.

## Honest scope
This is a **finite one-momentum linear-algebra decomposition**, not the full quantum field
theory of a Dirac fermion. Two explicit momentum points are used, both physically honest:
- the **null (light-cone) point** `p=(2,0,0,2)`, where the Weyl symbols are genuinely null
  (`KLnull*KRnull = 0`) — this is where the massless decoupling into two free null Weyl
  operators is exhibited;
- an **on-shell reference point** (scale 4) with the clean Clifford relation
  `KL*KR = 16·I`, used to display the mass-shell square `D(m)² = (16+m²)·I` and the 3-4-5
  instance `D(3)² = 25`.
These are different points in momentum space (light cone vs. massive shell), as they must be:
on the light cone the Weyl symbols square to zero, so a nonzero kinetic² can only appear off
the null cone. Nothing here addresses spinor fields, propagators, second quantization, or
Lorentz covariance beyond this single-momentum symbol-level statement.

## Build
`RequestProject/Main.lean`, Mathlib only. Builds in-project (≈45s for the file).
