# HNU 3+1 theorem, obstruction, and topology ledger

Date: 2026-07-20
Owner: Codex
Work items: `QCA-3PLUS1-001`, `CONT-FOURIER-001`
Status: living synthesis; massless full-zone crossing set, exact endpoint
winding, companion-block chirality balance, free Weyl changing-lattice limit,
fixed-momentum massive continuum rate, and the free massive changing-lattice
position-space limit are closed; the maximal momentum Hamiltonian, free finite
Fock locality, and one finite cell-local even interaction control are also
closed; exact Sobolev-domain identification, HNU physical-sector stability
under interactions, and interacting convergence remain open

## 1. Plain-language verdict

The HNU route is now a serious free `3+1` regulator rather than a promising
Taylor expansion. It is exactly local and unitary; every nonzero internal state
moves in some conditioned substep; the full schedule has the desired Weyl
tangent; the live changing-lattice evolution converges strongly in position
space to exact Weyl evolution; and the limiting differential generator is the
displayed position-space Weyl operator on Schwartz data.

The massive successor is now closed at the free one-particle level as well.
For fixed complex Pluecker mass, fixed time, and fixed four-component `L2`
datum, the actual cell-projected massive HNU evolution converges strongly in
momentum and position space to exact massive Dirac evolution. The theorem uses
an explicit adaptive schedule and preserves the mass term unchanged under
Mathlib's Fourier convention.

The limiting momentum-space Hamiltonian is no longer only a formal multiplier
on a dense core. On its maximal graph domain it is dense, symmetric,
self-adjoint, and closed; both imaginary shifts are surjective by explicit
bounded fibre resolvents. Separately, the standard exterior-algebra lift of a
finite sparse one-particle update sends each local CAR algebra into the declared
finite-depth neighborhood algebra. A separate five-mode control now supplies a
nontrivial even pair update whose conjugation fixes both outside CAR generators,
preserves the full two-particle sector, and mixes an overly narrow one-pair
sector. It does not yet identify the Fourier-conjugate differential operator on
an exact Sobolev domain, compose with the live HNU schedule, or show that an
interaction preserves the selected HNU sector.

It is not yet a complete microscopic theory. The massless endpoint has an
unavoidable anomalous `pi`-quasienergy boundary sheet, and an all-moving cover
adds a dynamically invariant complement carrying its own `pi` sector. The
massive doubled construction opens a uniform full-zone gap, but no theorem yet
shows that the selected sector remains complete and stable after second
quantization and interactions.

## 2. Exact ledger

