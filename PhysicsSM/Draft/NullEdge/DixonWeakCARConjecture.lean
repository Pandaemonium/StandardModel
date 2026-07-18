import PhysicsSM.Draft.NullEdge.DixonWeakLadders

/-!
# Pre-registered conjecture: the eq-31 weak CAR as an OPERATOR relation (Furey 1806.00612)

**Status: DRAFT / pre-registered conjecture. The CAR theorems carry `s o r r y`
as handoff markers - this is the Aristotle target, not a claimed result.**

SM-branch, item 2. This file states the CORRECT (operator-level) form of Furey's
eq-31 weak Clifford CAR, after the kernel-checked finding that the ELEMENT-level
CAR fails (`DixonWeakLadders.betaH_like_anticomm_ne_zero`: `{beta_1,beta_2}_element
= 1/2 != 0`). It does NOT assert the CAR; it pins the two candidate operator
readings and a kill-condition so a proof attempt (Aristotle) is well-posed.

## What is KERNEL-CERTAIN (upstream, do not re-litigate)

* `DixonAlgebra` (sorry-free): `C(x)H(x)O` with `i_j^2=-1`, `i_1 i_2 = i_3`,
  `{i_j,i_k}=0` (`i1_i2_anticomm`), and `ofColour_comm_i_j` (H commutes with colour).
* `DixonWeakLadders` (sorry-free): the faithful eq-30 elements `betaH1 =
  (1/2)(-i_2 + i i_1 tau_1)`, `betaH2 = omega‡ i i_1`, the `‡` `conjH`, and
  `betaH_like_anticomm_ne_zero` (element `{beta_1,beta_2} = 1/2`).
* Colour ladders satisfy the CAR at the ELEMENT level (`LadderOperators`:
  `alpha_i alpha_j‡ + alpha_j‡ alpha_i = delta_ij` in `C(x)O`), and `{omega,omega‡}
  = 1` (the two complementary idempotents `(1 -+ i e_111)/2` sum to `1`).

## Grounding of the operator reading (Furey PDF, eq. 8, 13; p.4-5, p.8)

* States are minimal left ideals `Psi = Cl(2n) v` on an idempotent vacuum `v`
  (eq. 8); `z = 1` is NOT a physical state.
* Dirac generators are BAR operators (eq. 13): `gamma^0 = 1|i_1`,
  `gamma^1 = i_1|i_2`, `gamma^2 = i_2|i_2`, `gamma^3 = i_3|i_2`, where
  `(x|y) z = x z y`.
* LEFT multiplication rotates spin; RIGHT multiplication rotates chirality (p.4-5).
  The weak `Cl(4)` is TWO RIGHT actions (chirality on `C(x)H`, isospin on `C(x)O`)
  (p.8).

## The two candidate operator readings (this is the open question)

(A) **RIGHT-action operators on the ideal.** `R_{beta}(z) = z * beta`, and the CAR
    holds for `z` in the leptonic ideal `L = v_w * Cl(4)` (eq. 32,
    `v_w = beta_1‡ beta_2‡ beta_2 beta_1`). The element `1/2` is irrelevant because
    `1 not in L`. This matches Furey's explicit "right action" + the `Psi=Cl(2n)v`
    construction. **Conjectured PRIMARY reading; stated below.**
(B) **BAR operators on all of `C(x)H(x)O`.** `(x|y) z = x z y`; here `(x|y) 1 = x y`
    is NOT the element product, so `1/2` is again no obstruction. Matches eq. 13's
    explicit `x|y` Dirac generators. Fallback if (A) is refuted.

## Kill-condition (pre-registered)

If BOTH (A) [these ideal-restricted statements] AND (B) [the bar-operator CAR] are
kernel-REFUTED for these eq-30 `beta` definitions, then the `beta` translation
itself (sign / factor / which `H`-triple / parenthesization) is wrong and must be
re-derived from the PDF before any weak-CAR claim. A refutation is a genuine result.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.DixonWeakCARConjecture

open PhysicsSM.Draft.NullEdge.DixonAlgebra
open PhysicsSM.Draft.NullEdge.DixonWeakLadders

/-- The weak leptonic vacuum `v_w = beta_1‡ beta_2‡ beta_2 beta_1` (eq. 32),
left-associated. The ideal is `L = v_w * Cl(4)` (all `v_w * c`). -/
def vw : Dixon := ((betaH1dag * betaH2dag) * betaH2) * betaH1

/-- **(A) Like-CAR on the ideal**, `{R_{beta_1}, R_{beta_2}} = 0` on `L`: for every
`c`, with `z = v_w * c`, `(z beta_2) beta_1 + (z beta_1) beta_2 = 0`. Conjecture. -/
theorem betaH_like_CAR_on_ideal (c : Dixon) :
    ((vw * c) * betaH2) * betaH1 + ((vw * c) * betaH1) * betaH2 = 0 := by
  sorry

/-- **(A) Mixed off-diagonal CAR on the ideal**, `{R_{beta_1}, R_{beta_2}‡} = 0`
(`delta_12 = 0`). Conjecture. -/
theorem betaH_mixed_CAR_on_ideal (c : Dixon) :
    ((vw * c) * betaH2dag) * betaH1 + ((vw * c) * betaH1) * betaH2dag = 0 := by
  sorry

/-- **(A) Mixed diagonal CAR on the ideal**, `{R_{beta_1}, R_{beta_1}‡} = 1`
(`delta_11 = 1`): the right-action anticommutator is the identity ON `L`. Conjecture. -/
theorem betaH_diag_CAR_on_ideal (c : Dixon) :
    ((vw * c) * betaH1dag) * betaH1 + ((vw * c) * betaH1) * betaH1dag = vw * c := by
  sorry

end PhysicsSM.Draft.NullEdge.DixonWeakCARConjecture
