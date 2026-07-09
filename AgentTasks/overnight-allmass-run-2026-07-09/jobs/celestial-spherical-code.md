# claude-celestial-spherical-code — mass = chordal separation of null directions on the celestial sphere; a massless multiplet is a tight frame (spherical-code/design port)

## Context (blind to any repo; self-contained finite linear algebra, Mathlib only)

Port the spherical-code / spherical-design notion (as in the Sphere-Packing-Lean and LeanCamCombi
programs; Delsarte-Goethals-Seidel designs, tight frames) -- reference/provenance, NOT an import
(version-pinned). Each null edge is a direction on the celestial 2-sphere. The MASS of a two-edge
state is the CHORDAL SEPARATION of the two null directions: coincident directions (chordal distance 0)
= collinear = massless; separated = massive. A maximally symmetric massless multiplet -- a set of null
directions in perfect balance -- is a TIGHT FRAME / spherical 2-design (the sum of their outer products
is isotropic). Prove the finite, RATIONAL version (chordal distances, no arccos/transcendental).

## The model (finite, rational; Fin 3 -> Q unit vectors)

Null directions as rational unit vectors `u : Fin 3 -> Q` with `inner u u = 1` (rational points on S^2,
e.g. the coordinate frame `e0,e1,e2`, or Pythagorean-triple points like `(3/5,4/5,0)`). Inner product
`inner u v = sum_i u i * v i`. Chordal distance squared `chordSq u v = sum_i (u i - v i)^2`. The mass of
the pair is `chordSq` (the null-disagreement, rational). A configuration `U : Fin n -> (Fin 3 -> Q)`.
Frame operator `S U = sum_k (outer (U k) (U k))` (the 3x3 rational matrix `sum_k U k i * U k j`).

## Targets (rational; ring/norm_num/decide/fin_cases/Finset; NO Real, NO Complex, NO nlinarith deg>=3)

1. `chord_eq_two_sub_two_inner`: for unit vectors (`inner u u = 1`, `inner v v = 1`),
   `chordSq u v = 2 - 2 * inner u v`. Pure `Finset`/`ring` expansion. Hence `0 <= chordSq u v <= 4`.
2. `massless_iff_collinear` (payload): `chordSq u v = 0 <-> u = v` (coincident null directions =
   massless), and for the antipode `chordSq u (-u) = 4` (maximal). The mass reads off the chordal gap;
   it vanishes exactly when the two null edges point the same way. Explicit.
3. `orthoframe_is_tight_frame` (payload -- the design core): the coordinate frame `U = ![e0,e1,e2]`
   is a spherical **tight frame / 2-design**: its frame operator is isotropic, `S U = I` (the `3x3`
   identity), equivalently `sum_k outer (U k)(U k) = (n/d) . I` with `n=d=3`. Prove `S U = 1` by
   `decide`/`fin_cases` + `ring` on the explicit rational entries. (This is the finite tight-frame /
   Delsarte 2-design condition: the massless multiplet is in perfect isotropic balance.)
4. `spherical_code_verdict`: package -- mass = chordal separation of the two null directions
   (`chordSq = 2 - 2 inner`), zero iff collinear (massless), maximal `4` at the antipode; and a
   balanced massless multiplet is a tight frame / spherical 2-design (`S = I` for the ortho frame),
   with an explicit non-tight control configuration (`S != c.I`, e.g. two equal directions) to show
   tightness is a real constraint. Honest scope: a finite rational avatar of spherical codes/designs
   on S^2; provenance = the spherical-code/design programs (Sphere-Packing-Lean / LeanCamCombi),
   clean-room. Not a claim about physical multiplets' quantum numbers.

MANDATORY non-degeneracy: explicit rational unit vectors (coordinate frame + a Pythagorean point like
`(3/5,4/5,0)`); `chordSq` values as explicit rationals (0 for coincident, 4 for antipode, `2` for
orthogonal); the tight frame `S(orthoframe) = I`; a NON-tight control `S(![e0,e0,e1]) != c.I` (an
explicit off-isotropic entry). All in-theorem.

## Constraints (HARD -- buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only (Sphere-Packing-Lean /
LeanCamCombi are REFERENCE, not imports). Footprint exactly [propext, Classical.choice, Quot.sound];
in-file `#guard_msgs (whitespace := lax) in #print axioms <thm>` on every headline. Rational `Fin 3`
vectors + `Finset.sum` + `Matrix`; ring/norm_num/decide/fin_cases; NO Real.sqrt/cos/sin/arccos, NO
Complex, NO nlinarith deg>=3. Build under 3 min. Deliver RequestProject/Main.lean (namespace
CelestialSphericalCode) + ARISTOTLE_SUMMARY.md WITH the spherical-code/design provenance line.
