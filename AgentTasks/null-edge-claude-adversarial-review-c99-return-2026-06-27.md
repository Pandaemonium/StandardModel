# Claude adversarial review request: C99 returned finite chiral-index substrate

Date: 2026-06-27.

Please review the attached returned C99 source against the attached audit
template.

## Returned project

- Aristotle project: `4fd2e530-eb89-4e94-83c1-dc97b254e0c4`
- Target: `PhysicsSM/Draft/NullEdgeFiniteChiralIndexSubstrate.lean`

The integration helper found the nested returned module automatically. It
reports:

- placeholders: none;
- `native_decide`: 2;
- live file missing.

## Initial Codex audit

The return appears to improve on C98 because:

- plus/minus counts are derived from finite state predicates and operator
  columns, not arbitrary user-supplied count fields;
- it has explicit zero-index and nonzero-index examples;
- it clearly says it is not C1 release.

But it likely does **not** satisfy the strong C99 criteria because:

- grading is `chirality : Fin n -> Bool`, not an explicit involution `Gamma`;
- there is no compatibility law between the grading and `D`;
- plus/minus sectors are basis labels rather than eigenspaces of an operator;
- headline examples use `native_decide`;
- the nonzero example may be obtained by choosing a diagonal `D` whose column
  annihilates the plus state but not the minus state, which may be too close to
  hand-setting the desired index.

## Questions

1. Should this C99 be integrated as a useful fallback/planning substrate?
2. Should it be rejected until C99b or C99-v2 supplies an explicit grading
   involution and operator compatibility?
3. If integrated, what status label and documentation warning should be used?
4. Is a C99-v2 job needed now, or should we wait for C99b?
5. Are there theorem/API names in the returned file that are too strong?

Please provide:

- verdict: integrate fallback / hold / reject;
- key reasons;
- exact next action.
