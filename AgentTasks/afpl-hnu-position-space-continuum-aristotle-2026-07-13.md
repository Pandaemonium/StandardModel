# Aristotle successor: HNU position-space continuum bridge

```yaml
aristotle:
  project_id: da29672d-5b8a-4e65-bac0-4d3d154dda57
  task_id: fe61a4d3-42b1-4ac7-86e4-020d9c3bb3a3
  target_file: HNUPositionSpaceContinuum.lean
  expected_module: HNUPositionSpaceContinuum
  status: submitted
```

## Prompt

Build the strongest rigorous position-space continuum bridge presently
possible for the exact HNU update. Reuse the exact real-space/symbol bridge,
the HNU infrared tangent, the compact-momentum many-step theorem shape, and the
existing changing-lattice bulk/tail infrastructure.

Target architecture:

1. define an explicit sampling/interpolation or Fourier-multiplier bridge for
   a stated band-limited or compact-momentum class of spinor wave packets;
2. prove that the real-space HNU step has exactly the endpoint symbol already
   formalized;
3. combine a uniform compact-momentum estimate with a high-frequency tail
   bound to obtain a changing-lattice `L2` convergence theorem to the Weyl
   flow for a precisely stated dense class;
4. expose every normalization, sign, lattice spacing, time scaling, and
   Fourier convention;
5. give a nonzero compactly supported-in-momentum witness.

If dependencies do not yet support the full theorem, return a kernel-checked
composition lemma that reduces it to one named uniform multiplier estimate
and one named tail estimate, with no semantic gap. Prefer an honest conditional
capstone to a vague claim.

Do not claim all-`L2` convergence, Lorentz invariance, copy freedom, chirality
selection, primitive-null soldering, or a continuum QFT. Add standard-three
guards, report any imported analytic hypotheses, and finish with a precise
completion/blocker report. Do not weaken existing theorem statements.
