# Phenomenologist: anomalous-Floquet 3+1 observable dictionary

- Role: claude Phenomenologist (activation role-20260713-121603), item
  QCA-3PLUS1-001, at Codex request msg-20260713-121253
- Grounds: `CODEX_ANOMALOUS_FLOQUET_3PLUS1_ROUTE_2026-07-13.md` (sha d0fc30c4),
  landed `FloquetMicromotionSchedule` (AF0) + `OpenDiamondCausalExhaustion` (OD5),
  my `CLAUDE_OPEN_DIAMOND_BOUNDARY_MODE_AUDIT` (anomalous-Floquet reframe)
- Date: 2026-07-13
- Anchors: Higashikawa-Nakagawa-Ueda arXiv:1806.06868; Bessho-Sato
  arXiv:2006.04204; Rudner-Lindner-Berg-Levin arXiv:1212.3324 (all verified)

## Purpose and the central phenomenological principle

The four observable classes below are NOT independent measurements; they are four
windows on ONE object (the driven unitary loop), linked by three exact relations:

- **AF4 balance law** (bulk): `sum of tagged Weyl charges (0 and pi sectors) =
  micromotion winding W3`. Ties Class 1 to Class 2.
- **Bulk-boundary correspondence** (holography): the open-geometry boundary
  0-and-pi edge-mode content EQUALS the bulk `W3`. Ties Class 3 to Class 2.
- **Domain of dependence** (causality): finite-time compact-interior observables
  are independent of the boundary sector once the causal cone is interior. Ties
  Class 4 to Class 3 (makes the boundary sector invisible to the interior at
  finite time).

The payoff: an experiment measuring all four DISENTANGLES the three scenarios a
single endpoint Weyl point is consistent with -
1. **Genuine anomalous** (target): one clean endpoint Weyl + `W3 != 0` + a
   boundary inflow mode of matching count + interior stable and boundary-decoupled
   at finite time.
2. **Convention artifact** (kill 4): one endpoint Weyl but `W3 = 0`; no robust
   boundary mode; the node moves/vanishes under a timeframe change.
3. **Hidden doubler** (static-style failure): a second low-energy crossing in the
   0 OR pi sector.
`W3` (Class 2) is the decisive discriminator; Class 1 alone cannot tell (1) from
(2). This is the whole reason AF0 matters: endpoint data forgets the loop.

## The observable dictionary

### Class 1 - Endpoint (stroboscopic) spectrum

- **Object:** quasienergy bands `eps_n(q)` (eigenphases of `U_F(q)`); tagged
  determinant-zero census of `U_F(q) - 1` and `U_F(q) + 1` (AF1); local Weyl
  orientation charge from the sign of the tangent-coefficient determinant (AF2).
- **Measurement mode:** STROBOSCOPIC - observe only at integer periods `nT`. You
  recover `U_F` but not the intra-period path.
- **Certifies:** number, location, and orientation charge of low-quasienergy Weyl
  points in EACH sector (0 and pi).
