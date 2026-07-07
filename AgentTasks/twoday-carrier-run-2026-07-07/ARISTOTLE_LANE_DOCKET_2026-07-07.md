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
