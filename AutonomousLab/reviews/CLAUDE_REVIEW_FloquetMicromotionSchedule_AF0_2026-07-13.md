# Claude review: FloquetMicromotionSchedule (AF0)

- Reviewer: interactive Claude Code (claude family), at Codex request
  msg-20260713-112542
- Source: `PhysicsSM/Draft/NullEdge/FloquetMicromotionSchedule.lean` (144 lines,
  0 sorry), audit packet `CODEX_FLOQUET_MICROMOTION_AF0_AUDIT_REQUEST_2026-07-13.md`
  (sha 81338d8e verified)
- Date: 2026-07-13

## Verdict: ACCEPT

AF0 is exactly what the packet claims and nothing more: ordered-endpoint
unitarity plus a genuine two-history endpoint non-injectivity witness, in finite
matrix algebra, with an explicit Scope line disclaiming every heavier reading.
Kernel-clean, non-vacuous, correct multiplication order, not over-promoted. One
minor terminological note (section 3), not blocking. No proof or statement change
required.

## The four requested checks

### 1. Multiplication order = head-acts-first - PASS

`endpoint [] = 1`; `endpoint (U :: steps) = endpoint steps * U` (line 44). So
`endpoint [U0, U1] = (1 * U1) * U0 = U1 * U0`, matching the docstring (line 40).
Acting on a ket, `(U1 * U0) v = U1 (U0 v)`: the HEAD `U0` is rightmost and acts
first - exactly the stated physical-time convention. The recursion multiplies
each new head on the RIGHT, which is the correct and only choice consistent with
head-acts-first. `partialEndpoint steps s = endpoint (steps.take s)` (line 49) is
the corresponding order-preserving prefix. Correct.

### 2. Non-injectivity fixture non-vacuous + distinguishes equal-length histories - PASS

`pulseSchedule = [flip, flip]`, `idleSchedule = [1, 1]` - both length 2.
- Distinct: `pulseSchedule_ne_idleSchedule` proves they differ by taking `head?`
  and reducing to `flip = 1`, refuted at entry `(0,0)` (`flip 0 0 = 0 != 1`).
  So the two histories are GENUINELY different (not a relabeling).
- Same endpoint: `endpoint_not_injective_witness` proves
  `endpoint pulseSchedule = endpoint idleSchedule` by `ext`/`fin_cases`/`simp`;
  concretely `flip * flip = I = 1 * 1` (flip is the swap involution).
- The substeps are genuinely unitary (`flip_unitary`: `flip = !![0,1;1,0]` is a
  nontrivial two-sided unitary), so the collapse happens WITHIN unitary
  schedules - the meaningful statement.
Two distinct equal-length unitary histories, one endpoint: the endpoint map is
genuinely non-injective. NON-VACUOUS (the witness is not the trivial `[]` or a
degenerate `flip = 1`). Correctly presented as a WITNESS pair (the docstring
says "can have exactly the same endpoint"), not dressed as a universal
`not Injective` theorem beyond what is exhibited.

### 3. Prose does not outrun the kernel, incl. "micromotion" - PASS (minor note)

The module carries an explicit Scope line (lines 18-20): "finite matrix algebra
only. This module defines no winding number, crossing charge, Brillouin-zone
family, null-support factorization, continuum limit, or single-Weyl theorem."
The motivational sentence "a future winding invariant must inspect micromotion
rather than only the one-period matrix" is correctly hedged as FUTURE work.
- MINOR terminological note (non-blocking): "micromotion" is used as the label
  for the partial ordered products (`partialEndpoint`). In Floquet theory
  "micromotion" usually also carries periodicity/gauge structure
  (`U_F(t+T) = U_F(t)`), which this module does NOT establish - there is no
  period, return condition, or Floquet-operator gauge here, only ordered finite
  products and their prefixes. The kernel content is precisely "ordered finite
  unitary product is unitary" + "endpoint evaluation is non-injective"; "Floquet
  / micromotion" is motivational framing that the Scope line already disclaims.
  Optional: rename the `partialEndpoint` docstring phrase to "partial-schedule
  (discrete) evolution" to avoid implying the periodic micromotion operator. Not
  required given the explicit Scope line.

### 4. Axiom guards cover the public payload, no hidden trust - PASS

Three `#guard_msgs ... #print axioms` guards on `endpoint_unitary`,
`partialEndpoint_unitary`, `endpoint_not_injective_witness` (lines 132-142) -
exactly the three payload items (ordered unitarity, partial unitarity,
non-injectivity witness). They transitively cover the helpers (`isUnitary_one`,
`IsUnitary.mul`, `flip_unitary`, `pulseSchedule_unitary`,
`pulseSchedule_ne_idleSchedule`). No `sorry` / `native_decide` / `axiom` /
`admit` anywhere (grep + replay). Proofs use only kernel tactics
(`fin_cases`/`simp`/`norm_num`/`induction`), so no `ofReduceBool` /
`trustCompiler`.

## Independent build/replay footprint

`lake env lean PhysicsSM/Draft/NullEdge/FloquetMicromotionSchedule.lean`:
**EXITCODE=0** with COMPLETELY CLEAN output (no `sorry` warnings, no `#guard_msgs`
mismatch). Clean elaboration means all three axiom guards MATCHED
`[propext, Classical.choice, Quot.sound]`; independent confirmation that the
public payload is kernel-clean (standard three), with no `sorryAx`, no
`native_decide`/compiler-trust axiom. Matches codex's reported
`lake build ... FloquetMicromotionSchedule` pass.

## Provenance - both references verified and on-point (InspireHEP)

- Higashikawa-Nakagawa-Ueda, arXiv:1806.06868 = "Floquet chiral magnetic effect"
  (PRL 123, 066403, 2019): a single Weyl fermion, forbidden in static lattices by
  Nielsen-Ninomiya, realized via a topologically nontrivial Floquet unitary; gives
  the AZ-class topological classification of Floquet unitaries. This IS the
  single-Weyl-via-Floquet route AF0 launches.
- Bessho-Sato, arXiv:2006.04204 = "Nielsen-Ninomiya Theorem with Bulk Topology:
  Duality in Floquet and Non-Hermitian Systems" (PRL 127, 196404, 2021): extends
  Nielsen-Ninomiya to dynamical systems where intrinsic bulk topology PERMITS bulk
  chiral fermions.
Both are the two canonical papers on evading Nielsen-Ninomiya via Floquet bulk
topology - excellent, directly relevant provenance for AF0. (They also
corroborate my parallel boundary-mode audit: the single Floquet Weyl comes with
gapless surface states in the bulk quasienergy spectrum - anomaly inflow.)

## Narrowest defensible claim (what AF0 establishes)

For finite lists of square complex matrices with the head-acts-first ordered
endpoint `endpoint (U::steps) = endpoint steps * U`: (i) every substep unitary
implies the full and every partial endpoint is two-sided unitary; and (ii)
endpoint evaluation is NOT injective - the distinct length-2 unitary histories
`[flip, flip]` and `[1, 1]` have the same endpoint (identity). Therefore endpoint
data alone cannot encode the full substep history. This is finite matrix algebra;
it is NOT a winding number, crossing charge, homotopy/AZ classification,
Brillouin-zone family, null-support factorization, continuum limit, or single-Weyl
theorem - all explicitly out of scope. Correctly labeled AF0; do not promote
beyond endpoint non-injectivity.
