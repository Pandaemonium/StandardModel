# M14: P1 crosswalk patches A–F — final application audit

Type: manuscript/audit (report-only). **Do not auto-apply.** This file is a
ready-to-apply audit for Codex/Claude/user approval.

Scope guard: this audit only corrects *provenance/status labels* for the absent
`PhysicsSM.Spinor.TwistorPluckerMass` module and one wrong Lean identifier. It
does **not** rewrite the manuscript, and it **preserves the safe P1 thesis**: P1
is the finite kinematic Plücker / null-spread mass obstruction (origin-of-mass
accounting), not a claim to all mass mechanisms or to continuum dynamics. The
trusted finite-linear-algebra core (Sections 1–6 and the `PhysicsSM.Spinor.PluckerMass`
results) is untouched.

---

## 0. Verdict (headline)

**Patches A–F have NOT been applied. All six are still needed, essentially as
written in M12/M13.** No evidence that Claude (or any integrating agent) edited
the manuscript or publication plan since M12/M13: every overclaim location M12
catalogued is still present verbatim in the current files.

Two additional facts found during this audit, not stated in M12/M13:

1. **The "ready" patch file has no payload.** `AgentTasks/null-edge-p1-crosswalk-patches-a-f-ready.md`
   does *not* contain patch hunks A–F. Its content is the M13 run summary
   (`ARISTOTLE_SUMMARY.md`) preserved verbatim, which *describes* the hunks but
   does not include them. So the exact replacement text below is reconstructed
   directly from the live manuscript, not copied from a bundled hunk file.
2. **No `PhysicsSM` Lean modules are present in this snapshot at all.** The only
   Lean file in the tree is `RequestProject/Main.lean`. Therefore neither the
   *absence* of `TwistorPluckerMass` nor the *presence* of the covariance
   banners (`PluckerObstruction.lean`, `PluckerMassCovariance.lean`) can be
   kernel-verified from inside this project. This sharpens the direction of the
   safe edits (see §4): the mandatory edits all *remove unverifiable
   trusted/re-verified claims* (safe direction); any *upgrade to trusted* must
   wait for the live tree and stays optional/deferred.

---

## 1. Current state of every overclaim location (re-checked against live text)

File: `Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md`

| ID | Location | Current text (overclaim) | Status |
|----|----------|--------------------------|--------|
| O1 | line 9, 11 — header anchors | `Lean anchors (trusted unless noted):` … lists `PhysicsSM.Spinor.TwistorPluckerMass` with no "noted" caveat | **still present** |
| O2 | lines 18–20 — provenance paragraph | "the two **trusted** anchor modules `…PluckerMass` and `…TwistorPluckerMass` were **re-verified to kernel-check** with no errors" | **still present** (worst overclaim) |
| O3 | lines 589–590 — §8 attribution | "From the **trusted module** `PhysicsSM.Spinor.TwistorPluckerMass`:" | **still present** |
| O4 | line 681 — §11 established list | "twistor-chart matching with explicit normalization conventions;" under **"What is established (kernel-checked finite linear algebra)"** | **still present** |
| O5 | line 711 — §12 table row | `two_twistor_mass_invariant_eq_plucker … trusted` | **still present** |
| O6 | line 712 — §12 table row | `multi_twistor_momentum_det_eq_pairwiseMass … trusted` | **still present** |
| U1 | line 564 — §7 Lean block | wrong identifier `spinorAction A (psi i)` (correct Mathlib/PhysicsSM name is `actSpinor`) | **still present** (correctness bug) |

File: `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`

| ID | Location | Current text (overclaim) | Status |
|----|----------|--------------------------|--------|
| O7 | lines 270–272 — "Banked Lean" paragraph | "**Trusted** twistor-chart matching in `PhysicsSM.Spinor.TwistorPluckerMass` (**promoted, no proof holes**)." | **still present** |

The working plan (`Null_Edge_Unified_Mass_Model_Working_Plan.md`) contains no
release-blocking twistor overclaim (its twistor mentions are generic
"status-labelled wrapper" references); **no edit required there.**

---

## 2. Mandatory release-blocking edits (Patches A–F)

These are mandatory because each is a *false provenance claim* about an absent
module, or a *wrong Lean identifier*. They do not delete mathematical content:
the twistor statements, normalization notes, and out-of-scope lists are kept;
only the trust label is corrected from `trusted`/`re-verified`/`established` to
`pending` (with an "absent in current tree" note).

