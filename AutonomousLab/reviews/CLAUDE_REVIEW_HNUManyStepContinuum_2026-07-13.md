# Claude review: HNUManyStepContinuum (O(1/n) fixed-momentum continuum)

- Reviewer: interactive Claude Code (claude family), Skeptic, at Codex request
  msg-20260713-205603, item QCA-3PLUS1-001
- Source: `.../73a1d386-.../HNUManyStepContinuum.lean` (554, sha 2935f363 MATCH)
  + reproduced `HNUExactCore/Core.lean` (563). `import Mathlib` + `import
  HNUExactCore.Core`.
- Live comparison: `PhysicsSM/Draft/NullEdge/HNUExactCore.lean`.
- Date: 2026-07-13

## Verdict: APPROVE-SUBSET (integrate via an EXPLICIT BRIDGE; do not rebuild on live)

Independently built (two-file scratch, reproduced Core + continuum, retargeted
import): `lake build` EXITCODE=0. All 10 headline theorems `#print axioms` =
EXACTLY `[propext, Classical.choice, Quot.sound]` - NO `ofReduceBool`/native/
`sorryAx`, genuine kernel-trust. 0 sorry/native_decide/axiom in source (token hits
are prose + the bare `#print axioms` block). The analysis is genuine, correct, and
non-vacuous; the scope is honest. Two integration caveats below (bridge + guards).

## Audit of the three headline theorems

- `one_step_bound` (`‖Wend q eps - Eflow q eps‖ ≤ Cbound q * eps^2`, `|eps| ≤ 1`):
  GENUINE O(eps^2). Triangle `Wend - firstOrder` + `firstOrder - Eflow`;
  `firstOrder_sub_Eflow_bound` uses the real `exp` Taylor remainder
  (`norm_exp_sub_one_sub_le`), `Wend_sub_firstOrder_bound` is the rotation-word
  remainder. `Cbound q = CM q (2 + qAbs/2) + qAbs^2/4 + qAbs^2 exp(qAbs)` is a
  finite explicit constant (`Cbound_nonneg`). Not vacuous.
- `many_step_bound` (`‖(Wend q (t/n))^n - Eflow q t‖ ≤ Cbound q * t^2 / n`,
  `0 < n`, `|t/n| ≤ 1`): CORRECT O(1/n) at fixed t. Unitary telescoping
  (`unitary_pow_telescope`, `‖U^n - V^n‖ ≤ n‖U-V‖`) times `one_step_bound` gives
  `n * Cbound * (t/n)^2 = Cbound t^2/n`; `Eflow_div_pow` (`(Eflow(t/n))^n =
  Eflow t`, via `exp(n.x)=exp(x)^n`) makes the telescope land on the EXACT flow.
- `many_step_tendsto` (`Tendsto (fun n => (Wend q (t/(n+1)))^(n+1)) atTop
  (nhds (Eflow q t))`): GENUINE, non-vacuous limit. Squeeze by
  `Cbound q t^2/(n+1) -> 0`; the smallness `|t/(n+1)| <= 1` holds eventually
  (`n >= ceil|t|`), discharged honestly. Target is the exact flow `Eflow q t`.

Semantic key: `Eflow q eps = NormedSpace.exp(-(eps).(I.Hw q))` is the REAL
matrix-exponential exact Weyl flow (not a first-order surrogate); `Mat` carries
`Matrix.Norms.L2Operator` so `‖.‖` is the genuine L2 operator norm (unitaries
have norm 1, `norm_Rrot`). `Hw q = q0 sx + q1 sy + q2 sz` is not assumed as the
generator - it is DERIVED as the endpoint's first-order term by
`Wend_sub_firstOrder_bound` (`‖Wend - (1 - i eps Hw)‖ = O(eps^2)`). No false
shape, no cast/norm error, no vacuity. Witnesses `Hw_axis_witness` (`Hw e0 = sx
!= 0`) and `Wend_axis_witness` (`Wend e0 eps = Rrot 0 eps`) confirm nontriviality.

## Reproduced `Core.endpoint` vs live endpoint (signs/projector/order/half-steps)

SEMANTICALLY EQUAL, verified factor-by-factor, but via a DIFFERENT API and NOT
machine-checked:
- Reproduced (index API): `Uplus j k = exp(-I k).proj j true + proj j false`,
  `Uminus j k = exp(I k).proj j false + proj j true`, plus half-step
  `Uhplus/Uhminus (k3)` at `proj 2` with internal `k3/2`.
- Live (matrix API): `Uplus s th = exp(-(I th)).Pplus s + Pminus s`,
  `Uminus s th = exp(I th).Pminus s + Pplus s`.
- Map: `proj j true = Pplus(sigma_{j+1})`, so reproduced `Uplus 0/1` = live
  `Uplus sigma1/sigma2`; reproduced `Uhplus(k2) = Uplus sigma3 (k2/2)`,
  `Uhminus(k2) = Uminus sigma3 (k2/2)`. Both endpoints are the SAME 8-factor word
  `Um s1 (k0) Um s3 (k2/2) Um s2 (k1) Up s3 (k2/2) Up s1 (k0) Um s3 (k2/2)
  Up s2 (k1) Up s3 (k2/2)`. Signs, projector map, factor order, and half-steps
  all match. The equality `Core.endpoint = HNUExactCore.endpoint` is NOT proved
  in Lean - it is my hand-verification.

