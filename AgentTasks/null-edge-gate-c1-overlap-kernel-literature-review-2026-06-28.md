# Null-edge Gate C1 overlap-kernel literature review

Date: 2026-06-28

Purpose:

```text
Record the focused literature implications of the current Null-Edge Overlap
kernel direction after integrating C238 and C242.
```

## Executive read

The literature supports the new Gate C1 architecture:

```text
null-edge centered/Hermitian kernel
  -> Wilson/flavored-Wilson branch mass
  -> overlap sign or domain-wall transfer construction
  -> Ginsparg-Wilson projectors and anomaly-aware measure contracts.
```

The literature also warns that the tetrahedral/non-orthogonal branch geometry is
not a detail. It is the next decisive physics check. Hypercubic Wilson intuition
does not automatically transfer to a tetrahedral or hyperdiamond-like shift set.

## Source implications

### Neuberger overlap

Source:

```text
Herbert Neuberger, "Exactly massless quarks on the lattice",
arXiv:hep-lat/9707022.
https://arxiv.org/abs/hep-lat/9707022
```

Implication:

```text
Use a Wilson-Dirac-type Hermitian kernel with negative mass, then take a
sign-function/overlap construction. This is the reference model for avoiding
unwanted doubling without fine tuning.
```

Project use:

```text
H_ref should be the Wilson/Neuberger reference.
H_ne should be imported into the same gapped sign sector, not treated as a
brand-new standalone chiral release.
```

### Luescher exact lattice chiral symmetry

Source:

```text
Martin Luescher, "Exact chiral symmetry on the lattice and the
Ginsparg-Wilson relation", arXiv:hep-lat/9802011.
https://arxiv.org/abs/hep-lat/9802011
```

Implication:

```text
The Ginsparg-Wilson relation realizes lattice chirality differently from the
assumptions in Nielsen-Ninomiya-type no-go theorems.
```

Project use:

```text
D_ov,ne is the release operator only after sign(H_ne) is well-defined and the GW
algebra/projectors are in place.
```

### Hernandez-Jansen-Luescher locality

Source:

```text
P. Hernandez, K. Jansen, M. Luescher,
"Locality properties of Neuberger's lattice Dirac operator",
arXiv:hep-lat/9808010.
https://arxiv.org/abs/hep-lat/9808010
```

Implication:

```text
Overlap locality is conditional. A smooth/admissible gauge-field condition can
give exponential decay, but locality is not automatic from the formal sign
operator.
```

Project use:

```text
Keep HJL locality as a source contract at the background-gauge layer.
For the null-edge route, also allow path-sum/resolvent/domain-wall control as
the native non-ultralocal certificate.
```

### Kaplan domain-wall fermions

Source:

```text
D. B. Kaplan, "A Method for Simulating Chiral Fermions on the Lattice",
arXiv:hep-lat/9206013.
https://arxiv.org/abs/hep-lat/9206013
```

Implication:

```text
Domain walls give a topological/boundary interpretation of chiral modes, with
doublers decoupled in a gauge-invariant manner in the intended construction.
```

Project use:

```text
Use domain-wall as the unfolded/topological version of the overlap sign
operator. Do not make the fifth direction a physical null direction in the first
Gate C1 theorem.
```

### Adams and flavored-overlap constructions

Sources:

```text
David H. Adams, "Theoretical foundation for the Index Theorem on the lattice
with staggered fermions", arXiv:0912.2850.
https://arxiv.org/abs/0912.2850

David H. Adams, "Pairs of chiral quarks on the lattice from staggered
fermions", arXiv:1008.2833.
https://arxiv.org/abs/1008.2833
```

Implication:

```text
Flavored mass terms can turn a multi-taste kernel into an overlap/GW
construction with index control.
```

Project use:

```text
Start with M_br = 0.
Add M_br only if the scalar null-edge Wilson term fails the branch-mass test.
If added, M_br must be gamma5-even, Hermitian, gauge-covariant or gauge-dressed,
and recorded as extra branch/flavor structure rather than a hidden fit.
```

### Creutz / hyperdiamond / non-orthogonal lattice warning lane

