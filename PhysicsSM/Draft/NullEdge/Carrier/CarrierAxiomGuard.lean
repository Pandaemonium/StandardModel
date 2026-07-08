import PhysicsSM.Draft.NullEdge.Carrier.NullNilpotentSquare
import PhysicsSM.Draft.NullEdge.Carrier.SolderedSquareGram
import PhysicsSM.Draft.NullEdge.Carrier.WeitzenbockMaster
import PhysicsSM.Draft.NullEdge.Carrier.CarrierPotentialTurn
import PhysicsSM.Draft.NullEdge.Carrier.WeitzenbockQC_Torus
import PhysicsSM.Draft.NullEdge.Carrier.CarrierSquareAssembly
import PhysicsSM.Draft.NullEdge.Carrier.CarrierESlot
import PhysicsSM.Draft.NullEdge.Carrier.CarrierESlotTorsionSplit
import PhysicsSM.Draft.NullEdge.Carrier.WeitzenbockMasterPair
import PhysicsSM.Draft.NullEdge.Carrier.CarrierKreinSquare
import PhysicsSM.Draft.NullEdge.Carrier.CarrierApertureIdentification
import PhysicsSM.Draft.NullEdge.Carrier.CarrierMinkowskiBridge
import PhysicsSM.Draft.NullEdge.Carrier.CarrierFlatSectorPositivity
import PhysicsSM.Draft.NullEdge.Carrier.CarrierPontryaginWitness
import PhysicsSM.Draft.NullEdge.Carrier.CarrierIndexProtection
import PhysicsSM.Draft.NullEdge.Carrier.KugoOjima
import PhysicsSM.Draft.NullEdge.Carrier.KreinPositiveSectorWitness
import PhysicsSM.Draft.NullEdge.Carrier.CarrierWardDescentWitness
import PhysicsSM.Draft.NullEdge.Carrier.FockSecondQuantization
import PhysicsSM.Draft.NullEdge.Carrier.DGammaSquare
import PhysicsSM.Draft.NullEdge.Carrier.FockQuotientPairing
import PhysicsSM.Draft.NullEdge.Carrier.FockGradedRadical
import PhysicsSM.Draft.NullEdge.Carrier.CheckerboardTwoParticle
import PhysicsSM.Draft.NullEdge.Carrier.CheckerboardCrossingNonvacuous
import PhysicsSM.Draft.NullEdge.Carrier.ScatteringVertexDAG
import PhysicsSM.Draft.NullEdge.Carrier.GWRetardedTransfer
import PhysicsSM.Draft.NullEdge.Carrier.GWWilsonSymbol
import PhysicsSM.Draft.NullEdge.Carrier.GWConjecture
import PhysicsSM.Draft.NullEdge.Carrier.GWEdgeReversalBridge
import PhysicsSM.Draft.NullEdge.Carrier.KoideSubNatProbe
import PhysicsSM.Draft.NullEdge.Carrier.ColorCommutantScalar
import PhysicsSM.Draft.NullEdge.Carrier.ColorCommutantMultiplicity
import PhysicsSM.Draft.NullEdge.Carrier.RGSchurMassWitness
import PhysicsSM.Draft.NullEdge.Carrier.ChiralZeroModeParity
import PhysicsSM.Draft.NullEdge.Carrier.CarrierMassBudget
import PhysicsSM.Draft.NullEdge.Carrier.ApertureDominancePositivity
import PhysicsSM.Draft.NullEdge.Carrier.EquivariantGradedIndex
import PhysicsSM.Draft.NullEdge.Carrier.SectorGroundMass
import PhysicsSM.Draft.NullEdge.Carrier.MassMonogamy
import PhysicsSM.Draft.NullEdge.Carrier.RankAreaMass
import PhysicsSM.Draft.NullEdge.Carrier.SectorGroundMassWitness
import PhysicsSM.Draft.NullEdge.Carrier.WittenPositiveMass
import PhysicsSM.Draft.NullEdge.Carrier.MassMonogamyPartition
import PhysicsSM.Draft.NullEdge.Carrier.FiniteCarrierAction
import PhysicsSM.Draft.NullEdge.Carrier.FiniteQuadraticAction
import PhysicsSM.Draft.NullEdge.Carrier.FiniteUnitaryEvolution
import PhysicsSM.Draft.NullEdge.Carrier.FiniteRGFlow
import PhysicsSM.Draft.NullEdge.Carrier.FiniteCanonicalEnsemble
import PhysicsSM.Draft.NullEdge.Carrier.FreeMassBridge
import PhysicsSM.Draft.NullEdge.Carrier.MassGapWitness
import PhysicsSM.Draft.NullEdge.Carrier.CarrierUnitaryFlow
import PhysicsSM.Draft.NullEdge.Carrier.BindingDefect
import PhysicsSM.Draft.NullEdge.Carrier.CliffordAssembly
import PhysicsSM.Draft.NullEdge.Carrier.SectorMassGap
import PhysicsSM.Draft.NullEdge.Carrier.MassSpacingPrediction
import PhysicsSM.Draft.NullEdge.Carrier.ContinuumLimit

