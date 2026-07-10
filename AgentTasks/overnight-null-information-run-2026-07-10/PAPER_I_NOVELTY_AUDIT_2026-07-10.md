# Paper I novelty audit, 2026-07-10

Scope: claim-level positioning for
`Sources/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex`.
This is not a legal priority search or a proof that no earlier publication
contains an equivalent result.

## Verdict table

| Candidate claim | Closest checked precedent | Defensible wording |
|---|---|---|
| A two-spinor wedge gives `det P = |z|^2` | Cauchy--Binet, spinor-helicity, and rank-one Hermitian momentum are established | Classical kinematics, formalized here |
| `B(z) = [[0,z],[conj z,0]]` is the canonical odd Hermitian rest operator and gives `H^2 = (k^2 + det P) I` | Standard Dirac mass matrices and phase conjugacies are established; no checked source in the scoped corpus derives this operator from the null-spinor Pluecker coordinate | New synthesis/construction; avoid claiming discovery of odd mass matrices themselves |
| The unitary coin has corner/stay ratio `-i tan(a mu)` | Succi--Fillion-Gourdeau--Palpacelli (2015) explicitly relate exponential Dirac mass matrices to quantum-walk Euler angles through tangent formulas | Established parametrization; the new payload is its exact recursive-kernel composition with Pluecker-derived `B(z)` and machine verification |
| The recursive unitary kernel equals `cos(a mu)^n` times the polynomial checkerboard kernel | D'Ariano--Mosco--Perinotti--Tosini (2014) give an exact Dirac-QCA path integral; Feynman-checkerboard literature counts turns | Exact finite theorem in this artifact; describe as a checked composition unless a broader full-text search establishes priority |
| Uniform `O(1/n)` product convergence | Product formulas and observational-convergence machinery are established | New explicit instantiation/constant for this derived walk, not a new Trotter theory |
| Successive-axis local `3+1` walk | Mlodinow--Brun (2018) construct a 3D walk as three one-dimensional factors; Nzongani et al. (2024) give a tetrahedral `3+1` Dirac walk | Established architecture; new payload is the formalized ordered bridge, explicit compact rate, and Pluecker-derived rest input |
| The massless points are `0` and `pi` | Floquet partners and doubling are established; Gupta--Short (2026) distinguish doublers from pseudo-doublers and construct stationary-amplitude families | Exact audit of this walk. Call the quasienergy-`pi` point a Floquet pseudo-doubler, not a second zero-energy doubler |
| Formal verification is scientifically material | PhysLean/HepLean and formalized quantum-information work establish the broader method | Emphasize the concrete corrections exposed here: mass versus mass squared, tangent versus linear corner parameter, factor order, full-zone terminology, and many-step versus one-step control |

## Primary sources checked

- G. M. D'Ariano, N. Mosco, P. Perinotti, A. Tosini,
  *Path-integral solution of the one-dimensional Dirac quantum cellular
  automaton*, arXiv:1406.1021.
- S. Succi, F. Fillion-Gourdeau, S. Palpacelli,
  *Quantum lattice Boltzmann is a quantum walk*, EPJ Quantum Technology 2,
  12 (2015), doi:10.1140/epjqt/s40507-015-0025-1.
- A. Mallick, C. M. Chandrashekar,
  *Dirac Quantum Cellular Automaton from Split-step Quantum Walk*,
  arXiv:1509.08851.
- L. Mlodinow, T. A. Brun,
  *Discrete spacetime, quantum walks and relativistic wave equations*,
  arXiv:1802.03910.
- U. Nzongani et al., *Dirac quantum walk on tetrahedra*,
  arXiv:2404.09840.
- C. Gupta, A. J. Short, *Fermion Doubling in Dirac Quantum Walks*,
  arXiv:2601.15885, accepted by Physical Review A on 2026-07-01.

## Search record

- Web searches: exact unitary Dirac checkerboard tangent/corner relation;
  split-step path sums; current fermion-doubling work.
- Local Neo4j full-text chunk search: `exact unitary Dirac quantum walk
  checkerboard corner weight tangent coin angle tan mass`; `fermion doubling
  pseudo-doubler Floquet pi quasienergy Dirac quantum walk`.
- Negative search results are treated only as evidence for cautious wording,
  never as proof of originality.

## Release gate

Before submission, search citation trails and full text for the exact finite
kernel identity, ask at least one specialist reader whether an equivalent
normalization appears under another coin convention, and replace every absolute
priority phrase with the claim-level wording above unless that audit is clean.
