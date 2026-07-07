# Grand-strategy review — Weitzenböck-carrier unification of mass (2026-07-07)

**Reviewer stance:** skeptical program director. Grades are anchored to the *kernel*, not the prose.
**Verification performed for this review (not taken on trust):**

- `lake build PhysicsSM.Draft.NullEdge.Carrier.CarrierAxiomGuard` → **green, 8033 jobs.**
  Every `#print axioms` guard block passes, so the 13 guarded carrier flagships are genuinely at
  `[propext, Classical.choice, Quot.sound]` or fewer. The LANDED claim is real.
- `grep` for `sorry` across `Carrier/` → **exactly one live `sorry`:**
  `Torus.mZero_iff_commute` (`WeitzenbockQC_Torus.lean:114`), **not guarded**, emits the expected
  `declaration uses 'sorry'` warning at build. Everything else in the lane is sorry-free.
- The abstract master/assembly identities (`weitzenbock_master`, `carrier_square_assembly`,
  `solderedNC`) are **never instantiated on the concrete torus model** (`Torus.nabla`,
  `plaquetteCurvature`), nor on any other concrete algebra. The two live in disjoint universes
  (abstract `B` vs `End (Site → W)`); no probe P-i…P-iv is landed.
- `grandMassCapstone` (`GrandMassCapstone.lean`) is an honest **conjunction of toy finite
  witnesses** (`X_masses := ![1,2,3,4]`, etc.) and **does not reference the carrier at all**.

Bottom line up front: **the algebra of Move-1 is real and clean; the *physics* of Move-1 is not yet
on the kernel.** What is proved is a grade-decomposition of `D²` (an algebraic polarization identity)
in an abstract ring. What is claimed in the run prose — "the origin of mass from null edges" — needs
(i) the Krein `D^#D` upgrade, (ii) the Move-2 identification lemmas, and (iii) one concrete nontrivial
witness. All three are OPEN. The gap between kernel and headline is the central finding.

---

## (a) Is the carrier decomposition still the right organizing principle?

**Verdict: right taxonomy, wrong headline. Keep the principle; demote the artifact.**

The decomposition `D^#D = Q_A + Q_C + Q_T + E` is the correct *organizing* idea — it dissolves the
old "three distinct modes vs. `no_common_carrier`" tension exactly as advertised (§0 of `FABLE_STEER`).
But the object currently kernel-checked, `weitzenbock_master`, is the **standard Weitzenböck/Clifford
grade split and nothing more**:

```
4·(∑ γe ∇e)² = ∑∑ {γe,γf}{∇e,∇f}  +  ∑∑ [γe,γf][∇e,∇f]
             = Q_A (grade-0)       +  Q_C (grade-2)
```

The proof is the polarization identity `4(ab)(cd) = {a,b}{c,d}+{a,b}[c,d]+[a,b]{c,d}+[a,b][c,d]`
with the two cross blocks killed by the index-swap involutions `sum_sym_antisym_zero` /
`sum_antisym_sym_zero`. This is **canonical given a Clifford structure, but tautological as an
identity** — it is precisely the "`D^#D` decomposes into its own terms" non-vacuity flag that
`FABLE_STEER §3` already warns is content-free. The content lives **entirely** in the Move-2
identification lemmas (Q_A = aperture, Q_T = turn, Q_C ↔ Z2 gap), which are **all OPEN**.

**Sharper organizing principle (recommend adopting as the headline):** the *obstruction-theory
bigrading* already stated in `FABLE_STEER §5.1` —
`T = index/K-theory · C = H²/holonomy · A = Clifford-symbol positivity · G = harmonic/boundary`,
on one 2-complex. That framing is decision-forcing (it *predicts* the dropped-hypothesis terms and
their physics) where "the decomposition" is not. Concretely: **rename the program's north star from
"the discrete Weitzenböck decomposition" (W1) to "the four identification lemmas + the graded
irreducibility theorem" (W2a/W2b)**, and treat W1 as scaffolding, not as the result.

---

## (b) Highest-value next move; over/under-investment

**Single highest-value move: build the *glue instance* — instantiate `carrier_square_assembly` on the
concrete `Z2×Z2` torus so that `Q_A`, `Q_C`, `Q_T` are simultaneously nonzero in one model, and
discharge probes P-i…P-iv there.**

