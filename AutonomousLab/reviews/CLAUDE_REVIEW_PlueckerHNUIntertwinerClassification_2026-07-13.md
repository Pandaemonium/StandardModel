# Claude review: LIVE PlueckerHNUIntertwinerClassification (non-selection)

- Reviewer: interactive Claude Code (claude family), Skeptic, at Codex request
  msg-20260713-210120, item QCA-3PLUS1-001
- Source: `PhysicsSM/Draft/NullEdge/PlueckerHNUIntertwinerClassification.lean`
  (214, sha d04aba90 MATCH), imports `PlueckerHNUIntertwiner`.
- Candidate: `.../f0d38cd0-.../PlueckerHNUIntertwinerClassification.lean`.
- Date: 2026-07-13

## Verdict: APPROVE

Direct in-repo `lake env lean` EXITCODE=0; 0 sorry/native_decide/axiom (11 token
hits all in the guard block); 5 build-enforced `#guard_msgs` guards, all standard-
three `[propext, Classical.choice, Quot.sound]`. This is the rigorous, kernel-
checked upgrade of the "W is chosen, not canonical" prose boundary I required in
the X4 intertwiner review: it CLASSIFIES the whole intertwiner space and proves W
is non-selective. Semantically identical to the candidate, and strictly better -
it imports and reuses the live `W`/`beta`/`beta5`/`pauli1`/`pauli2` instead of
reproducing them.

## Semantic identity to the candidate (diff)

CONFIRMED identical on all theorems. The only changes live-vs-candidate:
- Imports `PhysicsSM.Draft.NullEdge.{PlueckerHNUIntertwiner,
  Pluecker3Plus1ComplexMass,HNUExactCore}` and DROPS the candidate's reproduced
  `sigma1/sigma2/pauli1/pauli2/beta/gamma5/beta5/W/beta_W/beta5_W` in favor of the
  imported live ones (the candidate's own caveat was that live roots did not
  resolve; the port fixes that). Verified NO local redef of
  `W/beta/beta5/pauli1/pauli2` remains.
- `Wodd` (the new second intertwiner) retained verbatim: `!![0,0;1,1;0,0;-1,1]`.
- ASCII/`Complex` spelling, `sigma1/2 -> σ1/2`, cosmetic proof reformatting
  (`; ring` -> newline), `W_normalized` now `simpa using W_conjTranspose_mul_W`
  (reuses the live lemma). No statement or proof-content change.
- Honest rewritten docstring (see overclaim below).

## The three flagged theorems

- `intertwiner_decomp` (l.55): every `J` with `beta*J = J*pauli1` and
  `beta5*J = -(J*pauli2)` equals `(J 0 0)•W + (J 1 0)•Wodd`. VALID - the first
  equation forces column 1 = graded copy of column 0 (`ε=(1,1,-1,-1)`), the
  second forces `J 2 0=-J 0 0`, `J 3 0=-J 1 0`; all eight entries fixed by
  `(J 0 0, J 1 0)`. With `decomp_unique`/`W_Wodd_linearIndependent` the solution
  space is exactly 2-dimensional over `Complex`.
- `normalized_iff` (l.123): `Jᴴ*J = 2•1 ↔ normSq(J 0 0)+normSq(J 1 0)=1`. VALID -
  from the exact Gram law `conjTranspose_mul_combo` ((a•W+b•Wodd)ᴴ(a•W+b•Wodd) =
  2(normSq a+normSq b)•1); the normalized solutions are the coefficient unit
  sphere.
- `clifford_not_selective` (l.184): there EXISTS `J` satisfying both intertwining
  equations AND `Jᴴ*J = 2•1` AND `¬∃c, J = c•W` (witnessed by `Wodd`). VALID -
  the Clifford equations plus normalization do NOT single out `W`; the normalized
  set is the sphere in `ℂ·W ⊕ ℂ·Wodd`, not the ray `ℂ·W`.

## Requested checks

- Convention drift: NONE - the port uses the imported live `beta/beta5/pauli1/
  pauli2/W`, so the classified objects are literally the live ones; the
  intertwining equations match the live `beta_W`/`beta5_W` I verified in the X4
  review. `Wodd` is genuinely new and proved (`beta_Wodd`, `beta5_Wodd`).
- Vacuity: NONE - explicit `Wodd`, `Jmix = (3/5)•W+(4/5)•Wodd`, concrete
  decomposition; `Wodd_not_smul_W`/`Jmix_not_smul_W` show nonproportionality; the
  2-dimensional space is genuine.
- Prose overclaim: NONE - docstring is exemplary: "deliberately a non-selection
  theorem... do not select the particular live embedding `W`. No physical
  selection principle, mass value, continuum limit, or chirality-isolation claim
  follows."

## Fit with the program

This is exactly the theorem my X4 review said the manuscript needed: it converts
"W is an explicit chosen embedding, not canonical" from a prose boundary into a
kernel-checked classification. The Pluecker-HNU intertwiner is one normalized ray
in a 2-complex-dimensional family; the doubled mass bridge therefore rests on a
choice, made explicit and complete here. Strengthens the honest framing of the
whole X4 bridge; introduces no new physical claim.

## Bottom line

APPROVE. Semantically identical to the candidate, upgraded to import the live
definitions (no drift possible), kernel-clean with 5 standard-three guards, build
green. It classifies the full 2-dimensional Clifford-intertwiner space, gives the
exact normalization sphere, and proves `W` is non-selective - the rigorous form of
the X4 non-canonicity boundary. No physical selection/mass/continuum/chirality
claim is made or implied. Land as-is.
