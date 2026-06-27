# Wave 16 C69: off-branch zero sector audit report

Date: 2026-06-26. Gate C audit job (with one small, kernel-checked Lean addition).

Canonical prompt: `AgentTasks/null-edge-wave16-c69-off-branch-zero-sector-audit-aristotle-2026-06-26.md`.

## Scope and method

This is an audit, not a release. Findings below come from reading the live repo
modules cited inline and from the one small Lean module added by this job
(`PhysicsSM/Draft/NullEdgeOffBranchZeroSector.lean`), which builds `sorry`-free
on top of the existing C64/C62/C47–C48 surfaces. Because the project's default
targets transitively import the (offline-unavailable) `SpherePacking` dependency,
the new module was verified by a single-module build
(`lake build PhysicsSM.Draft.NullEdgeOffBranchZeroSector`, 8035/8035 jobs,
"Build completed successfully") with the `SpherePacking` `require` temporarily
disabled and then restored byte-for-byte; the lakefile and manifest are unchanged
in the returned project.

The object under audit is the C64 off-branch nodal point

```text
q⋆ = (2π/3, 0, 0, 4π/3),   u⋆ = phaseU q⋆ = (ω−1, 0, 0, ω²−1),   ω = exp(2πi/3),
```

certified in `PhysicsSM.Draft.NullEdgeNodalSetExhaustion` as a genuine scalar and
full Clifford-determinant zero (`extra_qform_zero`, `extra_mink_zero`), nonzero
(`extra_ne_origin`), on no branch line (`extra_not_on_branchLine`), and *not*
gapped by the `g5` species-split term for any coefficient (`extra_Msplit_g5_zero`).

**Bottom line (adversarial verdict).** `q⋆` is currently an *unclassified* bare
determinant zero. The repo has rich per-branch chirality / Krein / ghost
machinery, but every piece of it is indexed by the four-branch label `Fin 4`, and
`q⋆` carries no branch label. Maximal flavored index, projected one-dimensional
chirality, and gauge covariance of the dressed projectors are all genuinely
established elsewhere — and none of them touches `q⋆`. So the honest status is:
**off-branch zeros are neither proven fatal nor proven discardable.** They are a
real, open ghost-safety hole in the *faithful, full-locus* reading of Gate C
Clause 1. They are not, on the present evidence, fatal; but nothing in the repo
discharges them, and the prompt's warning is correct — the existing maximal /
covariant / chiral data do **not** imply ghost safety here.

---

## Q1. What data do we currently have for `q⋆`?

Itemized against the requested fields. The recurring theme: the data exist as
**branch-indexed** objects, and `q⋆` is off-branch, so almost all of them are
simply *undefined at* `q⋆`.

- **Branch label — NONE (provably).** A certified branch line `branchLineU a t`
  has *exactly one* vanishing retarded component (the distinguished edge `a`), or
  degenerates to the origin. `u⋆` has *two* vanishing components (edges 1 and 2,
  `extra_comp1_zero`/`extra_comp2_zero`) and is nonzero, so
  `extra_not_on_branchLine : ∀ a t, phaseU q⋆ ≠ branchLineU a t`. `q⋆` therefore
  has no branch index in the C43/C44 sense.

- **Projected-sector membership — NOT computed.** The projected Gate C dataset
  `ProjData` (`NullEdgeProjectedGateCRelease`) records `retained : Fin 4 → Bool`,
  `kerDim`, `nodalGap`, etc. *per branch*. The physical selector
  `physSel = ![true,false,true,false]` (`NullEdgeKreinPositiveReleaseCriterion`,
  `NullEdgeCanonicalSpeciesSelector`) retains the branch pair `{0,2}`. None of
  these assign `q⋆` to "retained" or "discarded": there is no map from the
  off-branch locus into the four-branch selector. So projected-sector membership
  for `q⋆` is **undefined**, not "out".

- **Krein sign — NOT computed.** `branchKreinSig : Fin 4 → ℝ` (C22,
  `branchKreinSig_values = (+1,−1,+1,−1)`) is the trace `(kreinJ * Pbranch a).trace`
  of a *branch* projector. There is no `Pbranch` for `q⋆`, hence no Krein sign.
  (The `KreinPositivePhysicalSector` predicate is about enumerated `ZeroDatum`s,
  and no `ZeroDatum` has been attached to `q⋆` — see "residue/ghost" below.)

