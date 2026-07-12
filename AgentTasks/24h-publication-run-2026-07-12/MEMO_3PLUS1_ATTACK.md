# Memo: what it takes to crack strict 3+1

Fable, 2026-07-11 (24h run, T+6h). Program-level; shared with Codex
(B-lane owner). Everything below uses the program claim discipline:
statements marked KNOWN cite kernel-checked results; VERIFY marks a
literature fact that must be full-text-checked before any manuscript
use; the rest is strategy.

## 1. The problem, stated exactly

Exhibit a strictly local (finite-range Laurent symbol), exactly unitary,
translation-invariant discrete-time update on a 3+1 lattice with finite
internal dimension whose quasienergy spectrum has exactly one Dirac
point --- an involutory unit-speed Dirac tangent at the origin --- and
no other +-1-quasienergy crossings anywhere in the zone, at either
quasienergy 0 or pi.

OR prove that no such update exists in a stated architecture class: a
discrete-time Nielsen-Ninomiya theorem.

Either outcome is field-changing for the discrete-spacetime and QCA
communities. The second is the one the evidence favors.

## 2. What we already know (the fence, all kernel-checked)

The obstruction suite pins every cheap exit:

- **Complete crossing classification** (all-zone determinant
  factorization, `det(U^4 -+ 1) = 4 P_{0,pi}`; `FullBlochZeroClassification`,
  `FullBlochSplitPlus/Minus`): for the successive-axis family, 0- and
  pi-quasienergy modes occur exactly where all three momentum cosines
  vanish simultaneously. The three even-parity corner aliases are exact,
  and the 0/pi Floquet pairing is explicit --- pseudo-doublers (Gupta-Short
  language) are tracked, not ignored.
- **All-coins alias theorem** (`eq:genericcorneralias`): in the
  four-channel, range-one, single-factor-per-axis architecture, NO
  momentum-independent onsite coin removes any even-parity alias. Onsite
  data is not an exit.
- **Stationary-amplitude no-go** (`StationaryAmplitudeNoGo`): no
  degree-one nearest-neighbor factor supports a stay-put amplitude
  compatible with origin normalization, exact unitarity, and the full
  involutory Dirac tangent. Consequently (kernel corollary) the
  Gupta-Short stay-put family --- the only published doubler- and
  pseudo-doubler-free walks --- necessarily has a NON-involutory tangent,
  and their own Appendix F concedes residual Weyl-like states.
- **Body-center kill**: the massive body-center step retains +-1
  eigenmodes at every mass angle; that regulator never opens a global
  Floquet gap.
- **Temporal blocking**: exact two-step blocking closes only the mass
  subgroup; composition-order effects are exact. Blocking does not
  manufacture new exits.
- **B-lane invariant state** (Codex): Laurent-unit theorem, additive
  flow exponent, exact Fourier determinant phase law --- and the decisive
  negative: the determinant (U(1)-level) flow is BLIND on the live
  stationary-amplitude witness (zero flow, nonidentity). The abelian
  invariant does not decide the problem.

The fence teaches: every surviving exit changes the architecture ---
larger internal cell, longer range, coupled non-separable substeps,
non-cubic lattice, or abandoning the involutory tangent (the Gupta-Short
price).

## 3. Route A correction: the full Dirac point is neutral

The previous version asked for a nonzero class-A charge of the complete
four-component Dirac tangent. That object cannot exist under the displayed
mass-admitting hypotheses. If

```text
F0(n) = n1 alpha1 + n2 alpha2 + n3 alpha3,
F0(n)^2 = I,
beta^2 = I,
F0(n) beta + beta F0(n) = 0,
```

then

```text
Fs(n) = cos(pi s / 2) F0(n) + sin(pi s / 2) beta
```

also satisfies `Fs(n)^2 = I`, starts at `F0`, and ends at the constant
matrix `beta`. The kernel therefore supplies an explicit pointwise unit-circle
family of gapped involutions from the tangent to a constant. Calling this a
null-homotopy and concluding that the total class-A charge vanishes is the
standard topological reading of that family, not a separate kernel-checked
homotopy theorem. The live Weyl-sector restriction independently exhibits the
expected opposite local Jacobian signs; their equivalence to the topological
reading is not asserted here.

This correction is now binding. Never claim that an involutory
four-component Dirac tangent by itself forces a nonzero local charge.

