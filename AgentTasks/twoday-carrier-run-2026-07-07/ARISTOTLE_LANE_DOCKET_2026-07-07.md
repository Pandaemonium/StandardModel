# Aristotle lane docket - 2026-07-07

This docket maps the null-edge Aristotle submissions to their intended
proof/strategy/audit roles.  The jobs use lightweight per-lane project
directories under `AgentTasks/aristotle-submit/ne-*-20260707/`, each copied from
the common context pack `null-edge-lane-pack-20260707/`.  The pack contains
Q06-Q10/Q12, recent landed Lean files, the thread board, and the solo goal
prompt.

Submission note: these packs intentionally avoid uploading the full repository.
Aristotle warns that they have `.lean` files but no `.lake` folder.  That is
acceptable for strategy/audit jobs.  If a proof job stalls on environment setup,
resubmit that target as a focused Mathlib Lake package.

## New running jobs

| Project ID | Descriptive name | Lane | Type | Intended deliverable |
|---|---|---|---|---|
| `dbe113e5-3cd3-47b6-a63b-8887693ab6ad` | `ne-q10-l3-lorentzian-transitivity-20260707` | Q10-L3 Lorentzian positive-pairing transitivity | proof | standalone Lean theorem if feasible; otherwise exact proof plan |
| `3a66e413-069a-4ad9-8f6b-b9452c94700b` | `ne-q10-l5-split-tachyon-witness-20260707` | Q10-L5 split-signature tachyonic mass witness | proof | standalone Lean file for determinant/wedge witness |
| `7fd8a9bf-39ce-4bb2-a11a-65ea2bdf3ccd` | `ne-q10-l6-scalar-amplitude-census-20260707` | Q10-L6 scalar mass-amplitude census | strategy/audit | representation-theory formalization ladder and kill tests |
| `65a9d42d-a67d-4933-a6ff-cbdc5658422a` | `ne-q11-jr-real-structure-ko-unimodularity-audit-20260707` | Q11 `J_R` real-structure / KO / unimodularity audit | audit/strategy | Lean ladder for sign tables, RC0, B-L, C3, and order conditions |
| `0a6239d5-15b0-4fe6-b560-6a002d61354f` | `ne-q12-g2-parity-chirality-solder-audit-20260707` | Q12 G2-parity chirality-solder audit | audit | exact finite theorem statements and convention risks |
| `bbcf12c6-a96e-46a0-bc45-b58128a13bd5` | `ne-q12-psa-equivariant-ms-audit-20260707` | Q12 PSA/equivariant McKean-Singer gates | audit/strategy | per-sector anomaly-gate Lean targets |
| `4929366f-8f0b-4992-a4d1-0fd196461ede` | `ne-q08-fock-exterior-quotient-strategy-20260707` | Q08 Fock exterior quotient | strategy | route to `rad(Lambda h)=ideal(N)` and quotient theorem |
| `7067efa0-9755-482a-8d74-9c0b9a8318c7` | `ne-q08-dgamma-square-identity-20260707` | Q08 `dGamma` square identity | proof/strategy | Lean file if feasible; otherwise basis theorem decomposition |
| `2ed38421-a2fe-4c80-b34a-6fd1b9ec8f22` | `ne-q09-entropy-horizon-audit-20260707` | Q09 entropy/horizon upgrade audit | audit | claim-grade table and finite hypotheses/kill conditions |
| `5f3b8963-862c-41ab-911e-23f32e4980b5` | `ne-q06-carrier-gw-generalization-audit-20260707` | Q06 carrier-GW generalization | audit/counterexample | theorem assumptions or finite nonabelian search design |

## Canceled duplicate-name submissions

The first attempt submitted the same prompts from the shared pack directory, so
all nine showed up as `null-edge-lane-pack-20260707` in `aristotle list`.
Those latest tasks were canceled and replaced by the uniquely named projects
above.

Canceled project IDs: `73783ae1`, `084a94aa`, `1e580bf5`, `cb831dfd`,
`787b1794`, `bf3ae076`, `2de1cbe8`, `77c347fe`, `5fe806c2`.

## Existing running jobs counted toward the 12-job load

| Project ID | Lane |
|---|---|
| `43a7f979-ed2b-45a7-853e-af43ea55b6a2` | EQUIPARTITION-GATE / Koide |
| `0dc48ac7-f184-4cb2-b713-17532d333462` | perp-signature / GB positivity support |
| `6b8dcebd-7efc-4485-b02e-b6fe6f0176de` | KP fixed-forest injection |

