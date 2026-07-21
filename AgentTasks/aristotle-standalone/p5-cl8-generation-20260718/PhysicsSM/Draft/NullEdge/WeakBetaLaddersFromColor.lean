import PhysicsSM.Algebra.Furey.LadderOperators

/-!
# The weak beta-ladders built from the colour ladders (Furey 1806.00612 eq. 29-31)

**Status: DRAFT / partial + Aristotle handoff. Contains `s o r r y`.**

SM-branch, item 2 (electroweak on the actual octonionic states). Grounded in the
ACTUAL Furey 1806.00612 PDF Section 5 (verified 2026-07-17; the earlier
`B_j = i e_7 | beta_j` design-note form was a conflation with the SU(5) paper).

## Faithful construction (verbatim)

The isospin `Cl(2)` generators are built from the COLOUR product
`omega = a_1 a_2 a_3` (the `alpha_i` of `LadderOperators`):

  `tau_1 = omega + omega‡,  tau_2 = i*omega - i*omega‡,
   tau_3 = omega*omega‡ - omega‡*omega`      (eq. 29)

The `Cl(4)` weak ladders (eq. 30), in a new basis, are

  `beta_1 = (1/2)(-e_2 + i*e_1*tau_1),   beta_2 = omega‡ * i * e_1`,

with the CAR relations (eq. 31)

  `{beta_i, beta_j} = {beta_i‡, beta_j‡} = 0,  {beta_i, beta_j‡} = delta_ij`
  for `i,j = 1,2`.

**Convention (pinned here):** Furey's `e_1, e_2` are the XOR units `e001 = c1`
and `e010 = c2` (read off from the landed `LadderOperators`: `alpha_2 =
(-e_3 + i e_1)/2 = (-e110 + i e001)/2` fixes `e_1 = e001 = c1`; `alpha_3` fixes
`e_2 = e010 = c2`). `omega‡ = alpha_3_dag * alpha_2_dag * alpha_1_dag` (dagger is
an anti-automorphism, so it reverses the colour-ladder order).

## What is DONE here (the definitions) vs handed to Aristotle

DONE (below, kernel-typechecked): the concrete `ComplexOctonion` definitions of
`omega, omegaDag, tau_1, tau_2, tau_3, beta_1, beta_2` from the repo's `alpha_i`.
This is the missing "beta-ladder" data the earlier Aristotle no-go (661e5230)
flagged - now shown to be `C(x)O`-constructible (NOT needing a separate `C(x)H`
substrate; that was an artifact of the conflated construction).

HANDED TO ARISTOTLE (the `s o r r y`s): the CAR relations `beta_cars`, and the
`beta_i` daggers, are an intricate non-associative octonionic computation. The
subsequent `su(2)_L` generators `T_j = tau_j (1/2)(1+i_3)` (eq. 35) and the
closure `T_+ = TPlusEnd` (via `WeakIsospinLadderDerived.TPlusEnd_unique`) are the
further steps.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.WeakBetaLaddersFromColor

open PhysicsSM.Algebra.Furey.LadderOperators
open PhysicsSM.Algebra.Octonion.ComplexOctonion

/-- The colour product `omega = a_1 a_2 a_3`. -/
def omega : ComplexOctonion := alpha1 * alpha2 * alpha3

/-- The dagger `omega‡ = a_3‡ a_2‡ a_1‡` (order-reversed, dagger an
anti-automorphism). -/
def omegaDag : ComplexOctonion := alpha3_dag * alpha2_dag * alpha1_dag

/-- The isospin `Cl(2)` generator `tau_1 = omega + omega‡` (eq. 29). -/
def tau1 : ComplexOctonion := omega + omegaDag
/-- `tau_2 = i*omega - i*omega‡` (eq. 29). -/
def tau2 : ComplexOctonion := I * omega + (-(I * omegaDag))
/-- `tau_3 = omega*omega‡ - omega‡*omega` (eq. 29). -/
def tau3 : ComplexOctonion := omega * omegaDag + (-(omegaDag * omega))

/-- Furey `e_1 = e001 = c1` embedded in `C(x)O` (see convention note). -/
def e1u : ComplexOctonion := ofOctonion ⟨0, 1, 0, 0, 0, 0, 0, 0⟩
/-- Furey `e_2 = e010 = c2` embedded in `C(x)O`. -/
def e2u : ComplexOctonion := ofOctonion ⟨0, 0, 1, 0, 0, 0, 0, 0⟩