The correct symmetry-resolved object uses

```text
Xi = -i alpha1 alpha2 alpha3.
```

`Xi` commutes with the spatial tangent matrices. The two `Xi = +-1` sectors
are two-component Weyl representations with opposite orientation. A sector
charge is globally meaningful only under the additional hypothesis
`[U(k), Xi] = 0` throughout the Brillouin zone. Local chirality at the origin
does not supply that global splitting.

## 4. Corrected route A: sector charge and strict-Laurent no-go

- **A0 (full-Dirac neutrality, finite Clifford algebra).** Land the explicit
  mass homotopy and its square, endpoints, and nondegenerate sphere control in
  `DiracLocalChargeNeutrality.lean`. This is elementary and must precede every
  topological claim. **Landed:** the algebraic interpolation, explicit
  anticommuting involutions, and missing-anticommutation control are guarded.
- **A1 (exact Weyl-sector charge).** For a globally split `2 x 2` determinant-
  one sector, write the symbol as `u0 I - i u dot sigma`. At an isolated
  `+-I` crossing, define the local charge as the sign of the exact `3 x 3`
  crossing-Jacobian determinant. Prove the intended Weyl tangent has charge
  `+-1` and the two sectors of the Dirac tangent have opposite charges.
  **Live tangent composition landed:** `SU2LocalCrossingCharge` proves the sign
  API and singular control; `CubicWeylSectorCharge` proves that the actual live
  `4 x 4` Clifford tangent commutes with the explicit chirality, restricts on
  explicit orthogonal Weyl bases to the Pauli triple and its negative, and
  therefore has exact local sector charges `+1` and `-1` with cancelling sum.
  The all-momentum chirality boundary is now landed in A2.  The displayed
  census matrix has also been identified exactly with the complete Frechet
  derivative of the live positive-Weyl Pauli vector, and the two designated
  finite charge sums cancel separately.  What remains is branch-resolved proof
  that those lists exhaust the positive-Weyl crossings on the momentum torus.
- **A2 (global chirality is load-bearing).** State every sectorwise sum rule
  with a constant Hermitian involution `Xi` satisfying `[U(k),Xi]=0` for all
  `k`. If the symbol mixes sectors away from the origin, the sector charge is
  not globally defined and A2 does not apply. **Live boundary landed:** for the
  actual ordered Bloch step,
  `[Xi,U(q,theta)]=0` if and only if `sin(theta)=0`. Thus the complete massless
  walk is globally split, while every genuine mass angle exits the chiral
  class; an exact quarter-turn fixture witnesses the failure. The chirality is
  now proved Hermitian and the positive-sector projector is proved to commute
  with the complete massless step, so "globally split" is a kernel statement,
  not merely shorthand for a vanishing commutator.
- **A3 (strict-Laurent strong triviality, source-supported imported-T).** Read
  arXiv:1608.04696v3 explicitly computes
  `K1(C[z1^+-,z2^+-,z3^+-]) = C^* + Z^3` and that its change-of-rings image in
  `K^1(T^3)` has no nonzero `SK1`/strong three-dimensional component. The
  primary source supports the algebraic spine; finite-rank stabilization,
  Floquet-sector sign conventions, and composition with the charge theorem
  remain VERIFY. Never encode the imported result as a Lean assumption.
- **A4 (conditional chiral doubling).** Kernel-check the finite implication:
  total sector charge zero + one nonzero local sector charge + uniqueness of
  the crossing gives a contradiction. Supply total-charge zero either by an
  exact finite census for a concrete architecture or by a separately graded
  external theorem after A3 is source-verified. **Finite hinge landed:**
  `ChargeBalanceForcesPartner` proves that zero total integer charge plus one
  nonzero supplied-Jacobian charge forces a distinct nondegenerate partner,
  with an exact two-sector witness and a singleton negative control. It does
  not derive the zero-total premise.
- **A5 (first escape resource).** Decompose
  `U_parallel = (U + Xi U Xi)/2` and `U_perp = (U - Xi U Xi)/2`. Prove the
  even/odd commutation laws and that the constant and linear jets of `U_perp`
  vanish when `U(0)=I` and the intended tangent commutes with `Xi`. Combined
  with A4, a single-cone strict-local candidate must have nonzero chirality
  mixing beginning at quadratic or higher order. **Finite coefficient core
  landed:** reconstruction, even/odd commutation laws, zero constant/linear odd
  coefficients, and a nonzero odd fixture. The analytic Taylor estimate and A4
  composition remain open.

