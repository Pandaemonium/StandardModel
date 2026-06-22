# Null-edge physics/semantics audit report

Date: 2026-06-22
Scope: comment/docstring-only audit (no statements, proofs, imports, namespaces,
or executable behavior changed). Confidence scores 1-10 per the prompt rubric.

Reference program documents read: `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`,
`Sources/Null_Edge_Causal_Graph_Research_Plan.md`,
`AgentTasks/null-edge-autonomous-aristotle-loop-plan-2026-06-21.md`.

All 14 prioritized modules were inspected in full and confirmed free of the
unfinished-proof placeholder token.

## 1. Audit table (grouped by module)

### PhysicsSM/Spinor/PluckerMass.lean (trusted)
| Declaration | Score | Note |
|---|---|---|
| `rankOneHermitian`, `spinorWedge`, `complexAbsSq` | 9 | Clean carriers; conventions explicit in module docstring. |
| `det_rankOneHermitian_eq_zero` | 10 | Single null edge is massless; exact. |
| `two_edge_plucker_mass_identity` | 10 | `det(psi psi^dagger + phi phi^dagger) = |wedge|^2`; exact Gram/Cauchy-Binet. |
| `fin_bundle_plucker_mass_identity` | 10 | General finite Pluecker mass; exact and central. |
| `fin_bundle_det_*_nonneg` / `_im_eq_zero` / `_ofReal_*` | 9 | Correctly exposes the determinant as a nonnegative real (mass-squared positivity). |
| `*_iff_common_direction`, collinearity criteria | 9 | Massless-iff-collinear, stated quotient-free with explicit nonzero base. |

### PhysicsSM/Gauge/CausalDiamondHolonomy.lean (trusted)
| Declaration | Score | Note |
|---|---|---|
| `DiamondLabels`, `PathPair`, `diamondDefect`, `pathPairDefect` | 9 | Wilson-line branch comparison; honest that it is not a continuum field strength. |
| `diamondDefect_gauge_covariant` (non-Abelian) | 10 | Conjugation at the top endpoint; correct. |
| `diamondDefect_gauge_invariant` (Abelian) | 10 | Correct commutative specialization. |
| `pathPairDefect_verticalCompose` / `_comm` / `_horizontalCompose` | 9 | Correct gluing laws incl. the non-Abelian transport correction. |
| `diamondDefect_classFunction_gauge_invariant` | 9 | Finite analog of trace of a plaquette holonomy; correct. |

### PhysicsSM/Draft/TwistorPluckerMass.lean
| Declaration | Score | Note |
|---|---|---|
| `SpinorChartTwistor`, `infinityTwistorPairing` | 8 | Identifies the infinity-twistor spinor pairing with the `pi`-wedge; `omega` carried but unused (stated). |
| `two_twistor_momentum_det_eq_massInvariant` | 9 | Exact reuse of the trusted two-edge identity. |
| `twoTwistorMassSq{Det,Trace}Convention*` | 9 | The det-vs-trace factor of 2 is kept explicit rather than hidden -- good practice. |
| `multi_twistor_momentum_det_eq_pairwiseMass` | 9 | Multi-twistor matching; exact. |

### PhysicsSM/Draft/NullEdgeDiracSlashCore.lean
| Declaration | Score | Note |
|---|---|---|
| `minkowskiNorm`, `sigmaMomentum`, `barSigmaMomentum` | 9 | `(+---)` Weyl blocks; `det(sigma.p) = p0^2-p1^2-p2^2-p3^2` verified. |
| `sigma_mul_barSigma_eq_norm`, `barSigma_mul_sigma_eq_norm` | 9 | Correct Clifford/slash square per block. |
| `chiralDiracSlash_sq_eq_norm` | 9 | `(slash p)^2 = p^2 I`; exact finite Clifford identity. |
| `chiralDiracSlash_sq_eq_mass_of_norm_eq` | 9 | Honest bridge hypothesis to an external mass functional. |

### PhysicsSM/Draft/NullEdgeBundleDiracPluckerCore.lean
| Declaration | Score | Note |
|---|---|---|
| `matrixWeylCoords` + `sigmaMomentum_matrixWeylCoords_eq` | 9 | Correct Pauli-coordinate inverse of `sigmaMomentum`. |
| `bundleMomentum_minkowskiNorm_eq_pairwisePluckerMass` | 9 | Routes Pluecker det through the trusted API; exact. |
| `chiralDiracSlash_bundleMomentum_sq_eq_pluckerMass` | 9 | Static slash squares to trusted Pluecker mass; clear scope. |