/-- The weak ladder `beta_1 = (1/2)(-e_2 + i e_1 tau_1)` (eq. 30). -/
def beta1 : ComplexOctonion := (1 / 2 : ℂ) • ((-e2u) + I * e1u * tau1)
/-- The weak ladder `beta_2 = omega‡ i e_1` (eq. 30). -/
def beta2 : ComplexOctonion := omegaDag * I * e1u

/-! ## CAR check: these definitions FAIL the CAR (Aristotle 2f3fd545, kernel-proven)

Aristotle triggered the pre-registered kill condition and RIGOROUSLY REFUTED the
element-level (and left-action operator-level) CAR for the `beta_i` as defined
above: the off-diagonal like-anticommutator is `-1/2`, not `0`.

DIAGNOSIS (kernel-proven fact + two candidate fixes). The FACT: with these
definitions the LEFT-multiplication anticommutator `{beta_1, beta_2}` is exactly
`-1/2 * Id` (a scalar), not `0` (`beta12_left_action_anticommutator`). Two things
this rules the definitions to be missing, both needing more of the faithful
formalism:

1. **Right-action / bar operator.** Furey's Cl(4) weak sector is the RIGHT action
   (the `x|y` bar operator `x|y . z = x z y`, eqs 13/29 use it), NOT left
   multiplication. My `beta_i * -` is a LEFT action; the CAR is a relation for the
   right/bar action. The landed `ChiralityFromActionSplit` (left = chirality,
   right = isospin, "conceptually distinct actions do not mix") is exactly this
   distinction. So the CAR should be re-checked for the right/bar action.
2. **Quaternion units.** Eq. 30's `i_1, i_2` are (per eq. 13) Furey's `H`-units,
   possibly a different octonion triple than `e_1=c1, e_2=c2` used in `e1u,e2u`.

The `-1/2 * Id` scalar (a mixed-`delta`-like value) is the fingerprint that
`beta_2` currently behaves like a dagger of `beta_1` under LEFT mult. Sharpened
next step for item 2: rebuild the ladders as RIGHT/bar-operator actions (and/or
the `H`-triple units) and re-check the CAR. Genuine kernel-checked finding, not a
false-shape patch. -/

set_option maxRecDepth 10000 in
set_option maxHeartbeats 8000000 in
/-- The scalar coordinate witnessing failure of the off-diagonal
like-anticommutator: `{beta_1, beta_2}.re.c0 = -1/2`. (Aristotle 2f3fd545.) -/
theorem beta12_anticommutator_c0 :
    (beta1 * beta2 + beta2 * beta1).re.c0 = (-1 / 2 : ℝ) := by
  norm_num [beta1, beta2, tau1, I, e1u, e2u, alpha1, alpha2, alpha3,
    alpha1_dag, alpha2_dag, alpha3_dag, omega, omegaDag, ofOctonion]

/-- **The element-level CAR `{beta_1, beta_2} = 0` is FALSE for these (wrong-unit)
definitions** - so the eq-30 units must be the `H`-quaternion units, not the
octonion `e_1, e_2` used here (see diagnosis). -/
theorem beta12_anticommutator_ne_zero :
    beta1 * beta2 + beta2 * beta1 ≠ 0 := by
  intro h
  have hc : (beta1 * beta2 + beta2 * beta1).re.c0 = (0 : ComplexOctonion).re.c0 :=
    congrArg (fun x : ComplexOctonion => x.re.c0) h
  rw [beta12_anticommutator_c0] at hc
  norm_num at hc

set_option maxRecDepth 10000 in
set_option maxHeartbeats 8000000 in
/-- The left-action anticommutator is `-1/2` times the identity, so the
operator-level CAR fallback also fails for these definitions. (Aristotle 2f3fd545.) -/
theorem beta12_left_action_anticommutator (x : ComplexOctonion) :
    beta1 * (beta2 * x) + beta2 * (beta1 * x) = (-1 / 2 : ℂ) • x := by
  ext <;>
    simp [beta1, beta2, tau1, I, e1u, e2u, alpha1, alpha2, alpha3,
      alpha1_dag, alpha2_dag, alpha3_dag, omega, omegaDag, ofOctonion] <;>
    ring

end PhysicsSM.Draft.NullEdge.WeakBetaLaddersFromColor
