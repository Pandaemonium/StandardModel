# Aristotle task: spin coherent projector identities (wave 1, job 3)

Date: 2026-06-12

## Goal

Fill the 8 documented `sorry`s in

```text
PhysicsSM/Draft/SpinCoherentProjectorAristotle.lean
```

(self-contained file; defines Pauli matrices, `dot3`, `cross3`,
`spinProjector a = (1/2)(1 + sigma.a)` on `Matrix (Fin 2) (Fin 2) C`):

```lean
pauliVec_mul_pauliVec       -- sigma.a sigma.b = (a.b) 1 + i sigma.(a x b)
pauliVec_conjTranspose
spinProjector_conjTranspose
trace_spinProjector         -- trace = 1 (no norm hypothesis)
spinProjector_mul_self      -- idempotent on the unit sphere
det_spinProjector           -- singular (rank one) on the unit sphere
spinProjector_sandwich      -- P(a)P(b)P(a) = ((1+a.b)/2) P(a)
trace_spinProjector_triple  -- Bargmann invariant (discrete Berry phase)
```

## Mathematical intent

WP3 of `Sources/Luminal_Motion_Checkerboard_Research_Program.md`: the
algebraic spin-transport layer of the 3+1D null-polygon expansion. The
sandwich collapse is the Foster--Jacobson bending suppression
(arXiv:1610.01142); the Bargmann invariant's argument is half the signed
solid angle on the direction sphere -- the discrete Berry/Pancharatnam
holonomy. Both the trace and Bargmann identities are polynomial (no norm
hypotheses; oracle-checked with non-unit vectors).

Oracle: `Scripts/oracle/validate_checkerboard.py` section "Pauli projector
identities" (ALL OK, 2026-06-12).

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, `unsafe`, no `native_decide`.
- Do not change definitions or statements. Helper lemmas welcome.

## Verification

```bash
lake env lean PhysicsSM/Draft/SpinCoherentProjectorAristotle.lean
```

Axiom check on each finished theorem: only
`[propext, Classical.choice, Quot.sound]`.

## Submission

**Status**: COMPLETE, integrated 2026-06-12
**Job ID**: `b16b762b-a7f0-4093-898a-b5eb091b5f61`
**Submitted**: 2026-06-12
**Submission project**: `AgentTasks/aristotle-submit/checkerboard-wave1-20260612-project`
**Output archive**: `AgentTasks/aristotle-output/spin-coherent-projector-20260612-correct`
**Selected extraction**: `AgentTasks/aristotle-output/picked-completed-20260612`

Integrated into:

```text
PhysicsSM/Draft/SpinCoherentProjectorAristotle.lean
```

Verification run after integration:

```bash
lake build PhysicsSM.Draft.SpinCoherentProjectorAristotle
```