/-!
# CarrierAxiomGuard: build-enforced axiom-footprint guard for the Weitzenbock-carrier lane

The Claude-lane counterpart of `GateYM/SlabAxiomGuard.lean` (the closure-lane guard).
This module pins the transitive axiom footprint of every flagship in the null-edge
**Weitzenbock-carrier** program (`AgentTasks/overnight-mass-run-2026-07-06/FABLE_STEER.md`;
executed by the two-day carrier run `AgentTasks/twoday-carrier-run-2026-07-07`).

Each `#guard_msgs (whitespace := lax) in #print axioms ...` block FAILS TO BUILD if the
audited theorem's transitive axiom footprint ever drifts from the standard base
`[propext, Classical.choice, Quot.sound]` (or fewer) - i.e. if a `s o r r y`,
`n a t i v e _ d e c i d e`, or new `a x i o m` ever leaks into a carrier flagship.

Ownership: Claude owns this file in the two-day run; Codex owns `SlabAxiomGuard`. The two
guards are edited independently to avoid collision.

## Guarded flagships

* Move-1 brick 1 (`NullNilpotentSquare`): the null Clifford nilpotency keystone
  `c(alpha)^2 = 0` and the zero-edge-diagonal "mass is relational" identity.
* [H2] constraint (`ColorCommutantScalar`): the color commutant on the triplet is the
  scalars (Schur), so only a color-blind scalar mass is color-exact.
* CC-MULT (`ColorCommutantMultiplicity`): on a finite color triplet tensored
  with a multiplicity space, the color commutant is exactly the color-blind
  multiplicity algebra `I_color x End(K)`.
* Fock-Gupta-Bleuler finite shadow (`KugoOjima`): a nilpotent Krein-self-adjoint
  charge has radical exactly `range Q` on `ker Q`, and the quotient form is
  nondegenerate. Positivity is not claimed.
* Q01 positive-sector separation (`KreinPositiveSectorWitness`): an explicit
  unbalanced `(2,1)` finite positive quotient witness and a same-charge `(1,2)`
  no-go showing that Kugo-Ojima nondegeneracy does not imply positivity.
* Ward/descent witness (`CarrierWardDescentWitness`): a concrete non-identity
  phase symmetry on the `(2,1)` positive-sector model satisfying the finite
  `descent_unitary` hypotheses, plus the induced action on
  `ker Qop / range Qop` preserving the descended Krein form. Physical Ward
  identities are not claimed.
* Fock second-quantization finite shadow (`FockSecondQuantization`): a two-mode
  diagonal occupation-basis witness for
  `dGamma(D)^2 = dGamma(D^2) + 2 dGamma_2(Lambda^2 D)`.
* Fock second-quantization general decomposable identity (`DGammaSquare`): the
  finite Leibniz-combinatorics identity on decomposable exterior-algebra states.
* Fock second-quantization global derivation (`DGammaSquare`): the one-body
  operator `dGammaOp` is a genuine derivation on all of `ExteriorAlgebra`, and
  its square on decomposable states reproduces the tuple identity. The identity
  one-body operator acts by the finite particle number on decomposable states,
  and the identity two-body term counts strict pair slots.
* Fock-Gupta-Bleuler quotient bridge (`FockQuotientPairing`): the degree-by-
  degree finite exterior-power radical quotient identity and perfect-pairing
  bridge. Positivity and Hilbert completion are not claimed.
* Graded Fock radical assembly (`FockGradedRadical`): the all-particle-number
  finite-support direct-sum upgrade. The radical of the orthogonal direct-sum
  Fock form is componentwise, hence it is the graded family of exterior-power
  projection kernels. Positivity and Hilbert completion are not claimed.
