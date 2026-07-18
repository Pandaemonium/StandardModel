# Prior work: causal-set nerves and stable homology

Date: 2026-07-16
Work item: `GRAV-GROWING-ATLAS-001`
Status: primary-source architecture comparison; no new program claim

## Relevant prior result

Major, Rideout, and Surya construct a topology from thickened inextendible
antichains and prove a conditional discrete-continuum correspondence for a
causal set faithfully embedded at sufficiently high density in a globally
hyperbolic spacetime. Their later computational study builds a one-parameter
family of nerve simplicial complexes and observes that continuum homology tends
to appear in the first stable region above the discreteness scale in tested 2D
and 3D manifold-generated causal sets.

Primary sources:

- Seth Major, David Rideout, Sumati Surya, [On Recovering Continuum Topology
  from a Causal Set](https://arxiv.org/abs/gr-qc/0604124), 2006.
- Seth Major, David Rideout, Sumati Surya, [Stable Homology as an Indicator of
  Manifoldlikeness in Causal Set Theory](https://arxiv.org/abs/0902.0434),
  2009.

The 2009 paper explicitly grades stable homology as a necessary but not
sufficient manifoldlikeness criterion.

## Relation to the protected-core atlas

The prior construction and the current R4 proposal share a valid structural
idea: topology is encoded by literal common intersections of an order-derived
cover, and stability must be tested across a scale parameter. They are not the
same cover.

- The prior work seeds spatial localization with an inextendible antichain and
  thickens it.
- R4 selects protected Alexandrov cores in a finite spacetime diamond using a
  capacity-constrained growing atlas.
- The prior theorem assumes faithful continuum embedding and sufficient
  density; it does not prove that the R4 selector is manifoldlike or that its
  nerve has the target homology.
- R4 currently gates only coverage, bounded multiplicity, connectedness, and
  occupied pair/triple overlaps. It does not yet compute persistent or stable
  homology.

## Program consequence

If R4 passes its held-out finite gate, the next topology stage should compare
the protected-core nerve across adjacent buffer and density scales and archive
Betti numbers or an equivalent exact homology summary. A preregistered stable
plateau can then serve as a manifoldlikeness control alongside, not in place
of, metric and curvature convergence.

If R4 fails, importing a homology calculation cannot repair the failed atlas:
the selector first needs a connected, bounded-multiplicity cover with genuine
higher overlaps. No tetrad, spin, curvature, or GR claim follows from either
the prior work or this note.
