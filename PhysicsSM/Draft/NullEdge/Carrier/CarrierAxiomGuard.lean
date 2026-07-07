import PhysicsSM.Draft.NullEdge.Carrier.NullNilpotentSquare
import PhysicsSM.Draft.NullEdge.Carrier.SolderedSquareGram
import PhysicsSM.Draft.NullEdge.Carrier.WeitzenbockMaster
import PhysicsSM.Draft.NullEdge.Carrier.CarrierPotentialTurn
import PhysicsSM.Draft.NullEdge.Carrier.WeitzenbockQC_Torus
import PhysicsSM.Draft.NullEdge.Carrier.CarrierSquareAssembly
import PhysicsSM.Draft.NullEdge.Carrier.CarrierESlot
import PhysicsSM.Draft.NullEdge.Carrier.WeitzenbockMasterPair
import PhysicsSM.Draft.NullEdge.Carrier.CarrierKreinSquare
import PhysicsSM.Draft.NullEdge.Carrier.CarrierApertureIdentification
import PhysicsSM.Draft.NullEdge.Carrier.CarrierFlatSectorPositivity
import PhysicsSM.Draft.NullEdge.Carrier.CarrierPontryaginWitness
import PhysicsSM.Draft.NullEdge.Carrier.CarrierIndexProtection
import PhysicsSM.Draft.NullEdge.Carrier.ColorCommutantScalar

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

/-! ## Move-1 E-slot: soldering-gradient (gravity) remainder; E=0 iff hcomm -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.soldered_square_defect' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.soldered_square_defect

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.weitzenbock_master_varying' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.weitzenbock_master_varying

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

/-! ## [H2] constraint: color commutant on the triplet = scalars -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.color_commutant_eq_scalars' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.color_commutant_eq_scalars

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.nonscalar_mass_not_color_exact' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Carrier.nonscalar_mass_not_color_exact

end PhysicsSM.Draft.NullEdge.Carrier.CarrierAxiomGuard
