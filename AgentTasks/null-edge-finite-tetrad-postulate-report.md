# Report: finite tetrad-postulate frame-term vanishing (T15)

Deliverable: `PhysicsSM/Draft/NullEdgeFiniteTetradPostulate.lean`
(imports `Mathlib`). All statements are kernel-checked with no `sorry` and
depend only on the standard axioms `propext`, `Classical.choice`, `Quot.sound`.

## Setting (finite algebra, not continuum)

Operators are modeled as elements of an arbitrary, possibly non-commutative,
`Ring R`, indexed by a finite type `ι` (`[Fintype ι]`):

- `C : ι → R`  — finite Clifford / dual-soldered frame symbols `C_a = c(α^a)`;
- `nab : ι → R` — finite transports / connections `∇_a`.

Definitions follow the sign / decomposition convention fixed in
`docs/NULLSTRAND.md` (§ "Frame term and tetrad compatibility") and
`Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` §15.10, §17.4:

- `frameComm C nab a b = ∇_a C_b − C_b ∇_a`  ( the finite commutator `[∇_a, C_b]` );
- `Tframe   = ∑_{a,b} C_a [∇_a, C_b] ∇_b`;
- `Kplus    = ∑_{a,b} C_a C_b ∇_a ∇_b`  (combined kinetic + curvature block);
- `DN       = ∑_a C_a ∇_a`  (finite null Dirac operator `D_N`);
- `Boxnull  = ¼ ∑_{a,b} {C_a, C_b} {∇_a, ∇_b}`  (needs `[Invertible (4 : R)]`);
- `Cdiamond = ¼ ∑_{a,b} [C_a, C_b] [∇_a, ∇_b]`  (needs `[Invertible (4 : R)]`).

The **finite tetrad postulate** is `∀ a b, frameComm C nab a b = 0`, i.e.
`[∇_a, C_b] = 0` (edge-transport / frame compatibility).

## Statements proved

1. `frame_term_vanishes` — **main T15 result**: if `[∇_a, C_b] = 0` for all
   `a, b`, then `Tframe C nab = 0`. (Holds over any `Ring R`.)

2. `dirac_square_decomp` — the finite square identity
   `D_N² = Kplus + Tframe`, for arbitrary non-commuting `C`, `∇`.
   (The algebraic core: `C_a ∇_a C_b ∇_b = C_a C_b ∇_a ∇_b + C_a [∇_a,C_b] ∇_b`,
   summed over the index pairs.)

3. `dirac_square_of_tetrad` — under the tetrad postulate the frame defect drops
   out of the square: `D_N² = Kplus`.

4. `boxnull_add_cdiamond` — the symmetric/antisymmetric split recombines:
   `Boxnull + Cdiamond = Kplus` (over `Ring R` with `[Invertible (4 : R)]`).

5. `dirac_square_full_decomp` — the full `NULLSTRAND` decomposition
   `D_N² = Boxnull + Cdiamond + Tframe`.

6. `dirac_square_full_of_tetrad` — under the tetrad postulate
   `D_N² = Boxnull + Cdiamond` (frame defect removed from the full square).

## Assumptions / guardrails honored

- This is a **finite identity**; nothing here is a continuum / smooth-limit
  claim.
- The frame defect is removed from the square **only** when the finite
  tetrad-postulate hypothesis genuinely holds (it is an explicit premise of
  `frame_term_vanishes`, `dirac_square_of_tetrad`,
  `dirac_square_full_of_tetrad`). Thus the theorems prevent hidden `O(h⁻¹)`
  frame contamination precisely under that hypothesis, and never silently.
- If the frame varies but transport does not carry it compatibly
  (`[∇_a, C_b] ≠ 0`), the hypothesis fails and `Tframe` is *not* asserted to
  vanish: `dirac_square_decomp` / `dirac_square_full_decomp` keep `Tframe` as
  an explicit, separate summand rather than hiding it.
- The symmetric/antisymmetric blocks `Boxnull`, `Cdiamond` require
  `[Invertible (4 : R)]` (the `¼` coefficient); the central vanishing theorem
  and the combined-block square hold over any `Ring`.

## Commands run

- `lake env lean PhysicsSM/Draft/NullEdgeFiniteTetradPostulate.lean`
  — compiles with no errors, no warnings, no `sorry`.
- `#print axioms` on the main theorems — only `propext`, `Classical.choice`,
  `Quot.sound`.

## Remaining defect-classification work (out of scope here)

The audit branch of T15 — when the tetrad postulate *fails*, classifying the
surviving `Tframe` as nonmetricity / curvature-holonomy / torsion-like /
smooth-limit contamination (per `docs/NULLSTRAND.md`) — is a separate
modeling/audit task. It would require additional structure (metric, explicit
edge-transport maps, an `h`-scaling parameter) beyond the bare ring used here.
A natural next step is a concrete non-vanishing witness: an explicit small
ring (e.g. `2×2` matrices) with `[∇_a, C_b] ≠ 0` and `Tframe ≠ 0`, to
demonstrate the hypothesis is load-bearing.