* Checkerboard two-particle determinant (`CheckerboardTwoParticle`): the finite
  L=4, N=2 exterior-amplitude determinant identity and straight-through
  rational-polynomial witness.
* Checkerboard nonvacuous crossing (`CheckerboardCrossingNonvacuous`): the
  same-parity L=4, N=2 witness with both direct and crossing families nonzero,
  and the finite counterexample to the naive LGV reduction on the pre-registered
  transfer model.
* Corrected scattering-vertex DAG (`ScatteringVertexDAG`): a finite
  brick-wall DAG where crossing means shared vertex, the LGV swap cancellation
  is true and nonvacuous, and the naive no-shared-vertex route is killed.
* Wilson-symbol identity (`GWWilsonSymbol`): the exact `2 x 2` momentum-symbol
  determinant/unitarity, Hermitian Wilson scalar, and edge-reversal GW
  conjugation identities for the retarded/palindromic checkerboard symbol.
* Edge-reversal bridge (`GWEdgeReversalBridge`): decorated-edge reversal gives
  holonomy inverse, and the carrier generator-conjugation hypothesis is derived
  for homogeneous transfer powers, while arbitrary heterogeneous words remain
  blocked by the existing nonabelian counterexample.
* Koide / T-solder SUB-NAT probe (`KoideSubNatProbe`): exact rational gate
  facts for the tetrahedral corner bookkeeping and subdivision naturality.
  These are convention gates, not mass-value predictions.
* E-slot torsion/soldering split (`CarrierESlotTorsionSplit`): the doubled
  E-slot is the sum of torsion-like and symmetric soldering-difference
  contractions, and a concrete matrix witness shows the pure-torsion reading is
  not automatic without the symmetric-channel vanishing hypothesis.
* Minkowski carrier aperture bridge (`CarrierMinkowskiBridge`): the abstract
  carrier aperture quadratic form specializes to the trusted Minkowski
  `minkowskiSq` API and its finite future-null collinearity theorem.
-/

namespace PhysicsSM.Draft.NullEdge.Carrier.CarrierAxiomGuard

/-! ## Move-1 brick 1: null Clifford nilpotency + zero-edge-diagonal soldered square -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.null_clifford_sq_zero' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.null_clifford_sq_zero

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.nullSoldered_square_offDiagonal' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.nullSoldered_square_offDiagonal

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.lone_edge_massless' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.lone_edge_massless

/-! ## Move-1 brick 2a: the soldered square IS the aperture Gram form Q_A -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.nullSoldered_square_eq_half_gram' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.nullSoldered_square_eq_half_gram

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.nullSoldered_square_isScalar' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.nullSoldered_square_isScalar

/-! ## Move-1 brick 2b: the discrete Weitzenbock master identity (Q_A + Q_C) -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.weitzenbock_master' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.weitzenbock_master

/-! ## Move-1 brick Q_T: the chirality-dressed turn (potential) slot -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.crossTerm_eq_covariant_gradient' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.crossTerm_eq_covariant_gradient

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.dirac_square_with_potential' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.dirac_square_with_potential

/-! ## Move-1 brick torus-Q_C: transport commutator = plaquette curvature (proved part) -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.Torus.nabla_commutator_path_difference' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.Torus.nabla_commutator_path_difference

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.Torus.shift_mul_pointwise' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.Torus.shift_mul_pointwise

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.Torus.mZero_iff_commute' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.Torus.mZero_iff_commute

/-! ## Move-1 ASSEMBLY: 4 D^2 = Q_A + Q_C + 4 Q_T (E=0 regime) -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.carrier_square_assembly' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.carrier_square_assembly

/-! ## Move-1 E-slot: soldering-gradient (gravity) remainder; hcomm implies E=0 -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.soldered_square_defect' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.soldered_square_defect

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.solderingGradientDefect_eq_zero_of_comm' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.solderingGradientDefect_eq_zero_of_comm

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.weitzenbock_master_varying' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.weitzenbock_master_varying

/-! ## Move-1 E-slot audit: torsion/soldering split and pure-torsion obstruction -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.eslot_torsion_solder_split' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.eslot_torsion_solder_split

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.eslot_torsion_contract_eq_two_smul_defect_iff' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.eslot_torsion_contract_eq_two_smul_defect_iff

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.eslot_not_pure_torsion_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.eslot_not_pure_torsion_witness

