# C166 — Gate C1_NU Strategy Synthesis (go/no-go map)

Date: 2026-06-28
Inputs: ROUND_CONTEXT.md; integrated C148/C155/C157/C158/C159; sibling designs C162–C165; in-flight C154/C156/C160/C161.
Status of this job: strategy only. No new Lean claims are asserted here. The repo Lean (`RequestProject/Main.lean`) is still a bare Mathlib scaffold; everything below treats the C-job results as ledger facts, not as compiled theorems.

---

## 0. Executive verdict

**Conditional GO on the import route, with one hard caveat.**

The reference-kernel import doctrine (C159) is the right spine, and C155/C162 have made the *front half* of the chain credible: point-split/flavored mass is a real, sign-straddling `W_branch`, not an arbitrary inserted matrix. The shortest credible path to `GateC1_NU` is now the **abstract block-reference import** assembled through the C159 `NullEdgeReferenceOverlapImport` interface, with point-split `W_branch` as the seed and the mass-window/homotopy/anomaly/control certificates supplied as explicit hypotheses first, then discharged.

The hard caveat: **the load-bearing risk is not the seed, it is the middle of the chain** — specifically the *uniformly gapped homotopy* and the *sector-signature match*, both of which can silently fail because point-split product mass tends to produce **Weyl multiplets, not a single physical sector** (C163's own stated worry). Until C160/C161/C154 land, any claim past "we have a sign-straddling seed and a typed assembly interface" is **false confidence**.

So: GO to build the end-to-end *skeleton* now (it costs little and exposes the real hypotheses), but **do not** advance the headline claim past `GateC1_NU is reduced to {gap, signature, anomaly, control} certificates` until those certificates are actual theorems, not placeholders.

---

## 1. Shortest credible path to GateC1_NU

The minimal chain that can actually close, in dependency order:

```
point-split W_branch (C155/C162)          [solid]
  -> sign-straddling + mass-window seed (C160)            [in flight]
  -> sector-signature vector, single physical sector after flavor/projector fix (C154/C163)   [in flight, RISK]
  -> uniformly gapped homotopy H_t : H_ref -> H_ne, signature-preserving (C164/C161)   [RISK, bottleneck]
  -> H_ref = abstract block reference (cheapest), hypotheses explicit
  -> anomaly + index import certificate (currently placeholder)   [RISK]
  -> ghost / bad-gap / non-ultralocal control certificate (C156)   [in flight]
  -> SMActsInternally generator check (C157/C165)   [parallel, not on critical path for NU skeleton]
  -> GateC1_NU   (note: strictly weaker than GateC1_local, per C159)
```

Shortest *credible* (not shortest *fast*) means: assemble the C159 interface with every middle certificate as a **named hypothesis**, prove the *reduction theorem* (`certificates -> GateC1_NU`) first, then discharge certificates one at a time. This converts an open-ended physics problem into a finite list of Lean obligations and makes partial progress measurable.

The skeleton-first ordering is deliberate: it forces the *exact* hypothesis statements out into the open before we spend effort proving the hard analytic pieces, killing any circular or vacuous formulation early.

---

## 2. The bottleneck

**Primary bottleneck: the uniformly gapped, signature-preserving homotopy (C164/C161).**

Reasons it is the true chokepoint:
- Sign-straddling (C155/C162) only gives *existence of both signs*; it does **not** give a uniform spectral gap of `H_ne`, and it does not give a gap *along a path* to any reference kernel. Resemblance is not a gap (C164's own constraint).
- The homotopy must simultaneously (a) stay invertible/gapped for all `t`, and (b) preserve the sector signature. These two are in tension: the natural straight-line homotopy in mass parameters is exactly where eigenvalues cross zero (sector flips). A uniform lower bound `inf_t gap(H_t) > 0` is the single hardest object in the whole program.
- It is the join point of two separately hard things (C161 inverse-gap for bad sectors, C160 mass window). If either is loose, the homotopy gap is unprovable.

**Ranked blockers (most to least dangerous):**

1. **Gapped homotopy / uniform gap along `H_t`** (C164/C161). The one that can quietly be false.
2. **Sector-signature match — the multiplet problem** (C154/C163). Point-split product mass plausibly yields a pair/multiplet, not one Weyl sector. If so, an extra projector/flavor factor is mandatory, and a wrong chirality parity here invalidates the reference match. This can also *cause* (1) to fail.
3. **Anomaly / index import** (placeholder today). Load-bearing per C159; currently has no actual content. A clean reference match (Adams / naive-flavored overlap, arXiv 1110.2482 / 1011.0761) is the only credible way to import it; building it natively is out of scope short-term.
4. **Non-ultralocal control / locality** (C156). Neumann/range-k locality is plausible but unproven; without it no locality/control claim is allowed.
5. **Mass window** (C160). Believed tractable; main risk is that the window producing one negative sector is empty for the naive product mass (forces Adams-style shift).
6. **Overlap linearization** (C161). Tractable given the gap; depends on (1).
7. **SM internality** (C157/C165). Off the NU critical path; needed for *native gauge safety* claims, not for the `GateC1_NU` skeleton. Real risk is convention (octonion basis/sign), not feasibility.
8. **Point-split `W_branch` construction** (C155/C162). **Least risky** — effectively solid.

Note the dependency: blocker (2) is upstream of (1). Resolve the multiplet/signature question *before* attempting the gap, or the homotopy work will be wasted.

---

## 3. Recommended 10-step plan (ordered, with wait-gates)

Each step names the artifact and its blocking dependency. "WAIT" = do not start until the named in-flight job lands.

1. **Lock the C159 import interface as Lean types** — `NullEdgeReferenceOverlapImport` as a structure with explicit certificate fields (gap, signature, anomaly/index, control, internality). No proofs; just the typed obligation list. *No wait.* Enables everything else and forces honest hypotheses.
2. **Promote C162 point-split `W_branch`** to `PhysicsSM/Draft/NullEdgePointSplitWBranch.lean`: `BranchCorner`, branch parity/level, one-edge Pauli sign, point-split `W_branch`, branch projectors, shifted mass signs, plus the sign-straddling theorem and the "constant scalar mass cannot straddle" theorem. *No wait* (Mathlib-only, finite).
3. **Reduction theorem (skeleton)**: prove `(gap ∧ signature ∧ anomaly ∧ control [∧ internality]) -> GateC1_NU` against the interface from step 1, all antecedents as hypotheses. *No wait.* This is the highest-value early win: it makes the whole problem a finite checklist and is provable now.
4. **Sector-signature table for point-split** (C163) as Lean data + the multiplet diagnosis. **WAIT on C154** (reference audit) to fix the reference match and avoid duplicating its sector taxonomy. Output must explicitly answer: single Weyl sector or multiplet? If multiplet, define the extra projector/flavor factor.
5. **Mass-window specialization** to point-split product mass. **WAIT on C160** (generic mass-window package); then specialize, do not re-derive. Decide naive product vs Adams-style shift here.
6. **Choose `H_ref` = abstract block reference** and write the homotopy `H_t` (C164) with the gap criterion as an explicit inequality. **WAIT on C161** (overlap linearization / bad-sector inverse-gap) for the gap lemmas. This is the bottleneck; do not start the gap proof before C161.
7. **Uniform-gap proof along `H_t`** using C161 + C160 outputs: `inf_t gap(H_t) > 0` and signature preservation. Bottleneck step; budget the most effort here. Depends on 5 and 6.
8. **Locality/control certificate** from C156 Neumann/range-k locality. **WAIT on C156.** Slot into the interface field from step 1.
9. **Anomaly/index import certificate** via the reference kernel chosen in step 6 (cite 1110.2482 / 1011.0761 / Adams only with a convention bridge). Replace the placeholder field. Depends on 4 and 6.
10. **SMActsInternally generator checklist** (C165): `SMActsInternally`, `BranchFactorDisjoint`, `WeakChiralityNotBranch`, `InternalGeneratorFamily`, and `checklist -> JNotGauged`. Parallelizable from the start; merge last because it gates the *gauge-safety* claim, not `GateC1_NU` itself.

**Wait-gates summary:**
- WAIT on **C154**: step 4 (signature table / reference match).
- WAIT on **C160**: step 5 (mass window).
- WAIT on **C161**: steps 6–7 (homotopy gap, the bottleneck).
- WAIT on **C156**: step 8 (control/locality).
- **No wait** (do now): steps 1, 2, 3, and start 10 in parallel.

Start 1/2/3 immediately and in parallel with 10. Everything else is gated as above.

---

## 4. Genuine no-go / pivot criteria

These are the conditions under which we stop, pivot, or downgrade the headline claim. Be ruthless about these.

- **NO-GO (hard) — no uniform gap.** If C161 + the homotopy analysis show `inf_t gap(H_t) = 0` for every admissible `H_ref` and homotopy (eigenvalue crossing forced by the sector flip), the import route fails. Pivot: treat the finite seed as a *certified branch-projector* result only (C148), and explicitly downgrade — `GateC1_NU` is not closed.
- **NO-GO (hard) — irreparable signature mismatch.** If point-split product mass yields a multiplet whose chirality parity cannot be projected to a single physical Weyl sector without breaking gauge representation (C163 failure mode "wrong chirality parity" / "gauge representation mismatch"), and Adams-style shift does not fix it, there is no clean reference and no-go.
- **PIVOT — anomaly import has no reference.** If no naive/flavored-overlap or domain-wall reference can supply the index/anomaly certificate under our conventions, pivot from "import" to "native index theory", which is a multi-round program, not a job — and the NU claim is deferred, not closed.
- **PIVOT — gauge mixes branch J.** If C165 finds any generator with a nonzero branch-mixing block (C157's stated failure mode), native gauge safety is dead; pivot to a non-native (embedded/spectator) gauge treatment and drop all native-gauge-safety claims.
- **PIVOT — locality fails.** If C156 shows the Neumann series is not range-k summable (non-ultralocal in a fatal way), control/locality certificates are unavailable; `GateC1_NU` may still close but *all* locality claims are forbidden and the physical interpretation weakens.
- **Soft pivot — empty mass window.** If C160 specialization gives an empty window for naive product mass, switch to Adams-style flavored mass (expected, not fatal).

A no-go in the gap (first bullet) is the only one that kills the program outright. The others reshape the claim or extend the timeline.

---

## 5. Native overlap vs abstract block-reference vs domain-wall — ordering

**Recommendation: abstract block-reference import FIRST, domain-wall SECOND, native overlap LAST.**

- **Abstract block reference first.** Lowest convention risk, fastest to a compiling end-to-end skeleton, and it makes the certificate hypotheses explicit (steps 1/3 above). It is the only route that lets us prove the *reduction* theorem now. Its danger — vacuity/circularity — is controllable precisely because the hypotheses are named and must later be discharged by a concrete reference. Use it as scaffolding, not as the final release.
- **Domain-wall second.** Most physically credible source of the index/anomaly and gap content, with a well-understood boundary-mode dictionary. Best candidate to *discharge* the abstract hypotheses with real content once the skeleton compiles. Convention bridge still required but lighter than native octonion overlap.
- **Native overlap last.** Highest cost: requires building `sign(H_ne)` spectral theory, the GW algebra (C158 has only the finite seed), and the index natively. Only attempt after the skeleton + a discharging reference exist, or if both block-reference and domain-wall fail to supply the anomaly certificate.

Do **not** lead with native overlap; it front-loads the hardest analysis with the least architectural payoff. Lead with the abstract block reference to expose obligations, then make them true with domain-wall.

---

## 6. Claim-boundary checklist (what we may and may not say now)

**Allowed now (supported by integrated C148/C155/C157/C158/C159):**
- Point-split/flavored/species mass is a concrete, principled `W_branch`; it sign-straddles, and a constant scalar mass cannot (C155).
- The finite branch×qutrit seed yields exact GW algebra from two involutions, in repo-draft Lean (C158).
- Sub-gap-stable branch-projector certificate exists given a true inverse-propagator gap and nonzero J-graded selection invariant (C148).
- `NullEdgeReferenceOverlapImport` is the central typed assembly interface; the finite seed is **not** the physical release (C159).
- Native gauge safety **reduces to** `SMActsInternally` (C157) — as a reduction, not as an established fact.
- The path to `GateC1_NU` is reduced to a finite list of certificates (once the step-3 reduction theorem compiles).

**Forbidden now (no certificate yet):**
- ❌ The finite seed alone closes C1 (explicitly barred by ROUND_CONTEXT and C159).
- ❌ `T_br = sign(H_ne)` without the mass-window/gap hypotheses.
- ❌ `GateC1_NU` is closed — middle certificates (gap, signature, anomaly, control) are in flight/placeholder.
- ❌ `GateC1_local` is closed — `GateC1_NU` is strictly weaker (C159); never conflate them.
- ❌ SM gauge safety / `JNotGauged` without `SMActsInternally` or a generator-level check (C157/C165).
- ❌ Any locality / control / anomaly / determinant-line health claim without the explicit certificate (C156 / index import).
- ❌ Removing bad sectors via propagator zeros.
- ❌ A uniformly gapped homotopy inferred from resemblance to a reference kernel (C164).
- ❌ A single-Weyl-sector claim for point-split product mass until the multiplet question (C163/C154) is settled.

**Integration note for Codex/Aristotle:** wire the step-1 interface and step-3 reduction theorem as the first compiled artifacts; keep every middle certificate a named `s o r r y`-ed obligation so that `#print a x i o ms GateC1_NU` reads off the exact open assumptions at any time. That makes the go/no-go state machine-checkable rather than narrative.
