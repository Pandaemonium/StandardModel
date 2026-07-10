/-
# `carrier_graded_budget` — discharging the graded-budget hypothesis on the carrier

This file closes the call-08 organizing-theorem gap: it turns
`EquivariantGradedIndex.graded_budget_decomposition` — which pushes the
four-channel budget `4 D^#D = Q_A + Q_C + 4 Q_T + 4 E_#` through the graded
supertrace `sdim_g(A) = tr(Γ g A)` but takes the budget as an *assumed*
hypothesis — into a theorem `carrier_graded_budget` about the carrier's *own*
Dirac square, with NO free budget hypothesis.

## The bridge (design)

Two formalisms had to meet:

* the graded supertrace `sdim_g(A) = (Γ * g * A).trace` lives in the CONCRETE
  matrix ring `Matrix n n ℂ` (`EquivariantGradedIndex`), because a graded
  supertrace fundamentally needs a *trace* functional;
* the actual budget `4 (star D * D) = Q_A^# + Q_C^# + 4 Q_T + 4 E_#`
  (`CarrierKreinSquare.carrier_krein_square`) lives in the ABSTRACT carrier
  algebra `[CommRing R] [Ring B] [Algebra R B] [StarRing B] [StarModule R B]`.

**Route (a) — restating the graded index in the abstract algebra `B` — is
obstructed**: an arbitrary ring `B` has no trace, so `sdim_g` is not even
definable there. The obstruction is *essential*, not refactoring: the graded
supertrace is trace-shaped by nature.

**Route (b) — specializing the carrier budget to matrices — works cleanly.**
The decisive observation is that `Matrix n n ℂ` is SIMULTANEOUSLY

* an instance of the abstract carrier algebra (with `R := ℂ`, `B := Matrix n n ℂ`:
  it is a `Ring`, a `ℂ`-`Algebra`, a `StarRing` with `star = ᴴ`, and a
  `StarModule ℂ`), and
* the concrete home of the graded supertrace.

So the bridge is literally the instantiation `R := ℂ`, `B := Matrix n n ℂ`: the
carrier budget, proven generically, *is* a matrix identity, and that matrix
identity is exactly the hypothesis `graded_budget_decomposition` needs.

## What is reconstructed here, and why (obstruction report)

`CarrierKreinSquare.carrier_krein_square` and `CarrierSquareAssembly.carrier_square_assembly`
depend on a `PhysicsSM.Draft.NullEdge.Carrier.*` brick library
(`WeitzenbockMasterPair`, `CarrierPotentialTurn`, …) that is NOT part of this
project's import graph, so those two files do not elaborate here (`unknown module
prefix 'PhysicsSM'`). This is a *packaging* obstruction, not a mathematical one:
the identities are pure noncommutative-ring/`Finset`-sum algebra under the stated
hypotheses. The minimal unblocking change is to make that brick library an actual
dependency of this project; absent it, we reconstruct the two bricks the Krein
square needs (`weitzenbock_master_pair`, `potential_sq`) and the Krein square
itself (`carrier_krein_square`, a faithful copy of the source statement/proof)
self-containedly below, so `carrier_graded_budget` is fully discharged and
kernel-checked here. The original `src/CarrierKreinSquare.lean` and
`src/CarrierSquareAssembly.lean` are left untouched.

## Semantic alignment

The content is: *the graded-supertrace decomposition holds of the carrier's own
budget, not a hypothetical one.* The four kernel-defined channels `Q_A^#, Q_C^#,
Q_T, E_#` ARE the graded pieces of the carrier's Dirac square `4 D^#D`.
-/

import Mathlib
import src.EquivariantGradedIndex

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.Carrier.Bridge

/-! ## Reconstructed abstract carrier bricks (self-contained)

Faithful reconstructions of the `PhysicsSM.Draft.NullEdge.Carrier` bricks that
`carrier_krein_square` uses, so this file elaborates without the external brick
library. See the module docstring for the packaging-obstruction report. -/

variable {R B E : Type*} [CommRing R] [Ring B] [Algebra R B] [Fintype E]

/-- The soldered Dirac operator `D0 = ∑_e γ_e ∇_e`. -/
def solderedNC (gamma nabla : E → B) : B := ∑ e, gamma e * nabla e

