# Gate C1 — CKM index-import strategy and certificate stack

Companion to `RequestProject/GateC1.lean` (the compiling, proof-placeholder-free formal
interface). This document is the strategy/architecture layer.

**Bottom line up front.** A CKM-style one-flavor naive flavored-overlap reference
is a *reasonable* first import target, but only after one correction: the *naive*
flavored-overlap seed carries the `8 + 8` product-parity doubling and is a no-go on
its own in `d = 4`. The reference you actually import from must already be the
**doubler-resolved overlap/GW reference** (Neuberger overlap / properly tuned
domain-wall), with CKM data riding on top as the flavored mass texture. If the
program literally means "naive product flavored-overlap" as the *reference*, that
is the wrong first target and should be replaced — see §6.

---

## 1. Ranked theorem/certificate stack after `CKM_MassTable` and `ShiftedCKM_Window`

Ranked by *blocking power* (highest = closes the most no-go risk earliest; a later
item is pointless if an earlier one fails). Names match the Lean interface.

| Rank | Certificate / theorem | Why it is here | Lean handle |
|---|---|---|---|
| 1 | **SectorSignatureMatch** (7-slot) | If the sectors do not match slot-for-slot, every downstream import is type-incorrect. Cheap, decidable, do it first. | `SignatureMatch`, `nullEdge_matches_ckm` |
| 2 | **Doubler/no-go discharge** (`8+8` broken) | The naive seed is the product-parity no-go. Must show the reference is *already* overlap/GW-resolved, not a naive product. | `naive_doublers_four` |
| 3 | **UniformGapHomotopy** (gauge-safe) | The whole import is "transport along `H_t`". Without a *uniform* gap and gauge safety, nothing transfers. | stack field `gapHomotopy` |
| 4 | **InverseGapCertificate** for bad sectors | Bad sectors need a *true* inverse-propagator gap; this gates spectral-flow continuity. | `InverseGapCertificate`, `no_zero_mode` |
| 5 | **OverlapGW_Transferred** (GW algebra) | The GW/overlap relation is what makes the index well-defined; it transfers under the gap. | `HomotopyTransferred.overlapGW` |
| 6 | **ProjectorRank_Transferred** | Rank of the chiral projector is the homotopy invariant carrying chirality count. | `HomotopyTransferred.projectorRank` |
| 7 | **Index_Transferred** (spectral flow) | The index equals net spectral flow; constant under gapped homotopy. | `HomotopyTransferred.index` |
| 8 | **KreinSign_Transferred** | Krein/ghost sign must be carried, not silently flipped, across `H_t`. | `HomotopyTransferred.kreinSign` |
| 9 | **Anomaly_Matched** | Does **not** transfer automatically; anomaly/index weight must independently match SM content. | `IndependentCertificates.anomalyMatched` |
| 10 | **SMGauge_Cert** | Gauge representation content must be re-certified at the null-edge end. | `IndependentCertificates.smGauge` |
| 11 | **NonUltralocal_Control** | If locality is dropped, the path-sum/resolvent decay must be controlled. | `IndependentCertificates.nonUltralocal` |
| 12 | **Locality_or_Resolvent** | Either genuine locality of the overlap kernel, or its controlled non-ultralocal replacement. | `IndependentCertificates.localityOrResolvent` |
| 13 | **Release rule → `GateC1_NU`** | The deep theorem assembling all of the above. Explicit hypothesis, never an a x i o m. | `IndexImport_OverlapHomotopy` |

Guardrail encoded: items 1–12 are all required arguments of `C1ImportStack`; the
seed (`CKM_MassTable`) is a single field, so it can never be fed to `release` by
itself — "finite seed is not the release."

---

## 2. `IndexImport_OverlapHomotopy` — what transfers and what does not

Statement (see Lean): given a `release` rule `C1ImportStack → GateC1_NU` and a
populated `C1ImportStack`, conclude `GateC1_NU`. The content is in the split of the
stack into two bundles.

**Transfers automatically along a gauge-safe, uniformly gapped homotopy
`H_t : H_ref ↝ H_ne`** (`HomotopyTransferred`):

- Overlap / Ginsparg–Wilson algebraic relation (stays exact up to the gap).
- Spectral projector **rank** (integer; locally constant under a gap).
- **Index** = net spectral flow (homotopy invariant given no zero-crossing).
- **Krein sign** (indefinite-metric signature; cannot jump without a crossing).

These are exactly the *integer/topological* and *algebraic* data that a uniform gap
protects. The gap is the hypothesis that forbids the spectral crossing that would
let any of them jump.

**Does NOT transfer automatically** (`IndependentCertificates`) — each needs its
own proof at the null-edge endpoint:

- **Anomaly / index-weight matching** to SM content. The index can be invariant
  while the *physical anomaly weight* fails to match the target gauge content; this
  is a separate arithmetic obligation.
- **SM gauge-representation certificate.** The homotopy can preserve an abstract
  rank while changing the representation labels; gauge content must be re-checked.
- **Non-ultralocal control.** A gapped homotopy says nothing about kernel decay.
- **Locality (or its resolvent replacement).** Overlap locality is conditional on
  the gap *and* on admissibility bounds the homotopy does not supply.

This split is the precise answer: **topological/algebraic/spectral-sign data ride
the homotopy; representation-theoretic, anomaly-arithmetic, and analytic-locality
data do not.**

---

## 3. Bad-sector inverse-gap certificate vs propagator-zero removal

Formalized in `InverseGapCertificate` and `PropagatorZeroRemoval`.

- A **true inverse gap** is a *uniform positive lower bound* `Δ > 0` on the
  inverse-propagator (Dirac/overlap) spectrum `infSpec t` for **all** `t ∈ [0,1]`.
  Consequence: `no_zero_mode` — no zero mode anywhere on the homotopy, so spectral
  flow and index are protected.