| Gate | Exact result | Anchor | Grade | Remaining debt |
|---|---|---|---|---|
| Local unitarity | Each conditioned factor and the ordered endpoint are unitary | `HNUExactCore.lean`, `HNURealSpaceBridge.lean` | `M` | None for free one-step dynamics |
| Stay semantics | Every individual factor has a nonzero stationary sector, but the only state fixed by every substep is zero; movement budget is `4 I` | `HNUStayCoverage.lean` | `M` | Interpret conditioned stay under microscopic ontology |
| IR Weyl sector | Endpoint tangent is `-i q dot sigma`, isolated at the linearized origin, with Jacobian determinant and chirality `+1` | `HNUInfraredWeylCharge.lean` | `M` | Physical identification still reconstruction-level |
| `+1` full-zone census | In the closed Brillouin cube, a nonzero `+1` eigenvector exists iff all momenta are zero | `HNUSU2FixedVectorCensus.lean` | `M` | None for endpoint `+1` crossings |
| `-1` full-zone census | A nonzero `-1` eigenvector exists iff at least one coordinate is `+pi` or `-pi` | `HNUSU2MinusEigenvectorCensus.lean` | `M` | Quotient-identify opposite faces carefully |
| `pi` crossing shape | On a `pi` face the endpoint is exactly `-I`; both tangential derivatives vanish, derivative kernel has rank at least two, and one normal derivative is nonzero | `HNUPiFaceRankObstruction.lean` | `M` | No ordinary point-node chirality is available |
| Bloch descent | A half-character is antiperiodic; paired half-shifts are periodic; a linear displacement interpolation descends exactly at integral displacement | `HNUBlochPeriodicity.lean` | `M` | Does not classify arbitrary local-unitary homotopies |
| Endpoint winding | The restricted two-band endpoint equals the published `S^3` coordinate map, lands on the unit sphere, collapses the cube boundary to the south pole, has the exact oriented density, and has normalized global winding `W = +1` | `HNUWindingIntegral.lean` plus the crossing modules | `M` | Distinguish endpoint winding from any micromotion invariant or bulk-edge theorem |
| Protocol residue | Ordered reflection product is `-I`, invariant under global unitary conjugation; an explicit nontrivial alternative has product `+I` and is not globally gauge-equivalent | `HNUGlobalHolonomyClassification.lean` | `M` | A finite discriminator, not yet a published micromotion invariant |
| Companion chirality | The shifted high block is exactly the lower block with the second momentum reflected, has the opposite origin Jacobian sign, and the complete four-band local chirality sum is zero | `HNUCompanionChirality.lean` | `M` | Global full-drive interpretation and interacting sector stability |
| Massive tangent | Doubling opposite chiral sectors and adding the Pluecker mass coin gives the Dirac kinetic-plus-mass tangent | `HNUPlueckerMassiveStay.lean` | `M` | Position-space massive generator identification |
| Massive global spectrum | For mass angle in `(0, pi)`, the four-channel walk is unitary and uniformly separated from both `+1` and `-1` across the full zone; admissible angles are gapped-connected | `HNUMassiveGlobalGap.lean`, `HNUQuantitativeGlobalGap.lean`, `HNUMassiveGapHomotopy.lean`, `HNURegulatorCapstone.lean` | `M` | Physical mass parameter/sector selection and interactions |
| Massive fixed-momentum continuum | For fixed momentum and fixed complex Pluecker mass, the exact local-unitary walk has a one-step `O(eps^2)` error and an explicit many-step `O(1/n)` endpoint bound against the massive Dirac exponential | `HNUMassiveContinuumReduction.lean` | `M` asymptotic | Uniform momentum/tail control and changing-lattice position-space composition |
| Massive changing-lattice evolution | For fixed complex mass, fixed time, and fixed four-component `L2` datum, the actual cell-projected massive HNU walk converges strongly in momentum and position `L2` to exact massive Dirac evolution under the displayed adaptive schedule | `HNUMassiveExactFlowMomentumLipschitz.lean`, `HNUMassiveCompactMomentumContinuum.lean`, `HNUMassiveChangingCellProjectionL2.lean`, `HNUMassiveExactFlowCellIntegral.lean`, `HNUMassiveChangingCellL2.lean`, `HNUMassiveChangingLatticeContinuumCapstone.lean` | `M` asymptotic | PDE graph-domain composition, physical sector, second quantization, and interactions |
| Maximal massive Hamiltonian | The matrix-valued momentum multiplier has dense maximal graph domain, is symmetric, has both imaginary shifts surjective through explicit bounded resolvents, and is self-adjoint and closed | `HNUMassiveFibreResolvent.lean`, `HNUMassiveL2Resolvent.lean`, `VariablePointwiseL2Multiplier.lean`, `HNUMassiveMaximalMultiplier.lean` | `M` analytic | Exact Fourier-conjugate position operator and Sobolev-domain equality |
| Free finite Fock locality | Determinant-minor second quantization gives exact occupation amplitudes; conjugation transports creation/annihilation operators; sparse finite-depth one-particle support sends a local CAR algebra into the relational-power neighborhood algebra | `FiniteFermionicLocality.lean` | `M` | Instantiate the live HNU schedule explicitly; add an interaction and test selected/complement-sector invariance |
| Finite even interaction control | On five occupation modes, an exact quartic pair transfer and unit-phase closed update are supported on a declared four-mode cell: conjugation fixes both outside CAR generators, maps the cell CAR algebra to itself, preserves the whole two-particle sector, and mixes an explicit one-pair sector | `FiniteFermionicInteraction.lean` | `M` | Identify the update with an interaction exponential/action; compose with the live HNU schedule; test lower/complement HNU band selection; prove an interacting cone and limit |
| Changing-lattice evolution | Live HNU cell approximation converges strongly in momentum and position `L2` to exact Weyl evolution for the displayed schedule | `HNUChangingLatticeContinuumCapstone.lean` | `M` asymptotic | Adaptive substep cost and interacting extension |
| Weyl PDE | On two-spinor Schwartz data, Fourier transform of `(-i/(2*pi)) sum sigma_j partial_j` is exactly multiplication by `q dot sigma` | `HNUWeylSchwartzPDE.lean` | `M` analytic | Closed-operator upgrade optional; no interacting QFT |