Acceptance fixtures are revised accordingly: the cubic walk must produce
opposite exact sector charges with cancelling totals; Gupta-Short must reveal
which involutory/global-chirality hypothesis fails or which residual modes
compensate; the zero-determinant-flow witness may have nontrivial local charge
distribution while both determinant flow and total strong charge vanish.

**Exact live-census update:** the positive Weyl restriction of the actual
massless ordered step now has a kernel-checked Pauli decomposition and complete
Frechet derivative.  Its Jacobian determinant is
`u0 * (cos(qy)^2 - sin(qy)^2)`.  At the sixteen designated principal-torus
points, all Jacobians are nondegenerate with charge `+-1`; the four corner and
four body-center charges cancel separately for each of the displayed
`U=+I` and `U=-I` lists.  `LiveMasslessWeylCensusBridge` proves that these are
charges of the actual live derivative rather than a supplied arithmetic
matrix.  `MasslessBlochCrossingClassification` separately classifies the full
`4x4` zero and pi determinant sets in cosine coordinates as parity-selected
corners plus the body center.  The remaining theorem is deliberately narrower
and subtler: prove that the two displayed lists are the complete branch-resolved
crossing sets of the positive `2x2` Weyl block modulo torus identification.
Each `4x4` body center carries both a `+1` and a `-1` eigenvalue, so the required
branch assignment cannot be inferred by naively partitioning the `4x4` roots.

## 5. Route B: search only the required escape class

- **B1. Published-symbol audits.** Compute exact all-zone crossing tables,
  by chirality and quasienergy, for the tetrahedral, Pavia, Gupta-Short, and
  cubic symbols. Treat enlarged cells, half-cell transport, projection, and
  non-involutory tangents as explicit hypotheses, not incidental notation.
- **B2. Exact-local commutator regulators.** For Hermitian involutions `A,G`,
  study
  `R(p,q)=exp(-ipA) exp(-iqG) exp(ipA) exp(iqG)`. Each factor is Laurent and
  unitary; the loop is identity to first order and begins with a controlled
  quadratic commutator. Choose the leading commutator to be `Xi`-odd. Include
  the negative control that perfectly anticommuting choices can collapse to a
  central `-I` at high-symmetry momenta and merely exchange zero and pi modes.
  **Finite word and coefficient core landed:** `CommutatorRegulator` proves
  exact unitarity, normalization, axiswise identity, the anticommuting `-I`
  and commuting `+I` controls, both missing-involution counterexamples, and a
  genuinely noncentral rational fixture. `CommutatorChiralityCoefficient`
  proves the leading Lie coefficient is `Xi`-odd and nonzero for the live
  `Xi/alpha1/beta` choice. `CommutatorMixedDerivative` now proves that this
  coefficient is the actual mixed second Frechet derivative, while the full
  first derivative vanishes. No global root-exclusion or alias-removal claim
  follows. **New exact
  obstruction landed:** a zero-offset commutator whose phase angles are
  integer linear forms in cubic momenta is invisible at every `0/pi` corner,
  because all phase sines vanish there. Such loops may alter body centers but
  cannot remove the live corner aliases. **Stronger obstruction landed:** the
  commutator is pi-periodic in each phase angle, because a common sign flip of
  a cosine/sine pair contributes two cancelling central signs. Therefore
  affine offsets also leave every integer-frequency corner equal to the
  origin. `CommutatorPiPeriodicity` proves the common-sign invariance and keeps
  a single-step negative control, so the cancellation is genuinely a property
  of the doubled commutator word. An enlarged cell, half-step, or different
  Laurent primitive is required to act on those corners.
- **B3. Split the systematic sweep.** The control class imposes global
  chirality and should be emptied by A3/A4. The escape class requires
  `U_perp != 0` with zero constant and linear jets. Search commutator loops,
  larger cells, nonseparable substeps, diagonal/range-two hops, and memory
  registers in lexicographic resource order.
