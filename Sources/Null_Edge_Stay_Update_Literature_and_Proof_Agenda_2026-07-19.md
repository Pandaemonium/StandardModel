# Stay Updates in 3+1: Literature and Proof Agenda

## Executive conclusion

A stay amplitude is not an abandonment of relativistic causality. It is an
onsite internal branch of a local unitary update. The correct requirement is a
finite causal cone with a null front, not that every internal amplitude must
translate on every substep.

The literature now supports three sharper conclusions:

1. Stay terms are an exact algebraic resource, not a numerical patch.
2. A nonzero stay can remove conventional one-dimensional doublers without
   changing the Dirac infrared limit.
3. A stay term alone does not solve the full 3+1 problem: global zero/pi
   quasienergy censuses and Floquet topology remain decisive.

## Primary literature

### Gupta and Short: stay-assisted Dirac walks

Gupta and Short classify a one-dimensional Dirac-walk family after relaxing
the conventional zero-stay assumption. Their factorized update contains
forward, onsite, and backward amplitudes. A nonzero stay removes the ordinary
doubler and pseudo-doubler in 1+1 dimensions. Their 3+1 product construction,
however, retains isolated additional low-energy solutions, so stay is a new
degree of freedom rather than a universal cure.

- A. Gupta and A. J. Short, *Fermion Doubling in Dirac Quantum Walks*,
  arXiv:2601.15885v3, accepted in Physical Review A (2026):
  https://arxiv.org/abs/2601.15885

Their one-axis projector factorization has the clean-room algebraic form

```text
G+ = A B
G0 = A (1-B) + (1-A) B
G- = (1-A) (1-B),
```

for orthogonal projectors `A` and `B`. Up to a harmless unit-circle phase, the
Laurent symbol factors into two projector-conditioned unitary steps. This is
the immediate target of `GuptaShortStayCertificate.lean`.

### Higashikawa, Nakagawa, and Ueda: anomalous Floquet Weyl transport

Higashikawa, Nakagawa, and Ueda show that a periodically driven lattice can
realize a single Weyl fermion because the complete unitary evolution carries
topological information not visible in a static effective Hamiltonian. The
quasienergy-pi sector and micromotion are therefore part of the regulator, not
disposable artifacts.

- S. Higashikawa, M. Nakagawa, and M. Ueda, *Floquet chiral magnetic effect*,
  arXiv:1806.06868: https://arxiv.org/abs/1806.06868

### Sun et al.: low-energy chirality versus full Floquet balance

Sun et al. exhibit a three-dimensional Floquet lattice whose low-energy sector
can look purely chiral while the complete periodically driven system retains
the required global accounting. This supports treating the HNU zero node and
pi boundary as one anomalous Floquet object rather than demanding a static
Hamiltonian-style partner at zero quasienergy.

- X.-Q. Sun et al., *Three-dimensional Chiral Lattice Fermion in Floquet
  Systems*, arXiv:1806.09296, Phys. Rev. Lett. 121, 196401 (2018):
  https://arxiv.org/abs/1806.09296

### D'Ariano, Erba, and Perinotti: minimal isotropic Weyl walks

D'Ariano, Erba, and Perinotti classify homogeneous isotropic quantum walks with
two-dimensional coin space. In three dimensions the minimal Weyl solutions
live on the body-centered-cubic lattice, and the onsite coefficient vanishes
under that paper's combined minimality and isotropy assumptions. This does not
forbid stay amplitudes generally; it identifies which assumptions force them
away.

- G. M. D'Ariano, M. Erba, and P. Perinotti, *Isotropic quantum walks on
  lattices and the Weyl equation*, arXiv:1708.00826, Phys. Rev. A 96, 062101
  (2017): https://arxiv.org/abs/1708.00826

## What is already exact in this repository

- `StayLaurentUnitarityClassification.lean` classifies every range-one
  forward/stay/backward unitary symbol by ten exact coefficient identities.
- `HNUStayCoverage.lean` proves that each HNU projector-conditioned substep has
  a stationary sector, while no nonzero spinor stays fixed through every
  substep.
- `HNUPlueckerMassiveStay.lean` composes exact HNU transport with a local
  Pluecker mass turn and proves the combined Dirac infrared derivative.
- `HNUDecodedLocalStay.lean` realizes the selected HNU sector in finite real
  space with a visible pi-gapped complement and strict onsite selection.
- `HNUExactCore.lean` proves a unique zero-sector point at the origin and an
  exact pi-sector boundary census on the closed Brillouin cube.

## New proof agenda

### A. Massive global zero/pi gap

Prove that the nontrivial Pluecker mass coin gaps both `+1` and `-1`
quasienergies over the entire closed Brillouin cube. The key intermediate
statement is a parity census for the HNU endpoint:

```text
endpoint(k) = endpoint(-k)
iff k is the origin or lies on the Brillouin boundary.
```

An exact SU(2) block-determinant reduction then appears to force any massive
zero/pi crossing onto those two loci, where a mass angle strictly between zero
and pi excludes it. This is currently oracle-supported and must not be cited as
a theorem until the Lean proof lands.

### B. Projector-factorized stay classification

Prove the Gupta-Short projector construction satisfies the repository's exact
Laurent certificate, derive all-circle unitarity, and include an explicit
two-component witness with a nonzero onsite amplitude. This connects the
literature construction to the local classification already in the kernel.

### C. Canonical physical decoder

Replace the convenient component-reading decoder by the normalized orthogonal
decoder along the selected transverse profile. Prove that encoding followed by
decoding is the identity, decoding followed by encoding is exactly the onsite
selector, and the decoded real-space update is precisely the HNU schedule.
This removes an arbitrary coordinate choice but does not derive why nature
selects that transverse line.

### D. Correct Floquet topological invariant

The exact endpoint census plus local Weyl Jacobian is not yet a global winding
theorem. Construct the micromotion invariant appropriate to the full HNU
schedule, or identify a finite algebraic proxy with a proved continuum
interpretation. The target must account jointly for the unique zero node and
the pi boundary. Endpoint values alone are known to be insufficient.

## Scientific decision rule

The stay relaxation earns its place only if at least one of the following
lands:

- a global massive zero/pi gap theorem;
- a complete anomalous Floquet winding/accounting theorem;
- a local decoded construction whose selector follows from a physical symmetry
  or variational principle;
- a held-out dispersion, defect, or response prediction unavailable to a
  freely assigned mass term.

Until then, the strongest honest conclusion is that onsite internal updates are
compatible with null-front locality and enlarge the viable 3+1 design space.
