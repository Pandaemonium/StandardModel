# Summary of changes for run b388d77f-cda1-460d-a597-9838145498ce
Delivered `RequestProject/Main.lean` (namespace `ChiralProjectorsDirac`) and `ARISTOTLE_SUMMARY.md`, grounding the chiral (Weyl) decomposition of a Dirac spinor in the Dirac representation as a fully kernel-checked rational 4×4 matrix computation.

Model (over ℚ, real gamma5 — no Complex, no Real transcendentals):
- `g5 = !![0,0,1,0; 0,0,0,1; 1,0,0,0; 0,1,0,0]` (Dirac-rep gamma5 = i·g0·g1·g2·g3, the real block off-diagonal identity)
- `PL = (1/2)•(1 - g5)`, `PR = (1/2)•(1 + g5)` (entries in {0, 1/2, -1/2}).

Proved (all with an in-file `#guard_msgs ... #print axioms` check pinning the footprint to exactly `[propext, Classical.choice, Quot.sound]`, no sorry/admit/native_decide, no new axioms):
1. `g5_involutive`: g5*g5 = 1
2. `g5_traceless`: trace g5 = 0
3. `projectors_complete`: PL + PR = 1
4. `projectors_idempotent`: PL*PL = PL ∧ PR*PR = PR
5. `projectors_orthogonal`: PL*PR = 0 ∧ PR*PL = 0
6. `chirality_eigenvalues`: g5*PL = -PL ∧ g5*PR = PR
7. `projector_ranks`: trace PL = 2 ∧ trace PR = 2
8. `weyl_decomposition_verdict`: packaged verdict bundling all of the above plus the mandated non-degeneracy facts (g5 ≠ 1, g5 ≠ -1, PL ≠ 0, PR ≠ 0, PL ≠ PR, PL 0 2 = -1/2, traces = 2). Non-degeneracy is also available standalone via `g5_nontrivial` and `projectors_nontrivial`.

Proofs use `Matrix.mul`/`trace` with `fin_cases`/`simp`/`norm_num`/`ring` only. The project builds cleanly (no errors or linter warnings) in well under 3 minutes, and a grep confirms no remaining `sorry`. The summary records the honest scope (finite projector algebra only, not the Lorentz rep or mass coupling) and the clean-room provenance line: PhysLean `Fermion.LeftHandedWeyl`/`RightHandedWeyl` + `gamma5` used as reference only, not imported; Mathlib-only dependency. All work is committed and pushed.

# Chiral projectors P_L, P_R in the Dirac representation

**File:** `RequestProject/Main.lean` (namespace `ChiralProjectorsDirac`).

Clean-room grounding of the chiral (Weyl) decomposition of a Dirac spinor in the
Dirac representation, over the rationals ℚ (real `gamma5`, no `Complex`, no `Real`
transcendentals). Everything is a kernel-checked finite 4×4 matrix computation.

## Model

- `g5 = !![0,0,1,0; 0,0,0,1; 1,0,0,0; 0,1,0,0]` : ℚ 4×4 — the Dirac-representation
  `gamma5 = i·gamma0·gamma1·gamma2·gamma3`, the real block off-diagonal identity.
- `PL = (1/2) • (1 - g5)`, `PR = (1/2) • (1 + g5)` — the chiral projectors
  `P_L = (1 - gamma5)/2`, `P_R = (1 + gamma5)/2` (entries in `{0, 1/2, -1/2}`).

## Results (all with `#print axioms` footprint `[propext, Classical.choice, Quot.sound]`)

1. `g5_involutive` : `g5 * g5 = 1` — gamma5 squares to the identity.
2. `g5_traceless` : `Matrix.trace g5 = 0` — equal left/right chirality dimensions.
3. `projectors_complete` : `PL + PR = 1` — the two chiralities exhaust the spinor.
4. `projectors_idempotent` : `PL * PL = PL ∧ PR * PR = PR` — each is a projector.
5. `projectors_orthogonal` : `PL * PR = 0 ∧ PR * PL = 0` — the chiralities are disjoint.
6. `chirality_eigenvalues` : `g5 * PL = -PL ∧ g5 * PR = PR` — `PL`/`PR` project onto the
   `-1`/`+1` eigenspaces of gamma5.
7. `projector_ranks` : `Matrix.trace PL = 2 ∧ Matrix.trace PR = 2` — each chirality sector
   is 2-dimensional (a 2-component Weyl spinor).
8. `weyl_decomposition_verdict` : the packaged verdict bundling all of the above together
   with the non-degeneracy facts.

Non-degeneracy (proved, in `g5_nontrivial`, `projectors_nontrivial`, and bundled into the
verdict): `g5 ≠ 1`, `g5 ≠ -1` (nontrivial involution); `PL ≠ 0`, `PR ≠ 0`, `PL ≠ PR`;
explicit entry `PL 0 2 = -1/2`; and `trace PL = trace PR = 2` (not 0 or 4).

Each headline theorem carries an in-file
`#guard_msgs (whitespace := lax) in #print axioms <thm>` check pinning the axiom footprint
to exactly `[propext, Classical.choice, Quot.sound]`. No `sorry`/`admit`/`native_decide` and
no new axioms. Proofs use `Matrix.mul`/`trace` with `fin_cases`/`simp`/`norm_num`/`ring`.

## Verdict

In the Dirac representation, `gamma5` is a traceless involution; the chiral projectors
`P_L, P_R = (1 ∓ gamma5)/2` are a complete pair of orthogonal idempotents projecting the
Dirac 4-spinor onto its two 2-dimensional chirality (Weyl) sectors — the `-1`/`+1`
eigenspaces of `gamma5`. The Dirac 4-spinor thus splits as left Weyl (2) ⊕ right Weyl (2).

Honest scope: this is the finite projector algebra only (not the Lorentz representation or
the mass coupling).

## Provenance

PhysLean `Fermion.LeftHandedWeyl` / `RightHandedWeyl` and its `gamma5` — used as a
reference / convention only, **NOT** imported. This development is clean-room and depends on
Mathlib only.
