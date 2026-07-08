/-
# The organizing identity, discharged on the actual carrier

DRAFT (kernel-clean; no `s o r r y`). Closes the Fable call-08 gap on the
"organizing theorem": `EquivariantGradedIndex.graded_budget_decomposition` shows
that *any* four-channel budget pushes through the graded supertrace by linearity,
but the budget entered there as an *assumed hypothesis*. Here that hypothesis is
**discharged on the real carrier**: the budget is supplied by the project's
kernel-checked `carrier_krein_square` (`CarrierKreinSquare`), specialized to the
concrete matrix algebra `Matrix n n ℂ`.

**The bridge (design).** `Matrix n n ℂ` is *simultaneously* (i) an instance of the
abstract carrier algebra (`R := ℂ`, `B := Matrix n n ℂ` is a `Ring`, a `ℂ`-Algebra,
a `StarRing` with `star = ᴴ`, and a `StarModule ℂ`) and (ii) the concrete home of
the graded supertrace `sdim(A) = (Γ·g·A).trace`. So the generically-proven carrier
Krein square *is* the matrix identity `graded_budget_decomposition` needs. (Route
(a) — restating the graded index inside an abstract ring — is obstructed: a general
ring has no trace, so the supertrace is not definable there. Route (b), specialize
to matrices, is what is done; the Aristotle package reconstructed the carrier bricks
because the project brick library was absent from its sandbox — here we import the
project's real `carrier_krein_square`, no reconstruction.)

## Result (M, self-guarded)

- `carrier_graded_budget`: for the carrier `D = D0 + Γφ` (concrete matrices
  satisfying the carrier hypotheses), the graded supertrace of the carrier's *own*
  mass form `4 (D^#D)` equals the graded-supertrace sum over the four
  kernel-defined channels `Q_A^#, Q_C^#, Q_T = φ², E_#` — **no free budget
  hypothesis**. So "the four channels ARE the graded pieces of the carrier's Dirac
  square" is a theorem about the carrier, not an assumed input. (`Γ, g` are
  arbitrary — the identity is pure supertrace linearity applied to the real budget.)

## Provenance

All-mass solo run 2026-07-08 [orig]. Proof from Aristotle (standalone package
`AgentTasks/aristotle-standalone/allmass-proof-gradedfire-20260708`), reviewed for
semantic alignment and **re-based here onto the project's `carrier_krein_square`**
(dropping the sandbox's brick reconstruction). Builds on `EquivariantGradedIndex`
and `CarrierKreinSquare`.
-/

import Mathlib
import PhysicsSM.Draft.NullEdge.Carrier.EquivariantGradedIndex
import PhysicsSM.Draft.NullEdge.Carrier.CarrierKreinSquare

namespace PhysicsSM.Draft.NullEdge.Carrier.EquivariantGradedIndex

open Matrix PhysicsSM.Draft.NullEdge.Carrier

variable {n : Type*} [Fintype n] [DecidableEq n] {E : Type*} [Fintype E]

/-- **`carrier_graded_budget` — the discharged organizing identity.** For the
carrier `D = D0 + Γφ` built from concrete matrices satisfying the carrier
hypotheses, the graded supertrace `sdim(A) = (Grade * sym * A).trace` of the
carrier's *own* mass form `4 (D^#D)` decomposes over the four kernel-defined
channels `Q_A^#, Q_C^#, Q_T = φ², E_#`, with **no free budget hypothesis** — the
budget is supplied by `carrier_krein_square`. -/
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

end PhysicsSM.Draft.NullEdge.Carrier.EquivariantGradedIndex
