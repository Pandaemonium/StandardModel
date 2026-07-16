# Red-team note: FB-SU3 trusted flagship

- Artifact: `PhysicsSM/Algebra/Octonion/G2FixingE111SpecialUnitaryGroup.lean`
  (TRUSTED layer -- `PhysicsSM/Algebra/`, not Draft), claim FB-SU3 in
  `state/CLAIMS.json`.
- Reviewer: claude (interactive), cross-family (I did NOT build FB), unsolicited
  RED-TEAM extending the honesty-discipline audit to a trusted headline claim.
- Verdict: **honest and precise; one minor docstring-completeness fix.**

## What is actually proved

- `mem_su3Submonoid_iff_specialUnitaryGroup` / `su3Submonoid_eq_specialUnitaryGroup`:
  the octonion-derived `su3Submonoid` (elements satisfying `MatrixActsAsSU3OnC3`
  on the `C^3` complement) is EXACTLY `Matrix.specialUnitaryGroup (Fin 3) C`. A
  precise matrix-group identity via `Matrix.mem_specialUnitaryGroup_iff`.
- `octonionMulAutFixingE111MulEquivSpecialUnitary : ... ≃* Matrix.specialUnitaryGroup (Fin 3) C`:
  a **MulEquiv** (group isomorphism) from the algebraically-defined automorphism
  group `OctonionMulAutFixingE111` onto Mathlib's SU(3).

## Over-claim audit

- **False shape / Lie-vs-group: CLEAR.** The result is stated as a `≃*` (group
  isomorphism) and an equality of matrix subgroups. It does NOT claim a smooth
  Lie-group isomorphism, and the docstring says "group isomorphism" throughout.
  This is the correct, non-inflated statement -- matching the manuscript's care
  ("MulEquiv onto a submonoid proved equal to specialUnitaryGroup; NOT a theorem
  about the smooth Lie group G_2 = Aut(O)").
- **Vacuity: NO.** `su3Submonoid` is a genuine construction (the C^3-action
  predicate), proved equal to a nontrivial Mathlib group.
- **Source: honest.** "the octonion SU(3) construction of Furey / Dixon
  (G2ComplexLine); the identification here is a clean-room match." Trusted,
  kernel-checked, sorry-free.

## Minor finding (docstring completeness, not a false theorem)

The trusted file's docstring does NOT carry the explicit "**NOT** the smooth Lie
group G_2 = Aut(O)" non-claim that the FB manuscript abstract carries, and the
`G2`-prefixed filename/namespace (`G2FixingE111...`, `G2ComplexLine`) could lead
a careless reader (grep, index, citation) to conflate this with a statement
about the smooth Lie group G_2. Recommendation: add the one-line non-claim from
the manuscript to this module's docstring ("This is an algebraic group
isomorphism; it is NOT a statement about the smooth Lie group G_2 = Aut(O)").
Cost: one docstring line, zero kernel risk.

## Consistency with the session's honesty-discipline meta-finding

This reinforces the pattern from the gravity-capstone audit: the program's
results are **honest at the theorem level** (here the `≃*`/subgroup-equality is
exactly right and non-inflated), and the only lapses are naming/docstring
completeness that could invite over-reading in isolation. The
`PROPOSAL_capstone_honesty_convention.md` point (2) -- an explicit "Honest scope
/ NOT" section in every headline module -- would cover this case too. So the
convention should apply to trusted headline modules, not only draft capstones.
