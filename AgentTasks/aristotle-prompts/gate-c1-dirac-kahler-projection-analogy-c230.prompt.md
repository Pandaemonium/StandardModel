Gate C1 Dirac-Kahler chiral/flavour projection analogy audit, C230

You are Aristotle helping the StandardModel null-edge Gate C1 program.

Background:

Neo4j paper search surfaced:

```text
Steven Watterson, "The chiral and flavour projection of Dirac-Kahler fermions
in the geometric discretization", arXiv:0706.4385.
```

The current Gate C1 architecture is not Dirac-Kahler. It uses:

```text
Wilson/Neuberger overlap reference
  with CKM as an internal branch/flavor mass texture
  and a null-edge gapped homotopy/sector-signature match.
```

Task:

Audit whether Watterson-style chiral/flavour projection provides any useful
ideas or warnings for Gate C1.

Please answer:

1. What is the closest conceptual overlap between Dirac-Kahler chiral/flavour
   projection and our branch/flavor/projector problem?
2. Are there reusable finite projection patterns, multi-complex/taste-splitting
   ideas, or no-go warnings?
3. Does this literature support any part of GateC1_NU, or is it only an
   analogy?
4. How should the no-overclaim boundary be written?
5. Is there a concrete Aristotle/Lean job worth launching from this analogy, or
   should it stay as a literature note?

Claim boundaries:

```text
Do not treat Dirac-Kahler projection as proof of the null-edge operator.
Do not replace Wilson/Neuberger spacetime doubler resolution with this analogy.
Do not claim a true bad-sector inverse gap unless the construction supplies
one.
Do not claim anomaly/determinant/Krein safety from this analogy.
```

Requested output:

- concise analogy map;
- useful ideas to import, if any;
- warning/no-overclaim text;
- recommendation: pursue, park, or reject;
- any exact follow-up theorem statement if pursuit is justified.