### Patch A — header anchors + provenance paragraph (fixes O1, O2)
File: `Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md`, lines 9–21.

```diff
-Lean anchors (trusted unless noted):
-`PhysicsSM.Spinor.PluckerMass`,
-`PhysicsSM.Spinor.TwistorPluckerMass`,
+Lean anchors (trusted unless noted):
+`PhysicsSM.Spinor.PluckerMass`,
+`PhysicsSM.Spinor.TwistorPluckerMass` (pending; module absent in the current
+tree — statements below are reproduced from prior notes, not kernel-verified
+here),
 `PhysicsSM.Draft.NullEdgeSpinorGeometryTargets` (kernel-clean draft),
 `PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore` (kernel-clean draft),
 and the standalone celestial-moment artifact
 `AgentTasks/aristotle-standalone/null-edge-spinor-network-closure-20260621/`.

 Provenance check (2026-06-25). Every Lean declaration named in Part II was
-confirmed to exist in the cited module, and the two trusted anchor modules
-`PhysicsSM.Spinor.PluckerMass` and `PhysicsSM.Spinor.TwistorPluckerMass` were
-re-verified to kernel-check with no errors under `leanprover/lean4:v4.28.0` via
-`lake env lean`. The literature anchors below were cross-checked against
+confirmed to exist in the cited module. The trusted anchor module
+`PhysicsSM.Spinor.PluckerMass` was re-verified to kernel-check with no errors
+under `leanprover/lean4:v4.28.0` via `lake env lean`. The twistor wrapper
+`PhysicsSM.Spinor.TwistorPluckerMass` is pending: it is absent from the current
+tree and has not been re-verified here, so its statements below are reproduced
+from prior notes and are not yet a trusted surface. The literature anchors
+below were cross-checked against
 INSPIRE-HEP records (arXiv id, journal reference, and DOI where available).
```

### Patch B — §7 Lean identifier fix `spinorAction` → `actSpinor` (fixes U1)
File: `Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md`, line 564.

```diff
-    (finBundleMomentum (fun i => spinorAction A (psi i))).det
+    (finBundleMomentum (fun i => actSpinor A (psi i))).det
```

Note: this is a correctness fix (the quoted theorem block must name the actual
declaration). It is independent of the twistor downgrade and should land even if
A/C/D/E/F are deferred.

### Patch C — §8 attribution (fixes O3)
File: `Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md`, lines 589–590.

```diff
-the mass -- the same identity reads as a two-twistor / multi-twistor mass. From
-the trusted module `PhysicsSM.Spinor.TwistorPluckerMass`:
+the mass -- the same identity reads as a two-twistor / multi-twistor mass. From
+the pending module `PhysicsSM.Spinor.TwistorPluckerMass` (absent from the
+current tree; statements reproduced from prior notes, not kernel-verified here):
```

### Patch D — §11 established-claims list (fixes O4)
File: `Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md`, line 681.

The twistor line must leave the "established (kernel-checked)" block. Minimal
edit: annotate it as pending in place.

```diff
-- twistor-chart matching with explicit normalization conventions;
+- twistor-chart matching with explicit normalization conventions (pending:
+  module `PhysicsSM.Spinor.TwistorPluckerMass` absent from the current tree,
+  not kernel-verified here);
```

### Patch E — §12 theorem-to-Lean map rows + footnote (fixes O5, O6)
File: `Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md`, lines 711–714.

```diff
-two-twistor mass = wedge                 two_twistor_mass_invariant_eq_plucker             trusted
-multi-twistor mass = pairwise            multi_twistor_momentum_det_eq_pairwiseMass        trusted
+two-twistor mass = wedge                 two_twistor_mass_invariant_eq_plucker             pending+
+multi-twistor mass = pairwise            multi_twistor_momentum_det_eq_pairwiseMass        pending+
 Dirac slash squares to mass              chiralDiracSlash_bundleMomentum_sq_eq_pluckerMass draft**

 *  kernel-clean, standalone Aristotle package; promote or cite as appendix.
 ** kernel-clean draft in PhysicsSM.Draft.*; needs convention review to promote.
++  module PhysicsSM.Spinor.TwistorPluckerMass is absent from the current tree;
+   statements reproduced from prior notes, not kernel-re-verified here.
```

