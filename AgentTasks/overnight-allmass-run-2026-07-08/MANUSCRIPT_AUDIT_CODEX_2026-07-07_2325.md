# Codex audit: all-mass manuscript v1

Local time: 2026-07-07 23:25 PDT

Scope: G1/G2/G4 audit of `Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md`
against `MANUSCRIPT_SPEC.md`. I did not edit the manuscript.

Verdict: not ready for MORNING_REPORT delivery yet. The section-11 declarations
all exist in their stated files, and the kill list is substantially complete,
but G2 fails on table completeness/status, and G1 has two claim-shape repairs
that should be made before co-signature.

## Findings

### P0: M-grade cited theorem missing from the anchor table and guard claim

The manuscript cites `onshell_wedge_normSq_eq_coin_sq` as an M-grade theorem in
section 5:

- `Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md:222`
- Declaration exists at
  `PhysicsSM/Draft/NullEdge/GateI1/MassCoinBridge.lean:120`

However, section 11 says "Every declaration cited above" is in the table and
that M-grade entries are axiom-audited / guard-pinned:

- M definition: `Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md:17`
- Table claim: `Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md:472`

The theorem is not in the section-11 table, and I found no guard pin for it in
the Carrier/GateYM guard files. Under `MANUSCRIPT_SPEC.md:48-54`, a
claimed-pinned but unpinned citation is a P0 until repaired.

Suggested repair: add a row for
`PhysicsSM.Draft.NullEdge.GateI1.MassCoinBridge.onshell_wedge_normSq_eq_coin_sq`
with exact file, grade, guard status, and axiom footprint; add a guard pin in an
appropriate guard file, or downgrade the manuscript label from M to a
non-guarded draft/kernel-checked label and say why.

### P1: section 11 table lacks required guard/axiom columns

`MANUSCRIPT_SPEC.md:45-46` requires the anchor table to include exact declaration
name, file, guard-pin status, and axiom footprint. The current table at
`Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md:480-509` has only
section, declaration, file, and role. It also says "file and grade" at line 472
but does not include a grade column.

The table declaration/file sweep itself passed: 28 rows, and all 28 names were
found in their stated files. This is a status/auditability failure, not an
existence failure.

Suggested repair: add row-level columns `Grade`, `Guard pin`, and `Axiom
footprint`; do not rely on the paragraph above the table for this.

### P1: trusted section-3 status is ambiguous because the table cites draft files

Section 3 is titled the trusted kinematic layer, and the table role for
`fin_bundle_plucker_mass_identity` says "trusted". But the section-11 table
cites:

- `Draft/NullEdgeCoreAristotle.lean`
- `Draft/NullEdgePluckerGeneralAristotle.lean`

Those declarations also exist in the non-draft trusted namespace at:

- `PhysicsSM/Spinor/PluckerMass.lean:76`
- `PhysicsSM/Spinor/PluckerMass.lean:218`
- `PhysicsSM/Spinor/PluckerMass.lean:374`

Suggested repair: cite the trusted `PhysicsSM/Spinor/PluckerMass.lean` anchors
for the trusted §3 layer, or explicitly say the table is citing draft duplicate
copies and give their guard/axiom status.

### P1: closure-current wording outruns the kernel statement

Section 6 says the nonabelian closure block factors exactly as:

```text
Q_C = L^# L
```

and the table role for `closure_current_square` is "`Q_C = L^#L`
(skew-pairing)". The Lean theorem at
`PhysicsSM/Draft/NullEdge/GateYM/S1ClosureCurrentAlgebra.lean:190-201` proves an
abstract skew-pairing square:

```text
s (c1 * A + c2 * B) * (c1 * A + c2 * B)
  = 2 * (b * (s A * B))
```

The source docstring itself says the two-transport `Q_C = L^#L` instantiation is
queued, not landed
(`PhysicsSM/Draft/NullEdge/GateYM/S1ClosureCurrentAlgebra.lean:185-189`).

The manuscript does include a MEMO caveat at lines 286-289, but the headline
formula and table role still read as if the concrete `Q_C` identification is
kernel-checked.

Suggested repair: rephrase the M claim as "the abstract closure current square
has the skew-pairing form", and keep concrete two-transport carrier
identification `Q_C = L^#L` as MEMO/oracle/queued. Update the table role
accordingly.

### P1: four-slot budget language is ahead of the landed theorem

`MANUSCRIPT_SPEC.md:18-21` asks for the four-slot fraction theorem
`f_A + f_C + f_T + f_E = 1` if landed, or else a C-grade target. The manuscript
instead presents the landed theorem:

```text
b_A + b_C + b_T = 1
```

This matches `signed_budget_sum_one`
(`PhysicsSM/Draft/NullEdge/Carrier/CarrierMassBudget.lean:57-62`) and is a real
M-grade three-share budget. But the surrounding text says "four channels" and
the table role for `carrier_square_assembly` says "Weitzenbock 4-slot split",
while the theorem statement is the `D^2` three-block identity
(`PhysicsSM/Draft/NullEdge/Carrier/CarrierSquareAssembly.lean:45-68`). The
source docstring says the E term is a separate E-slot brick, not part of this
identity.

Suggested repair: call the landed M theorem a three-share `D^2` budget, then add
a separate C-grade registered target for the four-slot `D^#D` / E-slot budget,
unless a four-slot theorem has actually landed.

## Gate results

G1: fails until the closure-current and four-slot wording are repaired or
downgraded.

G2: fails until the missing `onshell_wedge_normSq_eq_coin_sq` row and row-level
guard/axiom columns are added. The table's 28 current rows do all resolve to
existing declarations in the stated files.

G4: passes on content. Section 10 explicitly reports the expected kills:
Koide, `Tr E`, defect-Gram-as-`Q_C`, positive-gluon-energy conflation, cyclic
zero-mode forcing, retardedness-only no-doubling / one-sided GW, and premature
spectral-measure language.

G3/G5: not audited here; ledger already says they remain pending.

## Commands run

- `aristotle list --limit 8`
- Exact row extraction and declaration/file sweep over
  `Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md`
- `rg -n "\bonshell_wedge_normSq_eq_coin_sq\b" ...`
- Backtick-candidate sweep for sections 3-9; only Lean-like missing table
  candidate was `onshell_wedge_normSq_eq_coin_sq`
- Guard scan for all 28 section-11 rows against
  `CarrierAxiomGuard.lean` and `SlabAxiomGuard.lean`
- Source inspections of `S1ClosureCurrentAlgebra.lean`,
  `CarrierMassBudget.lean`, `CarrierSquareAssembly.lean`, and
  `MassCoinBridge.lean`
