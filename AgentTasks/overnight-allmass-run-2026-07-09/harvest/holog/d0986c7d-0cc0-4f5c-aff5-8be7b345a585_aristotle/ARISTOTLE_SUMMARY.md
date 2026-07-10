# Summary of changes for run d0986c7d-0cc0-4f5c-aff5-8be7b345a585
Delivered `RequestProject/Main.lean` (namespace `HolographicEdgeBound`) plus `ARISTOTLE_SUMMARY.md`, building cleanly under Lean/Mathlib in well under 3 minutes with no `sorry`/`admit`/`native_decide`/new axioms, no `Complex` or `Real.sqrt/cos/sin`.

Model: interior state space `V = ℚ^4`, boundary source space `Bnd = ℚ^3` (edge count `B = edges = 3`), an explicit rational restriction map `R = mulVecLin Rm : V → Bnd`, and physical sector `Phys = range P` for an explicit rational embedding `P : ℚ^2 → V`.

Targets proved:
1. `boundary_rank_le_edges` — `finrank (range R) ≤ edges` (rank R ≤ B).
2. `phys_injects_to_boundary` — `Set.InjOn R Phys` (physical states are boundary-determined), plus trivial-kernel form `phys_ker_restrict_eq_bot`. Injectivity is certified via an explicit left inverse `Lm` of `Rm*Pm`.
3. `holographic_bound` — `finrank Phys ≤ edges`, via the chain `dim Phys = rank(R|_Phys) ≤ rank R ≤ B`.
4. `entropy_area_form` — the area law `S ≤ A` (`S = dim Phys`, `A = B`), with `entropy_area_coeff` giving the explicit Bekenstein-style coefficient family `S ≤ c·A` for `c ≥ 1`.

Non-degeneracy/controls: `dim_phys_eq` (`= 2`), `phys_pos`, `edges_pos`, and `holographic_bound_numeric` packaging the concrete `dim Phys = 2 ∧ edges = 3 ∧ 0 < dim Phys ∧ 0 < edges ∧ dim Phys ≤ edges`. The control `interior_not_boundary_determined` exhibits the interior-only state `e₄` that is nonzero, in `ker R`, and not in `Phys` — so global injectivity fails and reconstruction is a genuine hypothesis on `Phys`.

Every headline theorem carries an in-file `#guard_msgs (whitespace := lax) in #print axioms <thm>` audit; the verified footprint is exactly `[propext, Classical.choice, Quot.sound]`.

Scope is stated honestly in `ARISTOTLE_SUMMARY.md`: this is a finite linear-algebra (rank/finrank over ℚ) avatar of the holographic "boundary bounds interior" bound, not the covariant entropy bound of real gravity. All work is committed and pushed.

# A finite holographic / Bekenstein edge bound

`RequestProject/Main.lean` (namespace `HolographicEdgeBound`) formalizes a **finite
linear-algebra avatar** of the holographic principle / Bekenstein bound: the physical
degrees of freedom of a region are bounded by its *boundary* null-edge count, not by its
interior volume.

## The model

* Interior state space `V = ℚ^4` (interior "volume" `= 4`).
* Boundary source space `Bnd = ℚ^3`, one coordinate per pierced null edge, so the edge
  count is `B = edges = 3` (the boundary "area").
* `R : V → Bnd` — the interior-to-boundary restriction (trace) map, an explicit rational
  linear map `Matrix.mulVecLin Rm`.
* `Phys ⊆ V` — the physical (positive-sector) subspace, realized as the range of an
  explicit rational embedding `P : ℚ^2 → V`.

## Results (all kernel-checked, footprint exactly `[propext, Classical.choice, Quot.sound]`)

1. `boundary_rank_le_edges` : `finrank (range R) ≤ edges` — the boundary restriction map
   has rank at most the boundary edge count `B` (its target has dimension `B`).
2. `phys_injects_to_boundary` : `Set.InjOn R Phys` — on the physical sector, the boundary
   restriction is injective (a physical state is determined by its boundary data). Also
   given in trivial-kernel form as `phys_ker_restrict_eq_bot`.
3. `holographic_bound` : `finrank Phys ≤ edges` — the payload. Proof chain:
   `dim Phys = rank (R|_Phys) ≤ rank R ≤ B`.
4. `entropy_area_form` : `entropy ≤ area`, i.e. the area law `S ≤ A`, reading `S = dim Phys`
   as region entropy and `A = B` as area. `entropy_area_coeff` carries an explicit
   Bekenstein-style coefficient `c ≥ 1` giving the `S ≤ c · A` family.

## Non-degeneracy and controls

* `dim_phys_eq` : `finrank Phys = 2`; `phys_pos`, `edges_pos` : both positive.
* `holographic_bound_numeric` : the concrete numeric witness
  `dim Phys = 2 ∧ edges = 3 ∧ 0 < dim Phys ∧ 0 < edges ∧ dim Phys ≤ edges`
  (the explicit inequality `2 ≤ 3`).
* `interior_not_boundary_determined` : the control. The interior-only state
  `e₄ = (0,0,0,1)` is non-zero, lies in `ker R`, and is NOT in `Phys`. Hence `R` is not
  globally injective, so injectivity on `Phys` (reconstruction) is a genuine hypothesis on
  the physical sector, not a property of all of `V`.

Each headline theorem carries an in-file
`#guard_msgs (whitespace := lax) in #print axioms <thm>` audit.

## Honest scope

This is a **finite linear-algebra** statement: rank/`finrank` bookkeeping over `ℚ` for an
explicit small restriction map and physical subspace. It is a faithful finite avatar of
the holographic "boundary bounds interior" idea, but it is **not** the covariant entropy
bound of real gravity, nor a statement about physical black-hole entropy. No `Complex`,
`Real.sqrt/cos/sin`, `native_decide`, `sorry`, or new axioms are used.