### PhysicsSM/Draft/NullEdgeSuperDiracBlockCore.lean
| Declaration | Score | Note |
|---|---|---|
| `offDiagonal`, `chirality`, `hodgeDirac` | 8 | Standard NCG/Kaehler-Dirac odd-operator pattern; honest finite algebra. |
| `offDiagonal_sq_*Block`, `chirality_anticommutes_offDiagonal` | 9 | Correct block squares and chirality anticommutation. |
| `scalarFlip_sq_eq_massSq` | 9 | Higgs/Yukawa flip squares to `m^2`; correct. |

### PhysicsSM/Draft/NullEdgeSuperconnectionExpansionCore.lean
| Declaration | Score | Note |
|---|---|---|
| `finiteSuperconnection` and square-block lemmas | 8 | Quillen-style superconnection square expansion; correct and clearly scoped. |
| `*_noCross` Laplacian-plus-Higgs lemmas | 9 | Correct under the stated cross-term-vanishing hypotheses. |

### PhysicsSM/Draft/NullEdgeCovariantDifferentialCore.lean
| Declaration | Score | Note |
|---|---|---|
| `covariantD0`, `covariantD1`, `triangleCurvature` | 8 | Twisted discrete differential; `D1 D0 = curvature * f`. Abelian (`Units Complex`) only, stated. |
| `*_gauge_covariant`, `triangleCurvature_gauge_transform` | 8 | Correct abelian covariance; non-Abelian higher gauge explicitly out of scope. |

### PhysicsSM/Draft/NullEdgePluckerBargmannPhaseCore.lean
| Declaration | Score | Note |
|---|---|---|
| `spinorInner`, `spinorWedge`, `plucker_lagrange_identity` | 9 | Correct 2D Lagrange identity (overlap + wedge = product of norms). |
| `rankOneProjector` | 7 | Name suggests an idempotent projector but it is idempotent only for unit spinors. Comment added. |
| `bargmannTripleTrace_rankOne` | 8 | Correct cyclic-overlap trace; geometric-phase reading needs normalization (now noted). |
| `normalized_plucker_eq_one_sub_overlap` | 9 | Correct Fubini-Study/chordal bridge for unit spinors. |

### PhysicsSM/Draft/NullEdgeQubitConcurrence.lean
| Declaration | Score | Note |
|---|---|---|
| `trace2_mul_self_eq_trace_sq_sub_two_det` | 9 | Correct `Tr(rho^2)=Tr(rho)^2-2 det`. |
| `concurrenceSqComplex` | 7 | "Concurrence" = single-qubit tangle/linear-entropy form `4 det`, not Wootters; no positivity bundled. Comment added. |
| `linearEntropyComplex_eq_concurrenceSq_of_trace_one` | 8 | Correct under trace-one hypothesis. |
| `normalized_mass_ratio_eq_concurrence` and `_sq_eq_four_det` | 8 | Identification is by definition (`2 sqrt d`); honest but tautological bridge. |

### PhysicsSM/Draft/NullEdgePathPairInterchange.lean
| Declaration | Score | Note |
|---|---|---|
| `pathPair_vertical_horizontal_interchange` | 9 | Interchange law holds definitionally; clean. |
| `pathPairDefect_interchange`, `pathPairDefect_grid_comm` | 9 | Correct; abelian grid product clearly scoped. |

### PhysicsSM/Draft/NullEdgeGramWeightedMassAristotle.lean
| Declaration | Score | Note |
|---|---|---|
| `gramWeightedVisibleMomentum`, `exteriorPairGram`, `gramWeightedPluckerMass` | 9 | Correct `M G M^dagger` momentum and exterior-square Gram weighting. |
| `visibleDet_eq_exteriorGram_weighted_plucker` | 9 | Generalized Cauchy-Binet; correct, the strongest new result in this cluster. |
| `orthonormal_internalGram_recovers_plucker_sum`, `rankOne_internalGram_*` | 9 | `G=1` and rank-one limits correct. |
| two-state partial-coherence bridges | 8 | Correctly specializes to the existing decoherence-channel API. |

### PhysicsSM/Draft/NullEdgeGramWeightedOperator.lean
| Declaration | Score | Note |
|---|---|---|
| `visibleQuadraticForm_gramWeighted_eq_gramQuadraticForm` | 9 | `v^dagger P v = (proj v)^dagger G (proj v)`; correct. |
| `gramPositiveSemidefinite_implies_visiblePositiveSemidefinite` | 9 | Correct descent of positivity; PSD encoded as re>=0 and im=0. |