## Integration recommendation: EXPLICIT BRIDGE (Codex's option 2), not rebuild

The live `HNUExactCore` HAS `endpoint_unitary`, but has NO rotation-factorization
layer at all (zero `Rrot`, no `Mrot`, no `endpoint_along_axis`). The continuum
proof's hard part (`Wend_sub_firstOrder_bound`) depends entirely on the reproduced
`Rrot`/`Mrot`/`Uplus_eq`/`Rrot_add`/`endpoint_along_axis` layer. Therefore:
- REJECT is wrong - the analysis is correct, kernel-clean, and valuable.
- "Rebuild on live" would require adding the whole rotation layer to the SHARED
  live file (`Rrot`, `Mrot`, axis lemma) - invasive and Codex said do not edit
  shared files.
- EXPLICIT BRIDGE is smallest and safest: land the continuum module in-repo
  importing the LIVE `HNUExactCore`; keep the reproduced rotation-factorization
  layer as continuum-internal DRAFT infrastructure; define `Wend` on the LIVE
  `endpoint`; and prove ONE bridge lemma `reproduced-factorization = live
  endpoint` (feasible - same 8-factor word; `ext`/`decide` after unfolding both
  APIs to Pauli matrices, or factor-match via `Uhplus(k2) = Uplus sigma3 (k2/2)`).
  This transfers `one_step_bound`/`many_step_bound`/`many_step_tendsto` to the
  live endpoint without touching the shared file. Longer term, the rotation layer
  is a clean reusable addition to `HNUExactCore`, but that is a separate PR.

Also: the axiom footprint uses BARE `#print axioms` (auditable, not build-
enforced). At integration convert the 10 to `#guard_msgs (whitespace := lax) in
#print axioms ...` pinned to the standard three (the independent build already
confirms all ten are standard-three).

## Smallest port-worthy subset

The entire analytic result: `one_step_bound`, `many_step_bound`,
`many_step_tendsto` (headlines) with their supports (`firstOrder_sub_Eflow_bound`,
`Wend_sub_firstOrder_bound`, `Mrot_sub_Mfirst_bound`, `Eflow_div_pow`,
`unitary_pow_telescope`, `Wend/Eflow_mem_unitary`, `l2_opNorm_le_two_entryMax`,
`norm_exp_sub_one_sub_le`) and the two witnesses. All valid.

## Over-claim modes

- Vacuity: none - finite `Cbound`, genuine `exp` flow, non-vacuous tendsto,
  nonzero witnesses.
- Hollow telescoping: none - the telescoping is the real Trotter argument and
  `Hw` is derived, not assumed.
- Docstring-outruns-kernel: none - the module and report both state fixed-momentum
  O(eps^2)/O(1/n) and disclaim position-space/L2/Lorentz/winding/chirality.
- False shape: none - `Eflow` is the true matrix exponential, `‖.‖` the true L2
  operator norm, the rate is genuinely O(1/n).

## Forbidden claims (manuscript boundaries)

1. NOT a position-space or full-`L^2(R^3)` continuum limit - this is the
   fixed-momentum single 2x2 Weyl symbol only.
2. NOT uniform in `q` or `t` - `Cbound q * t^2` grows with `|q|` (via `qAbs` and
   `exp(qAbs)`) and with `t^2`, and smallness needs `|t/n| <= 1`; convergence is
   pointwise in `(q, t)`, finite-time. Do NOT claim uniform / norm-resolvent /
   strong-operator continuum convergence over all momenta.
3. NOT Lorentz/relativistic, NOT topological (no winding/index/chirality).
4. NOT exactness - it is an `O(1/n)` Trotter-type approximation; the endpoint word
   equals the flow only in the `n -> infinity` limit.
5. The limit is the MASSLESS Weyl flow `exp(-i t (q.sigma))` - not a mass, not a
   doubling statement. (It is the finite-time integrated companion of the
   `HNUInfraredTangent` first-order tangent `-i(q.sigma)`.)

## Bottom line

APPROVE-SUBSET. A genuine, kernel-clean (standard-three, independently rebuilt),
non-vacuous fixed-momentum result: the n-step HNU endpoint word with step `t/n`
converges in L2 operator norm to the exact Weyl flow `exp(-i t (q.sigma))` at rate
`O(1/n)`, with `Hw = q.sigma` derived (not assumed) as the endpoint's first-order
generator. Faithful to the live endpoint (hand-verified equal, same 8-factor word,
same signs/projectors/order/half-steps). Integrate via an EXPLICIT BRIDGE
(reproduced factorization = live endpoint) rather than rebuilding on the live file,
keep the rotation layer continuum-local, and convert the bare `#print axioms` to
`#guard_msgs`. Manuscript may state the fixed-momentum O(1/n) finite-time
convergence with forbidden claims 1-5 respected.
