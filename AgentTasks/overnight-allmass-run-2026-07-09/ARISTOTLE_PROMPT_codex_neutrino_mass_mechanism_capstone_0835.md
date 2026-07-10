# codex-neutrino-mass-mechanism-capstone-0835-20260709

aristotle:
  project_id: 4911f297-fa26-4974-9dc1-ee87d0f3a170
  target_file: PhysicsSM/Draft/NullEdge/NeutrinoMassMechanismCapstone.lean
  expected_module: PhysicsSM.Draft.NullEdge.NeutrinoMassMechanismCapstone
  submission_project: AgentTasks/aristotle-submit/codex-neutrino-mass-mechanism-capstone-0835-20260709-project
  output_dir: pending
  status: submitted 2026-07-09 ~09:00 PDT

You are Aristotle, proving a finite neutrino-mass mechanism capstone in Lean.
Stay in exact finite-avatar scope. This is not a prediction of the physical
neutrino mass or of whether nature chooses Dirac or Majorana neutrinos. It is a
kernel-checked structural statement:

- Dirac branch: CPT conjugacy gives an independent zigzag and lepton number is
  conserved.
- Majorana branch: CPT/self-conjugate structure violates lepton number.
- Type-I finite seesaw branch: a heavy sterile Majorana partner suppresses the
  light eigenvalue by `mD^2 / MR`.
- Schur finite seesaw branch: hidden-block leakage is resolvent-suppressed and
  vanishes exactly when hidden overlap is closed.

Do not add new assumptions, placeholder declarations, or Lean escape-hatch
tokens. Keep nonzero and nonvacuity witnesses explicit.

Target file to create:

```text
PhysicsSM/Draft/NullEdge/NeutrinoMassMechanismCapstone.lean
```

Use imports:

```lean
import Mathlib
import PhysicsSM.Draft.NullEdge.NeutrinoDiracMajorana
import PhysicsSM.Draft.NullEdge.NeutrinoSeesaw
import PhysicsSM.Draft.NullEdge.SchurSeesaw
```

Mission:

1. Compose `NeutrinoDiracMajorana.neutrino_verdict`,
   `dirac_two_states`, `majorana_self_conjugate`, and `lepton_number`.
2. Compose `NeutrinoSeesaw.char_vieta`, `eig_vieta`, `opposite_signs`,
   `seesaw_bound`, `seesaw_verdict`, `nondegen_suppressed`, and
   `nondegen_control`.
3. Compose the imported Schur-seesaw payload:
   `PhysicsSM.Draft.NullEdge.SchurSeesaw.seesaw_suppression` and
   `PhysicsSM.Draft.NullEdge.SchurSeesaw.seesaw_zero_iff_no_overlap`.
4. Add one capstone theorem that states the honest mechanism hierarchy:
   finite neutrino lightness is structurally supplied by a Majorana/heavy-hidden
   branch plus suppressed leakage, not by a bare mass assertion.

Preferred theorem shapes, adapted if live APIs require:

```lean
namespace NeutrinoMassMechanismCapstone

theorem dirac_majorana_branch_capstone :
    NeutrinoDiracMajorana.dirac_two_states /\
      NeutrinoDiracMajorana.majorana_self_conjugate /\
      NeutrinoDiracMajorana.lepton_number /\
      NeutrinoDiracMajorana.neutrino_verdict := by
  ...

theorem typeI_seesaw_capstone :
    (forall mD MR lp ln : R,
      0 < mD -> 0 < MR ->
      lp * ln = -mD ^ 2 -> lp + ln = MR -> ln < 0 ->
      0 < lp /\ ln < 0 /\ lp * (-ln) = mD ^ 2 /\
        -ln < mD ^ 2 / MR) /\
    (forall lp ln : R,
      lp * ln = -(1 : R) ^ 2 -> lp + ln = 100 -> ln < 0 ->
      100 < lp /\ -ln < (1 : R) ^ 2 / 100) /\
    (forall lp ln : R,
      lp * ln = -(1 : R) ^ 2 -> lp + ln = 1 -> ln < 0 ->
      -ln < (1 : R) ^ 2 / 1) := by
  ...

theorem schur_seesaw_payload_capstone :
    (forall {nv nh : Type*} [Fintype nv] [DecidableEq nv] [Fintype nh]
        [DecidableEq nh] [Nonempty nh]
        (A : Matrix nv nv C) (B : Matrix nv nh C) (M : Matrix nh nh C)
        (hM : M.PosDef) (v : nv -> C) (hprot : A *v v = 0),
      |(star v dotProduct (A - B * M^-1 * B.conjTranspose) *v v).re|
        <= (star (B.conjTranspose *v v) dotProduct (B.conjTranspose *v v)).re /
          PhysicsSM.Draft.NullEdge.SchurSeesaw.leastEigen hM) /\
    (forall {nv nh : Type*} [Fintype nv] [DecidableEq nv] [Fintype nh]
        [DecidableEq nh]
        (A : Matrix nv nv C) (B : Matrix nv nh C) (M : Matrix nh nh C)
        (hM : M.PosDef) (v : nv -> C) (hprot : A *v v = 0),
      star v dotProduct (A - B * M^-1 * B.conjTranspose) *v v = 0 <->
        B.conjTranspose *v v = 0) := by
  ...

theorem neutrino_mass_mechanism_verdict :
    dirac_majorana_branch_capstone /\
      typeI_seesaw_capstone /\
      schur_seesaw_payload_capstone := by
  ...

end NeutrinoMassMechanismCapstone
```

The preferred shapes intentionally use a few shorthand proof-term lines and
ASCII approximations. If those do not typecheck as propositions, restate the
exact propositions proved by the imported theorem and discharge them with the
imported theorem. That adjustment is desired; do not weaken the payload. Use
Lean's actual symbols for `ℝ`, `ℂ`, `⬝ᵥ`, `*ᵥ`, `⁻¹`, `ᴴ`, inequalities, and
matrix operations in the target file.

Add `#guard_msgs (whitespace := lax) in #print axioms ...` for each headline.
Run:

```text
lake env lean PhysicsSM/Draft/NullEdge/NeutrinoMassMechanismCapstone.lean
```

Return solved theorem names, exact statement adjustments, guard footprints, and
any semantic caveat.
