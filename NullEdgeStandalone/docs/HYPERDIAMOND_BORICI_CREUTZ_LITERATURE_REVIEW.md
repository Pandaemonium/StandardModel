# Hyperdiamond / Borici-Creutz Literature Review

Date: 2026-07-01

Purpose: identify the next convention data needed before the standalone package
can honestly compare `gateCStencil` with a named Borici-Creutz or hyperdiamond
fermion operator.

## Sources Checked

- Michael Creutz, *Four-dimensional graphene and chiral fermions*,
  arXiv:0712.1201. The paper introduces a strictly local four-dimensional
  graphene-inspired fermion action with two species and exact chiral symmetry:
  <https://arxiv.org/abs/0712.1201>.
- Artan Borici, *Creutz fermions on an orthogonal lattice*, arXiv:0712.4401.
  This is the orthogonal-lattice / parameter-free variant relevant to the
  "Borici condition": <https://arxiv.org/abs/0712.4401>.
- Bedaque, Buchoff, Tiburzi, Walker-Loud, *Search for Fermion Actions on
  Hyperdiamond Lattices*, arXiv:0804.1145. This paper is the key warning:
  enough hyperdiamond symmetry can avoid fine tuning, but the symmetric actions
  produce extra doublings, while the minimal-doubling limit lacks the needed
  symmetry: <https://arxiv.org/abs/0804.1145>.
- Kimura and Misumi, *Characters of Lattice Fermions Based on the Hyperdiamond
  Lattice*, arXiv:0907.1371. This is the most directly useful source for
  real-space construction and Lorentz-covariance requirements; it emphasizes
  that non-nearest-site hoppings are essential for correct excitations:
  <https://arxiv.org/abs/0907.1371>.
- Kimura and Misumi, *Lattice Fermions Based on Higher-Dimensional Hyperdiamond
  Lattices*, arXiv:0907.3774. Useful for the distinction between "Creutz
  condition" and "Borici condition" and for higher-dimensional parameter
  restrictions: <https://arxiv.org/abs/0907.3774>.
- Creutz and Misumi, *Classification of Minimally Doubled Fermions*,
  arXiv:1007.3328. Useful for classifying known minimally doubled actions by
  pole locations and Wilson-like corrections:
  <https://arxiv.org/abs/1007.3328>.
- Kishore, *Eigenspectra of Minimally Doubled Fermions*, arXiv:2501.10336.
  Recent context for Karsten-Wilczek and Borici-Creutz spectra, flavored mass
  terms, and modified chirality operators:
  <https://arxiv.org/abs/2501.10336>.
- Keith Earle, *Notes on The Feynman Checkerboard Problem*, arXiv:1012.1564.
  Checkerboard-side source for reconciling path-count conventions:
  <https://arxiv.org/abs/1012.1564>.

## Main Takeaways

1. `gateCStencil` is useful but not enough. It proves that the Gate C Clifford
   symbol can be repackaged as a first-order four-edge stencil, but the
   Borici-Creutz literature uses additional convention data: phases,
   normalization, pole locations, basis choices, and often a fifth-vector or
   shifted onsite term.
2. The next Lean statement must not be "Borici-Creutz equivalence" until those
   conventions are fixed. The honest next theorem is a convention map or a
   mismatch theorem.
3. Hyperdiamond symmetry and minimal doubling pull in different directions in
   the Bedaque-Buchoff-Tiburzi-Walker-Loud analysis. This supports keeping Gate
   C release frozen until the concrete operator supplies its physical
   predicates.
4. Kimura-Misumi suggests that a nearest-neighbor four-edge stencil is probably
   too small to capture the physically correct excitation structure. This is a
   strong reason to ask Aristotle for a theorem or counterexample around the
   current `HyperdiamondFirstOrderStencil` API.
5. The recent eigenspectrum literature reinforces that plain spacetime
   `gamma5` is not the whole chirality story for minimally doubled fermions;
   flavored mass or modified chirality data matter. This aligns with the
   package's `ProjectorPhysicalAudit` separation.

## Lean Consequence

The next highest-value formal target now has a Lean landing zone:

```lean
BoriciCreutzConventionData
```

with fields for:

- edge vectors or shifts;
- gamma-matrix/basis convention;
- phase factors;
- onsite/shifted term;
- pole locations;
- normalization;
- expected flavored chirality operator.

The standalone package also defines:

```lean
BoriciCreutzNearestPrincipalCrosswalk
boriciCreutzNearest_no_single_chirality
BoriciCreutzConventionData.fullFirstOrderSymbol
boriciCreutz_fullSymbol_ne_nearest_of_requiresFifthVector
```

After a source convention is instantiated, the theorem should be one of:

```lean
theorem boriciCreutz_crosswalk :
    GateCPrincipalCrosswalk (boriciCreutzStencil data)

theorem boriciCreutz_mismatch :
    Not (GateCPrincipalCrosswalk (boriciCreutzStencil data))
```

depending on the convention data. The first theorem must not be attempted until
the literature convention map is explicit.
