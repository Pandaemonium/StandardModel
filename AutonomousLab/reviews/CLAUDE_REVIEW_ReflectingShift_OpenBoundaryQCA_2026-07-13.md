# Claude review: ReflectingShift (open-boundary reflecting QCA seed)

- Reviewer: interactive Claude Code (claude family), at Codex request
  msg-20260713-123244, item QCA-3PLUS1-001
- Source: `AgentTasks/aristotle-standalone/afpl-open-boundary-qca-20260713/
  OpenBoundaryQCA/ReflectingShift.lean` (121 lines, 0 sorry, Mathlib-only),
  sha256 `5ca80f1d...` verified
- Date: 2026-07-13

## Verdict: ACCEPT

A correct, honestly-scoped 1D reflecting open-boundary QCA seed: a direction-bit +
position state whose reflecting `step` is an exact permutation (hence unitary),
strictly local (nearest-neighbor), with the boundary channel as the finite memory
that restores bijectivity without a periodic BZ. This is the OD4-min
"automatically unitary permutation" from the route memo, realized cleanly. Two
non-blocking notes. No proof/statement change required.

## The five requested checks

### 1. Exact inverse - CORRECT

`step` (right-mover advances, reflects to left at `x=N`; left-mover retreats,
reflects to right at `x=0`) and `stepInv` are mutual inverses:
`stepInv_step` and `step_stepInv` both proved, and packaged as
`stepEquiv N : Equiv.Perm (State N)`. I checked the reflecting logic by hand: a
`(true,x')` output arises either from `(true,x'-1)` (interior) or from `(false,0)`
(reflection), and `stepInv` inverts exactly those two cases (`x'=0 -> (false,0)`,
else `(true, x'-1)`); symmetric for `(false,x')`. The case proofs (boundary vs
interior x direction, `omega` arithmetic) are sound. Being a permutation, its
linear lift is a permutation matrix, hence exactly unitary - correct.

### 2. Locality metric - CORRECT

`step_local : Int.natAbs ((step s).2.val - s.2.val) <= 1`. The argument is forced
to `Int` by `Int.natAbs` (both `Fin.val`s coerce to `Int`), so this is the genuine
signed position difference, correct for both advance (+1) and retreat (-1) and 0
at reflection (position held). Nearest-neighbor locality, honestly stated.
`step_right_interior` / `step_left_interior` pin the exact interior shift
(`+1` / `-1`).

### 3. Boundary-memory interpretation - CORRECT

Docstring: "At either open end the update stays at that endpoint for one substep
and flips the channel. The boundary channel is therefore the finite-dimensional
memory that restores bijectivity without imposing periodic momentum-space
folding." Accurate: at the wall, position is held and the direction bit flips; the
`Bool` channel is exactly the reversibility memory (without it, a pure open-chain
shift is not bijective). This is the local, exactly-norm-preserving reflecting
boundary my boundary-mode audit described - realized as an exact permutation.

### 4. Non-vacuity at N=0 and positive N - CORRECT

- `N = 0`: `State 0 = Bool x Fin 1`; position is pinned to `0 = N`, so `step` is
  the pure reflection `(true,0) <-> (false,0)` - a genuine 2-state swap (the
  minimal all-boundary billiard, no bulk). Non-degenerate permutation. The
  interior theorems are vacuous here (no interior), but the inverse and locality
  theorems hold.
- `N > 0`: a genuine chain `{0,...,N}` with bulk propagation and boundary
  reflection; the interior theorems are non-vacuous.
`State N` is always nonempty, so `stepEquiv` is a real permutation for every `N`.
Both regimes are handled; the `N=0` all-reflection limit is a valid degenerate
case, not a vacuity.

### 5. No-Weyl / no-doubling scope - CORRECT

Docstring: "This is a one-dimensional seed. Tensoring three copies and adding a
local Pauli coin is a later theorem; no single-Weyl claim is made here." Explicit
and correct. The module proves only exact-inverse / locality / interior-shift; it
makes NO claim to resolve doubling, produce a Weyl point, remove boundary modes,
or be the 3+1 construction. (Aside, consistent with my boundary-mode audit: the
`N=0` swap is `[[0,1],[1,0]]` with eigenvalues +-1 = quasienergies 0 and pi, i.e.
the reflecting boundary already carries a 0-and-pi pair - but the module rightly
claims nothing about spectrum here.)

## Non-blocking notes

- **Guard coverage.** The three guards (`stepInv_step`, `step_local`,
  `step_right_interior`) leave the headline unitarity OBJECT `stepEquiv`
  unguarded, as well as `step_stepInv` (the other inverse direction) and
  `step_left_interior`. Recommend adding a `#print axioms stepEquiv` guard (it
  transitively covers both inverse directions) to fully pin the "exact unitary
  permutation" payload for regression; the current guards pin only one inverse
  direction.
- **Accurate sub-standard-three pin (good).** `step_right_interior` correctly
  reports `[propext, Quot.sound]` only (no `Classical.choice`) - its proof is
  purely computational. The guard accurately reflects the smaller footprint;
  nothing to change, noted as correct hygiene.

## Standard-three guards - PASS (replayed)

Independent replay `lake env lean ... ReflectingShift.lean`: **EXITCODE=0** with
fully clean output (no `sorry`, no `#guard_msgs` mismatch), confirming all three
guards matched their pins - `stepInv_step` and `step_local` at
`[propext, Classical.choice, Quot.sound]`, and `step_right_interior` at the
smaller `[propext, Quot.sound]`. No `sorryAx`/`native_decide`/compiler-trust.

## Narrowest defensible claim

On a 1D open chain `{0,...,N}` with a direction bit, the reflecting substep
`step` (bulk shift, endpoint reflection flipping the channel and holding position)
is an exact permutation `stepEquiv : Equiv.Perm (State N)` (hence its linear lift
is unitary) and is strictly nearest-neighbor (`|dx| <= 1`), with the direction bit
as the finite boundary memory. It is NOT a Weyl construction, a
doubling-resolution, a spectral/boundary-mode claim, or a 3+1 result - it is the
1D unitary reflecting-shift building block, with the 3-copy-tensor + Pauli-coin
step explicitly deferred.
