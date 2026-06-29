# Null-edge stay-move decision memo

Date: 2026-06-28

Status: exploratory decision memo, not a model change.

## Decision update after Pro feedback

The helpful physical framing is:

```text
All nontrivial spatial transport steps are lightlike/null.
The update rule may also include local onsite fiber evolution.
```

Use a three-layer description:

```text
Layer 1: transport graph
  null/lightlike spatial transport shifts.

Layer 2: onsite fiber dynamics
  local coin/rest/mass/Yukawa/Wilson/internal terms at a site.

Layer 3: derived propagator/path sum
  histories built from null transports and onsite factors.
```

This lets the model keep its null-edge transport core while giving mass,
Wilson branch lifting, finite internal Dirac/Yukawa structure, onsite phases,
and quantum-walk coin rotations a natural home.

Recommended official wording:

```text
The microscopic transport graph is null.
The microscopic update rule may include local onsite fiber evolution.
Mass, Wilson branch lifting, Yukawa mixing, and internal finite-Dirac data live
in the onsite/fiber layer.
```

For Gate C1, the onsite/fiber layer is already visible in the current overlap
kernel:

```text
H_tet(k) =
  gamma5 [
    (i/a) sum_A B_A sin(k_A)
    + (1/a)(r sum_A(1 - cos k_A) - rho)
  ].
```

Here:

```text
null-shift kinetic term:
  (i/a) sum_A B_A sin(k_A)

onsite/fiber branch-shaping term:
  (1/a)(r sum_A(1 - cos k_A) - rho)
```

Admissible onsite terms should be:

```text
local;
gauge-covariant or gauge-scalar;
tetrahedral-symmetric unless intentionally and explicitly broken;
Hermitian and gamma5-even for Wilson/branch-mass use inside H_ne;
or explicitly declared as chirality/Yukawa/internal finite-Dirac data;
recorded in the moduli ledger if not symmetry-forced.
```

The key theorem/API direction is:

```text
Adding an onsite fiber operator does not change the null transport graph.
```

Then the Gate C1 overlap target can be phrased as:

```text
D_null is built from null shifts.
E_onsite is local, gauge-covariant, and symmetry-constrained.
H = gamma5(D_null + E_onsite - rho/a) is Hermitian and gapped.
D_ov = (rho/a)(1 + gamma5 sign(H)) gives the GW release.
```

## 1. Question

Should the null-edge program allow a microscopic "stay" option?

Informally:

```text
At each tick, a state may move along an allowed lightlike edge, or it may stay
at the same spatial site.
If it moves, the move must be lightlike.
```

This is different from allowing arbitrary timelike or spacelike hopping. The
question is whether a local onsite/rest/coin operation is physically natural and
mathematically useful without destroying the null-edge interpretation.

## 2. Main distinction

There are two different proposals that must not be confused.

### Proposal A: primitive timelike transport edge

Add a new graph edge:

```text
(delta t, delta x) = (1, 0)
```

as a primitive spacetime transport edge.

This is a large change. It means the microscopic graph is no longer purely
lightlike.

### Proposal B: onsite coin/rest operation

Keep primitive spatial transport lightlike, but allow an onsite operator at a
time slice:

```text
local state at x -> local state at x
```

This is more like a quantum-walk coin, internal phase, mass/chirality-mixing
operation, or local regulator term.

This is the safer version:

```text
Primitive transport remains null.
Local internal evolution is allowed.
```

## 3. Working recommendation

Do not immediately add a primitive timelike transport lattice.

Do investigate a **lazy null-edge quantum walk** or **null-edge walk with onsite
coin**:

```text
one step = local onsite coin/rest operation + allowed null-edge shifts.
```

Symbolically:

```text
D(k) = C_onsite + sum_A C_A shift_A(k),
```

or for a unitary walk:

```text
U = S_null C_local,
```

where:

```text
S_null:
  conditional shift along null edges;

C_local:
  local internal/coin operation at each site.
```

This preserves the core intuition better than forcing every microscopic tick to
include spatial displacement.

## 4. Why this might be physically better

Forcing motion at every tick may be too strong.

A more physical microscopic rule may be:

```text
spatial propagation occurs through null moves;
local degrees of freedom may also evolve without spatial displacement.
```

This resembles several known structures:

```text
Feynman checkerboard:
  mass arises through local turning/chirality-flip amplitudes between lightlike
  segments.

Discrete-time quantum walks:
  a local coin operation plus conditional shift produces relativistic continuum
  limits.

Wilson/overlap lattice fermions:
  local onsite or scalar branch-mass terms are not themselves propagating
  spatial hops, but shape the inverse propagator.

Connes/spectral-triple finite Dirac terms:
  internal finite operators are onsite in spacetime but physically meaningful.
```

The stay option may therefore be interpreted as:

