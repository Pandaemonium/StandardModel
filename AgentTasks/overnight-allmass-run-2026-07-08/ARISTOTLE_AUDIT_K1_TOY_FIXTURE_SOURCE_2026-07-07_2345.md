# Aristotle audit job - K1 toy fixture source audit 2026-07-07 23:45 PDT

```yaml
aristotle:
  project_id: 32dcb44c-82e0-4dea-a81e-3817833ce1e7
  task_id: 38b9f67e-50e6-438e-917f-363919501cea
  target_file: PhysicsSM/Draft/NullEdge/GateYM/KPAntiRegressionToy.lean
  expected_module: PhysicsSM.Draft.NullEdge.GateYM.KPAntiRegressionToy
  submission_project: none
  output_dir: AgentTasks/aristotle-output/32dcb44c-82e0-4dea-a81e-3817833ce1e7-extracted/38b9f67e-50e6-438e-917f-363919501cea_aristotle
  status: harvested_COMPLETE_WITH_ERRORS_but_substantive_audit_positive
```

Submitted with:

```powershell
aristotle submit (Get-Content -Raw ARISTOTLE_AUDIT_K1_TOY_FIXTURE_SOURCE_2026-07-07_2345.md)
```

## Prompt

You are Aristotle, asked for a source-aware semantic audit, not a proof attempt.

Context: Codex landed the local K1 anti-regression fixture you recommended. It
is intentionally tiny and does not attempt the general fixed-forest injection.

Source:

```lean
import Mathlib

/-!
# K1 root-pinned encoder anti-regression toy

This module freezes the smallest K1 failure mode found by the 2026-07-07
root-hygiene audit. In the `n = 3` toy case, the root is slot `0`, the unique
root child is slot `1`, and the total child block is `{1, 2}`. There are two
internal block orderings, but a root-pinned flat word that records only the
root child collapses both orderings to one image.

The point is intentionally narrow: this file is an anti-regression fixture, not
the K1 fiber theorem. It refutes any future claim that the pinned flat encoder
already carries the full `m_j!` factor in the one-block toy, and it contrasts
that with a structured two-slot word that keeps both orderings.

Draft-trust: finite decidable equalities by `decide`; no compiler-trusted
evaluation is used.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace PolymerKPConclusion
namespace KPAntiRegressionToy

abbrev ToyPinnedWord := Fin 1 -> Fin 3
abbrev ToyStructuredWord := Fin 2 -> Fin 3

def toyTotalBlockPerms : Finset (Equiv.Perm (Fin 2)) := Finset.univ

def toyPinnedWordEncoder (_sigma : Equiv.Perm (Fin 2)) : ToyPinnedWord :=
  fun _ => (1 : Fin 3)

def toyStructuredBlockEncoder (sigma : Equiv.Perm (Fin 2)) : ToyStructuredWord :=
  fun i => if sigma i = (0 : Fin 2) then (1 : Fin 3) else (2 : Fin 3)

theorem toyTotalBlockPerms_card : toyTotalBlockPerms.card = 2 := by
  decide

theorem pinnedWord_collapses_toy :
    (toyTotalBlockPerms.image toyPinnedWordEncoder).card = 1 := by
  decide

theorem pinnedWord_not_injective_toy :
    Not (Set.InjOn toyPinnedWordEncoder
      (↑toyTotalBlockPerms : Set (Equiv.Perm (Fin 2)))) := by
  decide

theorem structuredWord_separates_toy :
    (toyTotalBlockPerms.image toyStructuredBlockEncoder).card = 2 := by
  decide

end KPAntiRegressionToy
end PolymerKPConclusion
end GateYM
end NullEdge
end Draft
end PhysicsSM
```

Guard pins added in `GateYM/AxiomGuard.lean`:

```lean
#print axioms ...KPAntiRegressionToy.pinnedWord_collapses_toy
#print axioms ...KPAntiRegressionToy.structuredWord_separates_toy
```

Observed commands passing:

```text
lake env lean PhysicsSM/Draft/NullEdge/GateYM/KPAntiRegressionToy.lean
lake build PhysicsSM.Draft.NullEdge.GateYM.KPAntiRegressionToy
lake env lean PhysicsSM/Draft/NullEdge/GateYM/AxiomGuard.lean
lake build PhysicsSM.Draft.NullEdge.GateYM
```

Request:

1. Is this an honest implementation of the n=3 anti-regression fixture you
   recommended?
2. Does the toy wording avoid overclaim?
3. Are the declaration names and shape good enough to block the bad pinned
   full-`m_j!` route?
4. Is anything missing before packaging the free-slot `(m_j - 1)!` theorem for a
   proof-focused Aristotle job?
5. Return concise sections: verdict, statement audit, overclaim guard, next
   handoff.

## Harvest

Aristotle returned `COMPLETE_WITH_ERRORS`, but the visible result is a
substantive source-aware audit rather than a mathematical objection.

Verdict:

- Ship the toy fixture as-is. Aristotle re-elaborated the claims in clean
  Mathlib, checked the `decide` proofs, and found the statement honest,
  faithful, non-vacuous, and appropriately narrow.
- The toy blocks the bad pinned full-factor route: the pinned encoder has image
  cardinality 1 in the two-ordering case, while the structured encoder has image
  cardinality 2.
- The wording avoids overclaim: the module and theorem names explicitly scope
  the result to an anti-regression toy, not the K1 fiber theorem.

Next handoff:

- Package the general free-slot theorem as a proof-focused Aristotle job:
  parametrized block size, pinned image cardinality `(m_j - 1)!`, structured
  image cardinality `m_j!`, and a named missing-factor statement.
- Bridge the general theorem back to the real K1 encoders before using it as a
  program result; until then it is a combinatorial anti-regression fact.