/-
**Weitzenböck master (pair form).** For `γ` obeying the Clifford relation
`hcl`, and `m, n : E → B` each commuting with every `γ`, the mixed square
`(∑_e m_e γ_e)(∑_f γ_f n_f)` decomposes into a symmetric (aperture) block and an
antisymmetric (closure) block.
-/
theorem weitzenbock_master_pair (gamma : E → B) (m n : E → B) (g : E → E → R)
    (hcl : ∀ e f, gamma e * gamma f + gamma f * gamma e = algebraMap R B (g e f))
    (hcommM : ∀ e f, gamma e * m f = m f * gamma e) :
    (4 : R) • ((∑ e, m e * gamma e) * (∑ f, gamma f * n f))
      = (∑ e, ∑ f, g e f • (m e * n f + m f * n e))
        + (∑ e, ∑ f, (gamma e * gamma f - gamma f * gamma e)
            * (m e * n f - m f * n e)) := by
  simp +decide only [Finset.sum_mul _ _ _, Finset.mul_sum, mul_assoc];
  simp +decide only [← mul_assoc, Algebra.smul_def, ← Finset.sum_add_distrib];
  rw [ show ( algebraMap R B ) 4 = ( algebraMap R B ) 1 + ( algebraMap R B ) 1 + ( algebraMap R B ) 1 + ( algebraMap R B ) 1 by rw [ ← map_add, ← map_add, ← map_add ] ; norm_num ] ; simp +decide [ ← hcl, mul_add, add_mul, mul_assoc, Finset.mul_sum _ _ _, Finset.sum_add_distrib ] ;
  simp +decide only [mul_sub, sub_mul, mul_assoc];
  simp +decide only [Finset.sum_sub_distrib];
  simp +decide only [← mul_assoc, hcommM];
  rw [ ← Finset.sum_comm ] ; abel1;

/-- **The potential squares away the chirality.** With `Γ² = 1` and `Γφ = φΓ`,
`(Γφ)² = φ²`. -/
theorem potential_sq (Gamma phi : B) (hGammaSq : Gamma * Gamma = 1)
    (hPhiComm : Gamma * phi = phi * Gamma) :
    (Gamma * phi) ^ 2 = phi ^ 2 := by
  rw [pow_two, pow_two]
  have h : Gamma * phi * (Gamma * phi) = Gamma * Gamma * (phi * phi) := by
    have hpc : phi * Gamma = Gamma * phi := hPhiComm.symm
    calc Gamma * phi * (Gamma * phi) = Gamma * (phi * Gamma) * phi := by noncomm_ring
      _ = Gamma * (Gamma * phi) * phi := by rw [hpc]
      _ = Gamma * Gamma * (phi * phi) := by noncomm_ring
  rw [h, hGammaSq, one_mul]

variable [StarRing R] [StarRing B] [StarModule R B]

