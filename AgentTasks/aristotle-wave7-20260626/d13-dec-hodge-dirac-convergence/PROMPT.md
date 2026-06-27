# Aristotle job: D13 DEC Hodge-Dirac convergence adaptation strategy

This is a no-build strategy/audit job.

Goal: determine whether Gate D can inherit or adapt the DEC/FEEC Hodge-Dirac convergence scaffold, especially Dabetic-Hiptmair arXiv:2507.19405, instead of inventing a continuum proof from scratch.

Please analyze:

1. The closest mathematical object to the null-edge finite operator among DEC Hodge-Dirac, FEEC Hodge-Dirac, graph Dirac, and connection-Laplacian discretizations.
2. Which pieces of the null-edge operator are standard DEC/cochain data and which pieces are genuinely null-edge-specific perturbations.
3. A theorem chain from finite cochains to a continuum Dirac or Hodge-Dirac square, including what norms, mesh hypotheses, Hodge-star assumptions, dual-mesh assumptions, and boundary conditions are needed.
4. Where the dual-soldered null frame enters: as a quadrature rule, a coframe/soldering map, a perturbation of DEC, or an incompatible structure.
5. How to express the finite square D_N^2 = K_null + C_diamond + T_frame in DEC/FEEC terms.
6. What the first Lean-realistic toy theorem should be, avoiding full analysis infrastructure if possible.
7. Acceptance criteria for Gate D and hard failure criteria.
8. Whether this route should precede or replace the existing D1/D2/D6/D7 jobs.

Deliverables:

- A precise theorem-roadmap.
- A table of assumptions required by known DEC/FEEC results versus assumptions currently available in the null-edge program.
- A recommended first Aristotle proof job after this audit.
- A concise verdict: promising, conditional, or likely mismatch.
