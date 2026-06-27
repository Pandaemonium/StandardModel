# FUR-L1: Foundational Furey/Baez source pack for theorem provenance

Type: literature / audit (source pack). **No papers were ingested.** This file is a
curation aid: it maps repo theorems/modules to their foundational sources, flags
docstrings that should be strengthened, and supplies Zotero/Neo4j metadata
suggestions for three foundational references that may not yet be curated in the
project literature graph.

Scope of audit (context files actually present in this snapshot):

- `PhysicsSM/Algebra/Furey/MinimalLeftIdeal.lean`
- `PhysicsSM/Algebra/Furey/FureyRealizesOneGeneration.lean`
- `PhysicsSM/Algebra/Furey/ElectroweakCompletePackage.lean`
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` (Section 22, Gate H)
- `docs/CONVENTIONS.md` (octonion + electroweak conventions)

Note on import surface: the three Furey `.lean` files import many sibling modules
(`LadderOperators`, `ComplexOctonion`, `AnomalyBridge`, `ElectroweakAnomalyBridge`,
`OneGenerationPackage`, `T3OpJbar`, `WeakIsospinDoublets`, `WeakIsospinLadder`,
`ElectroweakPaperPackage`, etc.) that are **not present** in this snapshot. The
provenance mapping below covers the declarations that live in the three audited
files; the same source assignments should be propagated to the imported modules
when they are curated.

---

## 0. The three foundational references

The descriptors below are taken from the task prompt and the repo docstrings.
arXiv identifiers are recorded as supplied by the task; the arXiv-to-journal
correspondence is flagged for curator confirmation rather than asserted, to avoid
an unverified bibliographic claim.

| Key | arXiv | Author(s) | Short title / role |
|-----|-------|-----------|--------------------|
| `Furey2018ideal` | arXiv:1806.00612 | C. Furey | Division-algebraic ladder operators; complex-octonion (ℂ⊗𝕆) minimal left ideal construction. |
| `Furey2018gauge` | arXiv:1810.10465 | C. Furey | SU(3)_C × SU(2)_L × U(1)_Y from octonionic / division-algebraic ladder operators. |
| `BaezHuerta2010GUT` | arXiv:0904.1556 | J. C. Baez, J. Huerta | *The Algebra of Grand Unified Theories.* Representation-theoretic SM/GUT embedding; hypercharge and Gell-Mann–Nishijima accounting. Published Bull. Amer. Math. Soc. 47 (2010) 483–552. |

Curator confirmation items (do not assert until checked against the arXiv abstract page):

- **C1.** Confirm `arXiv:1806.00612` ↔ the ladder-operator / minimal-ideal paper.
  This is the identifier already used inside `MinimalLeftIdeal.lean` (lines 16, 51).
- **C2.** Confirm `arXiv:1810.10465` ↔ the "SU(3)×SU(2)×U(1) as a symmetry of
  division algebraic ladder operators" paper. The repo currently cites this work
  only by journal string ("Eur. Phys. J. C 78 (2018), 375", in
  `FureyRealizesOneGeneration.lean`) **without an arXiv number**. The journal↔arXiv
  link must be confirmed before the two citations are merged into one graph node.
- **C3.** `arXiv:0904.1556` ↔ Baez–Huerta BAMS is well established; low risk.

Other Furey work already curated in the working plan (for cross-reference, not part
of this pack): Furey 2025 "A Superalgebra Within", arXiv:2505.07923 (working plan
Section 24.5); Furey 2015 "Charge quantization from a number operator", Phys. Lett.
B 742 (2015) 195 (cited in `FureyRealizesOneGeneration.lean`).

---

## 1. Theorem / module → source → convention map

Convention anchor for every row: project **XOR binary-label octonion basis**
(`docs/CONVENTIONS.md` → Octonions, Locked). Furey/Baez formulas must be relabeled
through `PhysicsSM.Algebra.Octonion.ConventionBridge`; in particular the privileged
imaginary unit is `e111 = e_7` (Baez) in this basis. **Do not copy Baez/Furey
formulas directly.**

### 1a. `MinimalLeftIdeal.lean`

| Declaration(s) | Claim | Primary source | Convention note |
|----------------|-------|----------------|-----------------|
| `omega`, `omega_idempotent` | Primitive idempotent ω = ½(1 − i·e111) | `Furey2018ideal` (1806.00612, §2) | Coefficient/sign is normalization-dependent; ω chosen as left-handed projector; `e111 = e_7` via ConventionBridge. |
| `alpha{1,2,3}_dag_kills_omega` | ω annihilated by raising/lowering daggers | `Furey2018ideal` (ladder operators) | Ladder operators α_i live in imported `LadderOperators`; source must be propagated there. |
| `v1…v6`, `nu`, `v*_eq`, `nu_eq` | 8 basis states of J as Cl(6) action on ω | `Furey2018ideal` (§2) | Particle identification (anti-e, anti-u colours, anti-d colours, ν) "adapted from Furey"; exact quantum-number map is Furey's. |
| `*_in_J`, `alpha*_kills_nu` | J is a left ideal; ν is top of the tower | `Furey2018ideal` | Finite coordinate identities; clean-room. |
| `act_a*_*` (full Cl(6) action table) | Complete ladder action table on the 8 states | `Furey2018ideal` | Trusted finite-coordinate computation; non-associativity caveat noted in-file. |
| `N{1,2,3}_*` (number operators) | Number-operator eigenvalues | `Furey2015` (number-operator charge) + `Furey2018ideal` | Charge-from-number-operator idea originates with Furey 2015; ladder realization is 1806.00612. |
| `charge_omega … charge_nu` | Electric charge from number operator | `Furey2015` / `Furey2018ideal` | Q normalization fixed by convention; cross-check with `docs/CONVENTIONS.md` electroweak `Q = T₃ + Y/2`. |
| `basis_linear_independent` | J is ≥ 8-dimensional over ℂ | `Furey2018ideal` (dimension count) | Lean proof is clean-room (coordinate witnesses); see flag F-3 (Python-oracle provenance). |
| `T12 … T32` (SU(3) generators) | Colour SU(3) from ladder bilinears α_i α_j† | `Furey2018gauge` (1810.10465); SU(3)=stabilizer-in-G₂ background | **Flag F-1**: in-file comment says "This section remains to be formalized." Generators are *defined* but the SU(3) action / closure is **not proved**. |
| `omega_bar` and complementary-ideal block | Complementary idempotent ω̄ = ½(1 + i·e111); J̄ partner | `Furey2018ideal` (particle/antiparticle conjugate ideal) | Charge-conjugation reading is convention-level only; theorems are finite rational arithmetic. Provenance: Aristotle job (in-file). |
| `charge_sum_*`, `cubic_charge_sum_*`, `coloured_charge_sum_*`, `anomaly_*` | Anomaly arithmetic over J ∪ (−J̄) | `BaezHuerta2010GUT` (anomaly/hypercharge bookkeeping) + SM convention | Anomaly *cancellation* accounting is standard SM (Baez–Huerta organizes the representation theory). |
| `T3_*`, `Y_*`, `Y_*_val`, `*_anomaly_*`, `witten_su2_anomaly_free`, `furey_generation_anomaly_free` | T₃/Y table, GMN, SU(2)/U(1) and Witten anomaly freedom | `BaezHuerta2010GUT` + `docs/CONVENTIONS.md` (Q = T₃ + Y/2, Y(H)=1) | Electroweak convention is Locked in CONVENTIONS.md; Baez–Huerta is the representation-theory source. |

### 1b. `FureyRealizesOneGeneration.lean`

| Declaration(s) | Claim | Primary source | Convention note |
|----------------|-------|----------------|-----------------|
| `RightSingletBoundary`, `rightSingletBoundary` | Machine-readable claim boundary: right-handed singlets are conventional, not derived | (program/claim-ledger) | Mirrors working-plan §22.5 ("reconstruction unless forced"); no external paper needed — this is honest scoping. |
| `FureyRealizesOneGenerationPackage`, `fureyRealizesOneGenerationPackage` | J̄ left doublets match SM Q_L, L_L; full one-gen table after conventional completion | `Furey2018gauge` (gauge group) + `BaezHuerta2010GUT` (SM multiplets) | All-left-handed basis convention; right-handed = charge conjugate w/ negated Y. |
| `furey_gellMannNishijima_all` | Q = T₃ + Y/2 on every J̄ state | `docs/CONVENTIONS.md` (GMN, Locked) + `BaezHuerta2010GUT` | Operator-level GMN realized in imported electroweak modules. |
| `furey_doublet_su2_squared_u1_anomaly`, `furey_combined_gravitational_anomaly`, `furey_combined_cubic_anomaly`, `furey_allLeftList15_eq_standardModel` | Anomaly coefficients vanish; multiplet list = `standardModelOneGeneration` | `BaezHuerta2010GUT` + Peskin–Schroeder §20.2 (already cited) | Standard anomaly conventions; finite checks. |

### 1c. `ElectroweakCompletePackage.lean`

| Declaration(s) | Claim | Primary source | Convention note |
|----------------|-------|----------------|-----------------|
| `Q_comm_TPlus`, `Q_comm_TMinus` | [Q, W±] = ±W± from [T₃, W±]=±W±, [Y, W±]=0 | `Furey2018gauge` (gauge symmetry of ladder ops) + EW convention | Follows from GMN by linearity. |
| `FureyElectroweakCompletePackage`, `fureyElectroweakCompletePackage` | Bundle: Q_op/GMN, T₃ doublets, SU(2)_L doublets, W± ladder + su(2) | `Furey2018gauge` | **Claim boundary in-file**: SU(2)_L algebra is **not derived** from octonionic α_i; W± are explicit permutation maps. Keep this scoping. |

---

## 2. Source → claim cross-index

Use this when tagging the literature graph (which paper "supports" which repo claim).

- **Minimal left ideal / primitive idempotent ω**
  → `Furey2018ideal` (1806.00612, §2).
  Repo: `MinimalLeftIdeal.omega`, `omega_idempotent`, `*_in_J`.

- **Ladder operators (α_i, α_i†) and the Cl(6) action / number operators**
  → `Furey2018ideal` (construction) + `Furey2015` (charge-from-number-operator origin).
  Repo: `act_a*_*`, `N{1,2,3}_*`, `charge_*`; and imported `LadderOperators`.

- **Gauge group SU(3)×SU(2)×U(1) (and the U(1)_X / charge quantization story)**
  → `Furey2018gauge` (1810.10465).
  Repo: `T12…T32` (defined only), `FureyRealizesOneGenerationPackage`,
  `ElectroweakCompletePackage` Q–W± commutators.

- **SU(3)_C from G₂ (automorphism group of 𝕆) stabilizing e₇**
  → `Furey2018gauge` for the ladder-operator realization;
  **background source outside the three-paper pack**: Baez, *The Octonions*
  (arXiv:math/0105155) for "SU(3) = subgroup of G₂ = Aut(𝕆) fixing a unit
  imaginary". **Flag F-1 / F-4**: the repo only *defines* SU(3) generators; it does
  **not** prove the G₂-stabilizer characterization. If that claim is ever stated,
  it needs Baez *The Octonions* (or Furey's thesis), which is **not** among the
  three pack papers — recommend adding it.

- **Electroweak embedding / hypercharge / Gell-Mann–Nishijima / one-generation
  multiplet structure and anomaly bookkeeping**
  → `BaezHuerta2010GUT` (0904.1556) as the representation-theory source;
  `docs/CONVENTIONS.md` (Locked EW convention) for the project normalization;
  Peskin–Schroeder §20.2 (already cited) for anomaly conventions.
  Repo: `T3_*`, `Y_*`, `furey_gellMannNishijima_all`, anomaly theorems,
  `furey_allLeftList15_eq_standardModel`.

- **DVT (division algebras / Dixon ℝ⊗ℂ⊗ℍ⊗𝕆) / Jordan algebra / triality**
  → **Not realized in the three audited files.** Triality appears only as a
  *future job* (working plan §22.9 H7, "triality/generation audit") and a
  packaging caveat (§22.5 "Triality-labeled three copies … packaging theorem, not
  prediction"). **Flag F-5**: the proper sources for triality / Jordan algebra
  J₃(𝕆) / DVT are **outside** the three-paper pack (e.g. Baez *The Octonions*
  math/0105155; Dixon's division-algebra program; Günaydin–Gürsey for the Jordan
  octonion link). Recommend curating these separately before any
  triality/Jordan/DVT theorem is claimed; do **not** attribute such claims to
  1806.00612 / 1810.10465 / 0904.1556.

---

## 3. Provenance / docstring strengthening flags

- **F-1 (SU(3) section is aspirational).** `MinimalLeftIdeal.lean` defines
  `T12…T32` and then states in a comment "The actual SU(3) action is via OPERATOR
  composition, not algebra product. This section remains to be formalized."
  Action: add a one-line docstring on each `T_ij` marking it **unproven scaffolding**
  with source `Furey2018gauge` (1810.10465), so a reader does not mistake the
  definitions for a proved SU(3) action. Consider a `ClaimBoundary`-style marker
  analogous to `RightSingletBoundary`.

- **F-2 (single arXiv tag in `MinimalLeftIdeal`).** The "## Sources" block cites
  only "Furey, arXiv:1806.00612, Section 2." The charge / number-operator content
  also rests on Furey 2015 (charge quantization) and the anomaly/EW arithmetic
  rests on Baez–Huerta + the project EW convention. Action: expand the Sources
  block to list `Furey2015`, `BaezHuerta2010GUT`, and a pointer to
  `docs/CONVENTIONS.md` (Octonions + Electroweak, both Locked).

- **F-3 (oracle/job provenance, not paper provenance).**
  `basis_linear_independent` ("verified via Python oracle; theorem proved by
  Aristotle job …") and `omega_bar` ("Aristotle job 68efb3f8…") record *who/what
  produced the Lean proof*, which is good for reproducibility, but they do **not**
  record the *mathematical* source. Action: keep the job IDs, but add the
  foundational citation (`Furey2018ideal`, dimension-count / conjugate-ideal
  discussion) alongside. Distinguish "proof provenance" from "claim provenance".

- **F-4 (`FureyRealizesOneGeneration` cites journal-string only for the gauge
  paper).** It cites "Eur. Phys. J. C 78 (2018), 375" with no arXiv ID. Action:
  once curator item **C2** is confirmed, add `arXiv:1810.10465` to that docstring
  so it resolves to the same graph node as `Furey2018gauge`.

- **F-5 (no triality/Jordan/DVT source, by design).** Ensure no future theorem
  silently attributes triality/Jordan/DVT structure to the three pack papers.
  Action: when such work begins, open a separate source pack for Baez *The
  Octonions* / Dixon / Günaydin–Gürsey.

- **F-6 (claim-boundary discipline is good — keep it).** Both
  `RightSingletBoundary` (right-handed singlets conventional) and the
  `ElectroweakCompletePackage` in-file note (SU(2)_L not derived from α_i) are
  correctly scoped against over-claiming and align with working-plan §22.5.
  No change needed; cite as the model for F-1.

---

## 4. Zotero / Neo4j metadata suggestions

### 4.1 Zotero items (BibTeX-style; fill DOIs/journal fields on confirmation)

```
@article{Furey2018ideal,
  author  = {Furey, Cohl},
  title   = {{Three generations, two unbroken gauge symmetries, and one eight-dimensional algebra}},
  year    = {2018},
  eprint  = {1806.00612},
  archivePrefix = {arXiv},
  primaryClass  = {hep-th},
  note    = {Complex-octonion (C x O) minimal left ideal; division-algebraic ladder operators.
             Journal ref to be confirmed (curator item C1).},
  keywords = {furey, octonions, complex-octonion, minimal-left-ideal, ladder-operators,
              clifford-Cl6, idempotent, standard-model-fermions}
}

