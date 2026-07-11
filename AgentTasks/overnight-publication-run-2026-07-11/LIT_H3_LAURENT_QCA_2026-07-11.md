# H3 literature and Lean-reference note: Laurent determinant exponent

Date: 2026-07-11 PDT

## Scope and evidence labels

This note evaluates the newly landed one-variable theorem in
`PhysicsSM/Draft/NullEdge/LaurentUnitResource.lean` and the proposed additive
exponent of the determinant of an invertible Laurent matrix. It does not edit
the shared literature log or any manuscript.

Evidence labels used below:

- **Body verified**: the relevant statement was checked in the primary paper
  PDF, not merely in an abstract or citation record.
- **Metadata/abstract only**: title, authors, identifier, and possibly abstract
  were checked, but the paper body was not used as theorem evidence.
- **Lean source verified**: the named declaration was checked in the pinned
  local Mathlib source or in the landed project module.

## Exact landed Lean content

`LaurentUnitResource` currently proves, over an arbitrary field `K` and for one
Laurent variable:

1. `isUnit_iff_exists_C_mul_T`: `p : K[T;T^-1]` is a unit iff
   `p = C c * T n` for some `c != 0` and `n : Int`.
2. `unit_monomial_exponent_unique`: the exponent in such a representation is
   unique when both coefficients are nonzero.
3. `two_term_not_isUnit`: two nonzero terms at distinct exponents cannot form a
   unit.
4. `qca_det_is_unique_monomial`: if a finite square Laurent matrix is a unit in
   the matrix ring, its determinant has a unique monomial exponent.

The fourth declaration is an algebraic matrix theorem. Its name anticipates a
QCA application, but its hypotheses do not yet contain a Hilbert space,
unitarity on the circle, translation invariance, causality, a Fourier transform,
or a many-body observable algebra.

## Recommended next Lean theorem

Use an algebraic name until the physical bridge is landed:

```lean
noncomputable def laurentDetExponent
    {r : Nat} (M : Matrix (Fin r) (Fin r) (LaurentPolynomial K))
    (hM : IsUnit M) : Int :=
  Classical.choose (qca_det_is_unique_monomial M hM).exists

theorem laurentDetExponent_spec
    {r : Nat} (M : Matrix (Fin r) (Fin r) (LaurentPolynomial K))
    (hM : IsUnit M) :
    Exists fun c : K => Ne c 0 /\
      M.det = LaurentPolynomial.C c *
        LaurentPolynomial.T (laurentDetExponent M hM)

theorem laurentDetExponent_mul
    {r : Nat}
    (M N : Matrix (Fin r) (Fin r) (LaurentPolynomial K))
    (hM : IsUnit M) (hN : IsUnit N) :
    laurentDetExponent (M * N) (hM.mul hN) =
      laurentDetExponent M hM + laurentDetExponent N hN
```

The proof is short and entirely within the landed algebra:

- use `Matrix.det_mul` to rewrite `det (M * N)`;
- use the two specification lemmas for `M` and `N`;
- combine coefficients with `map_mul` for `LaurentPolynomial.C`;
- combine exponents with `LaurentPolynomial.T_add`;
- use `mul_ne_zero` and `unit_monomial_exponent_unique` to identify the product
  exponent.

Low-cost companion lemmas are:

```text
laurentDetExponent_one       = 0
laurentDetExponent_inv       = -laurentDetExponent
laurentDetExponent_pow       = n * laurentDetExponent
laurentDetExponent_constant  = 0
```

The constant-matrix lemma is the precise ring-level statement needed for an
onsite coin. The inverse and power lemmas should be derived from uniqueness,
not from proof-irrelevant simplification of the `IsUnit` witnesses.

## Primary-source comparison

### 1. Gross-Nesme-Vogts-Werner: direct one-particle match after a bridge