Sources:

```text
Michael Creutz, "Four-dimensional graphene and chiral fermions",
arXiv:0712.1201.
https://arxiv.org/abs/0712.1201

P. F. Bedaque, M. I. Buchoff, B. C. Tiburzi, A. Walker-Loud,
"Search for Fermion Actions on Hyperdiamond Lattices",
arXiv:0804.1145.
https://arxiv.org/abs/0804.1145
```

Implication:

```text
Non-orthogonal/hyperdiamond-like fermion actions can reduce or reshape
doubling, but branch structure, symmetry protection, and fine-tuning hazards are
delicate. Bedaque et al. explicitly find a tension between enough symmetry to
avoid fine tuning and minimal doubling.
```

Project use:

```text
The tetrahedral branch test is not optional.
We must define the tetrahedral shift Brillouin zone and prove the actual zeros
of the free symbol. The claimed 16 branches and scalar Wilson mass window cannot
be inherited from hypercubic intuition.
```

### Friedan / Nielsen-Ninomiya no-go pressure

Source:

```text
Daniel Friedan, "A Proof of the Nielsen-Ninomiya Theorem",
Communications in Mathematical Physics 85, 481-490 (1982).
https://www.physics.rutgers.edu/~friedan/papers/Commun_Math_Phys_85_481-490_1982.pdf
```

Implication:

```text
The old goal of getting a one-handed finite local seed directly was
overconstrained. The no-go pressure is real.
```

Project use:

```text
Do not keep trying to make bare retarded D_+ the chiral release.
Use overlap/GW/domain-wall machinery to change the chiral symmetry realization.
```

### Golterman-Shamir propagator-zero warning

Source:

```text
Maarten Golterman and Yigal Shamir,
"Propagator zeros and lattice chiral gauge theories",
arXiv:2311.12790.
https://arxiv.org/abs/2311.12790
```

Implication:

```text
When gauge fields are turned on, mirror removal by propagator zeros can behave
like ghost-state substitution and can carry anomaly contributions.
```

Project use:

```text
Keep "true inverse-propagator gap, not propagator zero" as a hard Gate C1 audit.
```

### Luescher abelian chiral gauge theory

Source:

```text
Martin Luescher, "Abelian chiral gauge theories on the lattice with exact gauge
invariance", arXiv:hep-lat/9811032.
https://arxiv.org/abs/hep-lat/9811032
```

Implication:

```text
Anomaly-free abelian chiral gauge theories can be constructed nonperturbatively
with GW machinery, but determinant-line/measure control is a separate theorem
layer.
```

Project use:

```text
Keep determinant-line/anomaly accounting out of GateC1_NU_Free.
Promote it only at GateC1_NU_Quantum.
```

## Updated analysis

The safest current operator target is:

```text
H_ne = gamma5 [D_ne^0 + W_ne + M_br - rho/a],
D_ov,ne = (rho/a)(1 + gamma5 sign(H_ne)).
```

The literature suggests the next real decision is not philosophical. It is the
tetrahedral free-symbol theorem:

```text
Does the centered tetrahedral null-edge kinetic plus scalar Wilson term have
the expected branch zeros and a clean 0 < rho < 2r mass window?
```

If yes:

```text
Proceed with M_br = 0 in the first Gate C1 free theorem.
```

If no:

```text
Introduce a controlled flavored/matrix branch mass M_br, citing flavored
overlap as precedent and recording the added freedom in the prediction/moduli
ledger.
```

## Immediate proof queue

```text
1. Check/repair NullEdgeOverlapKernel.lean.
2. Check/repair NullEdgeOverlapReferenceImport.lean.
3. Prove the tetrahedral coframe identities for B_A.
4. Define the tetrahedral Brillouin zone and branch coordinates k_A.
5. Prove or refute: sum_A B_A sin(k_A) = 0 iff sin(k_A) = 0 for all A.
6. Prove the scalar Wilson branch-mass window 0 < rho < 2r if the branch
   classification holds.
7. Only after that, use C242 reference import to connect H_ne to H_ref.
```
