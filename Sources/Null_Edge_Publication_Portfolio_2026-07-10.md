# Null-edge publication portfolio

Updated: 2026-07-10.

This document supersedes the June P1-P12 publication plan. The older topic IDs
remain useful for provenance, but they no longer define the paper portfolio.
The current program has a much clearer scientific spine:

```text
null spinors
-> complex Pluecker field
-> canonical Hermitian rest operator
-> exact local unitary dynamics
-> locality, topology, continuum, and many-body consequences
```

The publication strategy should follow that spine. A subsystem becomes a paper
only when it supports one memorable claim that a skeptical reader can test.
Formalization is a major strength and a reproducibility standard, but it is not
a substitute for the paper's physics or mathematics headline.

## Portfolio at a glance

| Order | Working paper | Current state | Submit when | Primary venue lane |
| --- | --- | --- | --- | --- |
| A | Null-spinor area as a canonical Dirac rest gap | Active flagship draft | full-Bloch claims close or are scoped; release audit passes | J. Phys. A / J. Math. Phys.; PRResearch or Quantum after one upgrade gate |
| B | Locality, doubling, and mass in strict 3+1 Dirac QCAs | Active theorem program | exact all-zone classification plus a sharp no-go or viable successor | Phys. Rev. Research / Phys. Rev. A / J. Phys. A |
| C | Pluecker phase as a lattice connection and topological defect field | High-upside, gated | patched winding is derived from local spinors and forces a stable localized mode | Quantum / SciPost Physics / Phys. Rev. Research |
| D | A changing-lattice continuum limit for unitary Dirac walks | Analytic core landed; main bridge open | explicit sampling/interpolation and position-space PDE convergence close | Ann. Henri Poincare / J. Math. Phys. / J. Phys. A |
| E | Finite CAR lifting and Pluecker-phase two-particle dynamics | Active | Fock lift is unitary and local; one operational two-particle quantity is calculated | Quantum / Phys. Rev. Research / J. Math. Phys. |
| F | Positive Hodge theory and moduli of finite Krein-Dirac carriers | Long theorem paper | carrier classification and perturbative stability close | Ann. Henri Poincare / J. Math. Phys. |
| G | Machine-checked finite relativistic quantum dynamics in Lean 4 | Library paper, not yet mature | reusable APIs, trusted promotion, and proof-engineering lessons are packaged | Journal of Automated Reasoning; ITP/CPP conference-first |
| H | Finite null information: a synthesis and research program | Deferred synthesis | at least three core research papers exist and the synthesis makes new cross-paper deductions | invited/presubmission Perspective, review, or monograph |

The practical order is `A`, then whichever of `B` or `C` closes first. Papers
`D` and `E` should follow as independent technical contributions. Papers `F`
and `G` need consolidation rather than more theorem accumulation. Paper `H` is
earned by the preceding series; it should not be used to introduce claims that
the theorem papers have not established.

## Paper A: the flagship now

### Working title

**From Null-Spinor Area to a Dirac Gap: Exact Unitary Dynamics from a Complex
Pluecker Mass**

### One-sentence claim

A pair of primitive null spinors canonically determines a complex Pluecker
coordinate whose modulus is the rest gap, whose phase survives in oriented
histories and local connection data, and whose associated finite walk is
exactly unitary.

### Core theorem package

- finite Cauchy-Binet/Pluecker mass identity and exact collinearity boundary;
- the canonical odd Hermitian rest operator `B_z`, with `B_z^2 = |z|^2 I`;
- exact rest eigenvectors, phase covariance, and no independent mass parameter;
- exact unitary walk and direct complex-weight history expansion;
- position-dependent `z(x,t)`, exact local unitarity, causal cone, and induced
  endpoint connection under local phase rotation;
- the fixed-momentum many-step continuum estimate, stated at its actual scope;
- exact regulator/no-go consequences and the preregistered high-momentum
  benchmark;
- explicit negative results: constant `z` is spectrally equivalent to an
  assigned mass, homogeneous positive actions do not select a nonzero scale,
  and the bare split family is not closed under temporal blocking.