```text
local clock phase;
mass/chirality mixing;
internal finite Dirac evolution;
coin rotation;
Wilson branch mass;
onsite regulator;
waiting amplitude in a path integral.
```

## 5. Symmetry questions

The stay term is only acceptable if it is constrained by the right symmetries.

### Translation symmetry

A uniform stay/coin term is compatible with lattice translation symmetry:

```text
C_local(x) = C_local
```

or gauge-covariantly:

```text
C_local(x) -> g(x) C_local(x) g(x)^-1.
```

### Tetrahedral/null-edge point symmetry

If the active lattice is:

```text
L_H = span_Z {h_A},
```

then an onsite term is automatically invariant under permutations of the
`h_A` directions if it acts only on internal/spin indices and not on a chosen
edge direction.

This is good, but dangerous:

```text
a scalar onsite term may be too symmetric to select chirality.
```

### Lorentz symmetry / causal interpretation

A stay operation is timelike in coarse coordinates:

```text
(delta t, delta x) = (1,0).
```

But if it is interpreted as onsite internal evolution rather than transport,
it need not be a new spacetime primitive edge.

The safe claim is:

```text
All nontrivial spatial transport is null.
Onsite internal evolution is allowed.
```

The unsafe claim is:

```text
All primitive spacetime graph edges are null.
```

unless the stay operation is explicitly excluded from the graph-edge notion or
classified as a zero-length/internal edge.

### Gauge symmetry

A local onsite term is gauge-covariant if it is:

```text
gauge scalar,
or an intertwiner between legal gauge representations,
or built from local Higgs/finite-Dirac data with correct transformation law.
```

Examples:

```text
identity scalar:
  gauge invariant;

Yukawa/Higgs onsite term:
  gauge covariant only when Higgs field transforms appropriately;

arbitrary branch-mass matrix:
  not acceptable unless symmetry/legal-map constraints are specified.
```

### Chirality

A stay term may be:

```text
gamma5-even:
  Wilson/branch-mass style, compatible with overlap kernel mass term;

gamma5-odd:
  kinetic/Dirac style, may mix with null-edge slash structure;

chirality-flipping:
  physical mass/Yukawa style, but not a chiral massless release by itself.
```

Gate C1 is especially sensitive here. A scalar onsite term cannot be advertised
as a direct chiral selector on the balanced origin kernel, because we already
have a scalar-Wilson no-go in that role. It may still be valid as a branch-mass
input inside an overlap/sign-kernel construction.

## 6. Possible advantages for Gate C

### 6.1 A cleaner place for mass/regulator terms

The stay/coin term gives a principled location for:

```text
Wilson scalar branch mass;
finite internal Dirac/Yukawa block;
local coin rotation;
onsite phase;
local Higgs coupling;
controlled M_br fallback if scalar Wilson fails.
```

This may help keep the primitive spatial shifts null while still allowing the
inverse propagator to be gapped in unwanted sectors.

### 6.2 Better path-integral interpretation

A null-edge path sum with stays is:

```text
sum over paths made of null moves and waits.
```

This is closer to a general discrete path integral:

```text
amplitude(path) =
  product of null-edge transport amplitudes
  product of onsite coin/rest amplitudes.
```

The wait amplitude can encode local action/cost without forcing spatial motion.

### 6.3 Bridge to quantum walks

Discrete-time relativistic quantum walks often use:

```text
coin -> conditional shift
```

The continuum Dirac mass usually comes from the coin angle. This suggests a
natural route:

```text
null-edge transport geometry + local coin angle
  -> effective Dirac/overlap kernel.
```

### 6.4 Bridge to D4

The D4 discussion found non-null half-sum/half-difference roots. A stay term is
not the same as adding D4 root hopping. But it may offer a compromise:

```text
do not add timelike/spacelike D4 primitive hops;
allow only local onsite evolution plus null shifts.
```

This keeps the D4 root graph out of the primitive motion layer while still
letting local terms carry regulator or internal symmetry information.

## 7. Risks and failure modes

### 7.1 Too much freedom

An arbitrary onsite matrix can fit almost anything.

Guardrail:

```text
Every onsite term must be canonical, symmetry-forced, or recorded as added
moduli freedom.
```

### 7.2 Fake C1 success

An onsite term could appear to lift unwanted sectors while merely hiding a
ghost, propagator zero, or arbitrary branch projector.

Guardrail:

```text
bad sectors need a true inverse-propagator gap;
mirror removal by propagator zero remains forbidden;
Krein/spectral residue must be audited.
```

### 7.3 Loss of null-edge claim

If the stay is described as a primitive timelike edge, the model no longer has
only null primitive edges.

Guardrail:

```text
Use precise language:
  null spatial transport + onsite internal evolution.
```

### 7.4 Chirality confusion

A scalar onsite term may be gamma5-even and therefore unable to polarize the
balanced origin kernel directly.

Guardrail:

