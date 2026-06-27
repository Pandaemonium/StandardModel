# F15 genuine-prediction-candidate ledger (report-only audit/strategy)

Provenance: returned `ARISTOTLE_SUMMARY.md` for Summary of changes for run aaea2501-d8f2-4516-8376-37b77c08d2d0
The focused package did not ship the standalone report file; this is the
returned summary, preserved verbatim as the integration record.

---

Delivered the F15 audit/strategy report at `AgentTasks/null-edge-f15-genuine-prediction-candidate-ledger.md` (no Lean changes; this was a no-build audit/strategy job).

What it contains, addressing each task:

1. **Moduli ledger** for the finite P2 architecture — a 13-row table covering graph family, null/tetrad frame, inverse-Gram/Hodge star, edge weights, branch counterterms, gauge group, representations, `Φ_H`, Higgs potential, spectral function, cutoff, and irrelevant operators — each tagged with its actual status in the Lean files (Free / Convention-fixed / Posited-constraint / Operator-determined) and its source locus. Key finding: the EFT-rich moduli (Yukawa block `Φ_H`, Higgs potential, spectral function, cutoff, Pauli/irrelevant operators) are all currently *free*, so `F : M_finite → M_EFT` is effectively full-rank on the EFT-relevant sector as formalized.

2. **Theorem classification** — every formalized result is sorted into Reconstruction (forbidden-counterterm codimension, Lichnerowicz square, scalar/gauge quadrature, EW stabilizer rank), Consistency (anomaly inheritance, conditional Gate-C release, the `{±1}⁴→{±g5}` sign rigidity), or Prediction-only-with-extra-hypotheses (branch-chirality forcing; anomaly-selected hypercharge). The conclusion confirms and generalizes f14's verdict: nothing currently formalized is a Gate-F prediction.

3. **Ranked first prediction targets** — Rank 1: operator-forced branch chirality / flavored-index rigidity (Gate C slot #13), the only modulus designed to be operator-determined and whose discrete codimension is already proven, gated solely on the unproven, falsifiable `OperatorForcesAlignment`. Rank 2: anomaly-selected hypercharge codimension (a clean `R(θ)=0`). Rank 3: forbidden-Pauli coefficient from the flat square (speculative). Demoted as full-rank reparametrizations: generation number (`nCopies n`, n free), Yukawa texture as built (`legalYukawa` is bookkeeping-only), and the EW "one photon" reconstruction.

4. **Exact Lean targets** — concrete proposed theorem statements for the top three (`operator_forces_alignment` with `branch_kernel_finrank_one` / `branch_chirality_is_pm_one`; `hypercharge_selected` with the 5-component `anomalyMap`; `Cdiamond_coefficient_rigid`), each with explicit acceptance and failure/falsifier criteria, including the §23.3/§25.3 branch audit (higher-dim kernels, complex branches, extended loci, Krein-negative modes).

5. **Adversarial verdict** — stated plainly: the formalized targets are all reconstruction/consistency and the free EFT moduli make `F` full-rank as written; the only genuine structural route is the Gate-C branch-chirality forcing, which remains PENDING until its falsifiable operator lemma is kernel-checked.

The report uses no prediction language for any target without naming an explicit rank/codimension/forcing mechanism, and proposes no new axioms (all suggested targets are ordinary `sorry` handoffs).

## Convergence note (2026-06-27 lateral analysis)

An independent lateral read of the program reached the same verdict this ledger
already records: the first prediction-grade result should be an **absence
theorem**, not a mass value ("the program does not predict `m_e`, but it predicts
that certain dangerous maps are not legal at all"). This is reinforcement, not a
new claim. It maps onto R3 here (forbidden-counterterm codimension promoted to
`M_EFT`) and the Gate H target `LegalFiniteDiracForbiddenOperator` in
`AgentTasks/null-edge-gate-h-legal-finite-dirac-forbidden-operator-plan.md`. The
ranking above is unchanged; the lateral analysis only raises the priority of the
forbidden-operator / codimension family relative to any magnitude target.
