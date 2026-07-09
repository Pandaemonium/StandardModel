# Proof: protected massless modes from a finite chiral index (F6)

## Context (blind to the wider repo)

A finite mathematical-physics program formalizes mass on null-edge Dirac carriers.
One of its frontiers is the mechanism that keeps some modes *massless* even when the
operator would generate mass: a **chiral index**. A finite chiral carrier is a
finite-dim complex space `V = V₊ ⊕ V₋` with an odd Dirac operator `D` (`D` maps
`V₊ → V₋` and `V₋ → V₊`, i.e. `D Γ = −Γ D` for the grading `Γ`). Mass terms are odd
perturbations. The chiral index `ind = dim V₊ − dim V₋` is a topological invariant
that *protects* zero modes.

## Targets (`src/ChiralIndexProtection.lean`, three documented `sorry`s)

1. `corner_ker_ge_index`: for the off-diagonal corner `A : Matrix (Fin nm) (Fin np) ℂ`
   of the odd operator, `np − nm ≤ finrank (ker (mulVecLin A))`. Pure rank–nullity:
   `A` is a map from an `np`-dim space to an `nm`-dim space, so its kernel has
   dimension `≥ np − nm` (use `LinearMap.finrank_le_finrank_of_injective` /
   `LinearMap.finrank_range_add_finrank_ker` / the rank–nullity theorem). Handle the
   `ℕ`-subtraction (`np − nm = 0` when `nm ≥ np`, trivially true).
2. `corner_ker_ge_index_perturbed`: the same bound holds for `A + A'` — the index
   `np − nm` depends only on the *dimensions*, not the map, so it is automatically
   perturbation-stable. (This is nearly the same proof as (1) applied to `A + A'`;
   the point is that the protected count cannot be lowered by any odd perturbation.)
3. `witness_one_protected_mode`: a concrete `np = 2`, `nm = 1` carrier (index `1`)
   has `≥ 1` protected zero mode — the "exactly one massless mode plus a finite
   massive pattern" statement. If clean, also show the count is **exactly** one for a
   full-rank corner.

The physical reading: a chiral asymmetry `dim V₊ ≠ dim V₋` forces `|ind|` massless
modes that *no* mass term (odd perturbation) can lift — the finite version of "the
lightest neutrino is protected massless." (This is the mode-count mechanism only;
mapping it to physical neutrino data needs a family index + scale map and is NOT in
scope.)

## Constraints

Kernel-checked only: no `sorry`/`admit`/`native_decide`/new `axiom`; footprint
`[propext, Classical.choice, Quot.sound]`, guarded in-file with `#print axioms`.
Mathlib only. Reformulate (raw `Matrix`, `LinearMap`, `Fin np ⊕ Fin nm`) as cleanest,
as long as the exported statements mean "a chiral index forces ≥ |ind| protected zero
modes, stable under odd perturbation." Deliver the file + `#print axioms` +
`ARISTOTLE_SUMMARY.md` (final statements, whether the witness count is exactly one,
any target that resisted).
