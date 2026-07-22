# Literature pass: discrete adiabatic transport for the HNU physical band

- Topic: moving low-energy sectors in discrete-time unitary dynamics
- Search date: 2026-07-21
- Owner: Codex / Archivist pass
- Work item: `QCA-3PLUS1-001`
- Search tools: Neo4j exact and chunk search, Zotero exact search, scholarly
  Crossref/arXiv search, primary arXiv source inspection
- Collections: Zotero and Neo4j `9W59V3K9` (`null-edge-lit`)

## Finding

The HNU physical-sector problem should be posed directly for the one-step
unitary, not only through a continuously generated Hamiltonian. The relevant
literature proves that a slowly varying sequence of unitary walk operators can
transport an isolated spectral band with error `O(1/T)`, provided that:

1. the selected and complementary eigenvalue clusters remain separated on the
   unit circle;
2. the separation remains valid over neighboring steps, not merely pointwise;
3. first and second finite differences of the walk are `O(1/T)` and
   `O(1/T^2)`; and
4. the number of steps is large relative to the inverse quasienergy gap and
   the variation rate.

This is a better match to the live HNU/Floquet construction than first taking a
logarithm of every step. It permits the physical field to be a moving band of
the full all-moving register while retaining the compensating microscopic
sector required by topology.

## Primary sources

### Dranov, Kellendonk, and Seiler (1998)

- A. Dranov, J. Kellendonk, and R. Seiler, *Discrete time adiabatic theorems
  for quantum mechanical systems*, Journal of Mathematical Physics 39,
  1340-1349 (1998), DOI:10.1063/1.532382.
- Exact result used: continuous-time adiabatic asymptotics has a discrete-time
  counterpart for slowly varying unitary evolution; the physical product is
  approximated by an adiabatic transport that intertwines spectral sectors.
- Scope: abstract unitary families and supplied spectral separation. It does
  not identify an HNU band or prove locality of its projector.
- Zotero/Neo4j key: `9FE77BVH`.

### Tanaka (2011)

- A. Tanaka, *Adiabatic Theorem for Discrete Time Evolution*, Journal of the
  Physical Society of Japan 80, 125002 (2011),
  DOI:10.1143/JPSJ.80.125002.
- Exact result used: under a no-crossing spectral separation and slow variation,
  transitions between distinct instantaneous eigenspaces are suppressed in
  the long discrete-time limit.
- Scope: a qualitative discrete adiabatic theorem. The HNU application still
  owes quantitative gap and variation estimates.
- Zotero/Neo4j key: `NJDPNUQ8`.

### Costa et al. (2022)

- P. C. S. Costa, D. An, Y. R. Sanders, Y. Su, R. Babbush, and D. W. Berry,
  *Optimal Scaling Quantum Linear-Systems Solver via Discrete Adiabatic
  Theorem*, PRX Quantum 3, 040303 (2022), arXiv:2111.08152,
  DOI:10.1103/PRXQuantum.3.040303.
- Full-text location: source sections "Our result" and "The first adiabatic
  theorem", especially the multistep-difference and multistep-gap definitions
  and the two discrete adiabatic theorems.
- Exact result used: for unitary walks `W_T(s)`, bounds
  `||D W_T(s)|| <= c_1(s)/T` and
  `||D^2 W_T(s)|| <= c_2(s)/T^2`, together with a neighboring-step angular gap,
  imply an explicit bound between the physical and ideal adiabatic products.
  For fixed positive gap and bounded difference coefficients, the bound is
  `O(1/T)`. Their simplified estimate displays inverse-gap powers through
  `Delta^(-3)`.
- Important convention: unitary eigenvalues live on the circle, so the selected
  and complementary arcs require two separating gaps. Their multistep gap
  covers up to three consecutive walk operators. This is stronger than a
  pointwise gap declaration.
- Zotero/Neo4j key: `32E6MCJA`; full text ingested.

### Jansen, Ruskai, and Seiler (2007)

- S. Jansen, M.-B. Ruskai, and R. Seiler, *Bounds for the adiabatic
  approximation with applications to quantum computation*, Journal of
  Mathematical Physics 48, 102111 (2007), arXiv:quant-ph/0603175,
  DOI:10.1063/1.2798382.