### Mandatory submission gates

1. Complete or remove every advertised full-Bloch determinant formula.
2. Keep the Hamiltonian Wilson regulator distinct from a strict finite-range
   one-step QCA.
3. State that no observed mass value is predicted; `|z|` is not dynamically
   selected by the current homogeneous action.
4. State that changing-lattice position-space PDE convergence is Paper D, not a
   result of Paper A.
5. Include a baseline theorem showing exactly where constant `z` is only a
   reparametrized Dirac mass.
6. Release a clean Lean artifact, benchmark inputs/results, commit identifier,
   theorem-to-prose audit, and data/code availability statement.

### Venue decision

- **Core submission:** *Journal of Physics A* or *Journal of Mathematical
  Physics*. Both fit a substantial mathematical-physics paper with exact
  quantum-walk constructions and formal verification.
- **Upgrade submission:** *Physical Review Research* or *Quantum* only if Paper
  A absorbs one field-level consequence: either the strict alias-free `3+1`
  successor from Paper B or the protected defect theorem from Paper C.
- Do not send the current broad version to a prestige venue merely because it
  is ambitious. The upgrade is a theorem, not stronger adjectives.

## Paper B: strict 3+1 QCA theorem

### Working title

**Locality, Doubling, and Onsite Mass in Three-Dimensional Dirac Quantum
Cellular Automata**

### One-sentence claim

Exact unitarity, a live `3+1` Dirac tangent, onsite mass, finite propagation,
and absence of zero/pi aliases cannot all be achieved in the minimal
four-channel degree-one factorized architecture; the paper identifies the
smallest proved escape or the sharpest surviving lower bound.

### Already available

- the scoped stationary-amplitude obstruction;
- the exact even-parity alias theorem for every momentum-independent onsite
  coin in the live factorized class;
- determinant-to-Floquet-mode criteria;
- finite-range six-channel and D4/BCC/tetrahedral comparison candidates;
- a Wilson-Hamiltonian benchmark with explicit negative controls.

### Submission gate

The paper needs an exact full-zone result, not corner sampling. It must end in
one of two scientifically complete forms:

1. a concrete successor with exact all-momentum unitarity, finite-range inverse,
   Dirac tangent, Pluecker mass compatibility, and no unintended zero/pi modes;
   or
2. a genuinely sharp lower-bound theorem specifying which resource must grow:
   internal dimension, unit cell, range, or substep count, plus a witness at the
   first relaxed architecture.

### Venue lane

*Physical Review Research* or *Physical Review A* if the result materially
changes QCA construction practice; *Journal of Physics A* if the main result is
a mathematical classification/no-go theorem.

## Paper C: local phase and protected defects

### Working title

**Pluecker Phase as a Lattice Connection: Collinearity Defects in Unitary Dirac
Walks**

### One-sentence claim

The phase discarded by a scalar mass description becomes an exact lattice
connection for local Pluecker data, and nontrivial patched winding forces a
stable localized mode at a collinearity defect.

### Already available

- exact local phase covariance and endpoint link term;
- constant-phase cancellation;
- a theorem that a global real phase lift has zero winding;
- an explicit winding-one link field with no global lift;
- an existing finite winding/index spine elsewhere in the repository.

### Submission gate

Derive the patched link data from local nonzero `z(x)` away from its zeros,
reduce that data to the finite index operator, construct an explicit localized
eigenmode, and prove stability under a displayed perturbation class. Include a
zero-winding negative control. Without that bridge, the current material is a
strong section of Paper A, not a separate topology paper.

### Venue lane

This is the highest-upside standalone paper. A complete index/localization
theorem can plausibly target *Quantum*, *SciPost Physics*, or *Physical Review
Research*. The journals' selectivity should be treated as a test of whether the
result opens a reusable route for quantum-walk topology, not as a branding goal.

## Paper D: changing-lattice continuum analysis

### Working title

**A Changing-Lattice Strong Continuum Limit for Exactly Unitary Dirac Walks**

### One-sentence claim

Explicit sampling and interpolation maps carry the finite-range lattice walk
to the position-space Dirac flow uniformly on compact time intervals, with
quantified ultraviolet control.

