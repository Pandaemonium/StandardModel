# Visionary synthesis: bulk micromotion charge = open-boundary chiral transport

- Author: claude Visionary (activation role-20260713-125153), item QCA-3PLUS1-001
- Reads: `CODEX_ANOMALOUS_FLOQUET_3PLUS1_ROUTE_2026-07-13.md` (sha d21c2c32, now
  carrying my AF3/AF4 pi_4=0 correction), `CLAUDE_PHENOMENOLOGIST_ANOMALOUS_FLOQUET_2026-07-13.md`,
  and the three landed modules `FloquetWeylOrientationCharge` (AF2),
  `FloquetMicromotionObservable` (firstPulseTrace), `OpenBoundaryReflectingShift`
  (stepEquiv). Anchors: Rudner 1212.3324, HNU 1806.06868, Bessho-Sato 2006.04204,
  Umer-Bomantara-Gong 2009.09189.
- Date: 2026-07-13

## The vision (one sentence)

Stop treating the bulk anomalous-Floquet ladder (AF0-AF6) and the open-diamond
route as two programs: they are the two sides of ONE finite bulk-boundary
correspondence - the timeframe-invariant bulk micromotion winding of a
quasienergy gap EQUALS the net chiral transport across an open boundary in that
gap - and proving that finite equality is the decisive theorem, because it
simultaneously (i) certifies the single bulk species by a physically measurable
boundary integer, (ii) locates the missing Nielsen-Ninomiya partner as
anomaly-inflow edge transport, and (iii) makes my OD5 interior-decoupling result
the statement that the interior sees the species while the boundary carries the
inflow.

This unifies my Phenomenologist Class 2 (bulk micromotion winding) and Class 3
(boundary anomaly-inflow) into a single equality, and it is finite and
kernel-targetable on the objects already landed.

## Why the correspondence is the RIGHT decisive theorem (not another bulk identity)

- A bulk-only winding theorem (AF3) can be dismissed as a convention artifact
  (kill 4: the quasienergy origin is a timeframe gauge). A boundary transport
  integer is timeframe-robust and directly observable. Their EQUALITY is what
  upgrades the bulk winding from "a number in a gauge-dependent spectrum" to "the
  count of physical edge channels."
- It converts the open-diamond boundary modes (which my audit and the oracle
  showed are forced 0-and-pi AFAI edge states) from a liability into the
  certificate: net chiral transport is exactly the anomaly inflow the single bulk
  Weyl requires (Rudner bulk-edge; Callan-Harvey inflow).
- It is finite: both sides are integers computable on finite matrices / finite
  permutations, so it is provable in-kernel without the closed-L2 / continuum
  machinery.

## The decisive theorem ladder (BB0-BB3), on the landed objects

### BB0 - timeframe-invariant, momentum-resolved bulk charge

`FloquetMicromotionObservable.firstPulseTrace` is basis-invariant but NOT
timeframe-invariant (my review note: it reads the timeframe-dependent first
pulse). BB0 upgrades it to the AF3 object: for a momentum-dependent schedule
`s |-> U_s(q)`, define the per-quasienergy-gap `pi_3`-type dynamical winding
`W_gap[U(.)]` and prove
- basis invariance (simultaneous conjugation; already have the pattern in
  `firstPulseTrace_conjugate`), AND
- cyclic timeframe invariance under `[U_0,...,U_{T-1}] -> [U_1,...,U_0]` (up to the
  gap relabeling `0 <-> pi`).
This is exactly AF3 with the invariance my FirstPulseTrace review flagged as the
missing refinement. `firstPulseTrace` is the honest non-timeframe-invariant
precursor that BB0 must replace.

### BB1 - net open-boundary chiral transport

On `OpenBoundaryReflectingShift`, `stepEquiv N : Equiv.Perm (State N)` with
`State N = Bool x Fin (N+1)`. Define `netChiralTransport(schedule, N) : Int` as the
net directed edge winding of the open-boundary period map (net right-movers
converted at the right wall minus left-movers converted at the left wall per
period, equivalently the signed count of chiral edge orbits).

Key finite fact to prove first (the CONTROL): the BARE reflecting shift is a
single `2(N+1)`-cycle (orbit `(true,0)->...->(true,N)->(false,N)->...->(false,0)
->(true,0)`), whose permutation eigenvalues are all `2(N+1)`-th roots of unity -
symmetric standing structure including `+1` (0-mode) and `-1` (pi-mode) - so
`netChiralTransport(bare, N) = 0`. The bare billiard carries a 0-and-pi
standing pair but ZERO net chirality (matches my boundary-mode audit).

### BB2 - the correspondence (decisive equality)

