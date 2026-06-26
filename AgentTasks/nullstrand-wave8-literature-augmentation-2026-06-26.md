# Wave 8 literature augmentation: dual-solder super-Dirac proof wave

**Date:** 2026-06-26
**Purpose:** add Claude's literature findings as semantic review context for the running Wave 8 Aristotle jobs.

## Zotero / Neo4j provenance

Claude reports that 8 papers were added to Zotero collection `9W59V3K9` (`null-edge-lit`) and mirrored into Neo4j with tags for blocker lanes:

```text
PFAG59D4, TBBD2TB4, 79XN2CGU, WZBHBDRP,
2DEG7MT2, WW6TKVH8, 9RF2ESFQ, NSR38VHU
```

Tags include:

```text
super-dirac, graph-dirac, krein-lorentzian, causal-set,
index-anomaly, spectral-action, prediction-gate
```

## Substantive literature takeaways to use in Wave 8

1. **Bianconi, arXiv:2212.05621**

   Treat as the closest graph/topological Dirac template. Claude reports that it has discrete Dirac structures on 3+1 networks where anticommutator/commutator pieces produce metric, curvature, and magnetic-field terms, including the correct gyromagnetic moment in the nonrelativistic limit.

   Use for semantic review of:

   ```text
   Job B: dual-solder commutator and kinetic quadratic form
   Job C: graded square and curvature term
   Pauli/g=2 normalization test
   ````

   Do not copy claims blindly: the null-strand construction is Lorentzian/dual-soldered/primitive-null, while Bianconi's framework may be topological/network Dirac rather than identical causal null-edge geometry.

2. **Post, arXiv:0708.3707**

   Treat as the closest doubled graph-Dirac/index template. Claude reports supersymmetric doubled graph Dirac operators with decorated `C^d` vertex spaces and a graph index theorem.

   Use for semantic review of:

   ```text
   Job D: finite Krein API and retarded/advanced doubled operator
   Job E: spectral mass-shell matching and finite index/anomaly follow-ons
   ````

   Key question: does the Post doubling/index structure map cleanly to our `D_double = [[0,D_-],[D_+,0]]`, or only to a Hilbert/SUSY envelope that must be reinterpreted through Krein `J`-adjoints?

3. **Aslanbeigi--Saravani--Sorkin, arXiv:1403.1622**

   Treat as the warning/falsification probe for continuum scaling: 4D causal-set d'Alembertian instability is a concrete failure mode. The retarded/advanced Krein doubling and dual-soldered local finite operator should be audited against this kind of instability.

   Use for semantic review of:

   ```text
   Job B/C symbol and square claims;
   Job D doubled Lorentzian audit;
   future G5 scaling tests.
   ````

4. **Finite Markov SLLN gap**

   Claude reports the arXiv search did not close this. Likely leads are Glynn--Meyn / Meyn--Tweedie, to be verified separately. Job F should keep continuous-time martingale/SLLN claims as handoff unless Lean infrastructure is actually available; discrete-time Poisson-equation telescoping remains the preferred trusted target.

5. **Near-node continuum process gap**

   Claude reports no new prior art from arXiv. Job F should keep the near-node process as a charter plus Bessel-threshold proxy, not a fake continuum SDE theorem.

## How this should change the running jobs

- **Job A:** no major change; still prove the tetrahedral `NullSolderFrame` and normalization audit. Add provenance note that this frame is the null-edge specialization needed before comparing to graph-Dirac templates.
- **Job B:** compare the dual-soldered commutator/quadratic form to Bianconi's graph Dirac metric/anticommutator mechanism. The target remains exact finite Lean identities, not a literature paraphrase.
- **Job C:** use Bianconi as a semantic check for the `D^2` curvature/magnetic term and the `g=2` normalization; keep the `Gamma_s`/`Phi` sign guardrail explicit.
- **Job D:** use Post as the nearest graph-doubling/index template; ensure Krein `J`-self-adjointness is not conflated with Hilbert self-adjoint SUSY-QM pairing.
- **Job E:** use Post for finite index/spectral-pairing intuition and use the prediction-gate framing to avoid overclaiming mass-shell matching as a new prediction.
- **Job F:** keep finite/discrete/proxy targets honest; continuous-time CTMC SLLN and stopped-node diffusion remain library/charter unless a real proof path appears.

## Follow-on jobs suggested by the literature

After the current Wave 8 patches return, consider two new jobs:

```text
Wave 9A: Bianconi comparison theorem/audit
  Map our `boxNull`, `cDiamond`, and Pauli/g=2 coefficient to the closest graph-Dirac identities, isolating what is exact finite algebra vs. continuum interpretation.

Wave 9B: Post doubled graph index/Krein audit
  Compare Post's doubled graph Dirac/index theorem to our retarded/advanced Krein double, identifying the smallest finite index theorem we can trust.
```