@article{Furey2018gauge,
  author  = {Furey, Cohl},
  title   = {{SU(3)_C x SU(2)_L x U(1)_Y (x U(1)_X) as a symmetry of division algebraic ladder operators}},
  year    = {2018},
  eprint  = {1810.10465},
  archivePrefix = {arXiv},
  primaryClass  = {hep-th},
  journal = {Eur. Phys. J. C},
  volume  = {78},
  pages   = {375},
  note    = {arXiv<->journal link to be confirmed (curator item C2);
             repo currently cites the EPJC string without an arXiv ID.},
  keywords = {furey, octonions, gauge-group, SU3, SU2, U1, hypercharge,
              ladder-operators, standard-model, charge-quantization}
}

@article{BaezHuerta2010GUT,
  author  = {Baez, John C. and Huerta, John},
  title   = {{The Algebra of Grand Unified Theories}},
  year    = {2010},
  eprint  = {0904.1556},
  archivePrefix = {arXiv},
  primaryClass  = {hep-th},
  journal = {Bull. Amer. Math. Soc.},
  volume  = {47},
  number  = {3},
  pages   = {483--552},
  doi     = {10.1090/S0273-0979-10-01294-2},
  keywords = {baez, huerta, grand-unified-theory, representation-theory,
              standard-model, hypercharge, gell-mann-nishijima, SU5, SO10, anomaly}
}
```

Suggested Zotero collection: `Null-Edge / Gate-H / Furey-Baez-foundations`.
Suggested Zotero tags (shared): `gate-H`, `internal-spectrum`, `furey-bridge`,
`foundational`, `convention:octonion-XOR`, `status:to-confirm` (on the two Furey
items until C1/C2 are checked).

### 4.2 Neo4j graph nodes / relationships

Node label `:Paper` (one per reference), property `key` = the Zotero key above,
plus `arxiv`, `title`, `authors`, `year`, `confirm_status`.

```
(:Paper {key:'Furey2018ideal',  arxiv:'1806.00612', confirm_status:'C1-pending'})
(:Paper {key:'Furey2018gauge',  arxiv:'1810.10465', confirm_status:'C2-pending'})
(:Paper {key:'BaezHuerta2010GUT', arxiv:'0904.1556', confirm_status:'confirmed'})
```

Node label `:Claim` / `:LeanModule` / `:LeanDecl` for repo artifacts; relationship
`[:SUPPORTED_BY]` from claim to paper, `[:USES_CONVENTION]` to convention nodes.

```
(:LeanModule {name:'PhysicsSM.Algebra.Furey.MinimalLeftIdeal'})
  -[:SUPPORTED_BY {role:'minimal-ideal,ladder'}]-> (:Paper {key:'Furey2018ideal'})
  -[:SUPPORTED_BY {role:'anomaly,hypercharge'}]->  (:Paper {key:'BaezHuerta2010GUT'})
  -[:USES_CONVENTION]-> (:Convention {key:'octonion-XOR-basis'})

