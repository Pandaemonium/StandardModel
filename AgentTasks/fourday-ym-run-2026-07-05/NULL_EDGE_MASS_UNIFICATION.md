# Linking ALL mass to null edges: the unification outline

Date: 2026-07-06 (day 3 of the four-day run). Author: claude (run agent).
User directive: "find out if there's a consistent story which describes ALL
mass in terms of null edges ... can QCD confinement mass etc. also be
fundamentally understood from a null edge perspective?"

**Claim-discipline header.** This document is a MECHANISM OUTLINE plus a
concrete theorem ladder. The unification thesis itself is
interpretation/mechanism prose (program-doc section 13.1 grade). Every rung
below carries its own claim label (finite identity / kinematic identity /
reconstruction / consistency check), and the section 13.2 mass taxonomy
remains normative: the unification says the taxonomy rows share a MECHANISM
SHAPE; it does NOT license borrowing evidence across rows without an
explicit conversion argument (F-YM-CONFLATE stays constitution-grade).

## 1. The unification thesis ("no primitive mass")

Mechanism hypothesis: on a substrate whose primitive transport is null,
every physical mass in the taxonomy arises as one of three RELATIONAL
OBSTRUCTIONS to free null transport:

- **(T) Turn obstruction** - matter sector. Mass is the amplitude for
  chirality flip (the checkerboard/coin turn) coupling the two null
  movers. The Higgs-Yukawa coupling does not "give" mass as a substance;
  it sets the turn amplitude. Massless = the two chiral null cones
  decouple.
- **(C) Closure obstruction** - gauge sector. An open gauge edge is
  gauge-covariant, not gauge-invariant: there is NO physical single-edge
  gauge state (Elitzur - now a kernel-checked finite identity in this
  tree). The physical gauge spectrum starts at CLOSED flux composites,
  and the Yang-Mills mass gap is the minimal transfer energy of closure -
  a composite property, never a primitive `m^2 A^2` term.
- **(A) Aperture obstruction** - composite sector. A system of null (or
  near-null) constituents has invariant mass exactly when the constituent
  momenta fail to be collinear: mass is the failure of a composite to
  point in one null direction. Hadron mass - roughly 99% of visible mass -
  is dominated by confined null/near-null constituent motion plus flux
  energy, NOT by primitive quark mass parameters. Confinement is the
  reason the aperture can never close: gauge closure (C) forces permanent
  non-collinearity (A).

Excluded by construction: the Wilson regulator mass (taxonomy row 2) is an
artifact and the unification must PROVE it is structurally distinct, not
absorb it; the gravitational/inertial row stays registered-only.

**The keystone identity tying (T), (C), (A) together.** For future-pointing
null momenta `p_1 ... p_n` in Minkowski space:

```text
M^2 = (sum_i p_i)^2 = sum_{i<j} 2 (p_i . p_j),   each  p_i . p_j >= 0,
M^2 = 0  <->  all p_i collinear.
```

Mass-squared is a sum of pairwise "angles" between null directions - purely
relational, zero iff the composite is itself effectively one null edge. The
two-constituent case is EXACTLY Gate I1's Plucker identity `det P = m^2`
(the wedge `p wedge q` is the obstruction to decomposability = collinearity),
and the 1+1D case is exactly the checkerboard coin resolution already proved
in `MassCoinBridge.twoNull_resolution` / `onshell_wedge_normSq_eq_coin_sq`.
So the keystone is not a new speculation - it is the n-ary generalization of
two theorems the tree already holds.

## 2. Pillars already kernel-checked (what makes this credible NOW)

| Pillar | Where | Status |
| --- | --- | --- |
| Mass as obstruction geometry, `det P = m^2` | `GateI1/Core.lean` | proved |
| Two-null resolution + coin = wedge norm (1+1D keystone) | `GateI1/MassCoinBridge.lean` | proved |
| Walk dispersion `cos(wa) = cos(ka) cos(mua)` (null steps + mass coin) | `GateI1/MassCoinBridge.lean` | proved |
| "Null edges do not age" (entropy = 0 iff massless) | `GateI1/MassEntropyDictionary.lean` | proved |
| Elitzur: no gauge-invariant single-link expectation (Z2, quantitative, volume-uniform) | `GateYM/ElitzurLattice.lean` (codex) | proved |
| YM1 exact area law (finite G): quantitative flux/closure cost | `GateYM` YM1 stack | proved |
| gamma5 algebra + Wilson-Dirac gamma5-hermiticity (chirality bookkeeping at QCD level) | `GateYM/EuclideanGamma.lean`, `WilsonDiracOperator.lean` | proved |
| Berezin = det (fermion composite weight is determinant algebra) | `GateYM/BerezinMatthewsSalam.lean` | proved |
| Flux/center sectors (where closure composites live) | Q3 `FluxSector` machinery | proved (abstract) |