/-! ## Move-1 pair-master: bilinear generalization (Krein-enabling) -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.weitzenbock_master_pair' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.weitzenbock_master_pair

/-! ## Move-1 KREIN square: D^#D upgrade (the actual mass form) -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.carrier_krein_square' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.carrier_krein_square

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.carrier_krein_square_selfAdjoint' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.carrier_krein_square_selfAdjoint

/-! ## Move-2 identification: Q_A = Q(∑ α) (the aperture invariant mass) -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.Q_A_eq_totalSq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.Q_A_eq_totalSq

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.Q_A_zero_iff_totalSq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.Q_A_zero_iff_totalSq_zero

/-! ## Move-2 W2a seam: carrier aperture block in the concrete Minkowski API -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.minkQF_apply' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.minkQF_apply

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.carrier_QA_zero_iff_minkowskiSq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.carrier_QA_zero_iff_minkowskiSq_zero

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.carrier_QA_zero_iff_collinear' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.carrier_QA_zero_iff_collinear

/-! ## CRACK 2: flat-sector form identity (>=0 value) + Hermitian Krein form
    (conditional; certified Krein positivity pending the M4 kappa=2 witness) -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.flat_sector_positivity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.flat_sector_positivity

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.kreinForm_hermitian' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.kreinForm_hermitian

/-! ## The kappa=2 Pontryagin witness: certified fundamental symmetry + strict
    flat-sector Krein positivity (closes the M4-witness convergence point) -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PontryaginWitness.Gamma_selfAdjoint' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.PontryaginWitness.Gamma_selfAdjoint

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PontryaginWitness.Gamma_involutive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.PontryaginWitness.Gamma_involutive

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PontryaginWitness.finrank_eigenspace_plus' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.PontryaginWitness.finrank_eigenspace_plus

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PontryaginWitness.finrank_eigenspace_minus' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.PontryaginWitness.finrank_eigenspace_minus

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PontryaginWitness.witness_mass_form_strictly_positive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.PontryaginWitness.witness_mass_form_strictly_positive

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PontryaginWitness.witness_two_dim_nonneg_sector' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.PontryaginWitness.witness_two_dim_nonneg_sector

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PontryaginWitness.certified_krein_positivity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.PontryaginWitness.certified_krein_positivity

/-! ## Index protection (finite McKean-Singer): the chiral index is fixed by the
    complex - massless chiral surplus is topological, immune to phi and nabla -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.chiralIndex_eq_graded_dimension' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.chiralIndex_eq_graded_dimension

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.chiralIndex_protected' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.chiralIndex_protected

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.ker_adjoint_eq_orthogonal_range' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.ker_adjoint_eq_orthogonal_range

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.finrank_range_adjoint' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.finrank_range_adjoint

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.chiralIndex_adjoint_pair' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.chiralIndex_adjoint_pair

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.chiralIndex_krein_pair' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.chiralIndex_krein_pair

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.exists_protected_massless_mode' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.exists_protected_massless_mode

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.chiralWitness_index_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.chiralWitness_index_one

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.chiralWitness_forced_massless_mode' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.chiralWitness_forced_massless_mode

/-! ## Finite Kugo-Ojima: quartet completeness for nilpotent Krein charges -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.KugoOjima.finite_kugo_ojima' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.KugoOjima.finite_kugo_ojima

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.KugoOjima.descent_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.KugoOjima.descent_unitary

/-! ## Q01 positive-sector witness and sharp no-go -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.KugoOjima.nonvacuous_positive_sector' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.KugoOjima.nonvacuous_positive_sector

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.KugoOjima.nondegenerate_but_indefinite_no_go' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.KugoOjima.nondegenerate_but_indefinite_no_go

/-! ## Ward/descent nonvacuity on the finite positive-sector witness -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.KugoOjima.ward_descent_preservation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.KugoOjima.ward_descent_preservation

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.KugoOjima.ward_descent_nonvacuous' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.KugoOjima.ward_descent_nonvacuous

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.KugoOjima.quotient_ward_action' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.KugoOjima.quotient_ward_action

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.KugoOjima.UopQuot_e2' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.KugoOjima.UopQuot_e2

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.KugoOjima.kreinQuotForm_UopQuot' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.KugoOjima.kreinQuotForm_UopQuot