- **Chirality — only the universal Weyl split, not a single intrinsic label.**
  This is the one place real symbol-level data *do* apply to `q⋆`.
  `NullEdgeProjectedBranchChirality.projectedKernel_finrank_one` holds for **any**
  nonzero null covector `p` with `mink p = 0`; since `mink (pCov u⋆) = 0`
  (`extra_mink_zero`) and `u⋆ ≠ 0`, the Clifford kernel at `q⋆` is the usual
  chirality-balanced 2-dim space, and *each* Weyl projection (`branchProj a`,
  eigenvalue `g5 a = ±1`) cuts it to a one-dimensional `γ₅`-aligned line exactly
  as at any branch point. **Crucially, this means the chirality machinery does not
  distinguish `q⋆` from a branch point at all** — it carries both a `+1` and a
  `−1` kernel line, and nothing here selects one or labels `q⋆` with a species.
  So "projected chirality" is available but vacuous as a *discriminator*: it
  neither flags nor clears `q⋆`.

- **Residue / ghost classification — NONE.** The six-way `ZeroKind`,
  `ZeroDatum`, `IsFatalGhost` calculus (C47/C48) requires an enumerated zero with
  a `kreinResidue : ℝ` and a `gaugeCoupledPropagating : Bool`. No `ZeroDatum` has
  been constructed for `q⋆`. The only thing proven is *negative*:
  `extra_Msplit_g5_zero` shows the modeled species-split mass term vanishes at
  `q⋆` for every coefficient `r`, i.e. the one mechanism C60 uses to gap branch
  curves gives `q⋆` zero mass and does not remove it.

**Summary of Q1.** Of the six requested fields, five (branch label,
projected-sector membership, Krein sign, residue, ghost class) are *undefined* for
`q⋆`, and the sixth (chirality) is the universal null-covector Weyl split that
does not discriminate `q⋆` from any branch point. There is no positive datum that
classifies `q⋆`.

---

## Q2. Is `q⋆` outside the modeled branch projectors, or does it survive a projected physical sector?

**It is outside the modeled branch projectors — definitionally.** The branch
projectors `Pbranch a` and the physical-sector projector
`Pphys = Pbranch 0 + Pbranch 2` (`NullEdgeKreinPositiveReleaseCriterion`) live on
the abstract four-branch sector space (`RMat`, indexed by `Fin 4`). They are not
functions of the phase vector `q` or the covector `pCov u`. There is no arrow from
the determinant-zero locus `{q | qform (phaseU q) = 0}` into that branch index,
and `q⋆` is provably not on any branch line, so it is not in the domain those
projectors act on.

**Does it survive a projected physical sector? Unknown — and that is the hole.**
The link-dressed projector framework (`NullEdgeGaugeCovariantBranchProjectors`,
`NullEdgeProjectedGhostSafety`) acts on a genuine gauge fibre `Fin n → ℂ` and on
covectors, so it *could* in principle be evaluated at `pCov u⋆`. But:

- the Weyl/chirality projection (`branchProj`) does **not** annihilate the kernel
  at `q⋆` — it produces a nonzero one-dimensional chirality line (Q1), so the
  *chirality* projection alone does not discard `q⋆`;
- whether the *Krein / physical-sector* projection discards `q⋆`'s mode (i.e.
  whether `q⋆`'s kernel mode lies in the C62 "discarded sector",
  `ProjectedArtifact`) has **not been computed**. No theorem says it survives, and
  no theorem says it is projected out.

So the honest answer to Q2 is: `q⋆` is outside the four-branch projectors, and its
status under the physical-sector projection is **undetermined**. The adversarial
reading — that it *might* survive into a physical sector as an unclassified mode —
cannot currently be excluded.

---

## Q3. Can Gate C Clause 1 be rewritten as projected-sector nodal control, or would that hide a fatal bare ghost?

Clause 1 is `NodalSetControlled d := ∀ a, 0 < d.nodalGap a`
(`NullEdgeProjectedGateCRelease`), indexed over the **four branches**. C64 already
proved the decisive guardrail: `nodalSetControlled_does_not_imply_full_control`
exhibits a dataset (`releasedData`) satisfying `NodalSetControlled` whose
underlying bare symbol nevertheless has the off-branch zero `q⋆` that the `g5`
species-split term does not gap. So the literal four-branch clause **does not**
control the full nodal set.

**Verdict: a naive rewrite to "projected-sector nodal control" would hide a
potentially fatal bare ghost, and must not be done yet.** Concretely:

- Rewriting Clause 1 to quantify over the *projected physical sector* is only
  *faithful* if there is a theorem that the projection genuinely removes (or
  Krein-negatively/non-gauge-coupled classifies) every off-branch zero — i.e. an
  inhabitant of the discharge obligation in Q4. No such theorem exists.
- Without it, "projected-sector nodal control" would silently quantify `q⋆` out of
  existence by *fiat of indexing*, which is exactly the failure mode the prompt
  warns against: the rewrite would be true as stated (four-branch gaps are
  satisfiable) while a bare determinant zero with *no* ghost classification
  remains in the full symbol. That is hiding, not controlling.