### Already available

- one-step and fixed-momentum many-step estimates;
- finite-torus Fourier infrastructure;
- compact-support multiplier bridges;
- an abstract bulk/tail split;
- qualitative `L2` tail convergence over exhausting measurable bands.

### Submission gate

Define the changing Hilbert spaces, Fourier normalization, `S_a`, `I_a`, and
the limiting generator. Prove strong `L2` convergence for a stated Sobolev
class and identify the multiplier with the position-space Dirac PDE. Variable
`z(x)` is an extension, not a requirement for the first paper. Do not advertise
operator-norm convergence unless it is actually proved.

### Venue lane

*Annales Henri Poincare* is a stretch target if the analysis is general and
technically substantial. *Journal of Mathematical Physics* and *Journal of
Physics A* are the natural core venues.

## Paper E: second quantization and interaction

### Working title

**Finite CAR Dynamics from a Pluecker Dirac Walk**

### One-sentence claim

The one-particle Pluecker walk lifts to an exactly local, number/parity
preserving Fock automorphism, while the complex Pluecker phase controls a
measurable two-particle process invisible in the one-particle sector.

### Already available

- generic finite CAR creation/annihilation algebra;
- determinant-minor `Gamma(U)`, vacuum and one-particle agreement, linearity,
  number conservation, and parity conservation;
- a Hermitian Pluecker-weighted quartic pair transfer;
- an exact unitary rank-two pair kick that fixes every one-particle basis state
  and changes an explicit two-particle state.

### Submission gate

Close creation covariance, functoriality, unitarity of `Gamma(U)`, and inherited
causal locality. Then calculate one operational quantity: scattering phase,
bound-state energy, threshold, or a proved selection rule. The current rank-two
kick is a rigorous seed, not yet a many-body physics paper.

### Venue lane

*Quantum* or *Physical Review Research* if the operational consequence and
locality theorem are strong; *Journal of Mathematical Physics* or *Journal of
Physics A* for a finite CAR/operator theorem.

## Paper F: carrier classification

### Working title

**Positive Hodge Theory and Moduli of Finite Krein-Dirac Carriers**

This should absorb the best material from the positive carrier, Hodge,
cohomology, decoder, and moduli documents. It becomes publishable when it has:

- an invariant category/equivalence relation for carriers;
- necessary and sufficient physical positivity criteria;
- classification of induced operators on positive cohomology;
- a nontrivial moduli theorem rather than a list of witnesses;
- perturbative stability of the physical gap;
- at least two inequivalent examples and one no-go control.

The likely venues are *Annales Henri Poincare* and *Journal of Mathematical
Physics*. Standard Model names, generation counts, and cosmology should remain
applications or future gates unless the classification forces them.

## Paper G: formalization and reusable library

### Working title

**Machine-Checked Finite Relativistic Quantum Dynamics in Lean 4**

This is not a dump of all project theorems. It should present a reusable Lean
library and the scientific lessons exposed by formalization:

- separation of null support from Clifford soldering;
- determinant-level versus coefficient-level doubling tests;
- Hamiltonian locality versus strict QCA locality;
- global phase lifts versus patched winding data;
- one-particle unitarity versus CAR/Fock automorphisms;
- benchmark/oracle outputs validated against kernel-checked identities.

Submit only after the central APIs are documented, examples build from a clean
checkout, flagship declarations have axiom pins, and project-specific names are
factored away from reusable abstractions. *Journal of Automated Reasoning* is a
good journal target because it explicitly welcomes formal proof assistants and
scientific applications as case studies. An ITP or CPP paper can precede the
journal version if it tells a focused proof-engineering story.

## Paper H: synthesis, later

### Working title

**Finite Null Information: Dynamics, Defects, and Mass from Local Decoding**

This is the eventual paradigm paper, review, or monograph. It should synthesize
published results rather than ask one referee to validate the entire ontology
at once. A reasonable gate is three accepted or mature core papers, including
at least one of B/C and at least one of D/E.