**Source.** D. Gross, V. Nesme, H. Vogts, and R. F. Werner, "Index
Theory of One Dimensional Quantum Walks and Cellular Automata," *Communications
in Mathematical Physics* 310 (2012), 419-454.
[arXiv:0910.3675](https://arxiv.org/abs/0910.3675),
[DOI:10.1007/s00220-012-1423-1](https://doi.org/10.1007/s00220-012-1423-1).

**Evidence: Body verified.** The arXiv PDF was checked in Sections 6.3 and 6.4
and Section 7.3.

Exact relevance:

- Their Fourier convention is
  `F(Psi)(p) = sum_x exp(i p x) Psi(x)`.
- Equation (19) writes a finite-range translation-invariant walk as the Laurent
  matrix `Uhat(p) = sum_x U_x exp(i p x)`.
- Immediately before Proposition 5, they observe that `det Uhat` and its inverse
  are Laurent polynomials, hence the determinant must be a monomial.
- Proposition 5, equation (20), states
  `det Uhat(p) = C exp(i p ind(U))`.
- Theorem 3 states that the quantum-walk index is integer-valued, additive under
  composition, and zero exactly for locally implementable walks.

This is the narrow direct literature target. Once the repository proves that a
strict complex translation-invariant walk gives an `IsUnit` Laurent matrix with
the same Fourier convention, `laurentDetExponent` should equal the GNVW
**quantum-walk** index. The landed theorem currently formalizes the monomial
step used immediately before GNVW Proposition 5, not Proposition 5 itself.

Convention gaps that must be closed before stating equality:

- specialize `K` to `Complex` and define the involution combining coefficient
  conjugation with `T n -> T (-n)`;
- prove that pointwise unitary finite-range symbols have a finite Laurent
  inverse represented by that involution;
- define the evaluation/Fourier map and fix whether a right shift is `T 1` or
  `T (-1)`;
- prove that the repository's cell grouping and Fourier normalization preserve
  the exponent;
- prove `abs c = 1` for the determinant coefficient in the unitary case.

Under GNVW's displayed Fourier convention, their unit right shift has symbol
`exp(i p)` and index `+1`. No sign should be copied into the manuscript until
the live walk's shift convention is checked against this convention.

### 2. GNVW many-body QCA index: analogy, not identification

**Evidence: Body verified.** GNVW Theorem 9 was checked in Section 7.3.

For a one-dimensional many-body QCA, GNVW prove that `ind(alpha)` is a positive
rational number, is multiplicative under composition and tensor product, and is
`1` exactly for locally implementable automata. This differs categorically from
the integer-valued additive walk index.

Therefore:

- the Laurent determinant exponent directly matches the GNVW walk-index
  architecture, not the general many-body QCA index;
- taking a logarithm makes the many-body index additive, but does not identify
  it with a single-particle determinant exponent;
- a second-quantization theorem would have to specify bosonic versus fermionic
  local algebras, cell dimensions, stabilization, and normalization.

Calling the exponent "GNVW-type" is defensible only as a structural analogy.
Calling it "the GNVW index" is not defensible at the current formal scope.

### 3. Meyer scalar-QCA no-go: exact rank-one algebraic ancestor

**Source.** David A. Meyer, "From Quantum Cellular Automata to Quantum
Lattice Gases," *Journal of Statistical Physics* 85 (1996), 551-574.
[arXiv:quant-ph/9604003](https://arxiv.org/abs/quant-ph/9604003),
[DOI:10.1007/BF02199356](https://doi.org/10.1007/BF02199356).

**Evidence: Body verified.** The arXiv PDF and the local Neo4j full-text chunks
were checked. The no-go lemma appears in Section 2.

Meyer proves that every one-dimensional homogeneous local scalar unitary QCA
is a lattice translation times a phase. In Fourier/Laurent language this is the
rank-one complex-unitary specialization of the landed units theorem: a scalar
finite Laurent symbol with a finite Laurent inverse is one monomial.

The relation is narrow but exact:

- `isUnit_iff_exists_C_mul_T` recovers the algebraic core of Meyer's scalar
  conclusion and works over any field;
- `qca_det_is_unique_monomial` extends only the determinant conclusion to
  matrix-valued symbols;
- it does not classify the matrix symbol itself, and Meyer explicitly notes
  that multicomponent walks evade the scalar no-go.

### 4. Po-Fidkowski-Morimoto-Potter-Vishwanath: many-body information flow

**Source.** H. C. Po, L. Fidkowski, T. Morimoto, A. C. Potter, and A.
Vishwanath, "Chiral Floquet Phases of Many-Body Localized Bosons," *Physical
Review X* 6 (2016), 041070.
[arXiv:1609.00006](https://arxiv.org/abs/1609.00006),
[DOI:10.1103/PhysRevX.6.041070](https://doi.org/10.1103/PhysRevX.6.041070).

**Evidence: Body verified.** Sections IV.B-IV.E and Appendix C were checked.

They define the chiral unitary index as `nu(Y) = log ind(Y)`, where the GNVW
index is positive rational. Equation (22) makes `nu` additive under composition
and tensor product. They interpret it as quantum-information flow and use the
nonzero index as an obstruction to one-dimensional finite-time local-Hamiltonian
generation.

This supports the vocabulary "additive flow invariant" for an appropriately
bridged index, but it does not support identifying `laurentDetExponent` with
many-body entropy flow. In particular, a Laurent determinant is absent from
their definition.

### 5. Current QCA fermion-doubling work: adjacent, determinant is different

**Source.** D. Bakircioglu, P. Arnault, and P. Arrighi, "Fermion Doubling in
Quantum Cellular Automata," arXiv:2505.07900v3 (2025).
[arXiv:2505.07900](https://arxiv.org/abs/2505.07900).

**Evidence: Body verified.** Sections 3-6 and the closing summary were checked
in the v3 PDF. Neo4j/Zotero supplied metadata and abstract only; the theorem
assessment here comes from the primary PDF.

The paper diagnoses doublers from zeros and periodic identifications of the
Fourier-space **equation-of-motion determinant** `D(E,p)`. It then changes the
Brillouin-zone presentation through flavor staggering and covering maps. This
is not the determinant `det U(z)` of a one-step Laurent evolution matrix used by
`LaurentUnitResource`.

Consequently the landed monomial theorem neither proves nor contradicts their
doubling analysis. A relation would require an explicit theorem connecting the
monomial exponent of `det U(z)` to the zeros of `det(exp(iE) I - U(z))` over the
full energy-momentum torus.

### 6. Recent Dirac-walk doubling result

**Source.** C. Gupta and A. J. Short, "Fermion Doubling in Dirac Quantum
Walks," arXiv:2601.15885v2 (2026).
[arXiv:2601.15885](https://arxiv.org/abs/2601.15885).

**Evidence: Metadata/abstract only in this pass.** The abstract reports walk
families avoiding stated doublers and pseudo-doublers by allowing nonzero stay
amplitude, while retaining other low-energy solutions. No determinant-index
claim from this paper is used here.

## Lean and library references

**Lean source verified.** The pinned Mathlib contains the required low-level
API, but no ready-made Laurent-unit classification or GNVW/QCA index theory was
found.

- [`LaurentPolynomial.T_add`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Algebra/Polynomial/Laurent.html#LaurentPolynomial.T_add)
  multiplies Laurent monomials by adding integer exponents.
- [`LaurentPolynomial.degree_C_mul_T`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Algebra/Polynomial/Laurent.html#LaurentPolynomial.degree_C_mul_T)
  is already used by the landed uniqueness proof.
- [`LaurentPolynomial.eval2_C_mul_T`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Algebra/Polynomial/Laurent.html#LaurentPolynomial.eval%C2%B2_C_mul_T)
  is the natural evaluation lemma for the future Fourier bridge.
- [`Matrix.det_mul`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/LinearAlgebra/Matrix/Determinant/Basic.html#Matrix.det_mul)
  supplies exponent additivity under composition.
- [`Matrix.isUnit_iff_isUnit_det`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/LinearAlgebra/Matrix/NonsingularInverse.html#Matrix.isUnit_iff_isUnit_det)
  is the determinant-unit bridge already used by `qca_det_is_unique_monomial`.

`lean-explore` searches over Mathlib found the Laurent monomial, degree, and
evaluation declarations but no theorem classifying all Laurent units; the
project theorem fills that gap at one-variable field scope. A PhysLean search
for QCA/index/winding declarations returned no relevant result. No existing
Lean formalization of GNVW, strict QCA causality, or the walk-index trace formula
was located.

## Narrowest defensible mathematical relation

The exact relation is:

> For a one-dimensional, finite-range, translation-invariant complex quantum
> walk, once pointwise unitarity is bridged to invertibility over the Laurent
> ring using the same Fourier convention, the unique Laurent determinant
> exponent is the integer appearing in GNVW Proposition 5 and hence is additive
> under composition.

At present this is a proposed bridge theorem, not a consequence already present
in Lean. The ring theorem proves existence and uniqueness of the exponent; GNVW
supplies its physical interpretation after stronger analytic and locality
hypotheses are represented.

Useful controls:

- A momentum-independent invertible coin has exponent zero.
- A diagonal conditional shift with entries `T n_i` has exponent
  `sum_i n_i`; balanced left/right shifts can therefore have exponent zero.
- Nonzero exponent obstructs local implementability for a bridged GNVW quantum
  walk, but it does not specify the number or shape of quasienergy cones.
- Zero exponent records zero **net** flow. It does not imply a trivial symbol,
  absence of conditional shifts, or the presence of aliases.
- If `U(k) = exp(-i H(k))` has a globally defined periodic matrix logarithm,
  then `det U(k) = exp(-i tr H(k))` has zero winding. To combine this with the
  landed theorem one must separately show that `U` lies in the strict Laurent
  class, or work with a continuous winding invariant instead.

## Recommended manuscript comparison

> At one-particle, one-dimensional strict Laurent-symbol scope, our unique determinant exponent is the algebraic precursor of the translation-invariant quantum-walk index in GNVW Proposition 5; no identification with the many-body GNVW QCA index or with a fermion-doubling obstruction is claimed.

## Explicit nonclaims

- No physical QCA or quantum-walk representation theorem is yet formalized.
- No equality with the many-body GNVW positive-rational index is proved.
- No entropy-flow, charge-pump, spectral-flow, or chiral-Floquet interpretation
  is proved.
- No multidimensional Laurent-unit or vector-index theorem is landed.
- No statement about `3+1`-dimensional null-edge walks follows.
- No no-doubling, alias-removal, Nielsen-Ninomiya escape, or minimum-architecture
  theorem follows from the exponent alone.
- `m = 0` is not a rejection criterion for a candidate architecture without an
  additional theorem showing that the allowed de-aliasing moves preserve this
  index and that the target lies in a different index class.
- `m != 0` is not sufficient for a single Dirac cone, a nondegenerate tangent,
  chirality, locality beyond the stated Laurent range, or a correct continuum
  limit.
- A two-term nonunit result is a ring-level obstruction to an algebraic inverse;
  it is not by itself a theorem that a pointwise unitary trigonometric matrix
  cannot exist.

## Source-status audit

- GNVW 2012: primary PDF body verified; absent from the local Neo4j paper graph.
- Meyer 1996: primary PDF body verified; Neo4j contains full-text chunks and
  matching metadata.
- Po et al. 2016: primary PDF body verified; Crossref/arXiv metadata checked.
- Bakircioglu-Arnault-Arrighi 2025: primary v3 PDF body verified; local graph and
  Zotero records had metadata/abstract but no stored body chunks.
- Gupta-Short 2026: arXiv metadata and abstract checked only; not used as theorem
  evidence.
