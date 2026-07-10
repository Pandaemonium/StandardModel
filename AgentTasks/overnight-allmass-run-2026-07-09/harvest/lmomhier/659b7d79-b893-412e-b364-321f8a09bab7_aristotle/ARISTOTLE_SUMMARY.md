# Summary of changes for run 659b7d79-b893-412e-b364-321f8a09bab7
Delivered `RequestProject/Main.lean` (namespace `LambdaMomentHierarchy`) plus `ARISTOTLE_SUMMARY.md`. The file builds cleanly under the constraints: no `sorry`/`admit`/`native_decide`/new axioms, Mathlib only, no `Complex`/`Real.sqrt`/`cos`/`sin`/`nlinarith`, using only `ring`/`norm_num`/`simp` and the Matrix trace API on small explicit rational matrices. Each of the four headline theorems carries an in-file `#guard_msgs (whitespace := lax) in #print axioms ⋯` confirming the footprint is exactly `[propext, Classical.choice, Quot.sound]`.

Model: one explicit 4×4 rational Dirac operator `D = Dgrav + Dmatter` (nonzero soldering block coupling 2, nonzero matter block coupling 3; non-degeneracy in `parts_nonzero`), a two-coupling family `Dfam g m`, an explicit deformation `Pert`, and the single functional split into moments `order0 a0 M = a0·tr 1` (operator argument ignored — the channel-blindness core), `order2 a2 M = a2·tr(M²)`, `order4 a4 M = a4·tr(M⁴)`, `S = order0 + order2 + order4`.

Targets:
1. `moment_hierarchy`: order-0 = `a0·4` (carries neither coupling), order-2 = `a2·(2g²+2m²)` (soldering), order-4 = `a4·(2g⁴+2m⁴)` (matter), and `S` equals their sum.
2. `order0_deformation_invariant` (payload): for all dimensions `n` and all rational `Pert`, `order0 a0 (Dop+Pert) = order0 a0 Dop` and `= a0·n` — Λ has no operator pathway; only the count moves it.
3. `only_count_touches_lambda`: with explicit `D`, `Pert`, all values in-theorem — `tr 1 = 4` fixed while `tr(D²): 26→36` and `tr(D⁴): 194→324`, plus the `≠` facts.
4. `hierarchy_verdict`: packages order-0 invariance (all dimensions/deformations), the three-moment split on `D`, and the order-2/order-4 sensitivity.

Honest scope is recorded: this is a finite polynomial-moment avatar; the physical identifications stay at level [C], while the finite matrix-trace structure (notably exact order-0 invariance) is fully proved. Work committed and pushed.

# Lambda / gravity / matter as the 0 / 2 / 4 moments of one spectral functional

**File:** `RequestProject/Main.lean` — **namespace** `LambdaMomentHierarchy`.

Kernel-checked, `sorry`/`admit`/`native_decide`/axiom-free, Mathlib only, no `Complex`, no
`Real.sqrt/cos/sin`, no `nlinarith`. Axiom footprint verified in-file to be **exactly**
`[propext, Classical.choice, Quot.sound]` via `#guard_msgs (whitespace := lax) in #print axioms ⋯`
on each of the four headlines.

## The model (explicit, finite, rational)

- One finite rational Dirac operator on a 4-dimensional carrier, `D = Dgrav + Dmatter`, with an
  explicit nonzero soldering/gravity block (coupling `2`) and an explicit nonzero matter block
  (coupling `3`). Non-degeneracy proved as `parts_nonzero : Dgrav ≠ 0 ∧ Dmatter ≠ 0`.
- The two-coupling family `Dfam g m` (soldering coupling `g`, matter coupling `m`).
- The single spectral functional split into three moments:
  - `order0 a0 M = a0 * tr 1`  (the operator argument is **ignored** — the channel-blindness core),
  - `order2 a2 M = a2 * tr (M^2)`,
  - `order4 a4 M = a4 * tr (M^4)`,
  - `S a0 a2 a4 M = order0 + order2 + order4`.
- An explicit rational deformation `Pert` (a soldering-channel coupling).

## Targets delivered

1. **`moment_hierarchy`** — one functional, three moments. For all couplings `g m` and coefficients:
   `order0 = a0 * 4` (carries **neither** coupling), `order2 = a2 * (2g² + 2m²)` (soldering),
   `order4 = a4 * (2g⁴ + 2m⁴)` (matter), and `S` is exactly their sum.
2. **`order0_deformation_invariant`** (payload) — for **all** `n` and **all** rational `Pert`,
   `order0 a0 (Dop + Pert) = order0 a0 Dop` and `order0 a0 Dop = a0 * n`. The order-0 term has no
   pathway from any operator deformation: Λ is blind to all dynamics; only the count `n` can move it.
3. **`only_count_touches_lambda`** (contrast) — with the explicit `D` and `Pert`, all values in
   theorem: `tr 1 = 4` (fixed), while the gravity moment `tr(D²)` moves `26 → 36` and the matter
   moment `tr(D⁴)` moves `194 → 324`, with the corresponding `≠` facts. Gravity and matter are
   deformation-sensitive; Λ is not.
4. **`hierarchy_verdict`** (package) — combines: (a) order-0 invariance under every deformation in
   every dimension; (b) the functional equals the sum of its three moments on `D`; (c) yet the
   order-2 and order-4 moments genuinely change under `Pert`.

## Honest scope

This is a finite polynomial-moment **avatar** of the spectral action. The physical identifications
(order 0 ↔ Λ, order 2 ↔ gravity, order 4 ↔ matter) remain at confidence level **[C]**; what is
formally proved is the finite matrix-trace structure, in particular the exact order-0 invariance.