## 3. What the full-zone census means

The massless endpoint does **not** contain a set of isolated Weyl doublers at
the Brillouin corners. Its exact crossing geometry is different:

```text
quasienergy 0:  one isolated point at q = 0
quasienergy pi: every boundary face where some q_j = +/- pi
```

The origin carries an ordinary three-dimensional Weyl tangent and local charge
`+1`. A `pi` face is constant in its two tangential directions, so its
linearization has a kernel of dimension at least two. It is therefore false
shape to assign a usual determinant-sign Weyl chirality to each point of the
sheet.

This is the singular representative used in the published HNU construction.
Higashikawa, Nakagawa, and Ueda identify the restricted two-band endpoint as a
degree-one map from the Brillouin three-torus to `SU(2)`, with the boundary
collapsed to the south pole `-I`. Sun et al. show that, for a generic regular
two-band representative, the chirality imbalance at each of the north and
south poles equals that degree. The live `pi` sheet is nonregular, so it must
not be assigned point-node chirality; a generic perturbation or a degree
argument must perform the south-pole accounting.

This closes the endpoint topology problem itself. `HNUWindingIntegral.lean`
identifies the live endpoint with the published sphere-coordinate map, proves
the unit-sphere and collapsed-boundary identities, computes the exact oriented
density, and evaluates its normalized integral as `+1`. We no longer infer a
global invariant from a local Jacobian surrogate.

The primary-source block formula sharpens the second target. HNU define the
complement by `U^H(k1,k2,k3) = U(k1,k2,k3-2*pi)`. Exact numerical-oracle
reduction indicates the stronger all-momentum identity
`U^H(k1,k2,k3) = U(k1,-k2,k3)`. Its origin Jacobian is therefore expected to
be `diag(1,-1,1)`, with determinant `-1`, opposite the lower block's `+1`.
`HNUCompanionChirality.lean` now proves that identity, the reflected
high-block tangent, its determinant `-1`, the lower-block determinant `+1`,
their exact local balance, and invariant coordinate subspaces. Thus the
selected lower sector carries one Weyl orientation while the complete
four-band microscopic drive contains the opposite companion orientation.

## 4. Current topology split

Three invariants answer different questions and must remain separate:

1. **Restricted endpoint map invariant.** The published HNU quantity is the
   degree/winding of the periodic two-band map from the three-torus to
   `SU(2)`. The source and `HNUWindingIntegral.lean` compute `W = +1` by the
   exact normalized oriented-volume integral.
2. **Band/projector invariant.** A Chern-type invariant of a spectrally isolated
   band. It is unavailable on the massless crossing set without deleting or
   enclosing singularities.
3. **Protocol/micromotion invariant.** An invariant of a full periodic path of
   local unitaries, capable in other Floquet systems of carrying information
   invisible in the endpoint alone. This is not needed to name the published
   HNU endpoint winding and must not be substituted for it.

`HNUGlobalHolonomyClassification.lean` supplies a finite protocol residue:
the ordered reflection product is `-I`, while a nontrivial control protocol has
product `+I`; determinant alone cannot distinguish them, trace can, and global
unitary conjugation preserves the distinction. It is useful protocol data, but
it neither computes the published endpoint winding nor supplies the missing
full-system chirality balance.

The apparent conflict with the ordinary Floquet retraction is resolved by the
sector and periodicity hypotheses. Sun et al. retract the complete legitimate
continuous-time Floquet operator and recover zero total chirality. HNU instead
restricts to a two-band sector that is closed after a full cycle. Its half-cell
intermediate factors are antiperiodic in that restricted Bloch description, as
`HNUBlochPeriodicity.lean` proves, so truncating the protocol does not give a
homotopy through periodic restricted two-band endpoint maps. The full
microscopic system still contains a complementary block that restores the
global accounting.

## 5. Stay and dilation verdict

The conditioned stay sector is not global inertness. Each substep moves one
projected component and leaves its orthogonal complement at the coarse site;
opposite projectors across the schedule ensure no nonzero spinor is stationary
in every substep.

The known dilation route does not remove the issue for free.
`HNUDecodedLocalStay.lean` gives an injective encoding into a larger local
unitary update and exactly recovers the selected HNU dynamics. But its
complement is dynamically invariant and evolves with phase `-1`, with an
explicit nonzero witness. Thus the dilation converts coarse stay into extra
local register structure while retaining an additional physical-looking
quasienergy sector. It is an exact realization theorem and an exact warning,
not an all-null completion.

