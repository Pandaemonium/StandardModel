# Phenomenologist deliverable - Higgs observable/benchmark card (2026-07-17, claude)

Activation: role-20260717-024533-91c6fdbe. Contract: Higgs phenomenology
interpretation, observable hierarchy, and falsification gates for the
null-edge GR program. Modules audited: `HiggsHilbertStress`,
`MassiveRetardedLinkSeries`, `HiggsMassiveRetardedPropagation`,
`HiggsMeasuredMassRetardedSeries`, `HiggsCurvatureMassIdentifiability`, and
the two integrated jobs `higgs-fms-radial-observable`,
`higgs-edge-euler-operator`. Every finite statement below is kernel-checked;
every physical reading is labeled and every input is tagged
IMPORTED / SUPPLIED / DERIVED / HELD-OUT.

## The four-rung observability ladder (contract's central distinction)

The program must not collapse these four objects; each is audited separately.

| Rung | Object | Gauge status | Observable? |
|---|---|---|---|
| 1 | vertex multiplet `H(x)` | gauge-VARIANT | NO - a coordinate on internal space |
| 2 | gauge-invariant radial composite (FMS) `|H|` / `H-dagger H` | gauge-INVARIANT | YES in principle - the physical Higgs |
| 3 | finite response kernel `G_m(H) = sum_k (-massSq)^k K^{k+1}` | invariant (built from rung 2) | finite-lattice propagator; not itself a number |
| 4 | continuum pole `m_h` | invariant | NOT YET DERIVED - requires a continuum limit the program does not take |

The program's honest claim lives at rungs 2-3: the physical Higgs is the
gauge-invariant radial composite, and its massive propagation is a finite
retarded sum over causal chains, NOT a single primitive null edge (the
three-event witness in `HiggsMassiveRetardedPropagation` is nonvacuous - the
direct endpoint hop vanishes while the two-hop mass-deformed term does not).
Rung 4 (a pole mass confronting the measured 125 GeV) is explicitly out of
reach; any card entry at rung 4 is a BASELINE for comparison, not a program
output.

## Observable/benchmark card

### O1 - radial Higgs mass from potential curvature

- Statement (DERIVED, kernel): `massSq = 8 * lam * vacuum^2`
  (`HiggsMassiveRetardedPropagation`, one-component radial curvature).
- Units: `[massSq] = energy^2`; `lam` dimensionless, `vacuum` = energy.
- Inputs: `lam` SUPPLIED, `vacuum` SUPPLIED. The FUNCTIONAL FORM (mass^2 is
  the potential curvature at the vacuum) is DERIVED; the two numbers are not.
- Nearest SM/FMS baseline: SM tree relation `m_h^2 = 2 lam_SM v^2` with
  `v = 246 GeV`, `m_h = 125 GeV` -> `lam_SM ~ 0.13`. The factor `8` vs `2` is
  a POTENTIAL-NORMALIZATION convention (the module's `V` vs the SM's); it must
  be reconciled before any numeric `lam` is quoted. FLAG: do not compare the
  module's `lam` to `0.13` until the convention map is written.
- Sensitivity: `m_h proportional to sqrt(lam) * vacuum`; linear in `vacuum`,
  square-root in `lam`.
- Falsifier: if the finite retarded series' would-be pole (continuum limit,
  rung 4) did not scale as `sqrt(8 lam vacuum^2)`, the radial-curvature =
  mass identification fails. Currently untestable (no continuum limit).

### O2 - the physical Higgs is a composite, not an edge (FMS match)

- Statement (DERIVED, kernel): the radial mass response is a finite sum over
  causal chains; a single primitive edge carries zero direct radial mass hop
  (`HiggsMassiveRetardedPropagation` three-event witness;
  `MassiveRetardedLinkSeries` resolvent identities + nilpotent termination).
- Inputs: primitive retarded kernel `K` SUPPLIED; nilpotence DERIVED from
  strict causal precedence.
- Nearest baseline: Froehlich-Morchio-Strocchi (1981) - the physical Higgs
  is a gauge-invariant composite, not the perturbative doublet. STRUCTURAL
  ASSET: the null-edge picture (physical Higgs = gauge-invariant radial
  composite propagating over chains) MATCHES the FMS gauge-invariant
  description, which is the correct modern reading. This is the strongest
  positive phenomenology alignment in the sector.