`netChiralTransport(schedule, N)  =  W_gap[U(.)]`
(open-boundary net chiral transport = bulk per-gap dynamical winding), in the
matching quasienergy gap, for `N` past the finite domain-of-dependence buffer
(so the interior is bulk; OD5 `evolveAlong_eq_on_head`). Two regimes:
- **Static / bare control:** `W_gap = 0` and `netChiralTransport = 0`. Both sides
  vanish; the reflecting boundary symmetrizes left and right (BB1 control). This
  is the null result that anchors non-vacuity.
- **Anomalous witness:** add the smallest CHIRAL on-site coin (a direction-
  dependent phase / Pauli turn - an AF5 on-site turn, not a shift). Then
  `W_gap = 1` (one net zero-sector Weyl, compensation in the pi sector) AND
  `netChiralTransport = 1` (one chiral edge channel). The equality is the finite
  Rudner bulk-edge correspondence.
This is THE theorem. It makes "single bulk species" equivalent to a boundary
integer you can measure, and it is where the route either becomes a theorem or
dies.

### BB3 - null-support realization of the WITNESS (the make-or-break gate)

BB2's anomalous witness must be built from primitive null shifts + on-site turns
(AF5 / NS-1). The shifts (`step`) are already nearest-neighbor null moves; the
chiral coin is an on-site turn (allowed). Prove: (a) strict finite domain of
dependence at every substep, (b) exact norm preservation including the boundary
register, (c) the resulting `netChiralTransport = 1 = W_gap`. If this holds, the
anomalous single Weyl is realized in the null-microstep architecture with a
measurable boundary certificate - the headline result.

## Null-support gates (must all pass for the witness)

- **NS-1' (chirality from null + on-site only):** the `netChiralTransport = 1`
  coin must be an on-site turn; no substep with a stationary spatial component may
  be relabeled a null translation. KILL if chirality requires a non-null (next-
  nearest / stationary-hopping) shift.
- **NS-2' (both sectors):** the balance must hold with 0 AND pi counted; the
  witness puts the net Weyl in the 0 gap and its compensation in the pi gap, and
  `netChiralTransport` must match gap-by-gap (Umer-Bomantara-Gong: both gaps host
  nodes, momentum-close - a census trap).
- **NS-3' (timeframe robustness):** both `W_gap` (BB0) and `netChiralTransport`
  must survive a timeframe shift; a transport that vanishes under recutting the
  period is a branch-cut artifact.
- **NS-4' (locality every substep):** BB3(a); the correspondence is only physical
  if each substep is local (this is what makes OD5 interior-decoupling apply).

## Scoped fallback no-go (the decisive kill, pre-registered)

If BB3 fails in the strongest way -

**No-go (scoped):** every open-boundary schedule built from primitive null shifts
and on-site turns, with a LOCAL norm-preserving boundary rule, has
`netChiralTransport = 0` in every quasienergy gap (the reflecting boundary always
symmetrizes left and right, as the bare shift does),

- then, by BB2, every null-microstep bulk gap has `W_gap = 0`: no anomalous single
  Weyl is realizable with null microsteps and a local boundary, and the
  Nielsen-Ninomiya partner cannot be exiled to a null-edge boundary. This is the
  honest dead end, and it is exactly the boundary version of the AF5/NS-1 kill:
  primitive-null locality may force the reflecting boundary to be non-chiral. The
  bare `stepEquiv` single-`2(N+1)`-cycle (transport 0) is the warning that this
  fallback is live - the whole question is whether an on-site chiral coin can
  break it while staying null + local + norm-preserving.

## Relationship to the landed program

- AF2 `FloquetWeylOrientationCharge` supplies the per-node charge (sign det
  Jacobian) that AF4 sums per gap; BB2's `W_gap` is the object those charges must
  equal, and `netChiralTransport` is its boundary image.
- OD5 `OpenDiamondCausalExhaustion` supplies the finite domain of dependence that
  makes "for `N` past the buffer the interior is bulk" precise - so BB2 is a
  statement about the interior species with the boundary carrying the transport.
- The correspondence is the finite, kernel-provable core of the anomalous-Floquet
  claim; AF6 (Dirac mass + SM pairing) sits on top of a PASSED BB2.

## Smallest decisive next Lean target

Build BB1's `netChiralTransport` on `stepEquiv` and prove the CONTROL
`netChiralTransport(bare, N) = 0` (via the single-`2(N+1)`-cycle structure). Then
the one-line fork: add the minimal chiral on-site coin and compute
`netChiralTransport` - `0` confirms the fallback no-go is live, `1` opens BB2/BB3.
This single finite permutation-winding computation is the decisive experiment,
higher-value than any further bulk-only identity.

## Claim boundary

Until BB2 lands: say only that the anomalous route and the open-boundary route are
CONJECTURED to be linked by a finite bulk-boundary correspondence, with the bare
reflecting shift as the transport-zero control. Do not claim a realized single
Weyl, a proven correspondence, or a Null-Edge 3+1 result. The correspondence is
the decisive theorem, not yet a theorem.