The strongest honest interpretation is therefore:

> conditioned stay is an internal routing resource of the finite-depth
> protocol; every nonzero physical spinor participates in movement during the
> schedule, but not every component translates during every substep.

## 6. Massive extension

The doubled construction pairs opposite chiral endpoints, changes to a Dirac
basis, and applies the Pluecker mass coin. At the joint small-momentum,
small-angle limit its generator is the intended kinetic Dirac block plus the
complex Pluecker rest block. For every fixed mass angle strictly between zero
and `pi`, the full finite zone is uniformly separated from both Floquet gap
closures. `HNUMassiveContinuumReduction.lean` additionally proves the exact
fixed-momentum local-unitary flow, group law, one-step `O(eps^2)` estimate, and
explicit many-step `O(1/n)` convergence rate for fixed momentum and mass.

The changing-lattice composition is also now kernel-checked. The proof
separates the error into the live-walk approximation, exact-flow variation
within each momentum cell, and cell projection. The exact massive-flow
Lipschitz estimate cancels the common mass term, so bounded onsite mass creates
no additional ultraviolet penalty. Plancherel then transfers the complete
momentum-space estimate to position space. The quantifier order is part of the
claim: mass, time, and datum are fixed; the ultraviolet cutoff is chosen for
that datum before lattice refinement; and the adaptive substep count is then
increased with the cell resolution.

`HNUMassiveSchwartzPDE.lean` now identifies the limiting equation itself on
Schwartz spinors. The live HNU kinetic matrices and complex Pluecker mass block
form exactly the Fourier multiplier of the position-space massive Dirac
differential expression. Mathlib's Fourier convention forces the derivative
coefficient `-I/(2*pi)`; the constant mass block transfers unchanged. The file
also proves that the specialized symbol retains a nonzero spatial kinetic
direction. This is a generator identification on a dense core, not yet an
operator-closure or self-adjointness theorem.

`HNUMassiveExactFlowGenerator.lean` closes the corresponding live time-flow
algebra. For the actual complex Pluecker mass, it identifies the skew-Hermitian
fibre generator `-I * (kinetic4 q + mass4 z)`, proves the exact derivative at
every time, proves the pointwise one-parameter group law, transports the
derivative to its action on a spinor, and supplies a nonzero `3+4I` rest
control. This replaces any temptation to cite the older real-mass generator
theorem as though it already covered the live complex-mass regulator.

`HNUMassiveCompactSupportL2Generator.lean` now lifts that same live complex
symbol to the genuine momentum-space `L2` quotient. It proves exact chiral
conjugacy to the landed real-mass flow at mass `|z|`, packages the complex flow
as a representative-safe linear isometry, proves that the constant phase
preserves bounded momentum support, and transports the dominated-convergence
generator theorem. The main result states that every bounded-support `L2`
spinor has a strong derivative at zero represented almost everywhere by
`-I * (kinetic4 q + mass4 z)`. The result is guard-pinned, has no proof
placeholders, is root-imported, and passed its 8,065-job target build.

The maximal-domain upgrade is now kernel-checked in
`HNUMassiveMaximalMultiplier.lean`. It adapts the scalar-multiplier strategy in
PhysLean's
`Physlib.QuantumMechanics.DDimensions.Operators.Multiplication` to the finite
Hermitian matrix-valued family `kinetic4 q + mass4 z`: the maximal graph domain
is dense, fibrewise Hermiticity gives symmetry, and the explicit resolvents
solve both imaginary-shift range equations. The standard range criterion then
gives self-adjointness, adjoint equality, and closedness. PhysLean was consulted
at commit `ea3c9dd60268886f05c07469b74b38321b975a28`; it is not imported because
of the toolchain gap. The exact unitary-conjugation layer is now kernel-checked
in `HNUFourierPositionOperator.lean`. It defines the position operator on the
pulled-back maximal graph domain and proves exact domain membership,
self-adjointness, closedness, graph pullback, and graph-norm invariance. The
Schwartz derivative/momentum theorem fixes Mathlib's `2*pi`, sign, and
complex-unit convention. The remaining operator-theoretic theorem is narrower:
identify this abstract conjugate with the classical differential Dirac
expression on a graph core and prove its maximal domain is the expected
vector-valued Sobolev space. Aristotle isolated the missing library bridge as
the vector-valued `L2` weak-derivative/weighted-Fourier characterization.

