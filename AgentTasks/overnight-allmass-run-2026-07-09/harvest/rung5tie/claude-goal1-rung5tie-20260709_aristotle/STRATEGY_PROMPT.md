# Goal I rung-5 tie — bind the negative closure share to the ACTUAL bound eigenvector

## Context (blind to the wider repo; seeds in `seeds/`, Mathlib only)

`seeds/Goal1Hadron.lean` (namespace `Goal1Hadron`) is a landed verified toy hadron
on the 12-dim `Cl(4) (x) C^3` carrier. Its rung 3 (`rung3_bound_below_threshold`)
gives an explicit two-body color-singlet Hamiltonian `H2 d kappa` (a `3x3` real
matrix) with, for the witness `d=(0,1,7)`, `kappa=4`, a bound ground energy `-1`
that is the least eigenvalue and lies below the two-constituent threshold. Its
rung 5 (`rung5_signed_budget`) currently shows a channel budget `b_A=3/2, b_C=-1/2,
b_T=0` summing to 1 with `b_C<0` — BUT as a *modelled witness*, NOT computed from
the rung-3 bound eigenvector. This is the one honest gap in the result.

## Target (close the gap)

Compute the channel budget OF THE ACTUAL rung-3 bound eigenvector and prove its
closure share is negative.

1. `bound_eigenvector`: exhibit the explicit eigenvector `v` of `H2 (0,1,7) 4` for
   eigenvalue `-1` (the bound ground state), as an explicit RATIONAL vector in
   `Fin 3 -> Q` (or `-> R` with rational entries), and prove `H2 (0,1,7) 4 *ᵥ v =
   (-1) • v` and `v != 0` by direct computation.
2. `bound_budget_from_eigenvector`: define the channel shares `b_A, b_C, b_T` as
   the (normalized) expectations of the aperture/closure/turn parts of `H2` in the
   state `v` — i.e. `b_X = <v, H_X v> / <v, H2 v>` with `H2 = H_A + H_C + H_T` the
   channel split — and prove they are exact rationals summing to `1` with
   **`b_C < 0`** (binding realized as the bound STATE's negative closure share,
   the Ji-shaped statement, now dynamically tied to rung 3).
   **MANDATORY:** the shares must be computed from the eigenvector `v` of rung 3,
   not posited; state `<v, H2 v> = -1 * <v,v>` (consistency with the eigenvalue) in
   the theorem.

## Kill (a real result)

- The bound eigenvector's actual closure share is `>= 0` (binding is not
  closure-driven for the true ground state — would falsify the P-D reading on this
  carrier).

## Constraints (HARD — including build performance)

Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint
exactly `[propext, Classical.choice, Quot.sound]`, verified in-file with
`#guard_msgs (whitespace := lax) in #print axioms <thm>` on every headline theorem.

**BUILD PERFORMANCE (critical): the deliverable MUST build in-project in under ~3
minutes.** Keep every proof computationally cheap: use EXACT RATIONAL arithmetic
(`Rat`/rational-entry `Matrix ... Q` or `... R`), `decide`/`norm_num`/`ring` on
rationals, and explicit rational eigenvectors. **Do NOT** use `Real.cos`/`Real.sin`/
`Real.sqrt` in any fixture, and avoid `nlinarith` on transcendental reals — those
make the module take 10+ minutes to elaborate and it will be rejected. Everything
here is rational (eigenvalue `-1`, integer matrix `H2`), so this is achievable.

Deliver `RequestProject/Main.lean` (namespace `Goal1Rung5Tie`) + `ARISTOTLE_SUMMARY.md`:
the explicit rational eigenvector, the three shares as exact rationals, the `b_C<0`
value, and confirmation the budget is computed from `v` (not posited).