```text
Do not reuse scalar Wilson as a direct chiral selector.
Use it only as a branch mass inside the overlap/sign-kernel mechanism unless a
new theorem says otherwise.
```

### 7.5 Unitary-walk constraints

If we formulate the model as a unitary one-step walk:

```text
U = S_null C_local,
```

then `C_local` must be unitary and the continuum generator is obtained from a
logarithm or small-step expansion. This introduces branch-cut and effective
Hamiltonian issues.

If we formulate it as an inverse-propagator/operator:

```text
D = C_onsite + shift terms,
```

then Hermiticity/self-adjointness and overlap sign-kernel conditions become the
main audits.

These are related but not identical formulations.

## 8. Candidate formal API

Possible Lean-side vocabulary:

```lean
structure NullTransportStep where
  direction : EdgeDirection
  isNull : Prop

structure OnsiteStep where
  operator : LocalFiberEndomorphism
  gaugeCovariant : Prop
  pointSymmetric : Prop

structure LazyNullEdgeWalk where
  nullShifts : Finset NullTransportStep
  onsite : OnsiteStep
  allTransportNull : forall e in nullShifts, e.isNull
```

Gate C-specific predicate:

```lean
structure StayTermAdmissible where
  local : Prop
  gaugeCovariant : Prop
  pointSymmetric : Prop
  hermitianOrUnitary : Prop
  gammaParityDeclared : Prop
  noDirectScalarChiralClaim : Prop
  moduliLedgered : Prop
```

For overlap:

```lean
structure OnsiteOverlapMassTerm where
  E : Operator
  hermitian : E† = E
  gammaEven : gamma5 * E = E * gamma5
  gaugeCovariant : Prop
  symmetryConstrained : Prop
```

Then C239 already suggests:

```text
if D is gamma5-odd anti-Hermitian
and E is gamma5-even Hermitian
then gamma5(D + E - rho/a) is Hermitian.
```

The stay term can naturally contribute to `E`.

## 9. Decision tests

Before allowing stay in the main model, ask:

1. Is stay an onsite internal operation, or a primitive timelike graph edge?

2. If onsite, what symmetry forces its form?

3. Is it scalar, gamma5-even matrix-valued, chirality-flipping, or internal
finite-Dirac/Yukawa?

4. Does it preserve gauge covariance?

5. Does it preserve tetrahedral point symmetry?

6. Does it change the branch count?

7. Does it introduce new moduli?

8. Does it help C1 by creating a true inverse-propagator gap, not a propagator
zero?

9. Does it duplicate the scalar Wilson role already present in `H_tet`, or add
a genuinely new physical degree of freedom?

10. Does it have a path-sum interpretation compatible with null-edge transport?

## 10. Recommended near-term jobs

### Stay-1: Pro guidance

Ask Pro:

```text
Should null-edge models allow onsite stay/coin operations?
Under what symmetry constraints?
Does this improve or damage the Feynman-checkerboard/null-edge interpretation?
How does this compare to discrete-time quantum walks and Wilson/overlap
fermions?
```

### Stay-2: Literature review

Search:

```text
discrete-time quantum walk Dirac equation mass coin;
Feynman checkerboard mass turning amplitude;
lazy quantum walk relativistic lattice fermions;
quantum cellular automata Dirac equation;
onsite coin Wilson fermion overlap;
split-step quantum walk chiral symmetry.
```

### Stay-3: Lean/API job

Formalize a small API:

```text
Null shifts plus onsite term preserve "all spatial transport is null."
```

This is definitional but important for claim hygiene.

### Stay-4: Hermitian-kernel connection

Use C239:

```text
onsite gamma5-even Hermitian term E
  -> gamma5(D_null + E - rho/a) Hermitian.
```

Audit whether scalar Wilson and a stay term are the same object in the free
symbol.

### Stay-5: Gate C impact audit

Ask whether an onsite coin can:

```text
improve scalar Wilson global gap;
replace M_br;
produce branch splitting without arbitrary fitting;
or merely restate the existing Wilson overlap mass term.
```

## 11. Current provisional decision

Use this wording going forward:

```text
The microscopic spatial transport steps are null.
The model may allow local onsite internal evolution ("stay" or coin terms),
provided those terms are gauge-covariant, symmetry-constrained, and audited as
onsite operators rather than primitive non-null transport edges.
```

Do not yet change the active Gate C1 free proof:

```text
H_tet(k) =
  gamma5 [
    (i/a) sum_A B_A sin(k_A)
    + (1/a)(r sum_A(1 - cos k_A) - rho)
  ].
```

Instead, interpret the scalar Wilson/mass part as the first onsite/stay-like
component already present in the overlap kernel.

If the current `L_H` scalar-Wilson overlap proof succeeds, stay becomes a
physical interpretation layer and possible future generalization.

If it fails, a symmetry-constrained onsite coin/stay term may become one of the
preferred fallback mechanisms before adding arbitrary branch texture.