/-! ## Finite Fock interaction identity: two-mode diagonal dGamma square witness -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FockSecondQuantization.dGammaDiag_square_two_mode' depends on axioms: [propext] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.FockSecondQuantization.dGammaDiag_square_two_mode

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FockSecondQuantization.dGammaPairDiag_both_occupied' depends on axioms: [propext] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.FockSecondQuantization.dGammaPairDiag_both_occupied

/-! ## Finite Fock interaction identity: general decomposable dGamma square -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.DGammaSquare.double_sum_split' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.DGammaSquare.double_sum_split

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.DGammaSquare.dGamma_sq_identity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.DGammaSquare.dGamma_sq_identity

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.DGammaSquare.dGamma_sq_identity_operator' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.DGammaSquare.dGamma_sq_identity_operator

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.DGammaSquare.dGammaOp_id_wedge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.DGammaSquare.dGammaOp_id_wedge

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.DGammaSquare.dGammaTwo_id_pair_count' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.DGammaSquare.dGammaTwo_id_pair_count

/-! ## Finite Fock-Gupta-Bleuler exterior quotient bridge -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FockQuotientPairing.pairingDual_bijective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.FockQuotientPairing.pairingDual_bijective

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FockQuotientPairing.exteriorForm_radical_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.FockQuotientPairing.exteriorForm_radical_eq

/-! ## Graded Fock radical assembly (all particle numbers) -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FockGradedRadical.bilinDS_ker_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.FockGradedRadical.bilinDS_ker_iff

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FockGradedRadical.bilinDS_isSymm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.FockGradedRadical.bilinDS_isSymm

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FockGradedRadical.bilinDS_nondegenerate_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.FockGradedRadical.bilinDS_nondegenerate_iff

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FockGradedRadical.fockGraded_radical_componentwise' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.FockGradedRadical.fockGraded_radical_componentwise

/-! ## Finite checkerboard two-particle determinant identity -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.CheckerboardTwoParticle.checkerboard_twoParticle_amplitude_eq_det' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.CheckerboardTwoParticle.checkerboard_twoParticle_amplitude_eq_det

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.CheckerboardTwoParticle.checkerboard_amplitude_ratQ' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.CheckerboardTwoParticle.checkerboard_amplitude_ratQ

/-! ## Finite checkerboard same-parity crossing: nonvacuous LGV obstruction -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.CheckerboardTwoParticle.twoParticle_amplitude_eq_det_general' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.CheckerboardTwoParticle.twoParticle_amplitude_eq_det_general

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.CheckerboardTwoParticle.twoAmpGen_nonvacuous' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.CheckerboardTwoParticle.twoAmpGen_nonvacuous

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.CheckerboardTwoParticle.naive_LGV_reduction_false' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.CheckerboardTwoParticle.naive_LGV_reduction_false

/-! ## Corrected scattering-vertex DAG: nonvacuous LGV-compatible model -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.ScatteringVertexDAG.lgv_crossing_cancels' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.ScatteringVertexDAG.lgv_crossing_cancels

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.ScatteringVertexDAG.scatter_LGV_reduction_true' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.ScatteringVertexDAG.scatter_LGV_reduction_true

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.ScatteringVertexDAG.scatter_crossing_nonvacuous' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.ScatteringVertexDAG.scatter_crossing_nonvacuous

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.ScatteringVertexDAG.naive_no_crossing_swap' depends on axioms: [Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.ScatteringVertexDAG.naive_no_crossing_swap

/-! ## GW structure of retarded transfer: the exact Ginsparg-Wilson relation
    (R = 1/2) for involution-inverted transfer maps + the 8x8 checkerboard
    verification with the edge-reversal grading (Q06 harvest, job 4043f341) -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.GWTransfer.gw_of_involution_inverts' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.GWTransfer.gw_of_involution_inverts

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.GWTransfer.deformed_symmetry' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.GWTransfer.deformed_symmetry

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.GWTransfer.gamma5_hermiticity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.GWTransfer.gamma5_hermiticity

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.GWTransfer.checkerboard_verification' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.GWTransfer.checkerboard_verification

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.GWTransfer.transfer_mul_inv' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.GWTransfer.transfer_mul_inv