- **B3a. Reciprocal conditional-shift escape.** Pure phase commutators are
  blind on the cubic two-torsion corners, but a projector shift
  `D(z)=diag(z,1)` is noncentral at `z=-1`. The exact rational oracle for
  `K(z)=D(z) C D(z^-1) C^-1` and `S(z)=K(z)K(z^-1)` gives `det S=1`,
  `S(1)=I`, `S(z)-I=(z-1)^2 Q(z)`, and nonzero determinants for both
  `S(-1)-I` and `S(-1)+I`. This first concrete survivor primitive is now
  kernel-checked in `ReciprocalConditionalShiftRegulator`: exact circle
  unitarity, determinant one, the quadratic factor, the rational corner matrix,
  and both corner gaps are all guarded. It is not a 3+1 construction until a
  live four-component embedding and global torus root classification are
  proved. **Naive embedding kill:** acting with the
  same `S` on the chirality register gaps all sixteen old high-symmetry fixtures
  but numerically creates generic eigenvalue-one roots, apparently because it
  loses the spectral pairing that kept crossings isolated. The live embedding
  must preserve an explicit paired-spectrum symmetry before root exclusion is
  even a plausible target. **Family-level oracle kill:** with the rational
  rotation parameterization `c=(1-r^2)/(1+r^2)`, `s=2r/(1+r^2)`, the
  zero-quasienergy determinant is a strict negative perfect-power expression
  at a body center and a strict positive perfect-power expression at
  `(pi,0,0)` for every generic `r`. A hostile exact-arithmetic audit reproduced
  both endpoint formulas and the exceptional-parameter list, but also exposed
  two missing hypotheses in the proposed continuity proof: the embedded live
  Dirac blocks must be defined explicitly, and the determinant must be proved
  real along an explicit origin-avoiding path. Until those are supplied, this
  is a strong family-level oracle obstruction rather than a landed no-go.
  A hostile audit identifies the clean sufficient isolation mechanism as
  global `SU(2) + SU(2)` determinant locking under constant chirality. That is
  exactly the control class the escape must leave. Treat the resulting
  codimension argument as strategy, not theorem: a true mixed-chirality escape
  has no accepted symmetry shortcut and must carry an exact torus root
  certificate.
  **Chirality-coupled P1 kill (exact oracle):** grand strategy 7 proposed
  putting the reciprocal mixing inside a `4 x 4` coin that genuinely
  anticommutes with the live `Xi`. Translating that proposal into the
  repository basis and restricting to `q_x=pi`, `q_y=0` gives exact squared
  reciprocal-quartic formulas for both `det(U-I)` and `det(U+I)`. After
  dividing by `z^2` and writing `x=z+z^-1=2 cos(q_z)`, the zero polynomial has
  opposite signs at `x=1,2`, and the pi polynomial has opposite signs at
  `x=-1,0`. Thus this genuinely coupled direct embedding also creates an
  additional zero crossing and an additional pi crossing on one physical
  slice. See `B_COUPLED_RECIPROCAL_SLICE_ORACLE_2026-07-11.md`; focused Lean
  proof `06fe540d` is in flight. Until that proof lands, this is an exact
  external-oracle kill, not a kernel theorem. The next constructive target is
  the determinant-paired enlarged-register architecture or the minimally
  doubled hedge, not another global certificate attempt for this P1 word.
- **B4. Exact certificates only.** Encode torus variables by
  `z_j=c_j+i s_j`, `c_j^2+s_j^2=1`, saturate away the intended origin, and
  return a Groebner, resultant, or Positivstellensatz certificate excluding
  every other root of `det(U-I)` and `det(U+I)`. Oracles discover certificates;
  the kernel or a small exact checker decides them.

A survivor in B3 is the construction paper. A certified-empty bounded family
is a resource lower-bound paper. A universal no-go for symbols with global
chirality does not settle the full problem, because quadratic chirality mixing
is precisely the remaining escape.

## 5b. Route C (user-proposed, 2026-07-11): embrace the doublers

The reframe: stop treating the extra species as a disease of the free
walk; treat the free-level doublers as physical and ask the
INTERACTION - a chirality-flipping coupling read from the derived field
z, i.e. exactly a frozen Higgs-Yukawa datum - to gap the partners in
the full path sum.