Rationale: this is the one move that converts everything already landed from "true but possibly
hollow" into "demonstrably instantiated." Right now the master identity, the torus curvature lemma
(`nabla_commutator_path_difference`), and the turn brick (`dirac_square_with_potential`) are three
proofs in three disjoint settings that **have never been shown to describe the same object**. A single
`example`/theorem feeding `Torus.nabla` + a Clifford `γ` acting on the internal factor into
`weitzenbock_master`/`carrier_square_assembly`, with `Q_C ≠ 0` witnessed by nonzero
`plaquetteCurvature`, would:
- kill the disjoint-universes hollowness risk (R3 below);
- execute the pre-registered oracle probes before further analytic spend (the run's own discipline);
- make "the assembly" a statement about a model rather than a ring tautology.

It is also cheap (finite linear algebra) and unblocks W2a (the identifications need a concrete `Q_A`).

**Over-invested:** Lane C's nonabelian gap. `FABLE_STEER §5.1` already ordered "STOP over-investing,"
yet OS1 + QC + KP + PH + TY-LINEAGE together are the majority of Codex cycles. The unification needs
from C only (a) the `Q_C` slot (have it) and (b) one solved instance (have Z2 + Q8). Everything past
the strong-coupling SU(2) `β₀` rung is off the critical path.

**Under-invested:** (i) the glue instance / probes (currently zero); (ii) Move-2 identification lemmas
W2a — the actual content, still at "statement drafting"; (iii) the Krein `#` upgrade, which gates
whether the `D²` line is even on the mass-critical path (see R1).

---

## (c) Top risks — likely FALSE, mis-scoped, or hollow (ranked)

**R1 — [most severe] The `D²` assembly is physically premature; mass needs `D^#D`, not `D²`.**
The carrier is defined (FABLE_STEER §0) as the *Krein square* `D^#D`, and `M² = inf spec D^#D`. What
is kernel-checked (`carrier_square_assembly`) is `4·(D0+Γφ)² = Q_A + Q_C + 4Q_T`, i.e. the square of
the *wrong operator* unless `D^# = D`. On an indefinite Krein space `D² ≠ D^#D` in general, and
`inf spec D²` is not a mass. So the assembly is legitimate **scaffolding** but is **not a mass
statement**. The in-file docstrings are honest about this ("NO Krein #", "NO spectral positivity"),
so this is *not* an in-kernel over-claim; but the run-level prose ("Move-1 milestone… origin of
mass," THREAD_BOARD/LEDGER) drifts past it. **Decision:** do not advance any "origin of mass"
language until the Krein brick (`krein_square_form`, `positivity_transfer`) lands or the
doubled-index route is adopted. This is already in flight as Fable call-02 — correct.

**R2 — Q_A/Q_C/Q_T is grade-canonical, but the physics assignment is an artifact until Move-2.**
Answering the review's pointed question directly: **the split *is* the sym/antisym (Clifford-degree)
decomposition.** As pure algebra it is a convention-canonical polarization identity, not a discovered
structure. It becomes non-artifactual **only** through the identification lemmas that tie each grade
block to an *independently defined* lane functional (aperture, turn, Z2 gap) built before the
decomposition existed. Those lemmas (W2a) are unproven. **Downgrade the canonicity claim** to
"grade-canonical modulo the (still-open) identification lemmas" everywhere it appears.

**R3 — No concrete nontrivial witness; hollowness risk that the slots can be simultaneously nonzero
and matched.** Verified: `weitzenbock_master`/`carrier_square_assembly` are never instantiated; probes
unrun. The claim is *likely true* but *unproven*, and until the glue instance (b) exists the
"unification" is three proofs that may not describe one object. Mitigation = move (b).

**R4 — `mZero_iff_commute` is a live `sorry`; "Q_C has a concrete realization" overstates.** The
forward lemma `nabla_commutator_path_difference` is landed and guarded, but the equivalence
`plaquetteCurvature = 0 ⇔ [∇a,∇b]=0` (needed for "vanishes iff collinear ∧ flat ∧ Φ-free") is
`sorry` at `WeitzenbockQC_Torus.lean:114`, unguarded. THREAD_BOARD's "Q_C … Z2×Z2 realization
landed" should read "forward realization landed; flatness equivalence OPEN." Cheap to close (shift is
a bijection); should be closed or the claim narrowed.

**R5 — Relative exhaustiveness (W2c) is the statement most likely to be FALSE if stated absolutely.**
`FABLE_STEER §3` already relativizes it correctly (translation-regular, boundaryless, cov-constant
soldering, vacuum Φ) and `[H1]` fixes it at the operator-term (not particle) level. The risk is a
future drafter dropping a hypothesis. Enforce the relativized statement and the operator-term
scoping in the docstring at authoring time; do not let W2c be stated as an unconditional trichotomy.

---

## (d) Re-scope / escalate / abandon

- **Abandon / keep parked (correct as-is):** Spin(10) Transitivity (falsified); all-`β` SU(N) gap
  (Clay-adjacent, OPEN — stop gating the program on it, per §5.1).
- **Re-scope headline (new):** demote `carrier_square_assembly` from "Move-1 milestone / origin of
  mass" to "Weitzenböck `D²` scaffold (pre-Krein)"; promote **W2a identifications + the glue instance**
  to the critical path. Update THREAD_BOARD W1 done-condition prose accordingly.
- **Re-scope (already decided, keep):** OS1 → strong-coupling SU(2) with explicit `β₀`
  (Osterwalder–Seiler mechanization); QC → leading-order only. These are correctly bounded.
- **Escalate to Fable (in flight, correct):** the Krein `#` decision (call-02) — whether `D^#=D` is
  attainable or the doubled-index route is mandatory. This is the true gate on R1; keep it top of the
  queue and do not let W1 prose advance until it resolves.
- **Close cheaply, then re-guard:** `mZero_iff_commute` (R4) — finish the `sorry` and add it to
  `CarrierAxiomGuard`, or explicitly mark the torus module DRAFT and remove the equivalence from any
  "landed" claim.

---

## (e) Does the PROVED/MODELED/OPEN grading match the kernel?

**Mostly yes at the file level; the mismatches are all in the run-level prose, and they inflate.**

**Matches (verified):**
- All 13 guarded carrier flagships are truly kernel-checked at standard axioms — the guard build
  passing (8033 jobs) is direct evidence, not the subagent's word.
- Per-file docstrings are commendably disciplined: `WeitzenbockMaster`, `CarrierSquareAssembly`,
  `CarrierPotentialTurn` all explicitly flag "NO Krein #", "NO spectral positivity", "E=0 regime by
  construction", "identification is Move-2". This is honest scoping.
- The `[H2]` color-commutant framing was already self-corrected in-ledger to "linear-algebra
  constraint," matching `color_commutant_eq_scalars` (linear algebra, sound).

**Mismatches / over-claims to fix:**
1. **"Move-1 D² assembly … origin of mass" (THREAD_BOARD/LEDGER).** True as an algebra identity; the
   "origin of mass" reading outruns the kernel (D² not D^#D; no spectrum; no witness). Grade should
   read **MODELED (algebra), OPEN (mass)**. (R1/R3.)
2. **"Q_C has a concrete Z2×Z2 realization" (task framing + board).** Forward direction only;
   `mZero_iff_commute` is `sorry`. Grade **PARTIAL**, not landed. (R4.)
3. **`grandMassCapstone` as "the unification."** It is an honest conjunction (`AND`) of **toy finite
   witnesses** (`X_masses := ![1,2,3,4]`) and **does not mention the carrier**. The advertised `AND→+`
   upgrade is NOT done. Ensure no scorecard entry reads the current capstone as the carrier
   unification; it is a lane-representative conjunction only.
4. **"Canonical decomposition."** Downgrade to "grade-canonical modulo identification" (R2).

No fabricated PROVED grades were found; the failure mode here is optimistic *prose* around correctly
guarded kernel objects, not fake kernel objects.

---

## One-screen scorecard

| Item | File / name | Kernel state (verified) | Honest grade |
|---|---|---|---|
| Null nilpotency, zero-diagonal | `NullNilpotentSquare` | guarded, std axioms | PROVED |
| Q_A Gram (flat) | `SolderedSquareGram` | guarded | PROVED |
| Master identity `4D0²=Q_A+Q_C` | `weitzenbock_master` | guarded | PROVED (algebra); tautological grade split |
| Turn slot `(D0+Γφ)²=D0²+φ²` | `dirac_square_with_potential` | guarded | PROVED (algebra) |
| Assembly `4D²=Q_A+Q_C+4Q_T` | `carrier_square_assembly` | guarded | PROVED (algebra, E=0); **not** a mass statement |
| Torus curvature commutator | `Torus.nabla_commutator_path_difference` | guarded | PROVED |
| Q_C=0 ⇔ flat | `Torus.mZero_iff_commute` | **live `sorry`, unguarded** | OPEN |
| Color commutant = scalars | `color_commutant_eq_scalars` | guarded | PROVED (linear algebra) |
| Glue instance / probes P-i…iv | — | **absent** | OPEN (highest-value next) |
| Krein `D^#D` upgrade | — | absent (call-02 in flight) | OPEN (gates "mass") |
| Move-2 W2a/W2b/W2c, capstone | — | absent | OPEN (the actual content) |

**Three decisions forced:** (1) build the glue instance + run probes before more analytic spend;
(2) freeze all "origin of mass" prose until the Krein brick lands; (3) close or DRAFT-mark
`mZero_iff_commute` and stop calling Q_C "realized" until it is.