/-! ## Wilson symbol identity: hidden Wilson scalar for the 2 x 2 transfer symbol -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.GWWilsonSymbol.transferSymbol_det' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.GWWilsonSymbol.transferSymbol_det

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.GWWilsonSymbol.wilson_term' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.GWWilsonSymbol.wilson_term

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.GWWilsonSymbol.gw_symbol' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.GWWilsonSymbol.gw_symbol

/-! ## Carrier-level GW conjecture: positive word-order theorems -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.GWConjecture.conj_prod_forward' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.GWConjecture.conj_prod_forward

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.GWConjecture.palindrome_conj_inv' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.GWConjecture.palindrome_conj_inv

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.GWConjecture.abelian_conj_inv' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.GWConjecture.abelian_conj_inv

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.GWConjecture.nonabelian_oneSided_counterexample' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.GWConjecture.nonabelian_oneSided_counterexample

/-! ## Edge-reversal bridge: transfer-power derivation of the GW hypothesis -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.GWEdgeReversalBridge.holonomy_reverseEdges' depends on axioms: [propext] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.GWEdgeReversalBridge.holonomy_reverseEdges

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.GWEdgeReversalBridge.conj_inv_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.GWEdgeReversalBridge.conj_inv_iff

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.GWEdgeReversalBridge.conj_pow_inv' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.GWEdgeReversalBridge.conj_pow_inv

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.GWEdgeReversalBridge.gw_relation_transfer_power' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.GWEdgeReversalBridge.gw_relation_transfer_power

/-! ## Koide / T-SOLDER exact rational gate: kappa and SUB-NAT bookkeeping -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.KoideSubNat.kappaB2_tet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.KoideSubNat.kappaB2_tet

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.KoideSubNat.subNat_strict_fails' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.KoideSubNat.subNat_strict_fails

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.KoideSubNat.subNat_projective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.KoideSubNat.subNat_projective

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.KoideSubNat.subNat_outcome_table' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.KoideSubNat.subNat_outcome_table

/-! ## [H2] constraint: color commutant on the triplet = scalars -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.color_commutant_eq_scalars' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.color_commutant_eq_scalars

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.nonscalar_mass_not_color_exact' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.nonscalar_mass_not_color_exact

/-! ## CC-MULT: color commutant on triplet times multiplicity space -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.color_commutant_multiplicity_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.color_commutant_multiplicity_eq

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.multiplicity_operator_is_color_exact' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.multiplicity_operator_is_color_exact

/-! ## RG-SCHUR: blocking a null chain generates non-null effective terms

The dynamics witness (`RGSchurMassWitness.lean`): the abstract null-pair
product-square lemma, the non-nilpotent effective edge on the decimated
3-site chain, and the collinear negative control. -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.RGSchurMass.null_pair_prod_sq_eq_pairing_smul' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.RGSchurMass.null_pair_prod_sq_eq_pairing_smul

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.RGSchurMass.chain_schurComplement_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.RGSchurMass.chain_schurComplement_eq

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.RGSchurMass.effective_edge_not_nilpotent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.RGSchurMass.effective_edge_not_nilpotent

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.RGSchurMass.collinear_schurComplement_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.RGSchurMass.collinear_schurComplement_eq_zero

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.RGSchurMass.nullL_mul_mid_mul_nullN' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.RGSchurMass.nullL_mul_mid_mul_nullN

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.RGSchurMass.mid_effective_not_nilpotent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.RGSchurMass.mid_effective_not_nilpotent

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.RGSchurMass.mid_effective_nilpotent_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.RGSchurMass.mid_effective_nilpotent_iff

/-! ## T1: chiral-symmetry determinant dichotomy (K6, overnight 2026-07-08) -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.ChiralZeroModeParity.chiral_det_conj' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.ChiralZeroModeParity.chiral_det_conj

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.ChiralZeroModeParity.chiral_det_eq_pm_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.ChiralZeroModeParity.chiral_det_eq_pm_one

/-! ## K4 / S6: the signed mass-budget theorem + witness (overnight 2026-07-08) -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.MassBudget.signed_budget_sum_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.MassBudget.signed_budget_sum_one

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.MassBudget.witness_budget_sum_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.MassBudget.witness_budget_sum_one

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.MassBudget.witness_assembly' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.MassBudget.witness_assembly

/-! ## Keystone: the Rayleigh-Ritz ground-mass theorem (Aristotle 4bf9899f, overnight 2026-07-08) -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.SectorGroundMass.sector_ground_mass' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.SectorGroundMass.sector_ground_mass