Possible homes are an invited review or a presubmission proposal for a
Perspective. *Physical Review Research* accepts Perspective proposals but
normally invites them; it does not treat an opinion-only white paper as a
research article. Until the gate is met, maintain the synthesis documents as
internal research maps and public preprints only when every claim is graded.

## What is no longer a standalone publication target

The old P1-P12 plan encouraged fragmentation. The following material should be
merged or deferred:

| Old lane | New disposition |
| --- | --- |
| P1 Pluecker mass, P2 finite Dirac square root, P4 checkerboard dynamics | merge into Paper A |
| P3 causal-diamond holonomy | later application paper only after coupling to a variable walk/complex and refinement law |
| P5 quantum measure and P7 observer channels | infrastructure in A, E, or G; standalone only after a new operational theorem |
| P6 flavor overlaps | defer until a rank/mixing theorem or numerical constraint exists |
| P8 ontology manifesto | becomes Paper H after the research series exists |
| P9 source visibility/cosmological constant | defer; no cosmology submission without a calibrated continuum source-response theorem |
| P10 generations/triality | defer until multiplicity is forced rather than supplied |
| P11 stable particle sectors | fold into E when a genuine interacting spectral sector is proved |
| P12 exterior-history grade-2 capacity | supporting algebra in A or F |
| standalone RG or scale-selection paper | not yet; temporal nonclosure and homogeneous scale no-go are strong boundary results inside A/B |
| general-audience manuscript | outreach companion after Paper A is stable, not a research submission |

The mass-rank-defect and complete-null-information manuscripts remain valuable
research notebooks. They should not be submitted as claims of a completed
Standard Model, gravity theory, Higgs mechanism, or cosmology until downstream
prediction gates exist.

## Anti-fragmentation and authorship rules

1. One paper, one sentence that survives deletion of the Lean discussion.
2. A theorem used only as infrastructure belongs in the paper whose consequence
   it enables.
3. Do not publish both a formalization paper and a physics paper with the same
   theorem inventory unless each has a genuinely different contribution.
4. Each paper gets its own claim matrix, nearest-work comparison, negative
   control, falsifier, artifact manifest, and exact dependency list.
5. Resolve authorship, affiliations, ORCIDs, AI-use disclosure, and contributor
   roles before submission. The archival artifact must identify human
   responsibility for scientific claims and semantic review.

## Venue policy checked 2026-07-10

- [Quantum](https://quantum-journal.org/) is a community-run open-access venue
  for quantum science; use it for C or E only when the consequence matters to
  that community beyond this model.
- [Physical Review Research](https://journals.aps.org/prresearch/about) seeks
  significant developments across physics and emerging interdisciplinary work;
  it is an upgrade lane for A/B/C/E, not the default home for an internally
  consistent construction.
- [SciPost Physics](https://scipost.org/SciPostPhys/about) requires a
  breakthrough, a new research pathway, a cross-field link, or progress on a
  recognized stumbling block. C is the best fit if the defect/index theorem
  closes.
- [Journal of Mathematical Physics](https://pubs.aip.org/aip/jmp) explicitly
  covers mathematical methods applied to physics and formulation of physical
  theories; it is a natural home for A, D, E, or F at theorem-paper scope.
- [Journal of Physics A](https://publishingsupport.iopscience.iop.org/journals/journal-of-physics-a-mathematical-and-theoretical/about-journal-physics-mathematical-theoretical/)
  explicitly covers lattice models, cellular automata, mathematical physics,
  quantum information, and relativistic quantum mechanics; it is the broadest
  core fit for A, B, D, or E.
- [Annales Henri Poincare](https://link.springer.com/journal/23/aims-and-scope)
  emphasizes analytical theoretical and mathematical physics, including
  quantum dynamics and spectral analysis; reserve it for a genuinely general D
  or F theorem.
- [Journal of Automated Reasoning](https://link.springer.com/journal/10817/aims-and-scope)
  covers proof assistants and formalized scientific applications; it is the
  clearest journal target for G after the library is reusable.

Venue scopes and policies can change. Recheck them at submission time, along
with article types, length limits, open-access costs, and AI-use policies.
