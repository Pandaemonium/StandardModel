import Mathlib

/-!
# Intrinsic selector descent through a carrier representation

A word-degree or edge-exchange selector is initially defined on a source
presentation. It is intrinsic on represented carrier operators only if it is
independent of the chosen source representative. This file isolates the exact
linear-algebra gate: the selector descends precisely when it preserves the
kernel of the evaluation map. Surjectivity makes the descended selector unique.
-/

noncomputable section

namespace SelectorDescent

variable {R F V : Type*}
variable [Ring R]
variable [AddCommGroup F] [Module R F]
variable [AddCommGroup V] [Module R V]

/-- A source selector descends through `eval` when it is intertwined by some
selector on represented operators. -/
def DescendsThrough (eval : F →ₗ[R] V) (P : Module.End R F) : Prop :=
  ∃ Q : Module.End R V, Q.comp eval = eval.comp P

/-- The exact relation-preservation condition for selector descent. -/
def PreservesEvaluationKernel (eval : F →ₗ[R] V) (P : Module.End R F) : Prop :=
  LinearMap.ker eval ≤ LinearMap.ker (eval.comp P)

/-- Any descended selector necessarily preserves every relation erased by the
evaluation map. -/
theorem descent_necessary (eval : F →ₗ[R] V) (P : Module.End R F) :
    DescendsThrough eval P → PreservesEvaluationKernel eval P := by
  sorry

/-- The canonical selector induced on the represented space by a surjective
evaluation whose kernel is preserved. -/
noncomputable def descendedSelector
    (eval : F →ₗ[R] V) (P : Module.End R F)
    (heval : Function.Surjective eval)
    (hker : PreservesEvaluationKernel eval P) : Module.End R V :=
  let E := eval.quotKerEquivOfSurjective heval
  let hP : LinearMap.ker eval ≤ (LinearMap.ker eval).comap P := by
    simpa only [LinearMap.ker_comp] using hker
  E.toLinearMap.comp
    (((LinearMap.ker eval).mapQ (LinearMap.ker eval) P hP).comp
      E.symm.toLinearMap)

/-- The canonical descended selector intertwines source selection and
evaluation exactly. -/
theorem descendedSelector_comp
    (eval : F →ₗ[R] V) (P : Module.End R F)
    (heval : Function.Surjective eval)
    (hker : PreservesEvaluationKernel eval P) :
    (descendedSelector eval P heval hker).comp eval = eval.comp P := by
  sorry

/-- Surjectivity makes any descended selector unique. -/
theorem descendedSelector_unique
    (eval : F →ₗ[R] V) (P : Module.End R F)
    (heval : Function.Surjective eval)
    (Q : Module.End R V)
    (hQ : Q.comp eval = eval.comp P) :
    Q = descendedSelector eval P heval (descent_necessary eval P ⟨Q, hQ⟩) := by
  sorry

/-- **Intrinsic-selector criterion.** For a surjective carrier evaluation, a
unique represented selector exists exactly when the source selector preserves
the evaluation kernel. -/
theorem existsUnique_descended_iff
    (eval : F →ₗ[R] V) (P : Module.End R F)
    (heval : Function.Surjective eval) :
    (∃! Q : Module.End R V, Q.comp eval = eval.comp P) ↔
      PreservesEvaluationKernel eval P := by
  sorry

/-- A single relation killed by evaluation but moved out of the kernel is an
exact witness that the proposed selector is presentation-dependent. -/
theorem no_descent_of_relation_witness
    (eval : F →ₗ[R] V) (P : Module.End R F)
    (x : F) (hx : eval x = 0) (hPx : eval (P x) ≠ 0) :
    ¬ DescendsThrough eval P := by
  sorry

end SelectorDescent
