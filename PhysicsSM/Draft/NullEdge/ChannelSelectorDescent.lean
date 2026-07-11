import Mathlib

/-!
# Intrinsic selector descent through a carrier representation

A word-degree or edge-exchange selector is initially defined on a source
presentation. It is intrinsic on represented carrier operators only if it is
independent of the chosen source representative. This module isolates the
exact linear-algebra gate. Preservation of the evaluation kernel is always
necessary; for a surjective evaluation it is also sufficient and the descended
selector is unique.

This criterion does not construct a solder-degree, edge-exchange, locality, or
information-theoretic selector for the live carrier. It supplies the exact
relation check that any such source-level selector must pass before it can be
called intrinsic on represented operators.

Provenance: theorem statements designed locally after the Paper F selector
audit; all five proofs returned unchanged by Aristotle project
`545decd7-f32b-4780-8c53-9e151bcde74f`, then adapted to the project namespace
and independently checked under Lean 4.28.0.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.ChannelSelectorDescent

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
  rintro ⟨Q, hQ⟩ x hx
  simp only [LinearMap.mem_ker, LinearMap.ker_comp, Submodule.mem_comap] at hx ⊢
  rw [← LinearMap.comp_apply, ← hQ, LinearMap.comp_apply, hx, map_zero]

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
  ext x
  simp [descendedSelector]

/-- Surjectivity makes any descended selector unique. -/
theorem descendedSelector_unique
    (eval : F →ₗ[R] V) (P : Module.End R F)
    (heval : Function.Surjective eval)
    (Q : Module.End R V)
    (hQ : Q.comp eval = eval.comp P) :
    Q = descendedSelector eval P heval (descent_necessary eval P ⟨Q, hQ⟩) := by
  ext v
  obtain ⟨x, rfl⟩ := heval v
  have h1 : Q (eval x) = eval (P x) := LinearMap.congr_fun hQ x
  have h2 :
      (descendedSelector eval P heval
        (descent_necessary eval P ⟨Q, hQ⟩)) (eval x) = eval (P x) :=
    LinearMap.congr_fun (descendedSelector_comp eval P heval _) x
  rw [h1, h2]

/-- **Intrinsic-selector criterion.** For a surjective carrier evaluation, a
unique represented selector exists exactly when the source selector preserves
the evaluation kernel. -/
theorem existsUnique_descended_iff
    (eval : F →ₗ[R] V) (P : Module.End R F)
    (heval : Function.Surjective eval) :
    (∃! Q : Module.End R V, Q.comp eval = eval.comp P) ↔
      PreservesEvaluationKernel eval P := by
  constructor
  · rintro ⟨Q, hQ, -⟩
    exact descent_necessary eval P ⟨Q, hQ⟩
  · intro hker
    refine ⟨descendedSelector eval P heval hker,
      descendedSelector_comp eval P heval hker, fun Q hQ => ?_⟩
    rw [descendedSelector_unique eval P heval Q hQ]

/-- A single relation killed by evaluation but moved out of the kernel is an
exact witness that the proposed selector is presentation-dependent. -/
theorem no_descent_of_relation_witness
    (eval : F →ₗ[R] V) (P : Module.End R F)
    (x : F) (hx : eval x = 0) (hPx : eval (P x) ≠ 0) :
    ¬ DescendsThrough eval P := by
  intro hQ
  obtain ⟨Q, hQ⟩ := hQ
  apply hPx
  have h := LinearMap.congr_fun hQ.symm x
  simp only [LinearMap.comp_apply] at h
  rw [h, hx, map_zero]

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelSelectorDescent.existsUnique_descended_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms existsUnique_descended_iff

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelSelectorDescent.no_descent_of_relation_witness' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms no_descent_of_relation_witness

end PhysicsSM.Draft.NullEdge.ChannelSelectorDescent
