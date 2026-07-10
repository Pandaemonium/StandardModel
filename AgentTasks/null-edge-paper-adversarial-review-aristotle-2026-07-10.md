# Aristotle task: adversarial review of the complete Paper I manuscript

## Objective

Perform a hostile-but-fair scientific and formal audit of the entire manuscript
`Sources/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex`
against the supporting Lean source included in this project.  This is not a
request for encouragement, copy-editing, or a summary.  Try to falsify every
headline claim and identify the exact boundary between what the kernel proves,
what follows by a short human argument, what is standard background, and what
remains conjectural.

The manuscript and the complete `PhysicsSM` source tree are included.  The
semantic context pack is
`AgentTasks/context-packs/null-edge-paper-adversarial-review-20260710-20260710-131531.md`.
The document-index refresh was attempted twice before packaging but exceeded
both shell windows; treat the context pack as useful triage, not proof that its
index contains the final Wilson edit.

## Required audit procedure

1. Read the complete manuscript, including abstract, synthesis theorem,
   comparison table, negative controls, theorem ledger, interpretation, open
   problems, conclusion, and bibliography.
2. For every declaration named in the theorem ledger, locate the actual Lean
   declaration.  Record its full hypotheses and conclusion in mathematical
   English.  Verify that the manuscript does not silently omit quantifiers,
   positivity assumptions, support restrictions, nonzero hypotheses, finite
   cardinality hypotheses, fixed-time restrictions, or convention choices.
3. Apply the four repository over-claim tests independently to every headline
   theorem: vacuity, hollow telescoping, prose outrunning the kernel, and false
   mathematical shape.
4. Attack all existential and nondegeneracy claims.  Check that the supplied
   positive and negative controls instantiate the relevant hypotheses and do
   not live on a collapsed or trivial locus.
5. Audit the complete conceptual chain:
   null-spinor area -> determinant -> odd Hermitian mass operator -> Dirac
   square -> exact unitary turn -> checkerboard kernel -> finite 3+1 walk ->
   Fourier and L2 limits.  Identify every place where two separately supplied
   parameters are merely equated in prose rather than connected by a theorem.
6. Audit the lattice claims especially aggressively:
   - distinguish zero-quasienergy doublers from pi-quasienergy pseudo-doublers;
   - check the exact scope of the corner and body-center results;
   - check that the degree-one stationary-amplitude no-go includes origin
     normalization and does not claim universal minimality;
   - inspect `WilsonDiracRegulator.lean` and verify the exact square, uniform
     massive gap, and massless zero-set theorem;
   - reject any implication that the Wilson Hamiltonian exponential is already
     a strictly finite-range one-step QCA.
7. Audit every continuum statement.  Separate finite periodic Fourier
   conjugacy, finite-torus normalization, fixed-momentum product convergence,
   compact-support momentum-space L2 convergence, changing-lattice Fourier
   identification, inverse-Fourier convergence, and position-space Dirac PDE
   convergence.  Flag any sentence that merges adjacent levels.
8. Audit novelty and attribution.  Distinguish standard spinor-helicity,
   Clifford, Wilson, checkerboard, Trotter, and quantum-walk ingredients from
   genuinely new composition theorems.  Flag novelty language not supported by
   the cited references or by a clearly identified new theorem.
9. Inspect axiom guards and source files for proof placeholders, compiler-trust
   shortcuts, hidden assumptions, or declarations whose names suggest more
   than their statements prove.  Do not spend the task running the entire
   repository build; use narrow source inspection and targeted Lean checks only
   where a suspected mismatch requires them.
10. Evaluate the paper as a submission to a mathematically sophisticated
    quantum-walk/QCA audience.  Be exacting about physical interpretation,
    discrete-time versus continuous-time dynamics, locality, spectral gaps,
    and continuum-limit language.

## Required output

Create
`AgentTasks/ARISTOTLE_NULL_EDGE_PAPER_ADVERSARIAL_AUDIT_2026-07-10.md`
with these sections:

- **Verdict**: one-paragraph publication-readiness assessment.
- **Critical findings**: correctness or category errors that must be fixed.
- **Major findings**: overclaims, omitted hypotheses, or missing theorem links.
- **Minor findings**: notation, attribution, and presentation defects that
  affect expert trust.
- **Declaration-by-declaration ledger audit**: every manuscript theorem-table
  entry, its exact Lean scope, and `aligned / narrower than prose / missing /
  misleading name` status.
- **Synthesis-chain dependency audit**: identify which arrows are genuine
  compositions and which remain interfaces or conjectures.
- **Nonvacuity and controls audit**.
- **Continuum and locality audit**.
- **Novelty audit**.
- **Five highest-value repairs**, ordered by expected impact on expert readers.
- **Claims that survived attack**: list only claims that remained correct after
  inspecting their declarations and controls.

Every finding must cite a manuscript section/equation/declaration and the
supporting Lean file and theorem when applicable.  Do not silently edit theorem
statements, weaken claims, or rewrite the manuscript.  Return the audit report
as the primary artifact even if some targeted Lean check is slow.

```yaml
aristotle:
  project_id: d6da22f3-2575-4552-8556-15551872d3d1
  task_id: f2924d7d-0708-43b7-a4f6-44eecde933d4
  target_file: Sources/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex
  expected_output: AgentTasks/ARISTOTLE_NULL_EDGE_PAPER_ADVERSARIAL_AUDIT_2026-07-10.md
  submission_project: AgentTasks/aristotle-submit/null-edge-paper-adversarial-review-20260710-project
  output_dir: AgentTasks/aristotle-output/d6da22f3-2575-4552-8556-15551872d3d1
  status: completed-and-reviewed
```

## Review disposition (2026-07-10)

The completed report is preserved in the downloaded project at
`AgentTasks/aristotle-output/d6da22f3-2575-4552-8556-15551872d3d1/extracted/project-files.tar/null-edge-paper-adversarial-review-20260710-project_aristotle/AgentTasks/ARISTOTLE_NULL_EDGE_PAPER_ADVERSARIAL_AUDIT_2026-07-10.md`.
The integration helper initially reported it missing because the returned
archive has one additional project-root directory; direct inspection confirmed
the full 32,777-byte report.

Independent disposition:

- No critical correctness, vacuity, false-shape, novelty, or continuum/locality
  failure was found.
- The dispersion packaging concern was valid and was repaired at theorem level:
  `exact_quantum_walk_dispersion_verdict` now includes the concrete trace
  identity, trace bridge, determinant, and explicit unitarity certificate.
- The checkerboard row now distinguishes abstract two-weight recursion scaling
  from the separate transfer-matrix history identification, and identifies the
  complex orientation factor as a phase-conjugacy consequence rather than a
  direct complex-weight path-sum theorem.
- The group-velocity derivative formula is now marked Human while the
  kernel-checked deficit inequality retains its Kernel status.
- The LaTeX vector typo and the unformalized `GL(2,C)` weighted-extension label
  were corrected.
- Duplicate Plucker/Pluecker APIs and cosmetic tactic diagnostics remain
  maintenance work; they do not affect the audited theorem statements.