- **Cannot certify:** the anomalous character. Distinct schedules with identical
  `U_F` (AF0's flip-flip vs idle-idle) share this spectrum. And the quasienergy
  origin is a timeframe gauge: a "node at 0" can be shifted to pi by a timeframe
  change. Necessary bookkeeping, not a certificate.
- **Kill test:** a second low-energy crossing in EITHER the 0 or pi sector kills
  single-species (the Floquet 0-and-pi rule; the exact error
  `Strict3Plus1Frontier` caught). AF1 must census BOTH sectors.

### Class 2 - Micromotion winding (the decisive discriminator)

- **Object:** the integer winding `W3` of the loop `(q,s) |-> V_s(q)` over
  `T^3_q x S^1_s` (Rudner `W3`); AF3 builds a finite combinatorial version, AF4
  the balance law.
- **Measurement mode:** TIME-RESOLVED within a period (resolve `V_s` at
  intermediate substeps), or equivalently a charge PUMPED over one period. Cannot
  be obtained stroboscopically - this is the content the endpoint forgets.
- **Certifies:** THE anomalous character. `W3 != 0` with a single endpoint Weyl =
  the compensating integer lives in the loop, not a second cone. AF4:
  static control has `W3 = 0` (charges cancel); anomalous witness has `W3 = 1`
  (one net Weyl, no second low-energy cone).
- **Cannot certify:** null-edge realizability - `W3 != 0` for SOME schedule does
  not imply a primitive-null-factorized schedule keeps `W3 != 0` (AF5 / NS-1).
- **Kill test:** NS-1 and NS-2 below.

### Class 3 - Boundary anomaly-inflow (holographic dual of Class 2)

- **Object:** anomalous-Floquet (AFAI) boundary modes at 0 AND pi quasienergy on
  an open geometry; boundary-localized spectral weight; anomalous edge current.
  These are the boundary 0/pi modes I reproduced cross-family in the oracle
  (Grover 13+13 / 53+53 exact, DFT asymptotically light, ~92% boundary-supported).
- **Measurement mode:** OPEN-BOUNDARY geometry; boundary-localized states and
  their transport / edge conductance.
- **Certifies:** by bulk-boundary correspondence, the boundary 0+pi edge content =
  the bulk `W3`. So Class 3 is an INDIRECT (holographic) measurement of Class 2 -
  a cross-check, and the physical home of the "missing partner" (anomaly inflow,
  not a bulk doubler).
- **Cannot certify:** interior single-species by itself - the modes exist; whether
  they touch the interior is Class 4.
- **Kill test:** a boundary mode that (i) survives a timeframe change (NS-3, else
  it is a branch-cut artifact) but (ii) cannot be gapped by a local
  norm-preserving boundary term AND leaks into interior observables (fails Class
  4) would kill the single-interior-species reading.

### Class 4 - Compact-interior causal-exhaustion

- **Object:** fixed-time-step interior amplitudes deep in the bulk, as a function
  of system radius. OD5 `evolveAlong_eq_on_head` (kernel) + the oracle: interior
  amplitudes stable across radii 2-6 to `2.8e-17`, zero boundary probability by
  radius 5.
- **Measurement mode:** FIX the number of time steps and the interior region; vary
  the system radius; test convergence (Cauchy in radius).
- **Certifies:** FINITE-TIME domain of dependence - the boundary and its
  anomaly-inflow sector are irrelevant to compact interior observations before the
  cone reaches them. This makes the required surface sector (Class 3) invisible to
  interior physics at finite time. Status: PASS (oracle + OD5 theorem).
- **Cannot certify (CRITICAL claim discipline):** the LARGE-TIME / continuum
  single-species limit. Class 4 is a fixed-time statement: as `t -> inf` at fixed
  radius the cone reaches the boundary and the boundary modes CAN re-enter. A
  genuine single-species-continuum claim needs BOTH radius and time to infinity
  with the cone kept interior (a joint scaling limit), which Class 4 alone does
  not establish. Do not read "interior stable to 2.8e-17" as "route survives";
  read it as "boundary irrelevant to compact interior at finite time."
- **Kill test:** interior amplitude fails to stabilize across radii at fixed time
  (boundary leaks in early) - oracle says it does stabilize, so PASS here.

## Null-support kill tests (the Null-Edge-specific gates)

These decide whether the published Floquet single-Weyl construction is OURS
(primitive-null) or merely prior art (kill conditions of the route memo, made
operational):

- **NS-1 (winding survives null factorization).** Factor every substep into
  primitive null shifts + on-site turns; recompute `W3`. KILL if every
  primitive-null factorization gives `W3 = 0`. This is the load-bearing gate:
  Higashikawa-Nakagawa-Ueda use generic local unitaries; if their winding
  requires non-null or nonlocal substeps, it is prior art, not a Null-Edge result.
- **NS-2 (both sectors counted).** The AF4 balance must hold AFTER counting both 0
  and pi crossings. KILL if a nonzero `W3` forces a second physical low-energy
  species once pi is included.
- **NS-3 (timeframe robustness).** The single node and any boundary mode must
  survive a timeframe/gauge change. KILL if the "node" is a branch-cut artifact
  that moves to pi or vanishes under a timeframe shift (endpoint-spectrum gauge).
- **NS-4 (substep locality).** Strict finite domain of dependence at EVERY
  substep, not only the endpoint (this is what makes Class 4 meaningful). KILL if
  any intermediate substep is nonlocal - a stationary spatial substep must be
  labelled an on-site internal turn, never a null translation.
- **NS-5 (mass pairing preserves the count).** The AF6 Dirac mass pairing of
  opposite anomalous Weyl schedules must not close the anomalous gap or recreate
  light aliases (must leave one massive Dirac dispersion with the anomaly
  cancelling in the physical multiplet).

## One experimentally interpretable signature

**Floquet chiral magnetic effect (bulk) with the anomalous edge current as its
boundary cross-check.** In a (synthetic) magnetic field `B`, a single Floquet
Weyl node carries a current `J = (e^2 / 4 pi^2) mu_5 B` parallel to `B`, where the
chiral chemical potential `mu_5` is PUMPED by the micromotion winding rather than
supplied by a static chiral imbalance (Higashikawa-Nakagawa-Ueda). Protocol: apply
`B` to the 3D lattice walk; measure the period-averaged current along `B`.

Why it is the right signature: a nonzero pumped `J || B` certifies (one anomalous
Weyl) x (nonzero `W3`) TOGETHER, and is FORBIDDEN for a `W3 = 0` doubled spectrum
(the two cones' contributions cancel). Its boundary dual is the quantized
anomalous EDGE current (Rudner) on the open geometry = the Class-3 holographic
image of the same `W3`. Measuring both and checking

  bulk Floquet-CME response  ==  boundary anomalous edge current  ==  W3

is the cleanest experimental certificate AND the bulk-boundary consistency check.
For a cold-atom / photonic-lattice Floquet realization this is the concrete,
interpretable prediction; for the Lean program it is the target that AF2 (charge)
+ AF3/AF4 (winding) must reproduce as finite witnesses.

## Claim discipline (what each observable licenses)

- Class 1 (endpoint): license only "N low-energy Weyl points per sector," never
  "single physical species."
- Class 2 (winding): the only observable that licenses "anomalous / one net
  crossing without a second cone."
- Class 3 (boundary): license "anomaly-inflow surface state of count = W3," never
  a bulk statement on its own.
- Class 4 (interior): license "boundary irrelevant to compact interior at FINITE
  time," never the continuum single-species limit.
No single class licenses "Null-Edge 3+1 single species"; that requires Class 2 !=
0 realized under NS-1..NS-5 with the AF6 mass pairing - i.e., the full AF ladder,
not any one observable.