### Patch F — publication plan "Banked Lean" paragraph (fixes O7)
File: `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`, lines 270–272.

```diff
 Banked Lean. `PhysicsSM.Spinor.PluckerMass` (trusted): finite determinant
-identity, real nonnegativity, mass-zero/common-direction criterion. Trusted
-twistor-chart matching in `PhysicsSM.Spinor.TwistorPluckerMass` (promoted, no
-proof holes). `SL(2,C)` covariance of the determinant mass in
+identity, real nonnegativity, mass-zero/common-direction criterion. Pending
+twistor-chart matching in `PhysicsSM.Spinor.TwistorPluckerMass` (module absent
+from the current tree; not kernel-verified here, so not yet a banked surface).
+`SL(2,C)` covariance of the determinant mass in
 `PhysicsSM.Draft.NullEdgeSpinorGeometryTargets`
```

---

## 3. Optional clarity upgrades (NOT release-blocking; defer in this snapshot)

M12/M13 proposed clarity upgrades U2–U7 that *promote* the now-bannered
SL(2,C)-covariance / masslessness-obstruction interface from "draft" to
"trusted", backed by the convention banners reported to have landed in
`PhysicsSM/Spinor/PluckerObstruction.lean` and
`PhysicsSM/Spinor/PluckerMassCovariance.lean`.

**Recommendation: do NOT apply these in this snapshot.** Those two Lean files
are not present here, so the banners cannot be confirmed and a promotion to
"trusted" would itself be an unverifiable overclaim — the same failure class
this audit exists to remove. They should be applied only against the live tree,
after a `lake env lean` rebuild + `#print axioms` of the two bannered modules.
Until then the current "draft (kernel-clean)" labels on the SL(2,C) row
(§7, §12 row `finBundleMomentum_det_sl2_invariant … draft**`) are accurate and
should stay as-is.

The only U-item that is genuinely mandatory now is the identifier fix, captured
above as **Patch B** (`spinorAction` → `actSpinor`).

---

## 4. Files affected

- `Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md` — Patches A, B, C, D, E.
- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md` — Patch F.
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` — no change required.
- `AgentTasks/null-edge-p1-crosswalk-patches-a-f-ready.md` — no manuscript change,
  but flag separately: this file is mislabeled (contains the M13 run summary,
  not the hunks). Optional housekeeping, not release-blocking.

---

## 5. Application order

1. Patch B (identifier fix — independent, lowest risk).
2. Patch A (header + provenance — the most-cited overclaim).
3. Patches C, D, E (in-body twistor demotions).
4. Patch F (publication plan).

All six are line-local and non-overlapping; order only matters for clean review.

---

## 6. Post-apply verification checklist

- [ ] `grep -ni "re-verified" Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md`
      returns only the `PluckerMass`-scoped sentence (no twistor module).
- [ ] No remaining `trusted` label sits on any `TwistorPluckerMass`,
      `two_twistor_mass_invariant_eq_plucker`, or
      `multi_twistor_momentum_det_eq_pairwiseMass` reference:
      `grep -ni "twistor" Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md`.
- [ ] `grep -n "spinorAction" Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md`
      returns nothing; `actSpinor` appears in the §7 block.
- [ ] Publication plan no longer says "promoted, no proof holes" for the twistor
      module: `grep -ni "twistor" Sources/Null_Edge_Causal_Graph_Publication_Plan.md`.
- [ ] Safe-thesis intact: Sections 1–6 and all `PhysicsSM.Spinor.PluckerMass`
      rows in §12 remain `trusted`; the out-of-scope list in §11 and the
      conventions table (§13) are unchanged.
- [ ] (Live tree only, deferred) before applying any U2–U7 promotion: rebuild
      `PluckerObstruction.lean` + `PluckerMassCovariance.lean` and confirm
      `#print axioms` is clean.

---

## 7. One-line summary for the integrator

Apply Patches A–F (six line-local edits across the two `Sources/` files) to
demote the absent `PhysicsSM.Spinor.TwistorPluckerMass` wrapper from
trusted/re-verified to pending everywhere and to fix `spinorAction` →
`actSpinor`. Hold all "promote to trusted" clarity upgrades until the live tree
with the bannered Spinor modules is rebuilt. P1 stays release-clean *after* this
downgrade, not before.
