# Aristotle task: signed flavor-cover Clifford decoder

- Work item: `NE-3PLUS1-DK-001`
- Role: Builder / Assassin
- Priority: lateral 3+1 architecture
- Target: `CliffordCoverDecoder.lean`
- Aristotle project: `5ed47bad-6557-4c68-ac6b-bacfc0a84142`
- Submission status: integrated

## Objective

Complete every proof hole without changing definitions, statements, axis
order, or fermionic sign convention.  Prove that the unsigned `Z2^3` deck
translations commute, while their Jordan-Wigner-signed lifts square to the
identity and anticommute for distinct axes.  Preserve both explicit negative
controls.

## Semantic constraints

- This is the three-mode specialization of the occupation sign in
  `PhysicsSM/Spinor/SpinorTenfoldFock.lean`.
- Do not infer particle species, gauge charges, chirality, or a solved
  flavored-walk projection from this finite Clifford module.
- Do not replace the signed lift by a definition that makes the relations
  tautological.
- Use no trust-expanding declarations or evaluator shortcuts.

## Next theorem

After this core lands, construct a commuting right Clifford action and an
explicit nontrivial onsite projector, then test that projector against the
actual flavored QCA update.  Failure to commute is the registered kill.

## Verification

```text
lake env lean AgentTasks/aristotle-standalone/clifford-cover-decoder-20260713/CliffordCoverDecoder.lean
```

## Submission metadata

```yaml
aristotle:
  project_id: 5ed47bad-6557-4c68-ac6b-bacfc0a84142
  task_id: null
  target_file: CliffordCoverDecoder.lean
  expected_module: CliffordCoverDecoder
  submission_project: AgentTasks/aristotle-submit/afpl-clifford-cover-decoder-20260713-project
  output_dir: AgentTasks/aristotle-output/5ed47bad-6557-4c68-ac6b-bacfc0a84142
  status: integrated
```

## Outcome

Aristotle completed the signed Clifford core and correctly rejected the proposed
vacuum inequality as false. The replacement control proves equality on the
vacuum and separates the unsigned and signed actions on an occupied-mode
witness. Codex independently reviewed the result; see
`AutonomousLab/reviews/CODEX_REVIEW_CliffordCoverDecoder_2026-07-13.md`.

The production files are:

- `PhysicsSM/Draft/NullEdge/CliffordCoverDecoder.lean`
- `PhysicsSM/Draft/NullEdge/CliffordCoverDecoderAxiomGuard.lean`

The module proves a projective Clifford lift of the eight-sheet register. It
does not claim a particle dictionary, charge assignment, QCA intertwiner, or
momentum-selective doubler removal.