The live symbol now also has an explicit resolvent certificate in
`HNUMassiveFibreResolvent.lean`. Its Dirac square yields exact two-sided
inverses of `H(q) +/- i I` with denominator
`|q|^2 + |z|^2 + 1 > 0`, and proves both shifts are units at every fibre. This
removes momentum-dependent diagonalization from the graph-domain proof. The
inverse multipliers, maximal-domain range equations, and adjoint equality are
now packaged by `HNUMassiveL2Resolvent.lean` and
`HNUMassiveMaximalMultiplier.lean`.

The first many-particle locality rung is also closed in
`FiniteFermionicLocality.lean`. For any finite mode set, an explicit inverse
pair of sparse one-particle matrices induces determinant-minor second
quantization on the exterior algebra. Conjugation sends the local CAR algebra
at one mode into the algebra generated by its declared one-step neighborhood;
matrix-support composition yields the finite-depth light cone. A nonidentity
two-mode swap witnesses movement, and the empty-neighborhood control fails as
it should. This is an independent free exterior-algebra realization. It is not
an interaction theorem, a positive-energy selection theorem, or a proof that
the HNU lower block remains invariant under gauge coupling.

`FiniteFermionicInteraction.lean` now supplies a nontrivial finite interaction
control. On five fermionic modes, an explicit even quartic pair-transfer
Hamiltonian and reversible unitary update are supported inside a four-mode
cell: conjugation fixes the outside creation and annihilation operators and
maps the cell CAR commutant into itself. The update fixes vacuum and every
one-particle state, preserves particle number, parity, and the full
two-particle sector, but mixes an explicit one-dimensional pair sector. Thus
locality and interaction are compatible in one exact finite model, while a
chosen proper sector need not be invariant. The update is not yet proved to be
the time exponential of the displayed Hamiltonian or composed with the live
HNU free schedule.

This is more than a local dispersion fit. It proves exact locality/unitarity
and full-zone spectral stability for the free massive regulator. It does not
yet prove that:

- the four-channel encoded sector is the complete physical one;
- the massless anomalous sheet has the correct interacting anomaly inflow;
- an interacting second-quantized update preserves the desired sector split;
- gauge interactions avoid populating or destabilizing complement sectors;
- the Fourier-conjugate maximal multiplier equals the displayed position-space
  massive Dirac differential operator on an exact Sobolev domain;
- any interacting or gauge-covariant changing-lattice successor converges.

The free theorem is fixed-mass and fixed-data. It does not assert a uniform
limit over arbitrary masses or data, remove the companion sector, prove
interacting stability, or construct a quantum field theory.

## 7. Next decisive theorems

1. **Differential/Sobolev identification.** The unitary Fourier conjugate,
   exact graph domain, self-adjointness, closedness, and graph norm are proved.
   Prove on a graph core that it equals the classical differential Dirac
   expression, then supply the missing vector-valued weak-derivative theorem
   identifying the maximal domain with componentwise `H^1`.
2. **Physical-sector theorem.** `SectorInteractionClassification.lean` now
   proves the exact finite criterion: a Hamiltonian preserves a declared
   coordinate sector precisely when every selected/complement cross block
   vanishes, and then its exact exponential preserves the sector. The nonzero
   `3+4i` pair-transfer control fails this criterion. The remaining HNU work is
   therefore not to infer exact invariance from locality. The literature pass
   in `CODEX_LITERATURE_QUASILOCAL_PHYSICAL_SECTOR_2026-07-21.md` sharpens the
   target: define a gapped low-energy band projector and prove either exact
   cross-block vanishing or a quasi-local, moving-projector scaling law whose
   accumulated leakage tends to zero. The full compensating HNU block remains
   in the microscopic spectrum; the physical field is the asymptotically
   autonomous low-energy band, not a coordinate sector obtained by deleting
   that block.

   `SectorLeakageTelescope.lean` now closes the fixed-projector accumulation
   theorem: for a contractive step and normalized idempotent projector, the
   selected-to-complement leakage after `n` steps is bounded by `n` times the
   one-step commutator norm. It also proves that a changing-regulator budget
   with `n * epsilon_n -> 0` gives vanishing leakage, including an explicit
   exponentially suppressed schedule. This does not yet supply the HNU
   projector or prove its interaction commutator estimate.

   The discrete-adiabatic literature pass in
   `CODEX_LITERATURE_DISCRETE_ADIABATIC_BAND_2026-07-21.md` supplies the sharper
   route for the actual Floquet update. A moving physical band can be selected
   directly from separated eigenvalue arcs of the one-step unitary. The live
   successor must prove first- and second-difference bounds of order `1/T` and
   `1/T^2`, plus a quasienergy gap that separates selected and complementary
   arcs over every triple of neighboring steps. The resulting literature
   theorem gives `O(1/T)` adiabatic error for fixed positive gap. This avoids an
   artificial stepwise logarithm and permits a finite-rank selected band with
   internal degeneracy or crossings, provided the external gap remains open.
