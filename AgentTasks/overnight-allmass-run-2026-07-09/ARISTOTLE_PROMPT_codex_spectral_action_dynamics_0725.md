# codex-spectral-action-dynamics-0725-20260709

aristotle:
  project_id: 4eaa2407-0e4d-4758-9026-d45c3fb6be43
  target_file: PhysicsSM/Draft/NullEdge/SpectralActionDynamics.lean
  expected_module: PhysicsSM.Draft.NullEdge.SpectralActionDynamics
  submission_project: AgentTasks/aristotle-submit/codex-ambitious-proof-wave-0725-20260709-project
  output_dir: AgentTasks/aristotle-output/4eaa2407-0e4d-4758-9026-d45c3fb6be43
  status: submitted 2026-07-09 ~07:25

You are Aristotle, proving a finite action/Euler-Lagrange dynamics layer in
Lean, modeled clean-room after variational-calculus ideas.

Target file to create:

```text
PhysicsSM/Draft/NullEdge/SpectralActionDynamics.lean
```

Use imports:

```lean
import Mathlib
import PhysicsSM.Draft.NullEdge.SpectralActionAvatar
import PhysicsSM.Draft.NullEdge.JacobsonClausius
import PhysicsSM.Draft.NullEdge.GravitySourceMatter
```

Mission:
Turn the finite spectral-action avatar into an explicit action-gradient theorem.
This is the D1-style finite action/EOM move: stationarity of a concrete action
is equivalent to an algebraic equation, with nonzero control witnesses.

Preferred API:

```lean
namespace SpectralActionDynamics

def realSpectralAction (a0 a2 a4 E a c t : ℝ) : ℝ :=
  a0 * 6 + a2 * (6 + 2 * E ^ 2)
    + a4 * (6 + 12 * E ^ 2 + 2 * E ^ 4 + 4 * a * c * t)

def eGradient (a2 a4 E : ℝ) : ℝ :=
  4 * a2 * E + a4 * (24 * E + 8 * E ^ 3)

def channelGradientA (a4 c t : ℝ) : ℝ := 4 * a4 * c * t
def channelGradientC (a4 a t : ℝ) : ℝ := 4 * a4 * a * t
def channelGradientT (a4 a c : ℝ) : ℝ := 4 * a4 * a * c

theorem spectral_action_real_matches_rational_witness :
    realSpectralAction 1 1 1 2 1 3 5 = 166 := ...

theorem hasDerivAt_E
    (a0 a2 a4 a c t E : ℝ) :
    HasDerivAt (fun x => realSpectralAction a0 a2 a4 x a c t)
      (eGradient a2 a4 E) E := ...

theorem stationary_E_iff
    (a0 a2 a4 a c t E : ℝ) :
    HasDerivAt (fun x => realSpectralAction a0 a2 a4 x a c t) 0 E
      ↔ eGradient a2 a4 E = 0 := ...

theorem stationary_E_polynomial
    (a0 a2 a4 a c t E : ℝ) :
    HasDerivAt (fun x => realSpectralAction a0 a2 a4 x a c t) 0 E
      ↔ 4 * E * (a2 + 6 * a4 + 2 * a4 * E ^ 2) = 0 := ...

theorem channel_gradients
    (a0 a2 a4 E a c t : ℝ) :
    HasDerivAt (fun x => realSpectralAction a0 a2 a4 E x c t)
      (channelGradientA a4 c t) a
    ∧ HasDerivAt (fun x => realSpectralAction a0 a2 a4 E a x t)
      (channelGradientC a4 a t) c
    ∧ HasDerivAt (fun x => realSpectralAction a0 a2 a4 E a c x)
      (channelGradientT a4 a c) t := ...

theorem nonzero_gradient_control :
    eGradient 1 1 2 = 112
      ∧ channelGradientA 1 3 5 = 60
      ∧ channelGradientC 1 1 5 = 20
      ∧ channelGradientT 1 1 3 = 12
      ∧ eGradient 1 1 2 ≠ 0 := ...

end SpectralActionDynamics
```

Ambition target:
If the above closes, add a bundled theorem connecting
`SpectralActionAvatar.one_functional_verdict`,
`GravitySourceMatter.nondegenerate_witness`, and
`JacobsonClausius.nondegenerate_witness` if names permit. Keep it finite and
honest: no continuum heat-kernel, no physical E-slot tensor equation.

Add guard pins for headline theorem a x i o m footprints. Run first:

```text
lake env lean PhysicsSM/Draft/NullEdge/SpectralActionDynamics.lean
```

Return solved targets, any statement adjustments, and exact theorem names.