The defensible move is the opposite of a silent rewrite: keep Clause 1's literal
four-branch meaning, and add a **separate, explicit** full-locus clause (the
off-branch discharge obligation below). Clause 1 may be *upgraded* to full-locus
control only once that obligation is discharged — the reduction theorem added by
this job (`offBranch_discharged_ghostSafe`) is precisely the bridge that would
license the upgrade.

---

## Q4. What exact theorem would prove all off-branch zeros are discarded / Krein-negative / composite-removable / ghost-safe?

The repo already contains the right calculus for this — C62
(`NullEdgeCompositeZeroEscape`): invertible basis change is a proven NO-GO
(`not_removable_by_invertibleBasisChange`); the genuine escapes are non-invertible
projection (`ProjectedArtifact`) and composite enlargement (`CompositeEnlargement`),
and an `AlgebraicEscape` is *necessary but not sufficient* — it needs the physical
gauge-response contract (`CompositeRemovable.gaugeResponse`) to imply
non-fatality (`CompositeRemovable.not_fatal`). C62 even proves the algebra is cheap
(`compositeEnlargement_always`) and insufficient alone
(`algebraicEscape_not_sufficient`), so the obligation cannot be gamed.

The **exact theorem** that would close the hole is therefore: *assign to every
off-branch zero a Dirac symbol and a classified `ZeroDatum`, and exhibit, for each,
a `CompositeRemovable` certificate (projection or composite escape **plus** the
gauge-response contract); conclude ghost-zero safety of the entire off-branch
locus.* This job states that obligation precisely and proves the reduction half of
it (the implication), leaving the genuinely physical half (inhabiting the
certificate at `q⋆`) open. In `PhysicsSM/Draft/NullEdgeOffBranchZeroSector.lean`:

```text
def OffBranchZero (q : Fin 4 → ℝ) : Prop :=
  qform (phaseU q) = 0 ∧ phaseU q ≠ 0 ∧
  (∀ (a : Fin 4) (t : ℝ), phaseU q ≠ branchLineU a t)

theorem offBranch_nonempty : OffBranchZero extraPhase            -- q⋆ inhabits it

def OffBranchSectorDischarged {n} (D : (Fin 4→ℝ)→Sym n) (Z : (Fin 4→ℝ)→ZeroDatum) : Prop :=
  ∀ q, OffBranchZero q → CompositeRemovable (D q) (Z q)

theorem offBranch_discharged_ghostSafe {n} (D) (Z) :
  OffBranchSectorDischarged D Z → ∀ q, OffBranchZero q → ¬ (Z q).IsFatalGhost
```

`offBranch_discharged_ghostSafe` is the reduction: a discharge certificate makes
*every* off-branch zero non-fatal, which is exactly what is needed to upgrade
Clause 1 to full-locus control (Q3). It is proved from
`CompositeRemovable.not_fatal`, so it inherits C62's honesty — the gauge-response
contract is load-bearing, and an algebraic escape without it does not suffice.

**What is still missing to *inhabit* `OffBranchSectorDischarged`** (the concrete
data the algebra cannot supply, restated as a checklist for the C58/C62-style
follow-up job):

1. **A symbol map `D : OffBranchZero → Sym n`.** The explicit value of the
   inverse-propagator / Dirac symbol at each off-branch zero. For `q⋆` this is the
   `4×4` Clifford symbol `cliffordSymbol (pCov u⋆)`; its kernel mode must be
   extracted (it exists by `extra_mink_zero` ⇒ singular `blockA`/`blockB`).
2. **An escape witness:** either a physical-sector projector `P` with
   `ProjectedArtifact (D q⋆) P` — i.e. a proof that `q⋆`'s kernel mode lies in the
   *discarded* sector and the retained sector stays non-degenerate — or a
   `CompositeEnlargement` resolving it in an elementary-plus-composite basis. (Per
   `compositeEnlargement_always`, a bare enlargement is not enough; it must come
   with item 3.)
3. **The gauge-response computation:** a proof that, after weak gauge coupling,
   `q⋆`'s resolved/discarded mode does not propagate as a gauge-coupled state
   (`gaugeCoupledPropagating = false`). This is the genuinely physical input and
   is the same obligation as the still-open `PostGaugeGhostSafe` contract (C47/C48
   §7).
4. **The residue sign:** the Krein residue of any surviving physical pole at `q⋆`
   (to feed `KreinPositivePhysicalSector` / rule out the `< 0` ghost branch).

Items 3–4 are the symbols/residue computations the prompt asks about; they are
**not derivable from the existing chirality/index/covariance theorems** and remain
the open content.

---

## Q5. Which Gate C release clauses are unaffected, and which must be strengthened?