3. **Protocol topology.** Keep the endpoint winding `+1` separate from any
   proposed micromotion invariant; prove a micromotion or bulk-edge statement
   only if the full continuous-time protocol and hypotheses are supplied.
4. **Interacting Fock gate.** Instantiate the free CAR-light-cone theorem on the
   live finite real-space schedule, then add one explicit local interaction and
   test invariance of the selected/complement split. Free second-quantized
   locality is already proved abstractly.
5. **Adaptive-cost theorem.** `HNUPolynomialAdaptiveCost.lean` removes the
   exponential penalty at the abstract unitary product-formula layer. It proves
   the sharp skew-Hermitian ordered-product bound
   `eps^2 / 2 * (sum norms)^2`, exact unitary telescoping, an exact depth-eight
   two-component HNU exponential word whose generator norms sum to `qAbs q`,
   and a cubic arithmetic bound for a candidate `(R+M)^2 / 2` schedule. The
   decisive composition is still open: the generic bound is four-dimensional,
   the exact word proved there is the two-component massless endpoint, and the
   doubled chiral/Dirac-basis/Pluecker mass factors have not yet been assembled
   into the required one-step inequality. The old exponential envelope remains
   the only completed massive certificate until that theorem lands.

An independent harvested homotopy audit (Aristotle project
`83cd8f08-e5ea-4aba-bb7c-85624a882db5`) proves constancy of an unsigned
upper-semicircle spectral count for supplied continuous spectral branches while
both `+1` and `-1` gaps stay open. It also proves a crossing witness showing
that the gap hypothesis is necessary. This is a useful massive-gap consistency
check, but it is not the endpoint winding: a signed Floquet crossing invariant
still needs orientation, chirality, and multiplicity.

## 8. Kill conditions

- A re-audit invalidates the exact endpoint winding `+1` or opposite-companion
  result, or the claimed complete microscopic register contains additional
  uncompensated chiral sectors.
- The selected sector is not invariant after an admissible local interaction.
- The complement required by an all-moving dilation carries unavoidable
  low-energy physics that cannot be interpreted or decoupled.
- A semantic re-audit finds that the massive changing-lattice capstone does not
  compare the actual live walk and exact massive flow under the claimed
  quantifiers.
- The adaptive schedule requires a collapsing physical scale rather than only
  additional approximation depth.
- Any manuscript replaces the exact `pi` sheet with a fictitious isolated
  opposite-chirality point.

## 9. Current claim

> The project has a kernel-checked local-unitary free `3+1` regulator with one
> isolated infrared Weyl sector, an exactly classified anomalous `pi`
> boundary sheet, an exact degree-one endpoint winding, an opposite-chirality
> companion sector in the complete four-band drive, a uniformly gapped doubled
> Pluecker-mass extension, a strong changing-lattice position-space Weyl limit,
> an explicit fixed-momentum `O(1/n)` massive Dirac convergence theorem, and a
> strong changing-lattice position-space massive Dirac limit for fixed mass,
> time, and `L2` datum. On Schwartz spinors the limiting multiplier is exactly
> the Fourier image of the massive Dirac differential generator with the live
> HNU/Pluecker matrices, and on bounded momentum support its exact complex-mass
> flow has that generator as a strong `L2` derivative. The maximal
> momentum-space Hamiltonian is self-adjoint and closed; its exact
> Fourier-conjugated position operator is self-adjoint and closed on the
> pulled-back maximal graph domain; and finite sparse one-particle dynamics has
> an exact local exterior-Fock lift. Exact classical differential-expression
> and Sobolev-domain identification, physical-sector interpretation
> under interactions, and interacting QFT completion remain open.