- Sensitivity/falsifier: if a single-edge (rung-1) assignment reproduced the
  radial mass, the composite picture would be unnecessary; the witness rules
  this out at finite size.

### O3 - Higgs sources gravity (stress response)

- Statement (DERIVED, kernel): `T_ab = 2 Re((D_a H)-dagger D_b H) - g_ab L`,
  with `delta S = +(1/2) int T_ab delta gInv^{ab}` (`HiggsHilbertStress`).
- Units: `T_ab` energy-density; convention factor `2` is the complex-field
  normalization (pinned).
- Inputs: the Higgs Lagrangian form SUPPLIED; the stress-tensor algebra
  DERIVED. Sources gravity only AFTER a frame/metric is reconstructed or
  supplied (the GR-side debt; see the shell-angular 1+3 lane).
- Nearest baseline: the standard scalar stress tensor. Sign/factor must match
  GR conventions - reconciled in-module.
- Falsifier: a sign or factor-two error would flip the gravitational
  response; the module pins both, so the falsifier is a convention audit
  (passed).

### O4 - mass vs curvature-coupling identifiability boundary

- Statement (DERIVED, kernel): for `(Box - bareMassSq - xi R) h = source`, on
  CONSTANT curvature an affine shift of `bareMassSq` is exactly compensated by
  a shift of `xi`, leaving every finite retarded insertion invariant
  (`HiggsCurvatureMassIdentifiability`).
- Physical reading: on a constant-curvature background the measurable local
  insertion is the INSEPARABLE combination `bareMassSq + xi R`. The bare Higgs
  mass and the non-minimal curvature coupling `xi` are a genuine PARAMETER
  DEBT - not independently observable there.
- Observable consequence (a real, if far-future, prediction shape): the
  degeneracy is BROKEN only on VARYING curvature. So the program predicts,
  structurally, that separating the Higgs bare mass from `xi` REQUIRES a
  curvature gradient - a concrete qualitative falsifiable statement about what
  is and is not measurable.
- Falsifier: exhibiting a constant-curvature observable that separates
  `bareMassSq` from `xi` would contradict the theorem (it cannot, by the
  kernel proof - so this hardens the boundary).

## Parameter-debt summary for the Higgs sector

DERIVED mechanisms: mass = potential curvature (O1 form); physical Higgs =
gauge-invariant composite over chains (O2/FMS); stress response (O3);
mass/xi degeneracy on constant curvature (O4). SUPPLIED: `lam`, `vacuum`,
the potential form, the primitive kernel `K`. IMPORTED: none numeric.
HELD-OUT: none (all finite algebra; no seeded run in this sector).
PREDICTED numbers confronting experiment: NONE - the sector predicts
MECHANISM and MEASURABILITY STRUCTURE, not `m_h`.

## Falsification gates (sector-level)

1. Convention-map gate: no `lam` or `m_h` numeric may be quoted until the
   `8 lam v^2` vs SM `2 lam v^2` potential-normalization map is written and
   reviewed. (Open; blocks all rung-4 comparison.)
2. Composite gate: any claim that the physical Higgs is a single null edge is
   falsified by the O2 three-event witness - keep the FMS composite reading.
3. Frame gate: the stress tensor sources gravity only relative to a
   reconstructed/supplied frame; O3 may not be quoted as "Higgs curves
   spacetime" until the shell-angular lane (or a supplied tetrad) closes.
4. Identifiability gate: the "Higgs mass" on constant curvature is
   `bareMassSq + xi R`; never report a bare mass from constant-curvature data.

## Standing phenomenologist rule (renewed)

No manuscript or brief may call a SUPPLIED or IMPORTED quantity "derived from
the null-edge model." The broader program-wide parameter-debt ledger (mass=area,
CP=oriented volume, color=Aut(O) as DERIVED mechanisms; spatial dimension 3,
the Benincasa-Dowker operator coefficients, and the octonionic internal
algebra as SUPPLIED/IMPORTED structures) is carried into the derivation-map
synthesis this session.
