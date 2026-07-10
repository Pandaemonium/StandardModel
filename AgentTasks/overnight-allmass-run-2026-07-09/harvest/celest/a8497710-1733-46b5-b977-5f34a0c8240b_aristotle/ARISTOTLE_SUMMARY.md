# Summary of changes for run a8497710-1733-46b5-b977-5f34a0c8240b
Delivered `RequestProject/Main.lean` (namespace `CelestialSphericalCode`) plus `ARISTOTLE_SUMMARY.md`, a finite **rational** avatar of the spherical-code / spherical-design notion — no `Real`/`Complex`, no `arccos`/`sqrt`/`cos`, no high-degree `nlinarith`, Mathlib only. Builds clean under 3 min with no `sorry`/`admit`/`native_decide`/new axioms.

Model: null directions are rational unit vectors `u : Fin 3 → ℚ` with `dot u u = 1`; `dot u v = ∑ᵢ uᵢvᵢ`; the mass of a two-edge state is the chordal separation `chordSq u v = ∑ᵢ (uᵢ - vᵢ)²`; frame operator `frameOp U i j = ∑ₖ (U k)i·(U k)j`.

Theorems proved:
1. `chord_eq_two_sub_two_inner`: for unit vectors, `chordSq u v = 2 - 2·dot u v`; with `chordSq_nonneg` and `chordSq_le_four` this yields `0 ≤ chordSq u v ≤ 4`.
2. `massless_iff_collinear` (payload): `chordSq u v = 0 ↔ u = v` (coincident = massless); `chordSq_antipode`: `chordSq u (-u) = 4` (maximal).
3. `orthoframe_is_tight_frame` (design core): the coordinate frame `![e0,e1,e2]` has isotropic frame operator `frameOp orthoframe = I` — a tight frame / spherical 2-design.
4. `spherical_code_verdict`: packages all of the above; `control_not_tight` + `control_entries` supply the explicit non-tight control `![e0,e0,e1]` (entry `(0,0)=2`, `(2,2)=0`, so not any scalar multiple of `I`); `nondegeneracy_witnesses` records explicit rationals (`dot e0 e0 = 1`, `dot pyth pyth = 1` for the Pythagorean point `(3/5,4/5,0)`, `chordSq e0 e1 = 2`, `chordSq e0 (-e0) = 4`).

Every headline carries an in-file `#guard_msgs (whitespace := lax) in #print axioms …` check; the verified footprint is exactly `[propext, Classical.choice, Quot.sound]`. The summary file includes the required provenance line (Sphere-Packing-Lean / LeanCamCombi as reference, not import) and the honest-scope note. All changes committed and pushed.

# Celestial spherical code — mass = chordal separation of null directions

A finite, **rational** avatar (no `Real.sqrt`/`cos`/`sin`/`arccos`, no `Complex`) of the
spherical-code / spherical-design notions, formalized in `RequestProject/Main.lean`
(namespace `CelestialSphericalCode`).

## Model

Null directions on the celestial 2-sphere are rational unit vectors `u : Fin 3 → ℚ`
with `dot u u = 1` (rational points on `S²`, e.g. the coordinate frame `e0,e1,e2` or the
Pythagorean point `(3/5, 4/5, 0)`).

* `dot u v = ∑ᵢ uᵢ vᵢ` — rational inner product.
* `chordSq u v = ∑ᵢ (uᵢ - vᵢ)²` — chordal distance squared = the (rational) **mass** of
  the two-edge state.
* `frameOp U i j = ∑ₖ (U k) i · (U k) j` — the frame operator (sum of outer products).
* `orthoframe = ![e0,e1,e2]`, `control = ![e0,e0,e1]`.

## Results (all kernel-checked, no `sorry`/`native_decide`/new axioms)

1. `chord_eq_two_sub_two_inner` — for unit vectors, `chordSq u v = 2 - 2 · dot u v`;
   with `chordSq_nonneg` and `chordSq_le_four` this gives `0 ≤ chordSq u v ≤ 4`.
2. `massless_iff_collinear` (payload) — `chordSq u v = 0 ↔ u = v`: the mass vanishes
   exactly when the two null edges point the same way. `chordSq_antipode` gives the
   maximal separation `chordSq u (-u) = 4`.
3. `orthoframe_is_tight_frame` (design core) — the coordinate frame is a tight frame /
   spherical 2-design: `frameOp orthoframe = I` (isotropic frame operator).
4. `spherical_code_verdict` — packages all of the above. `control_not_tight` and
   `control_entries` give the explicit non-tight control (`frameOp control` has entry
   `(0,0) = 2` but `(2,2) = 0`, hence not any scalar multiple of `I`), showing tightness
   is a real constraint. `nondegeneracy_witnesses` records the explicit rational values
   (`dot e0 e0 = 1`, `dot pyth pyth = 1`, `chordSq e0 e1 = 2`, `chordSq e0 (-e0) = 4`).

Each headline carries an in-file `#guard_msgs (whitespace := lax) in #print axioms …`
check; the footprint is exactly `[propext, Classical.choice, Quot.sound]`.

## Provenance

Reference / provenance (NOT an import; version-pinned, clean-room): the spherical-code /
spherical-design programs — **Sphere-Packing-Lean** and **LeanCamCombi**
(Delsarte–Goethals–Seidel designs, tight frames). This development uses **Mathlib only**.

## Honest scope

A finite rational avatar of spherical codes / designs on `S²`. It is *not* a claim about
physical multiplets' quantum numbers.