The (C) pillar is further along than the run plan assumed: Elitzur was the
missing "gluon edges are bookkeeping, not particles" theorem, and it landed
this run as a finite identity, not prose.

## 3. The achievable ladder (NE-U1..NE-U6)

Ordered by cost. Each rung names its claim label, its dependency, and its
kill condition.

### NE-U1 - the aperture keystone (composite mass identity). IMMEDIATE.

New module `GateI1/CompositeApertureMass.lean` on the existing `minkowskiSq`
conventions:

- `compositeMassSq_eq_sum_pairwise` : for null `p_i`,
  `minkowskiSq (sum p_i) = sum_{i<j} 2 * mdot p_i p_j` (finite identity;
  bilinearity + null diagonal).
- `mdot_nonneg_of_futureNull` : future-pointing null vectors have
  `mdot p q >= 0`, with equality iff proportional (the reverse
  Cauchy-Schwarz for null vectors; the one genuinely nontrivial lemma).
- `compositeMassSq_nonneg` and the headline
  `compositeMassSq_eq_zero_iff_collinear` : a composite of null
  constituents is massless iff it is effectively ONE null edge.
- Bridge lemma to Gate I1: for `n = 2` the pairwise sum is the Plucker
  norm of `p wedge q` (ties `det P = m^2` to the composite story
  explicitly).
- Stretch: extend the entropy dictionary - the two-constituent rest frame
  is the maximally-mixed direction state (links aperture to "mass = aging"
  observer-conditioned reading).

Claim label: kinematic identity / finite identity. Dependencies: none
(Mathlib-only; oracle pin trivial). Kill condition: none foreseeable - this
is bookkeeping-hard, not truth-hard. This rung is the SPINE: it is the
formal statement that hadron-style mass needs no primitive mass input.

### NE-U2 - mass = chirality-mixing, at lattice-QCD grade. IMMEDIATE.

On the just-completed QMF4 stack (`EuclideanGamma` + `WilsonDiracOperator`):
decompose `D = D_kin + m * I + W_wilson` and prove

- `gamma5_anticommutes_kinetic` : the hopping/kinetic part anticommutes
  with `Gamma5` (chiral symmetry of pure null transport);
- `mass_term_gamma5_even` and `wilson_term_gamma5_even` : the mass term
  AND the Wilson term are exactly the chirality-mixing (gamma5-even)
  obstructions;
- headline `chiral_iff_massless_naive` : the naive operator
  gamma5-anticommutes iff `m = 0` (and the Wilson term is switched off).

This makes "fermion mass is exactly the turn amplitude" a theorem about the
real lattice QCD operator, not just the 1+1D walk - and it makes the
taxonomy row-1 vs row-2 distinction (physical mass vs regulator mass) into
MATHEMATICS: both are gamma5-even, but only one survives the `r = 0` naive
limit, and the doubling story (determinant-level, per NULLSTRAND discipline)
is exactly the price of removing the regulator turn. Claim label: finite
identity. Provenance anchor: Wilczek "mass without mass" (prose);
standard chiral-symmetry lattice lore (Montvay-Munster grade).

### NE-U3 - the closure pillar, consolidated. CHEAP (mostly done).

Elitzur (landed) + docstring-level mechanism reading + the general
finite-`G` Elitzur already queued in the YM1 paper layer. Add one named
corollary: `no_single_link_order_parameter` phrased so the composite/closure
reading is the literal statement. Claim label: finite identity.

### NE-U4 - the mass gap as closure cost. RIDES M1-M3.

The null-edge reading of the Track A endpoint: once M3's physical transfer
operator exists, state the gap theorem SECTOR-RESTRICTED (nontrivial
center-flux sector) so the theorem literally says "the lightest CLOSED flux
composite costs energy" - the (C) obstruction as spectral fact. At strong
coupling, tie the gap lower bound to the YM1 area-law flux cost. No new
mountain: this is a statement-shape and bridging-lemma discipline imposed on
work already scheduled. Claim label: finite identity (conditional on
M1-M3). Kill condition: inherits the mountains'.

