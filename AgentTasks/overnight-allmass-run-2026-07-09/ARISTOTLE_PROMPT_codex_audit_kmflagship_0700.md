# codex-audit-kmflagship-0700-20260709

aristotle:
  project_id: 3888a5c9-b651-4b08-a2f3-7d29410a59a9
  target_file: audit report only
  expected_module: n/a
  submission_project: AgentTasks/aristotle-submit/codex-next-round-0700-20260709-project
  output_dir: AgentTasks/aristotle-output/3888a5c9-b651-4b08-a2f3-7d29410a59a9
  status: submitted 2026-07-09 ~07:05

You are Aristotle, acting as an independent semantic auditor. This is an audit
job; do not spend time on broad project builds beyond opening/checking the named
files if available.

Audit these modules:

```text
PhysicsSM/Draft/NullEdge/KMPhaseCounting.lean
PhysicsSM/Draft/NullEdge/FiniteKMCP.lean
PhysicsSM/Draft/NullEdge/IncidenceCorank.lean
PhysicsSM/Draft/NullEdge/KMFlagship.lean
PhysicsSM/Draft/NullEdge/KMFamilyRankBridge.lean
```

Questions:
1. Does `KMFlagship.physicalPhases_eq_incidence_corank` really compose the
   arithmetic CP phase count with the complete-graph incidence corank, or is it
   only a definitional restatement?
2. Does `KMFlagship.goalII_lowN_summary` include the necessary nondegeneracy
   witnesses: constructive N=2 rephasing/no-go and exact nonzero N=3 Jarlskog?
3. Does any docstring/prose overstate the result as a global unitary normal form
   for arbitrary `N` or as a physical derivation of three generations?
4. Does `KMFamilyRankBridge` correctly say the CP-one condition supplies a
   rank-fixing datum rather than deriving it from nothing?
5. Give a PASS/FAIL verdict and any required wording patches before manuscript
   co-signing.

Output findings first, ordered by severity. Then give a short ready-to-paste
ledger note.