Where this sits in the known landscape (all VERIFY before manuscript
use): (i) it is the Wilson mechanism read as a path sum - in the
hopping expansion a Wilson term is precisely a per-step
chirality-flip amplitude that grows toward the zone boundary, marrying
the doublers off with momentum-dependent mass; (ii) it is the
minimally-doubled program's philosophy (Karsten-Wilczek/Borici-Creutz
keep two species and call them a flavor doublet; graphene realizes two
physical Dirac valleys - embracing doubling IS standard condensed
matter); (iii) its chiral-gauge version is the symmetric mass
generation / mirror-fermion-decoupling program (Eichten-Preskill
lineage) - the genuinely open frontier, because Nielsen-Ninomiya's
sting is not the extra species but their OPPOSITE chirality
assignments: naive embracing vectorizes the weak interaction, so the
partners must be gapped, not just accepted, and gapping them without
breaking the chiral symmetry explicitly is the hard part.  The
adversarial literature for this route is in our graph with full text:
Golterman-Shamir, "Propagator zeros and lattice chiral gauge theories"
(arXiv:2311.12790) and "Constraints on the symmetric mass generation
paradigm for lattice chiral gauge theories" (arXiv:2505.20436) - C3/C4
must be designed against their constraint arguments, and any Route C
manuscript sentence needs their exact statements checked first (the
constraints they prove are the professional version of the C3 kill
condition). (iv) Our own
checkerboard layer already IS the proposed object: the formalized
history sum carries chirality flips weighted z / conj z per corner -
"every trajectory, flipping chirality through a Higgs-like coupling"
is literally `ComplexPlueckerCheckerboardPathSum` with the derived
Pluecker field as the frozen Higgs.

**The finite laboratory result (this run, oracle-exact, gated).** On
the 4-site ring, the free two-particle lift carries TEN exact +-1
modes: six at momentum K=0 and four at K=2 - and K=2 on a 4-ring is
momentum pi, the doubler sector. Composing with the local pair kick
(the derived interaction at the 3-4-5 fixture) leaves exactly SIX +-1
modes: at the factor-multiset level the interaction removed precisely
the pi-momentum quartet and kept the K=0 modes. That is
interaction-induced doubler gapping, computed exactly, in flight for
kernel formalization (boundstate + momentum jobs).
Eigenvector-level check (run 2026-07-11, exact): the surviving +-1
kernels have dimensions 4 and 2 as the factorization requires, but they
are momentum-HYBRIDIZED - K-weights mix K=0 and K=2 (one surviving -1
vector is even purely K=2), consistent with [V, T2] /= 0. So the
mechanism is reshuffle-and-gap, not sector deletion: the multiset
statement ("four fewer +-1 modes, trade matching the K=2 quartet") is
exact; the naive "the kick deletes the pi-sector modes" is FALSE at
eigenvector level and must never be written. This sharpens C3: the
right bookkeeping is which CHIRAL content survives, not which momentum
label.

**C3 EXECUTED (2026-07-11 evening, oracle-exact; strategy5's three
finite numbers).** The chiral grading exists and is exact: in the
symmetric time frame (conjugation by the exact half-coin
exp(-i th/2 sigma_x), half-angle values 3/sqrt10, 1/sqrt10) the
site-diagonal sigma_y satisfies G Usym G = Usym^dag, its pair minor
lift G2 is an involution, and the free pair lift obeys the chiral
relation. Results: (a) the derived kick is chirality-EVEN
(G2 K G2 = K, not K^dag), so the COMPOSED step breaks the chiral
relation - the gapping is not symmetric mass generation as it stands;
(b) the chiral index of the protected sector: free +1 space (dim 6)
chi = -4, free -1 space (dim 4) chi = 0; composed +1 (dim 4) chi = -2,
composed -1 (dim 2) chi = +2 - NET protected chirality goes -4 -> 0:
the interaction VECTORIZED the protected sector, the exact finite
incarnation of the Golterman-Shamir worry. The C3 kill condition fired
on its first test - recorded as a sharp negative result, not a
failure. (c) The algebra names the repair precisely: with G U G =
U^dag and a palindromic placement K^(1/2) U K^(1/2), the chiral
relation survives iff the kick is chirality-ODD (G K G = K^dag). Our
derived kick is even; whether a Gamma-ODD pair kick is derivable from
the same Pluecker datum is now THE sharply-posed C4 question.