- **Propagator-zero removal** only asserts the *propagator* has a zero somewhere
  (`infSpec t = 0` at some `t`) — the cheap "mirror removal" trick.

`PropagatorZeroRemoval.not_inverse_gap` proves these are genuinely incompatible: a
point with `infSpec = 0` makes any positive uniform lower bound impossible.
**Therefore Gate C1 must demand an `InverseGapCertificate`, and explicitly reject
any bad-sector argument that only exhibits a propagator zero.** This is the
load-bearing distinction the guardrail asks for.

Practically: the certificate to produce is a *uniform inverse-propagator norm bound
along the homotopy parameter*, not a statement about where the dressed propagator
vanishes.

---

## 4. Sector-signature match checklist (null-edge vs CKM reference)

Seven slots, all decidable (`SectorSignature`, matched by `SignatureMatch`). A
**single** slot mismatch is fatal (see the one-slot counterexample in Lean).

1. **Rank** — generation/window rank agrees (`rank`).
2. **Chirality** — chiral eigenvalue `±1` agrees (`chirality`).
3. **Branch parity** — domain-wall branch parity `±1` agrees (`branchParity`).
4. **Gauge representation** — SM rep code agrees (`gaugeRep`).
5. **Shifted mass sign** — sign of the shifted Wilson/overlap mass agrees
   (`shiftedMassSign`); this is where the *shifted* window earns its keep.
6. **Krein sign** — indefinite-metric/ghost sign agrees (`kreinSign`); a flip here
   is a ghost, not a fermion.
7. **Anomaly/index weight** — carried weight agrees (`anomalyIndexWeight`).

Check order in practice: 1 → 2 → 3 → 4 (kinematic/representation), then 5 → 6 → 7
(sign/weight). Cheap slots first; the sign/weight slots are where a plausible-looking
match usually breaks.

---

## 5. Highest-value next Aristotle jobs after C173–C177

**Lean formalization jobs (do these in-repo):**

- **J-A (formalize):** Replace the abstract `Prop` placeholders in `C1ImportStack`
  with concrete operator-level statements for the *transferred* bundle — start with
  `Index_Transferred` as constancy of an integer under a gapped path
  (`ProjectorRank_Transferred` is the easiest: rank is locally constant). Highest
  value because it converts §2's claims from interface to theorem.
- **J-B (formalize):** Prove the `release` rule for a *toy* one-sector model where
  all certificates are concrete, eliminating the `release` hypothesis in that model.
  This is the first end-to-end `GateC1_NU` with no hypothesis-shaped holes.
- **J-C (formalize):** Strengthen the inverse-gap layer: prove that
  `InverseGapCertificate` + a continuous spectral path ⇒ constant index
  (Lean-level spectral-flow invariance for the toy operator). Directly retires the
  bad-sector no-go risk.
- **J-D (formalize):** Promote the `8+8` counter to a real obstruction lemma: in
  the toy model, a local + chiral + hermitian product operator forces
  `naiveDoublers 4 = 16` species (a Nielsen–Ninomiya stub), certifying that the
  reference must be overlap/GW.

**Strategy / literature-audit jobs (do these as audits, not Lean):**

- **J-E (audit):** Confirm the intended CKM reference is the doubler-resolved
  overlap/domain-wall reference, not a naive product (decides §6). Highest-priority
  audit — it can invalidate the whole import target.
- **J-F (audit):** Locality vs non-ultralocal decision: decide whether to require
  genuine overlap locality or commit to the resolvent/path-sum control route, and
  fix the decay norm to be certified.
- **J-G (audit):** Anomaly/index-weight matching against the actual SM hypercharge
  content for the null-edge sector — the non-transferred item most likely to fail
  quietly.

Recommended order: **J-E** (audit, gating) → **J-A, J-C** (formalize, parallel) →
**J-D** → **J-B** → **J-F, J-G** alongside.

---

## 6. No-go risks and whether CKM is the right first target — blunt

- **`8 + 8` product-parity no-go (highest risk).** Naive product flavored-overlap
  in `d = 4` is dead on arrival (`naive_doublers_four`). If "CKM reference" means
  the naive product seed, **it is the wrong first target.** Replacement: import from
  the **Neuberger overlap / tuned domain-wall reference** carrying the same CKM mass
  texture — i.e. keep the CKM *flavor data*, drop the *naive product discretization*.
  CKM-as-flavor-texture is fine; CKM-as-naive-operator is not.
- **Propagator-zero mirror removal (high risk).** Tempting and cheap; formally
  excluded by `PropagatorZeroRemoval.not_inverse_gap`. Do not accept any bad-sector
  closure that does not produce a `InverseGapCertificate`.
- **Silent Krein-sign flip (high risk).** A gapped homotopy preserves the Krein
  sign only if it is in the matched signature (slot 6). An unmatched flip imports a
  ghost, not a fermion. Keep it explicit.
- **Anomaly/gauge "free-ride" fallacy (medium-high).** The index transferring does
  **not** transfer anomaly-weight or gauge-rep matching (§2). Treating them as
  automatic is the most likely way to ship a wrong `GateC1_NU`.
- **Locality assumed, not certified (medium).** Overlap locality is conditional. If
  you drop it, you owe the non-ultralocal resolvent bound; do not leave it implicit.

**Verdict.** CKM is the right *flavor* reference and a workable *first* import
target **iff** the operator side is the doubler-resolved overlap/GW reference. If
the program insists on the literal naive product as reference, replace it with the
Neuberger-overlap / domain-wall reference before any further C1 work.
