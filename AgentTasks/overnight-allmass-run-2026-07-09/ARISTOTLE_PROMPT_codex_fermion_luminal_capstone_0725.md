# codex-fermion-luminal-capstone-0725-20260709

aristotle:
  project_id: ddc7701a-0ac1-4072-9cd2-03e486dd8b20
  target_file: PhysicsSM/Draft/NullEdge/FermionLuminalCapstone.lean
  expected_module: PhysicsSM.Draft.NullEdge.FermionLuminalCapstone
  submission_project: AgentTasks/aristotle-submit/codex-ambitious-proof-wave-0725-20260709-project
  output_dir: AgentTasks/aristotle-output/ddc7701a-0ac1-4072-9cd2-03e486dd8b20
  status: submitted 2026-07-09 ~07:25

You are Aristotle, proving an ambitious finite fermion dynamics capstone in Lean.

Target file to create:

```text
PhysicsSM/Draft/NullEdge/FermionLuminalCapstone.lean
```

Use imports:

```lean
import Mathlib
import PhysicsSM.Draft.NullEdge.DiracVelocityOperator
import PhysicsSM.Draft.NullEdge.HelicityChirality
import PhysicsSM.Draft.NullEdge.ZigzagWeyl
import PhysicsSM.Draft.NullEdge.ZitterbewegungAverage
```

Mission:
Compose the finite Dirac velocity, helicity/chirality, Penrose zigzag, and
zitterbewegung-average modules into one theorem package. The headline should be:
instantaneous velocity is luminal, mass couples chirality/helicity pieces, and
the observed 3-4-5 drift is the convex average of luminal channels.

Preferred theorem shapes, adapted if live theorem names differ:

```lean
namespace FermionLuminalCapstone

theorem luminal_zigzag_capstone :
    DiracVelocityOperator.velocity_spectrum
      ∧ DiracVelocityOperator.massless_luminal
      ∧ HelicityChirality.verdict
      ∧ ZigzagWeyl.zigzag_verdict 3
      ∧ ZitterbewegungAverage.zitterbewegung_verdict 4 5 3
          (by norm_num) (by norm_num)
      ∧ ZitterbewegungAverage.instance_345 := ...

theorem three_four_five_observed_drift_from_luminal_channels :
    ZitterbewegungAverage.wPlus 4 5 = 9 / 10
      ∧ ZitterbewegungAverage.wMinus 4 5 = 1 / 10
      ∧ ZitterbewegungAverage.meanVelocity 4 5 = 4 / 5
      ∧ ZitterbewegungAverage.meanVelocity 4 5 ^ 2 = 16 / 25
      ∧ DiracVelocityOperator.alpha1 * DiracVelocityOperator.alpha1 = 1
      ∧ DiracVelocityOperator.alpha1.mulVec DiracVelocityOperator.vplus
          = DiracVelocityOperator.vplus
      ∧ DiracVelocityOperator.alpha1.mulVec DiracVelocityOperator.vminus
          = -DiracVelocityOperator.vminus := ...

theorem mass_couples_but_average_is_subluminal :
    HelicityChirality.mass_couples_helicities
      ∧ ZigzagWeyl.mass_couples 3
      ∧ ZitterbewegungAverage.drift_subluminal_from_average 4 5 3
          (by norm_num) (by norm_num) := ...

end FermionLuminalCapstone
```

If dependent proof terms in theorem arguments are awkward, split helper lemmas.
Do not claim a field theory, Lorentz-covariant QFT, or boson result. This is a
finite one-momentum fermion capstone. Add guard pins for headline theorem
a x i o m footprints.

Run first:

```text
lake env lean PhysicsSM/Draft/NullEdge/FermionLuminalCapstone.lean
```

Return solved targets, any statement adjustments, and exact theorem names.