- Exact result used: the continuous Hamiltonian analogue transports a spectral
  band separated from the rest of the spectrum and makes the dependence of
  transition error on the gap explicit. Degeneracy and crossings inside the
  selected band are allowed when the entire band remains isolated.
- Consequence: the HNU physical field need not be a one-dimensional eigenline.
  A finite-rank low-energy cluster is acceptable if its external gap remains
  open.
- Zotero/Neo4j key: `RGV8P5X3`; full text ingested.

## Relationship to landed finite theorems

`SectorLeakageTelescope.lean` proves a robust algebraic bound for a fixed
projector: total leakage is at most the sum of one-step commutator defects.
The moving-projector target generalizes this to supplied projectors `P_k` and
one-step defects

```text
||(1 - P_(k+1)) U_k P_k||.
```

The discrete adiabatic theorem adds the missing physics: it derives small
defects from a spectral gap and slow variation of the actual unitary family.
The two layers should not be conflated:

- the telescope is elementary, assumption-transparent, and useful for exact
  witnesses or interaction perturbations;
- the adiabatic theorem is the mechanism that can make a moving spectral band
  autonomous without exact coordinate-block invariance.

## New HNU theorem ladder

1. **Moving-projector telescope.** Prove the exact product identity and norm
   sum for arbitrary supplied `P_k` and contractive `U_k`.
2. **Nonvacuity witness.** Give an exact rational two-band family with nonzero
   finite-step defect and a displayed schedule for which accumulated leakage
   vanishes.
3. **HNU first difference.** For the live parameterized walk, prove
   `||W_T((k+1)/T)-W_T(k/T)|| <= C_1/T` uniformly on the physical compact
   momentum region.
4. **HNU second difference.** Prove the corresponding `C_2/T^2` bound.
5. **Multistep quasienergy gap.** Upgrade the existing pointwise massive gap to
   separation of the chosen and complementary spectral arcs across every
   triple of neighboring steps.
6. **Adiabatic composition.** Package the finite-dimensional discrete theorem
   in the exact norm and indexing conventions used by the HNU schedule, then
   instantiate it to obtain `O(1/T)` band leakage.
7. **Interaction stability.** Add a local even interaction whose finite
   differences and cross-band perturbation are small relative to the same gap;
   prove the selected-band leakage still tends to zero.
8. **Quasi-local encoding.** Relate the momentum-band projector to a controlled
   real-space approximation using the already identified spectral-flow and
   Lieb-Robinson literature.

## What the sources do not support

- They do not delete the compensating HNU sector from the microscopic theory.
- They do not prove that the live HNU spectrum has the required multistep arc
  separation under an interaction.
- They do not make a spectral projector strictly finite range in real space.
- They do not turn the free changing-lattice theorem into an interacting QFT.
- They do not derive the observed mass scale or identify the physical band
  without a separately stated selection criterion.

## Consequence for theorem and manuscript claims

If the ladder closes, the correct statement is:

> The complete local unitary retains its topologically compensating register,
> while a gapped low-energy Floquet band is transported adiabatically and
> becomes dynamically autonomous in the continuum limit. The physical Dirac
> field is the moving band, not a microscopic coordinate block obtained by
> deleting the complement.

Until then, the project has an exact free continuum theorem and an abstract
leakage mechanism, but not a completed physical-sector theorem.

## Kill conditions

- The HNU selected and complementary spectra cannot be enclosed in disjoint
  arcs over neighboring steps.
- The minimal multistep gap collapses under the required schedule.
- The first or second finite difference grows too quickly for the adiabatic
  error to vanish.
- Interaction-induced variation closes the gap or leaves a nonzero accumulated
  leakage limit.
- The selected band is only operationally available through an uncontrolled
  nonlocal projector.

## Zotero/Neo4j identifiers

| Key | Identifier | Graph status | Full text |
|---|---|---|---|
| `9FE77BVH` | DOI:10.1063/1.532382 | ingested and embedded | metadata only |
| `NJDPNUQ8` | DOI:10.1143/JPSJ.80.125002 | ingested and embedded | metadata only |
| `32E6MCJA` | arXiv:2111.08152 | ingested and embedded | ingested |
| `RGV8P5X3` | arXiv:quant-ph/0603175 | ingested and embedded | ingested |
