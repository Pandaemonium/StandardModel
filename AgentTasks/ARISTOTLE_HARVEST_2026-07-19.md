# Aristotle harvest close-out - 2026-07-19

This note records the independent review of the Fable return batch and the
stalled Codex jobs. A completed Aristotle task is not treated as a theorem
landing until its source has been inspected and rebuilt locally.

## Assumption-clean and root-integrated

| Result | Aristotle project | Integrated module | Review outcome |
|---|---|---|---|
| C2 full-walk census | `78a8ea71-9ec7-4382-b28f-1ac840653ce7` | `PhysicsSM/Draft/NullEdge/HalfWindingFullWalkStatus.lean` | All four determinant-mode claims are proved from explicit integral null vectors. The result shows that the full field-2 walk has both signs even though its compressed sector has neither. |
| Ring A5 classification | `23312458-971a-45f7-bff6-1ccbb41d6c5e` | `PhysicsSM/Draft/NullEdge/RingHolonomyClassification.lean` | Equal holonomy is equivalent to gauge equivalence and yields diagonal unitary conjugacy. Already applied before this sweep; rebuilt here. |
| HNU canonical decoder | `70183b62-2e63-4e3a-a112-9ffab39017f2` | `PhysicsSM/Draft/NullEdge/HNUCanonicalDecoder.lean` | Additivity, homogeneity, locality, complement annihilation, a nonvacuous model, and uniqueness are hole-free. |
| Rank-four Lagrange selector | `695bcfb3-f956-4c37-8894-2713905d91d8` | `PhysicsSM/Draft/NullEdge/IntrinsicRankFourLagrangeSelector.lean` | Any four selected simple eigenvalues yield an exact idempotent polynomial filter with four-dimensional range. Gap, inertia, and refinement stability remain separate hypotheses. |
| Fixed-momentum phase image and fiber | `bdfa33fa-1eb5-4697-9858-7e1c1776a09f` | `PhysicsSM/Draft/NullEdge/NullFactorizationSpinFiber.lean` | Fixed momentum determines determinant magnitude but permits every phase; fixing phase leaves the unique right `SU(2)` orbit. Includes a nondegenerate quarter-turn witness. |

## Locally complete, but transitively assumption-tainted

The returned source files below contain no local proof holes and compile, but
an independent `#print axioms` audit found `sorryAx` in each headline theorem's
transitive dependency footprint. They are useful draft harvests, not root
milestones. The files remain in the draft tree but are deliberately omitted
from `PhysicsSM.lean` until their imported theorem chain is assumption-clean.

| Result | Aristotle project | Draft module | Audit outcome |
|---|---|---|---|
| Cl8 sigma action | `a5de8280-fec9-4c9f-98b9-516011897338` | `PhysicsSM/Draft/NullEdge/Cl8SigmaAction.lean` | Multiplicativity, signed color permutation, and the S3 braid are locally complete; the braid inherits `sorryAx`. |
| Exterior-action crux | `e104c7db-6372-48e9-8218-a0672687180d` | `PhysicsSM/Draft/Spin10FockExteriorAction.lean` | Cauchy-Binet composition and exterior-action functoriality are locally complete; `extAction_mul` inherits `sorryAx`. |
| B4 Wilson-Cayley dictionary | `283cb5b8-99d1-4252-8859-f8edff04ee9a` | `PhysicsSM/Draft/NullEdge/WilsonCayleyWalk.lean` | The local proof is complete, but it imports the open theorem in `Strict3Plus1Frontier.lean`; the headline no-go inherits `sorryAx`. |
| J1 power-four / Peirce chain | `47fe6cd0-b31d-4923-ae2a-b54248714fbe` | `PhysicsSM/Draft/H3OPeirceDecomposition.lean` | The local Peirce calculations are complete; `lagrangeE_isProjection` inherits `sorryAx` from the upstream H3(O) chain. |

## Useful partial returns

| Result | Aristotle project | Salvage | Remaining blocker |
|---|---|---|---|
| Vacuum-fiber transitivity | `9cf244e7-61dc-4873-af52-c3c54cf25883` | Stabilizer invariance, weak-spinor membership, identity witness, and scalar-line case were integrated in `Spin10VacuumFiberTransitivity.lean`. | General transitivity remains one explicit handoff hole. |
| General incidence | `f0c8d098-d381-433d-a2f6-be4368d6ff6f` | Two hole-free coefficient reductions were isolated in `Spin10VacuumIncidence.lean`. | The main incidence theorem remains open. |
| Chart lemmas | `d601d2ff-a3b1-4b5e-8579-c54a5aeadc06` | Five exact degree-four Pluecker coordinate identities were isolated in `Spin10VacuumChartQuadrics.lean`. | The proposed chart reconstruction times out and three declarations remain open in the returned artifact. |
| Moufang-Artin / Hurwitz gate | `65457ef8-a4fd-4760-bbe9-439c99d91d72` | Two Artin linearization lemmas were integrated in the standalone Stage2 package. | The requested unsigned `associator_mul_right` identity is false for octonions: the two sides differ by sign on an explicit basis witness. A corrected signed theorem is required before right Moufang can close. |

## Stalled Codex jobs

The following tasks exceeded the two-hour stall rule. Their project snapshots
were downloaded before cancellation under `AgentTasks/aristotle-output/`.

| Job | Aristotle project | Disposition |
|---|---|---|
| Massive HNU global gap | `081bd1d6-d82e-4a13-b215-c319775a5aac` | Canceled. The snapshot contains a promising parity/spectral decomposition, but its two new core lemmas remain open. Preserve as a smaller resubmission plan; do not merge it. |
| Gupta short-stay tangent | `daac1f2a-0bcc-4238-b8b7-74238185d1d2` | Canceled. The snapshot only adds six unproved declarations; the live certificate remains preferable. |
| Floquet micromotion strategy | `0fec57cf-2d61-4b56-b703-a075d6587977` | Canceled. No distinct strategy report or proof artifact was returned. |

## Scientific reading

The sweep contains genuine theorem progress rather than a second budget kill.
Five headline returns are assumption-clean after including the two residual
completed projects: ring-holonomy classification, full-versus-compressed C2
spectral separation, canonical HNU decoder uniqueness, exact rank-four
polynomial selection, and fixed-momentum phase/fiber classification. The
locally complete exterior-action, Wilson-Cayley, Cl8, and H3(O) files sharply
isolate upstream cleanup work. The most important negative result is equally
useful: the unsigned Moufang companion requested by the Hurwitz plan is
mathematically false and must be replaced by its signed version.

## Verification protocol

Each accepted or salvaged live module was checked directly with
`lake env lean`. The clean A5 flagship is pinned in
`PhysicsSM/Draft/AristotleHarvestAxiomGuard.lean`; the C2 and HNU modules carry
their own build-enforced pins. The four transitive `sorryAx` findings are not
permitted in the root milestone set. A root `lake build` and repository hygiene
checks complete this close-out.