Of the seven C59 clauses (`NullEdgeProjectedGateCRelease`):

- **Clause 1 — `NodalSetControlled` — MUST BE STRENGTHENED (the blocked clause).**
  In its faithful full-locus reading it is *not* discharged: C64's
  `nodalSetControlled_does_not_imply_full_control` plus `offBranch_nonempty` show a
  genuine off-branch zero escapes the four-branch gap. The literal four-branch
  predicate is still satisfiable (the guardrail), but it must be supplemented by an
  off-branch discharge clause (`OffBranchSectorDischarged`, Q4) before it can be
  read as controlling the full nodal set. **This is the only clause this audit
  blocks.**

- **Clause 6 — `GhostZeroSafe` — INDIRECTLY AT RISK.** It quantifies over the
  *enumerated* zero list `d.zeros`. If the enumeration omits off-branch zeros like
  `q⋆` (which it currently does — no `ZeroDatum` exists for `q⋆`), the clause is
  *vacuously* satisfied on an incomplete spectrum. So Clause 6 is sound *given a
  complete enumeration*, but the enumeration-completeness side condition is exactly
  what C64 + this audit show is currently unmet. It should be paired with the
  off-branch discharge clause, not changed internally.

- **Clauses 2–5, 7 — UNAFFECTED.** `BranchProjectorsControlled`,
  `ProjectedKernelOneDim`, `ProjectedChiralityAligned`, `ProjectedKreinPositive`,
  `SpeciesSplittingAudited` are statements about the *retained branch* data and the
  *enumerated* spectrum. They are independent of the off-branch locus and are not
  weakened or invalidated by `q⋆`. In particular the projected one-dimensional
  chirality theorem (`projectedKernel_finrank_one`) is *consistent with* `q⋆`
  (it even applies there) and so cannot be used against the off-branch zero — which
  is precisely why chirality alignment is not a discriminator here.

The clause-independence guardrails of C59 (`index_not_sufficient`,
`kreinPositive_not_chirality`, `chirality_not_ghostSafe`) and C61/C63
(`gaugeCovariant_not_ghostSafe`, `chirality_index_covariance_not_ghostSafe`)
already encode the prompt's adversarial point at the *branch/enumerated* level:
maximal index, Krein positivity, projected chirality, and gauge covariance each
fail to imply ghost safety. This audit shows the *same* lesson extends to the
off-branch locus, where it is sharper because there is not even a classification to
appeal to.

---

## Solved targets

- Characterized the data status of the C64 off-branch zero `q⋆` across all six
  requested fields (Q1): five undefined, one (chirality) non-discriminating.
- Determined that `q⋆` is outside the modeled four-branch projectors and that its
  physical-sector survival is undetermined (Q2).
- Determined that Clause 1 must not be silently rewritten to projected-sector
  control, and gave the safe alternative (Q3).
- Identified the exact discharge theorem and stated it in Lean, proving the
  reduction half kernel-checked (Q4).
- Classified all seven C59 clauses by impact (Q5).

## Changed statements

None weakened. One new module added with new statements only
(`OffBranchZero`, `OffBranchZero.mink_zero`, `offBranch_nonempty`,
`OffBranchSectorDischarged`, `offBranch_discharged_ghostSafe`,
`offBranch_audit_status`). No existing statement was modified.

## Remaining blockers / proof holes / handoff markers

- **OPEN (physical):** inhabit `OffBranchSectorDischarged` at `q⋆` — supply the
  symbol map, escape witness, gauge-response (`gaugeCoupledPropagating = false`),
  and residue sign of Q4 items 1–4. This is the real C69 obligation and is the
  same family as the open `PostGaugeGhostSafe` (C47/C48 §7) contract.
- **OPEN (structural):** an enumeration-completeness lemma showing the C59
  `d.zeros` list (or its projected-sector analogue) covers the off-branch locus,
  so Clause 6 is not vacuously satisfied on a partial spectrum.
- **Handoff:** once the above are in hand, `offBranch_discharged_ghostSafe`
  upgrades Clause 1 from four-branch to full-locus nodal control; wire it into the
  `ProjectedGateCRelease` bundle as the eighth (off-branch) clause.

## Exact files changed

- `AgentTasks/null-edge-off-branch-zero-sector-audit-report.md` (this report; new).
- `PhysicsSM/Draft/NullEdgeOffBranchZeroSector.lean` (new module; builds
  `sorry`-free via single-module build on the C64/C62/C47–C48 surfaces).
- `PhysicsSMDraft.lean` (added one `import` line registering the new module, next
  to `NullEdgeNodalSetExhaustion`).

`lakefile.toml` and `lake-manifest.json` are unchanged (the temporary
`SpherePacking` disable used only for offline single-module verification was
reverted byte-for-byte).