### PhysicsSM/Draft/NullEdgeGramWeightedHermitian.lean
| Declaration | Score | Note |
|---|---|---|
| `operatorGramWeightedVisibleMomentum_hermitian_of_gramHermitian` | 9 | Correct: Hermitian Gram induces Hermitian visible momentum. |
| `matrixHermitian_diag_im_eq_zero`, diagonal-real corollary | 9 | Correct. |

## 2. Highest-risk mismatches

1. `NullEdgePluckerBargmannPhaseCore.rankOneProjector` (score 7). The name
   asserts a projector, but the matrix is idempotent only for unit spinors; the
   triple-trace yields the Pancharatnam/Bargmann geometric phase invariant only
   after normalization. Smallest safe fix (applied): a docstring caveat pointing
   to the unit-spinor corollary. A future hardening would add an explicit
   `spinorNormSq psi = 1` hypothesis to any theorem given a geometric-phase
   reading.
2. `NullEdgeQubitConcurrence.concurrenceSqComplex` (score 7). "Concurrence" here
   is the single-qubit tangle/linear-entropy `4 det rho`, not the Wootters
   two-qubit concurrence, and no Hermiticity/positivity/trace-one axioms are
   bundled. Smallest safe fix (applied): a docstring caveat. The
   mass-ratio = concurrence identification (`normalized_mass_ratio_eq_concurrence`)
   is true only because both sides are defined as `2 sqrt d`; it records an
   intended physical identification rather than deriving one.
3. `TwistorPluckerMass.infinityTwistorPairing` (score 8, watch item). Dotted and
   undotted spinors share the carrier `Fin 2 -> C`, and `omega` is unused. This
   is fine for the finite mass statement but must not be read as twistor
   incidence; the existing module docstring already states this boundary.

## 3. Best-aligned theorem clusters

- Finite Pluecker mass (`PhysicsSM.Spinor.PluckerMass`): exact, central,
  trusted; massless-iff-collinear criteria are precise and quotient-free.
- Causal-diamond holonomy (`PhysicsSM.Gauge.CausalDiamondHolonomy`): clean
  Abelian invariance, non-Abelian endpoint covariance, class-function
  invariance, and gluing laws.
- Gram-weighted mass/operator/Hermitian cluster: the generalized Cauchy-Binet
  determinant formula plus matching positivity and Hermiticity descent form a
  coherent, well-scoped extension to nonorthogonal internal labels.
- Dirac-slash square + bundle bridge: `(slash p)^2 = p^2` composed with the
  trusted Pluecker determinant is a tidy, honestly-static square-root cluster.

## 4. Comment/docstring-only patches made

- `PhysicsSM/Draft/NullEdgePluckerBargmannPhaseCore.lean`: added an audit note to
  the `rankOneProjector` docstring (idempotence only for unit spinors; geometric
  phase requires normalization).
- `PhysicsSM/Draft/NullEdgeQubitConcurrence.lean`: added an audit note to the
  `concurrenceSqComplex` docstring (single-qubit tangle form, not Wootters; no
  positivity/Hermiticity/trace-one bundled).

No statements, proofs, imports, namespaces, or executable code were modified.
Comments are ASCII-only and avoid raw placeholder/escape-hatch tokens.

## 5. Recommended next audit or proof job

Audit the non-listed but adjacent draft cluster that these modules depend on or
extend -- in particular `PhysicsSM.Draft.NullEdgeDecoherenceChannelAristotle`
(supplies `partialCoherenceMomentum` / `hiddenOverlapDetFactor` used by the
Gram-weighted mass module) -- to confirm the partial-coherence factor and its
positivity range carry the intended decoherence semantics. A natural follow-on
proof job is to strengthen the geometric-phase and concurrence wrappers by
adding explicit normalization / positive-semidefiniteness hypotheses (or
`HermitianMatrix.PosSemidef`-style carriers) so the entanglement and
Pancharatnam readings are theorems about genuine density matrices rather than
unconstrained complex matrices.

## Modules not inspected

The repository contains 107 files under `PhysicsSM/Draft/` plus other trusted
modules. Only the 14 prioritized modules in the prompt were audited in detail;
the remaining drafts (including the larger checkerboard, Yukawa-gauge, and
exceptional-algebra lines) were not inspected in this pass.