### NE-U5 - "mass without mass": the confinement-mass toy. THE CROWN.

A small explicit gauge+fermion model (single plaquette or 2-site chain,
finite or compact group, Wilson fermions via the QMF3/QMF4 algebra) with
`quarkMassParameter = 0` whose sector-restricted transfer gap is computably
POSITIVE:

```text
theorem massWithoutMass_toy :
  quarkMassParameter M = 0  and  0 < hadronSpectralMass M
```

This is the kernel-checked heart of the user's question: composite
(confinement) mass with ZERO primitive mass input, in one self-contained
finite model. It does not need the M1-M3 mountains (a toy small enough to
diagonalize explicitly), but it DOES need the QMF5/QMF6 statement shapes
(fermionic RP + sector definitions) to name `hadronSpectralMass` honestly.
Route: Aristotle design job first (model choice is the hard part: smallest
model whose gap is provable without numerics), then a proof package.
Claim label: finite identity (toy); consistency check (for the mechanism).
Kill condition: if every model small enough to be kernel-tractable has a
degenerate (zero-gap or empty) hadron sector, record the obstruction
honestly and downgrade to a pure-gauge glueball-sector toy.

### NE-U6 - the electroweak rung (Higgs mass is also relational). NEXT-RUN.

Finite lattice gauge-Higgs ensemble; W-mass as a transfer-spectrum feature
of GAUGE-INVARIANT composite operators (the lattice-Higgs literature's
gauge-invariant formulation - the physical W is itself a closed composite,
not an open edge). Literature anchor: Fradkin-Shenker analytic
connectedness of the Higgs and confinement regimes on the lattice - the
strongest known formal hint that (T)-mass-by-condensate and (C)/(A)-mass-
by-confinement are one mechanism continuously deformed. NOTE the boundary:
Fradkin-Shenker is finite-lattice phase-diagram connectivity, NOT an
identity of mechanisms; claiming "Higgs = confinement" outright is a kill
condition. Claim label: reconstruction (statement layer first).
Bibliographic verification of Fradkin-Shenker 1979 required before any
formal use (verification-debt register discipline).

## 4. What the unification CAN and CANNOT deliver

CAN (kernel-checkable, this program):
- The keystone kinematic identity: all composite mass = aperture
  obstruction, with Gate I1's `det P = m^2` as its 2-body case (NE-U1).
- Mass = chirality-mixing amplitude at real-lattice-QCD operator grade,
  with the physical/regulator distinction as mathematics (NE-U2).
- No-single-edge-state and gap-as-closure-cost as theorems (NE-U3/U4).
- A self-contained "mass without mass" model: positive composite mass,
  zero primitive mass (NE-U5).
- A theorem-level mass taxonomy: `quarkMassParameter`,
  `hadronSpectralMass`, `regulatorMass`, `compositeApertureMass` as
  provably distinct named functionals (QMF7 + NE-U1 merge point).

CANNOT (kill list - saying otherwise is a violation):
- Numerical mass values or ratios (the Koide/F2 lane is separate and
  preregistered; no leakage).
- Continuum masses (QMF8 permanently out).
- The real-QCD spectral gap (NE-U5 is a toy; the real thing is the Clay
  frontier).
- "Higgs mechanism IS confinement" (Fradkin-Shenker connectivity is not
  mechanism identity).
- Observer-conditioned quantities (entropy dictionary) passed off as
  frame-invariant; the invariant object is `det P` / `M^2`, the
  conditioned object is the entropy. Both are real; they are different
  theorems.

## 5. One-paragraph summary of the story (for the final report)

Primitive transport is null; mass is what stops a system from being a
single null edge. For matter it is the turn amplitude coupling the chiral
null movers (Higgs sets it; kernel-checked in 1+1D, upgradeable to the
lattice Wilson-Dirac operator). For gauge fields there is no physical
single-edge state at all (Elitzur, kernel-checked); mass begins at closed
flux composites and the YM gap is the cost of closure. For hadrons - most
of the mass in the visible universe - mass is the aperture of confined null
constituents: `M^2 = sum of pairwise null angles`, positive because
confinement (closure) forbids collinearity, with `det P = m^2` as its
two-body germ. One mechanism shape - relational obstruction to null
transport - three obstruction types, four taxonomy rows kept distinct as
theorems.
