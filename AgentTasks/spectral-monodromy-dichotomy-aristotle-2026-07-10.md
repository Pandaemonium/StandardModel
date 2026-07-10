# Aristotle job: spectral monodromy for generations — the honest dichotomy

Date: 2026-07-10.  Origin: Pro moduli-theory analysis (round-8, sec 16 and
theorem program G), with an own-analysis CORRECTION: Pro proposes testing
eigenvalue-sheet monodromy on finite carrier families, but Hermitian
families have real, order-able eigenvalues — strictly ordered real spectra
cannot braid, so the permutation monodromy of a nondegenerate Hermitian loop
is always trivial.  The honest dichotomy is therefore: (positive half) an
explicit Z3 sheet monodromy on the COMPLEXIFIED family `λ³ = e^{iθ}` with
companion-matrix carrier and continuous sheets, and (no-go half) the
order-theoretic theorem that strictly ordered real eigenvalue paths force
the identity permutation.  Consequence for the program: generation-as-
monodromy needs complexified moduli loops or degeneracy crossings; on
Hermitian families the structure must live in eigenvector (Berry/Bargmann)
holonomy instead — consistent with the landed `BargmannCP`.

## Metadata

```yaml
aristotle:
  project_id: 8066248d-d28b-4262-ab65-94a0696a893c
  target_file: AgentTasks/aristotle-standalone/spectral-monodromy-dichotomy-20260710/SpectralMonodromyDichotomy/MonodromyDichotomy.lean
  expected_module: SpectralMonodromyDichotomy.MonodromyDichotomy
  submission_project: AgentTasks/aristotle-submit/spectral-monodromy-dichotomy-20260710-project
  output_dir: AgentTasks/aristotle-output/8066248d-d28b-4262-ab65-94a0696a893c
  status: submitted
```

Integration: this is the post-no-go generation rung after
`FamilyRankNoGo`; record both halves at their honest grades and do not let
the positive half claim more than a complexified toy family.
