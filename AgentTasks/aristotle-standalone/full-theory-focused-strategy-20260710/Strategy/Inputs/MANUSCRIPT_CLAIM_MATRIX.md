# Manuscript claim and evidence matrix

This is the run's manuscript control surface. A headline is not ready until its
row contains an exact declaration, assumptions, a model witness/control, an
assumption/build audit, a simulation benchmark or explicit reason none is valid, and
a falsifier. Grades: `T`, `T|H`, `M`, `C`, `[interp]`, `[import]`.

Passing every row is necessary but not sufficient. The claims must also compose
into the end-to-end architecture in `THEORY_COMPLETION_MATRIX.md`; otherwise the
manuscript is a checked collection of results rather than a candidate theory.

| ID | Manuscript claim | Grade at setup | Payload declaration/module | Load-bearing assumptions | Witness/control | Simulation ID | Kill/falsifier | Owner | Status |
|---|---|---|---|---|---|---|---|---|---|
| M1 | invariant mass squared is canonical pairwise null-direction disagreement | M + interpretation | `i1_5_cauchy_binet_mass_identity`, `detP_unique`, `spinorWedge_sl2_invariant` | positive spinor Gram/Pauli convention | collinear zero and noncollinear rational pair | S01 | determinant dictionary fails under stated convention | unclaimed | audit |
| M2 | normalized mass is directional mixedness; two-edge mass is concurrence squared | M | `MassEntropyDictionary`, `TwoEdgeMassConcurrence` | two-level visible register and normalization | pure/mixed endpoints | S02 | normalization or reduced-state dictionary mismatches | unclaimed | audit |
| M3 | physical existence is cohomology plus separately established positivity; a descending spectral decoder assigns class-invariant mass | M finite, C universal | `GenericFiniteHodge`, `PositiveHodgeDecoder`, `KreinHodgeNoGo`, `PositiveHodgeClassCostNoGo` | auxiliary Hilbert adjoint; chosen invariant positive sector; `Q^2=0`; radicality; decoder descent | `Jpos/Jneg`, non-exact `e2`, nilpotent rational class at cost `4/25` | S03 | positive sector empty/indefinite or decoder fails descent; nontrivial minimization over exact representatives is killed under the displayed cohomological hypotheses | Codex | corrected + guarded |
| M4 | a null-soldered carrier square has four obstruction types | M type classification; C physical dictionary | `CarrierKreinSquare`, `CarrierRigidity`, `FourChannelRigidityCapstone` | grading/support/selectors | explicit rational four-block witness and nonuniqueness control | S04 | refinement gives different operators or fifth independent type | unclaimed | audit |
| M5 | finite massive propagation is an exact coherent sum over null histories with mass at turns | M finite; C continuum | `ExactCheckerboardPathSum`, `ExactQuantumWalkDispersion` | 1+1 walk, branch/corner conventions | nonzero one-turn path and massless collapse | S05 | no controlled Dirac limit or wrong phase/dispersion | unclaimed | audit |
| M6 | tetrahedral null steps provide a first 3+1 checkerboard-like lift | M kinematic/spin path; C propagator | `TetrahedralNullHistory`, `TetrahedralSpinProjectorPath` | selected tetrahedral frame and normalization | mixed endpoint, orientation phase, 1/3 no-go | S06 | no unitary summed propagator or continuum cone | unclaimed | audit |
| M7 | common principal null cone gives front speed c while massive group drift is subluminal | M conditional; C universal fields | `LowerOrderChannelCausality`, `SubluminalBound` | displayed principal symbol; lower-order mixing | exact 3-4-5 witness and principal-order control | S07 | field equation changes principal cone or hypothesis not instantiated | unclaimed | audit |
| M8 | signed closure can bind and joint encoding can be cheaper than separated encoding | M finite; C hadron/QCD | `BindingDefect`, `BindingInformationInvariant`, `CarrierClosurePlane` | finite carrier block/physical branch | `(lambda,kappa)=(2,1)` and wrong-plane control | S08 | binding disappears under enlargement/refinement | unclaimed | audit |
| M9 | gauge-boson mass is a reference-orbit Gram cost; Goldstone DOF becomes longitudinal | M finite structure; C physical electroweak | `GaugeMassGram`, `HiggsDofConservation`, `HiggsLongitudinalMode` | supplied representation/couplings/reference | broken/unbroken generator and DOF counts | S09 | no physical representation/dynamics; Higgs self-mass remains input | unclaimed | audit |
| M10 | flavor CP structure singles out three as the minimal nonzero-phase case, not a forced generation count | M + no-go | `KMPhaseCounting`, `FiniteKMCP`, `FamilyRankNoGo`, `GenerationPermutationNoGo` | unitary/rephasing model and rank datum | explicit nonzero Jarlskog witness and permutation no-go | S10 | candidate forcing premise is rank fixing in disguise | unclaimed | audit |
| M11 | finite soldering defines metric-bearing codebook defects and variational response | M finite; C gravity | `NondegenerateSolderingGeometry`, `SolderingLocalFrameCovariance`, `UnifiedActionVariation` | matrix coframe/Lorentz/variation hypotheses | rational boost and nonzero defect action | S11 | no continuum covariant action/field equation | unclaimed | audit |
| M12 | Lambda is conjugate to event count and fluctuation scaling follows from stated statistics | M finite arithmetic/phase; C cosmology | Lambda modules plus geometry-register job | event count, ensemble and statistics assumptions | coherent count pair and non-Poisson control | S12 | volume identification, statistics, or sequestering fails | unclaimed | audit |
| M13 | local tensor factors obey no-signaling/microcausality | M finite tensor-factor model; C emergent locality | `FiniteNoSignaling`, `TwoRegionTensorMicrocausality` | chosen tensor factorization and TP channel | nonunitary reset changes joint state; local Pauli algebra remains noncommutative | S13 | graph regions do not factor/refine consistently | Codex | integrated + guarded |
| M14 | an executable null-information laboratory reproduces theorem identities and selected known physics | C until suite exists | simulation package and benchmark manifest | disclosed inputs/units/calibration | negative tests and held-out checks | all | only fitted flexibility explains agreement | unclaimed | build |

## Audit notes

- The phrase "everything moves at the speed of light" is interpretation, not a
  universal theorem. Primitive fermionic/walk support and principal fronts must
  be distinguished from massive drift, composite objects, interaction channels,
  and the scalar Higgs.
- `Q`, `Q^*Q+QQ^*`, and `D#D` are distinct throughout.
- Rank obstruction is invariant; a particular entropy formula uses a selected
  visible register and normalization.
- Every continuum, Standard Model, gravity, cosmology, and prediction sentence
  must expose the missing arrow.