/-! ## Kinematic strengthening (Aristotle round-2, overnight 2026-07-08):
F3 mass monogamy + the rank/area-spectral bridge -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.MassMonogamy.pairwiseMass_append' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.MassMonogamy.pairwiseMass_append

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.MassMonogamy.pairwiseMass_append_eq_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.MassMonogamy.pairwiseMass_append_eq_iff

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.RankAreaMass.posDef_iff_det_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.RankAreaMass.posDef_iff_det_pos

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.RankAreaMass.det_eq_zero_iff_not_posDef' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.RankAreaMass.det_eq_zero_iff_not_posDef

/-! ## Aristotle batch-1 + round-3 (overnight 2026-07-08): the T2 linchpin,
finite Witten positive-mass (F4), general-partition monogamy (F3 rd2) -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.SectorGroundMassWitness.T2_positive_mass' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.SectorGroundMassWitness.T2_positive_mass

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.SectorGroundMassWitness.sector_krein_form_eq_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.SectorGroundMassWitness.sector_krein_form_eq_one

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.WittenPositiveMass.weitzenbock_eq_zero_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.WittenPositiveMass.weitzenbock_eq_zero_iff

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.MassMonogamyPartition.massOn_add_massOn_compl_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.MassMonogamyPartition.massOn_add_massOn_compl_le

/-! ## D1 dynamics seed: finite carrier action and Euler equations -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FiniteCarrierAction.multiplierStationary_iff_eom' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.FiniteCarrierAction.multiplierStationary_iff_eom

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FiniteCarrierAction.stationaryPair_iff_eom_pair' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.FiniteCarrierAction.stationaryPair_iff_eom_pair

/-! ## D1 dynamics seed: finite quadratic action and mass-shell stationarity -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FiniteQuadraticAction.quadraticStationary_iff_eom' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.FiniteQuadraticAction.quadraticStationary_iff_eom

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FiniteQuadraticAction.massShellStationary_iff_eigen' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.FiniteQuadraticAction.massShellStationary_iff_eigen

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FiniteQuadraticAction.massShellAction_invariant_of_commutes' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.FiniteQuadraticAction.massShellAction_invariant_of_commutes

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FiniteQuadraticAction.massShell_equation_symmetry' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.FiniteQuadraticAction.massShell_equation_symmetry

/-! ## D2/D3 dynamics seed: finite unitary transfer conservation -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FiniteUnitaryEvolution.norm_conserved_orbit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.FiniteUnitaryEvolution.norm_conserved_orbit

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FiniteUnitaryEvolution.energy_conserved_orbit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.FiniteUnitaryEvolution.energy_conserved_orbit

/-! ## D4 dynamics seed: finite RG-flow invariant propagation -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FiniteRGFlow.invariant_orbit' does not depend on any axioms -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.FiniteRGFlow.invariant_orbit

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FiniteRGFlow.observable_antitone_orbit' depends on axioms: [propext] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.FiniteRGFlow.observable_antitone_orbit

/-! ## D5 dynamics seed: finite canonical ensemble normalization -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FiniteCanonicalEnsemble.sum_probability_eq_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.FiniteCanonicalEnsemble.sum_probability_eq_one

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FiniteCanonicalEnsemble.energyVariance_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.FiniteCanonicalEnsemble.energyVariance_nonneg

/-! ## Mass phase diagram: the sector mass gap is aperture minus closure

`MassGapWitness` generalizes `T2_positive_mass` from the fixed `(2,1)` point to the
whole coupling plane: the `3x3` Hermitian block `B(lam,kappa)` is positive definite
(massive) iff `|kappa| < lam`, singular (massless) exactly on `kappa = +-lam` for
`lam > 0`, and its least eigenvalue - the squared mass gap - is `lam - kappa`. -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.MassGapWitness.B_posDef_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.MassGapWitness.B_posDef_iff

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.MassGapWitness.B_massless_iff_of_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.MassGapWitness.B_massless_iff_of_pos

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.MassGapWitness.B_least_eigenvalue' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.MassGapWitness.B_least_eigenvalue

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.MassGapWitness.B_spectrum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.MassGapWitness.B_spectrum

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.MassGapWitness.M6_topBlock_eq_B' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.MassGapWitness.M6_topBlock_eq_B

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.MassGapWitness.M6_botBlock_eq_B' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.MassGapWitness.M6_botBlock_eq_B