(:LeanDecl {name:'MinimalLeftIdeal.T12..T32', status:'defined-only'})
  -[:SUPPORTED_BY {role:'SU3-gauge'}]-> (:Paper {key:'Furey2018gauge'})
  -[:FLAGGED {flag:'F-1', note:'SU(3) action not yet proved'}]-> (:Audit)

(:LeanModule {name:'PhysicsSM.Algebra.Furey.FureyRealizesOneGeneration'})
  -[:SUPPORTED_BY {role:'gauge-group'}]->     (:Paper {key:'Furey2018gauge'})
  -[:SUPPORTED_BY {role:'SM-representations'}]-> (:Paper {key:'BaezHuerta2010GUT'})

(:LeanModule {name:'PhysicsSM.Algebra.Furey.ElectroweakCompletePackage'})
  -[:SUPPORTED_BY {role:'EW-gauge-symmetry'}]-> (:Paper {key:'Furey2018gauge'})
  -[:CLAIM_BOUNDARY {note:'SU(2)_L not derived from alpha_i'}]-> (:Audit)
```

Suggested Neo4j tags/labels: `:Foundational`, `:GateH`, `:FureyBridge`. Edge
property `confirm_status` should propagate the C1/C2/C3 states so a query can list
all claims that rest on an unconfirmed arXiv↔journal link.

Cross-reference (already-curated, do not duplicate as new nodes): Furey 2025
`arXiv:2505.07923` (working plan §24.5) and Furey 2015 (Phys. Lett. B 742 (2015)
195). Add `[:RELATED_TO]` edges from the two Furey 2018 nodes to these.

---

## 5. Out-of-pack sources to curate next (recommendations, not part of this job)

These are referenced *implicitly* by repo claims but are **not** in the three-paper
pack. Flag for a follow-up source pack so claims are not mis-attributed:

- Baez, *The Octonions*, arXiv:math/0105155 — for SU(3) ⊂ G₂ = Aut(𝕆), triality.
- C. Furey, PhD thesis "Standard model physics from an algebra?" arXiv:1611.09182 —
  fuller derivation context for the ladder/ideal construction.
- Dixon, *Division Algebras: ...* (ℝ⊗ℂ⊗ℍ⊗𝕆 / DVT program) — for any DVT claim.
- Günaydin–Gürsey — for the Jordan-algebra J₃(𝕆) / quark-colour link.

---

## 6. Deliverable status

- [x] Theorem-provenance map (Section 1).
- [x] Source → claim cross-index, incl. minimal ideal, ladder operators, gauge
      quotient, SU(3) from G₂, electroweak embedding, DVT/Jordan/triality status
      (Section 2).
- [x] Provenance-strengthening flags F-1 … F-6 (Section 3).
- [x] Zotero/Neo4j tags + metadata for the three papers (Section 4).
- [x] No papers ingested; curator confirmation items C1–C3 listed (Section 0).