omit [StarRing R] [StarModule R B] in
/-- **The Krein square of the full carrier** (faithful reconstruction of
`CarrierKreinSquare.carrier_krein_square`).  `4 • (star D * D) = Q_A^# + Q_C^#
+ 4 Q_T + 4 E_#`. -/
theorem carrier_krein_square (gamma nabla : E → B) (Gamma phi : B) (g : E → E → R)
    (hcl : ∀ e f, gamma e * gamma f + gamma f * gamma e = algebraMap R B (g e f))
    (hcomm : ∀ e f, gamma e * nabla f = nabla f * gamma e)
    (hGammaSq : Gamma * Gamma = 1)
    (hGammaAnti : ∀ e, Gamma * gamma e = - (gamma e * Gamma))
    (hGammaNabla : ∀ e, Gamma * nabla e = nabla e * Gamma)
    (hPhiGamma : ∀ e, phi * gamma e = gamma e * phi)
    (hPhiComm : Gamma * phi = phi * Gamma)
    (hCov : ∀ e, nabla e * phi = phi * nabla e)
    (hgammaStar : ∀ e, star (gamma e) = gamma e)
    (hGammaStar : star Gamma = Gamma) (hphiStar : star phi = phi) :
    (4 : R) • (star (solderedNC gamma nabla + Gamma * phi)
        * (solderedNC gamma nabla + Gamma * phi))
      = (∑ e, ∑ f, g e f • (star (nabla e) * nabla f + star (nabla f) * nabla e))
        + (∑ e, ∑ f, (gamma e * gamma f - gamma f * gamma e)
            * (star (nabla e) * nabla f - star (nabla f) * nabla e))
        + (4 : R) • phi ^ 2
        + (4 : R) • (∑ e, gamma e * Gamma * (phi * (star (nabla e) - nabla e))) := by
  -- Derived commutation facts on the star-transports.
  have hcommMStar : ∀ e f, gamma e * star (nabla f) = star (nabla f) * gamma e := by
    intro e f
    have h := congrArg star (hcomm e f)
    simp only [star_mul, hgammaStar] at h
    exact h.symm
  have hCovStar : ∀ e, star (nabla e) * phi = phi * star (nabla e) := by
    intro e
    have h := congrArg star (hCov e)
    simp only [star_mul, hphiStar] at h
    exact h.symm
  have hGammaNablaStar : ∀ e, Gamma * star (nabla e) = star (nabla e) * Gamma := by
    intro e
    have h := congrArg star (hGammaNabla e)
    simp only [star_mul, hGammaStar] at h
    exact h.symm
  -- `star D0 = ∑ e, star (nabla e) * gamma e`.
  have hstarD0 : star (solderedNC gamma nabla) = ∑ e, star (nabla e) * gamma e := by
    unfold solderedNC
    rw [star_sum]
    apply Finset.sum_congr rfl
    intro e _
    rw [star_mul, hgammaStar]
  -- `Γφ` is Krein self-adjoint.
  have hstarPhi : star (Gamma * phi) = Gamma * phi := by
    rw [star_mul, hphiStar, hGammaStar, hPhiComm]
  -- The aperture + closure blocks from the pair master identity.
  have hkrein : (4 : R) • (star (solderedNC gamma nabla) * solderedNC gamma nabla)
      = (∑ e, ∑ f, g e f • (star (nabla e) * nabla f + star (nabla f) * nabla e))
        + (∑ e, ∑ f, (gamma e * gamma f - gamma f * gamma e)
            * (star (nabla e) * nabla f - star (nabla f) * nabla e)) := by
    have hpair := weitzenbock_master_pair gamma (fun e => star (nabla e)) nabla g
      hcl hcommMStar
    simp only [] at hpair
    rw [hstarD0]
    rw [show solderedNC gamma nabla = ∑ f, gamma f * nabla f from rfl]
    exact hpair
  -- The Krein cross term is the self-adjointness defect `E_#`.
  have hcross : star (solderedNC gamma nabla) * (Gamma * phi)
        + (Gamma * phi) * solderedNC gamma nabla
      = ∑ e, gamma e * Gamma * (phi * (star (nabla e) - nabla e)) := by
    rw [hstarD0]
    unfold solderedNC
    rw [Finset.sum_mul, Finset.mul_sum, ← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro e _
    have e1 : star (nabla e) * gamma e * (Gamma * phi)
        = gamma e * Gamma * (phi * star (nabla e)) := by
      have h1 : star (nabla e) * gamma e = gamma e * star (nabla e) := (hcommMStar e e).symm
      rw [h1]
      have h2 : gamma e * star (nabla e) * (Gamma * phi)
          = gamma e * (star (nabla e) * Gamma) * phi := by noncomm_ring
      rw [h2, ← hGammaNablaStar e]
      have h3 : gamma e * (Gamma * star (nabla e)) * phi
          = gamma e * Gamma * (star (nabla e) * phi) := by noncomm_ring
      rw [h3, hCovStar e]
    have e2 : Gamma * phi * (gamma e * nabla e)
        = - (gamma e * Gamma * (phi * nabla e)) := by
      have h : Gamma * phi * (gamma e * nabla e) = Gamma * (phi * gamma e) * nabla e := by
        noncomm_ring
      rw [h, hPhiGamma e]
      have h2 : Gamma * (gamma e * phi) * nabla e = (Gamma * gamma e) * (phi * nabla e) := by
        noncomm_ring
      rw [h2, hGammaAnti e]; noncomm_ring
    rw [e1, e2]; noncomm_ring
  -- The potential squares to `phi ^ 2`.
  have hpotsq : (Gamma * phi) * (Gamma * phi) = phi ^ 2 := by
    rw [← pow_two]; exact potential_sq Gamma phi hGammaSq hPhiComm
  -- Assemble the Krein square.
  rw [star_add, hstarPhi]
  have expand : (star (solderedNC gamma nabla) + Gamma * phi)
        * (solderedNC gamma nabla + Gamma * phi)
      = star (solderedNC gamma nabla) * solderedNC gamma nabla
        + (star (solderedNC gamma nabla) * (Gamma * phi)
            + (Gamma * phi) * solderedNC gamma nabla)
        + (Gamma * phi) * (Gamma * phi) := by noncomm_ring
  rw [expand, smul_add, smul_add, hkrein, hcross, hpotsq]
  abel

end PhysicsSM.Draft.NullEdge.Carrier.Bridge

/-! ## The bridge: discharge the graded-budget hypothesis on the carrier -/

namespace PhysicsSM.Draft.NullEdge.Carrier.EquivariantGradedIndex

open Matrix PhysicsSM.Draft.NullEdge.Carrier.Bridge

variable {n : Type*} [Fintype n] [DecidableEq n] {E : Type*} [Fintype E]

/-- **`carrier_graded_budget` — the discharged organizing identity.**
For the carrier `D = D0 + Γφ` built from concrete matrices
(`gamma nabla : E → Matrix n n ℂ`, chirality `Gamma`, Higgs `phi`, metric `g`)
satisfying the carrier hypotheses, the graded supertrace `sdim(A) = (Grade * sym * A).trace`
of the carrier's *own* mass form `4 (D^# D)` decomposes over the four
kernel-defined channels `Q_A^#, Q_C^#, Q_T = φ², E_#`:

`4 • sdim(D^#D) = sdim(Q_A^#) + sdim(Q_C^#) + 4 • sdim(Q_T) + 4 • sdim(E_#)`.

There is NO free budget hypothesis: the budget is supplied by
`carrier_krein_square`. `Grade`, `sym` are arbitrary (the identity is pure
linearity of the supertrace). -/
theorem carrier_graded_budget
    (Grade sym : Matrix n n ℂ)
    (gamma nabla : E → Matrix n n ℂ) (Gamma phi : Matrix n n ℂ) (g : E → E → ℂ)
    (hcl : ∀ e f, gamma e * gamma f + gamma f * gamma e = algebraMap ℂ (Matrix n n ℂ) (g e f))
    (hcomm : ∀ e f, gamma e * nabla f = nabla f * gamma e)
    (hGammaSq : Gamma * Gamma = 1)
    (hGammaAnti : ∀ e, Gamma * gamma e = - (gamma e * Gamma))
    (hGammaNabla : ∀ e, Gamma * nabla e = nabla e * Gamma)
    (hPhiGamma : ∀ e, phi * gamma e = gamma e * phi)
    (hPhiComm : Gamma * phi = phi * Gamma)
    (hCov : ∀ e, nabla e * phi = phi * nabla e)
    (hgammaStar : ∀ e, star (gamma e) = gamma e)
    (hGammaStar : star Gamma = Gamma) (hphiStar : star phi = phi) :
    (4 : ℂ) • (Grade * sym *
        (star (solderedNC gamma nabla + Gamma * phi)
          * (solderedNC gamma nabla + Gamma * phi))).trace
      = (Grade * sym *
          (∑ e, ∑ f, g e f • (star (nabla e) * nabla f + star (nabla f) * nabla e))).trace
        + (Grade * sym *
          (∑ e, ∑ f, (gamma e * gamma f - gamma f * gamma e)
            * (star (nabla e) * nabla f - star (nabla f) * nabla e))).trace
        + (4 : ℂ) • (Grade * sym * phi ^ 2).trace
        + (4 : ℂ) • (Grade * sym *
          (∑ e, gamma e * Gamma * (phi * (star (nabla e) - nabla e)))).trace := by
  have hbudget := carrier_krein_square (R := ℂ) (B := Matrix n n ℂ)
    gamma nabla Gamma phi g hcl hcomm hGammaSq hGammaAnti hGammaNabla
    hPhiGamma hPhiComm hCov hgammaStar hGammaStar hphiStar
  exact graded_budget_decomposition Grade sym _ _ _ _ _ _ hbudget

/-! ## Local axiom guard (self-contained) -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.EquivariantGradedIndex.carrier_graded_budget' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms carrier_graded_budget

end PhysicsSM.Draft.NullEdge.Carrier.EquivariantGradedIndex