/-! ## D2 on the T2 witness: the carrier flow is a genuine sector isometry

`CarrierUnitaryFlow` closes the one open §9a dynamics link: the carrier's
Hermitian-generated flow `exp(-i t H)` is unitary (a norm-preserving sector
isometry), so `FiniteUnitaryEvolution` fires on the actual carrier, not just a
generic isometry. -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.CarrierUnitaryFlow.hermitian_flow_mem_unitaryGroup' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.CarrierUnitaryFlow.hermitian_flow_mem_unitaryGroup

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.CarrierUnitaryFlow.B_flow_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.CarrierUnitaryFlow.B_flow_unitary

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.CarrierUnitaryFlow.carrier_orbit_norm_conserved' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.CarrierUnitaryFlow.carrier_orbit_norm_conserved

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.CarrierUnitaryFlow.carrier_orbit_energy_conserved' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.CarrierUnitaryFlow.carrier_orbit_energy_conserved

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.CarrierUnitaryFlow.carrier6_orbit_norm_conserved' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.CarrierUnitaryFlow.carrier6_orbit_norm_conserved

/-! ## T3b: the Δ binding-energy invariant is `−κ` (closure lowers the ground mass)

`BindingDefect` promotes the interacting-bridge binding defect from oracle to
kernel at the block level: `Δ_block(λ,κ) = −κ` (negative, closure-controlled,
off-diagonal). The physical identification rests on the `(λ,κ)` carrier reduction
(kernel only at `(2,1)`), so it stays grade C; the block identity is M. -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.BindingDefect.blockBindingDefect_eq_neg_kappa' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.BindingDefect.blockBindingDefect_eq_neg_kappa

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.BindingDefect.closurePerturbation_offDiagonal' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.BindingDefect.closurePerturbation_offDiagonal

/-! ## T2 Clifford provenance: the hand-typed carrier IS the Cl(4) Kronecker assembly

`CliffordAssembly` closes the audit gap: `HAC`/`Jmet` (hand-typed) equal the
Clifford assembly `J(Q_A+Q_C)` / `Js⊗I3` built from Pauli-Kronecker products —
verbatim, no convention change. So T2's carrier identification is kernel, not
oracle. -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.CliffordAssembly.Jmet_eq_clifford' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.CliffordAssembly.Jmet_eq_clifford

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.CliffordAssembly.HAC_eq_clifford' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.CliffordAssembly.HAC_eq_clifford

/-! ## Full physical-sector mass gap = aperture minus |closure|

`SectorMassGap` lifts the block gap to the actual `6×6` sector form `Msec = B(λ,κ)
⊕ B(λ,-κ)`: least eigenvalue `λ-κ`, PosDef iff `|κ|<λ`. -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.SectorMassGap.Msec_least_eigenvalue' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.SectorMassGap.Msec_least_eigenvalue

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.SectorMassGap.Msec_posDef_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.SectorMassGap.Msec_posDef_iff

/-! ## Within-carrier dimensionless prediction: the three mass levels are equally spaced

`MassSpacingPrediction`: the levels `{λ-κ, λ, λ+κ}` (= `B_spectrum`) are an
arithmetic progression, so `(m²_mid-m²_lo)/(m²_hi-m²_mid) = 1` (scale-invariant) —
one sharp dimensionless prediction with a kill condition. -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.MassSpacingPrediction.spec_spacing_ratio' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.MassSpacingPrediction.spec_spacing_ratio

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.MassSpacingPrediction.levels_eq_spectrum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.MassSpacingPrediction.levels_eq_spectrum

/-! ## Continuum-limit finite symbol facts (1+1D Dirac quantum walk)

`ContinuumLimit`: the finite kernel content underlying the QW→Dirac limit — the
mass shell `(kσz+mσx)² = (k²+m²)•1` and the leading-order symbol match of the
discrete transfer generator to the Dirac Hamiltonian. The continuum theorem itself
is [import] (1+1D) / open (Cl(4)); only these finite facts are M. -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.ContinuumLimit.dirac_mass_shell' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.ContinuumLimit.dirac_mass_shell

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.ContinuumLimit.Ustep_hasDerivAt_generator' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.ContinuumLimit.Ustep_hasDerivAt_generator

end PhysicsSM.Draft.NullEdge.Carrier.CarrierAxiomGuard