Queue check immediately after the named resubmission: the nine named projects
plus these three existing projects were `RUNNING`, giving approximately twelve
active StandardModel-relevant Aristotle lanes.  Q11 then arrived and was added
as a tenth named lane (`65a9d42d`), bringing the active StandardModel lane count
to approximately thirteen while it runs.

## Harvest status, Codex solo pass

The first named wave has now been mostly harvested into the live repo:

- `dbe113e5` Q10-L3: landed `LorentzianTransitivity.lean`.
- `3a66e413` Q10-L5: landed `SplitSignatureMass.lean`.
- `7fd8a9bf` Q10-L6: landed `MassAmplitudeCensus.lean`.
- `65a9d42d` Q11 L1/L2-core: landed `Q11RealStructure.lean`.
- `0a6239d5` Q12 G2 parity: landed `G2Parity.lean`.
- `bbcf12c6` Q12 PSA-1: landed `PSA.lean`.
- `7067efa0` Q08 dGamma square: landed `DGammaSquare.lean`.
- `2ed38421` Q09 modular no-go: landed `ModularNoGo.lean`.
- `4929366f` Q08 exterior quotient: strategy harvested; next proof jobs opened.
- `5f3b8963` Q06 carrier-GW: strategy/counterexample harvested; local
  no-compiler-trust counterexample subsequently landed, so follow-up `7a12dbbd`
  was canceled.

## Follow-up wave submitted after harvest

These jobs were submitted from lightweight updated lane packs.  Aristotle warned
that the packs are not full Lake projects; that is acceptable for strategy/audit
jobs.  If a proof-heavy job stalls on environment setup, resubmit it as a
focused Mathlib Lake package.

| Project ID | Descriptive name | Lane | Type | Intended deliverable |
|---|---|---|---|---|
| `5bdce729-5240-4c0d-b0b0-e5dc3f224334` | `ne-q08-fock-quotient-pairingdual-proof-20260707` | Q08 exterior quotient | proof/strategy | perfect-pairing bridge for `rad(Lambda h)=ideal(N)` and quotient theorem route |
| `97417bb8-8d9b-443a-8588-b895d0ce005c` | `ne-q08-dgamma-exterior-globalization-proof-20260707` | Q08 dGamma globalization | proof/strategy | lift decomposable tuple identity toward exterior-algebra statement |
| `825853b9-3bbe-4ec5-8c4a-46557fcbcabc` | `ne-q10-multitime-embedding-uniqueness-audit-20260707` | Q10 multi-time embedding | audit | next theorem after Lorentzian transitivity plus split witnesses |
| `f962cbe7-cb15-4db6-8a90-1982e75e6f8f` | `ne-q11-rc0-det-cocycle-strategy-20260707` | Q11 group-level RC0 | strategy | exterior functor determinant cocycle theorem ladder |
| `e2df3555-4bc9-4a1b-95e7-ec1c4ccfcd9f` | `ne-q11-bl-dictionary-finite-check-20260707` | Q11 B-L dictionary | finite check | decidable SM-entry check for the B-L/total-number claim |
| `c2e23b53-347c-4c38-9791-cf51e9816fa8` | `ne-q12-equivariant-ms-charge-resolution-proof-20260707` | Q12 equivariant MS | proof/strategy | finite sector-additivity bridge after PSA-1 |
| `85a73a6d-0e10-4955-8c76-27b9914db6c9` | `ne-q12-triality-convention-bridge-audit-20260707` | Q12 triality bridge | audit | T5-T8 intertwiners, G2 equivariance, and basis bridge kill tests |
| `7a12dbbd-3dbe-4b7e-a65b-64e48fc063b8` | `ne-q06-palindrome-gw-no-native-proof-20260707` | Q06 carrier-GW | canceled | redundant after local no-compiler-trust `nonabelian_oneSided_counterexample` landing |

Queue check after submission: all eight follow-up projects were `RUNNING`.
After the local Q06 counterexample landing, `7a12dbbd` was canceled; the other
seven follow-up projects remain active unless later status checks say otherwise.

Local parallel progress while `c2e23b53` is in flight: Codex landed the finite
sector-additivity bookkeeping theorem `sum_sectorContribution_eq_total` in
`PSA.lean`.  This should be treated as the additive accounting rung only; the
broader Aristotle job is still needed for any equivariant McKean-Singer
charge-sector index theorem or anomaly-gate promotion.