**Route C plan.**
- C1 (cheap, now): the eigenvector-level identification above; then
  the same experiment with the kick strength as the dial (the
  threshold alpha-sweep from the boundstate seed already shows level
  extraction onset between 0.3 and 0.8) - "how much Higgs does it take
  to gap the doublers" as an exact finite curve.
- C1 finite-size note (honest gap, 2026-07-11 evening): the N=6 ring
  replication (66-dimensional pair sector) exceeded exact-sympy memory
  (MemoryError in the symbolic minor lift); the finite-size control
  needs a momentum-block-first or integer-twin algorithm and is queued
  post-run. No claim currently rides on N=6.
- C2: one-particle version with a POSITION-space chirality-flip layer
  driven by z(x) (the variable-field walk exists:
  `VariablePlueckerLocalWalk`); measure the alias modes' fate exactly.
- C3: the chirality bookkeeping test - the honest kill condition for
  the whole route: compute the gauge/chirality assignment of the
  gapped vs surviving modes. If gapping the partners requires the
  flip coupling to transform WRONGLY under the would-be chiral gauge
  action (the Nielsen-Ninomiya sting), record it as the exact finite
  incarnation of the SMG obstruction - itself a publishable sharp
  statement.
- C4 (the prize, hard): a finite SMG-style theorem - conditions on a
  z-driven interaction under which the composed walk's low-energy
  sector has HALF the free chiral content with the chiral symmetry
  intact. Even a fixture-level instance with controls would be new.

Route C does not compete with route A: A concerns the FREE involutory
walk (and stands - our free-level fence is untouched); C concedes
free-level doubling and moves the burden to the interacting theory,
which is where the field's open chiral-gauge problem actually lives.

## 6. Milestones, owners, gates

- **M0 (now; Lean-first).** Land A0 and the elementary part of A5: full-Dirac
  neutrality, chirality even/odd projections, and zero constant/linear odd
  jets. These are the semantic guardrails for all later work.
- **M1 (days; exact fixtures).** Land A1's Jacobian-sign charge and compute
  chirality/quasienergy charge tables for the cubic walk, Gupta-Short, and the
  zero-flow control. Gate: exact determinant signs and explicit compensation,
  singularity, or failed-global-chirality diagnosis.
- **M2 (source and theorem audit).** Verify the Bass-Heller-Swan/Read strong-
  triviality bridge and the extended Floquet Nielsen-Ninomiya bookkeeping in
  primary full text. Keep algebraic `K1`, topological `K^1`, stable size, and
  determinant delays separate. Gate: an exact source/convention memo that a
  hostile reviewer can reproduce.
- **M3 (conditional composition).** Kernel-check A4 without importing A3 as
  an assumption: formulate total-charge zero as a displayed hypothesis and
  prove the finite no-unique-crossing implication. Concrete exact censuses can
  discharge that hypothesis immediately.
- **M4 (construction or lower bound).** Implement B2 and run B3/B4. Either a
  quadratic `Xi`-odd regulator removes every alias with an exact root-exclusion
  certificate, or a bounded escape class is proved empty with its minimum
  resource statement.

## 7. What is NOT needed

- No continuum analysis: every step above is finite algebra on Laurent
  symbols. The continuum limit machinery already exists and only enters
  after M4.
- No new physics assumptions: the hypotheses are locality, unitarity,
  translation invariance, finite cell, and the tangent condition ---
  all already formalized objects in this repo.
- No reliance on Nielsen-Ninomiya itself: the action-based theorem
  neither implies nor is implied by the discrete-time statement (scope
  row now in Paper A); we inherit its topology heuristic, not its proof.

## 8. Immediate actions after the Route A correction

1. The superseded full-Dirac nonzero-charge target is canceled. A0 and A5
   finite-algebra scaffolds are submitted first.
2. The earlier charge-design result is retained only for the `2 x 2` Weyl
   block. Its Schur reduction and Jacobian determinant are useful; any prose
   assigning that charge to the full four-component Dirac block is rejected.
3. A focused strategy/audit job is assigned to A3. It must return primary
   theorem numbers, exact rings and involutions, the algebraic-to-topological
   map, and counterexamples if stabilization or polynomial-unitarity scope was
   overstated.
4. B3 is restricted to the control and quadratic-mixing escape classes above.
   The Route C result already found that an even kick vectorizes the protected
   sector; its proposed odd-kick repair is aligned with, but does not prove,
   the single-particle `Xi`-odd resource requirement.
