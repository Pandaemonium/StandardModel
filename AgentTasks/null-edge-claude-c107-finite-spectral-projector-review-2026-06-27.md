# Claude adversarial review packet: C107 finite spectral-projector covariance seed

Date: 2026-06-27
Project: Null-edge / Gate C1_NU
Subject: C107 `ConjugationPowers`

## Context

The project has introduced `GateC1_NU`, a controlled non-ultralocal C1 target.
The decisive object is now a canonical branch observable:

```text
B(U)
```

If `B` is gauge-covariant:

```text
B(U^g) = S(g) B(U) S(g)^(-1),
```

then a finite spectral or polynomial branch projector should also be
gauge-covariant:

```text
p(B(U^g)) = S(g) p(B(U)) S(g)^(-1).
```

The attached C107 file proves only the finite matrix seed:

```text
(S B T)^k = S B^k T
```

when `S*T=1` and `T*S=1`, plus a projector/idempotence preservation theorem.

## Exact Lean source under review

The wrapper attaches:

```text
AgentTasks/aristotle-standalone/c107-finite-spectral-projector-20260627/C107FiniteSpectralProjector/ConjugationPowers.lean
```

## Questions for Claude

Please attack both the Lean statement and the project strategy.

1. Are the two theorem statements mathematically correct and aligned with the
   intended finite spectral-projector covariance seed?
2. Are both inverse hypotheses `S*T=1` and `T*S=1` necessary, and are they
   sufficient?
3. Is this too small to count as useful C1_NU progress, or is it the right
   base lemma before polynomial spectral projectors?
4. What is the next finite theorem after this: polynomial finite linear
   combinations, spectral-idempotence `p(B)^2=p(B)`, or origin chiral-index
   certificate for candidate `B`?
5. What overclaim risk would arise if this lemma were cited as “gauge-covariant
   spectral projection” too early?

## Requested output

Return:

```text
Verdict:
- sound / needs adjustment / false / too weak

Statement issues:
- ...

Gate C1_NU interpretation risks:
- ...

Best next theorem:
- ...
```
