/-
# Null-Edge Gate C: branch-locus / physical-sector release API (C100)

This is a small, self-contained finite API for the **C1-facing** part of the
Gate C program.  Task: `null-edge-wave25-c100-branch-locus-sheaf-alternatives`.

The new lateral analysis (context pack
`AgentTasks/context-packs/null-edge-wave25-lateral-analysis-20260627-114614.md`)
proposes treating the raw branch object

```text
Z = { q : det D_+(q) = 0 }
```

as a *branch-index / topological* problem rather than a scalar-coefficient
tuning problem.  The repo already records (and this file does **not** re-prove):

* bare `D_+` has chirality-balanced branch kernels;
* known off-branch and cyclotomic zeros exist;
* scalar Wilson terms may support Gate **C0** species health but cannot release
  **C1** chirality at the origin
  (`PhysicsSM.Draft.NullEdgeGateCSplit`, `NullEdgeGateC0SpeciesHealth`);
* ghost-zero safety forbids removing gauge-charged branches *only* by propagator
  zeros (`PhysicsSM.Draft.NullEdgeGateCGhostZeroSafety`).

## What this file is, and is not

This file is a **planning / guardrail API**.  It separates six pieces of data
that the program has repeatedly conflated, and proves *concrete
non-implications* among them so that a future C1 release theorem cannot be
assembled from a strictly weaker ingredient:

```text
branch-locus control          (BranchCandidate.branchLocusControlled)
projected one-line kernel      (BranchCandidate.projectedKernelOneDim)
physical chirality             (BranchCandidate.projectedChiralityAligned / chiralIndexNonzero)
Krein positivity               (BranchCandidate.projectedKreinPositive)
true inverse-propagator gap    (BranchCandidate.inversePropagatorGap)
ghost-zero safety              (BranchCandidate.ghostSafe)
```

It is **not** a Gate C release, **not** a domain-wall/overlap success theorem,
**not** an anomaly-cancellation claim, and it does **not** assert locality of any
nonlocal sign function.  All `Prop`s here are about finite toy data; they are
guardrails, not the eventual operator-level theorems.  In particular C0 species
health is *never* relabelled as a C1 release: see `c0_lift_not_c1_release`.

Everything is finite/decidable and proved by `decide`; the file has no imports
and uses only the Lean default proof environment.
-/

namespace PhysicsSM.Draft.NullEdgeBranchLocusPhysicalSectorAPI

/-! ## §1  Branch-locus data: the six separated bits

A `BranchCandidate` is a toy record of Boolean answers, one per claim that a
release proposal might make about a branch point `q ∈ Z`.  Each `Prop`-level
predicate below selects *exactly one* field, so a predicate can never silently
smuggle in another property.  This is the whole point of the API: the fields are
*independent inputs*, and the theorems show they are genuinely independent. -/

/-- Toy data attached to a candidate branch-release proposal.

Field meanings (all C1-facing unless noted):

* `branchLocusControlled` — the branch locus `Z` is understood/controlled
  (off-branch and cyclotomic zeros classified).
* `scalarWilsonLifted` — a **C0**, scalar Wilson species lift is present
  (species health), *not* a chiral release.
* `projectedKernelOneDim` — after projection the retained kernel is one-line.
* `projectedChiralityAligned` — the projected kernel carries aligned chirality
  (interface/projector "shape").
* `chiralIndexNonzero` — there is a genuine nonzero physical chiral index
  (the real C1 content).
* `projectedKreinPositive` — the retained physical sector is Krein-positive.
* `inversePropagatorGap` — unwanted branches are lifted by a *true
  inverse-propagator mass gap*.
* `propagatorZeroRemoval` — unwanted branches are removed *only* by propagator
  (numerator/determinant) zeros — the ghost-zero hazard route.
* `ghostSafe` — no gauge-charged branch is removed solely by a propagator zero. -/
structure BranchCandidate where
  branchLocusControlled : Bool
  scalarWilsonLifted : Bool
  projectedKernelOneDim : Bool
  projectedChiralityAligned : Bool
  chiralIndexNonzero : Bool
  projectedKreinPositive : Bool
  inversePropagatorGap : Bool
  propagatorZeroRemoval : Bool
  ghostSafe : Bool
deriving DecidableEq, Repr

/-- The candidate's branch locus is controlled. -/
def BranchLocusControlled (c : BranchCandidate) : Prop := c.branchLocusControlled = true
/-- A scalar Wilson species lift (Gate **C0**) is present. -/
def ScalarWilsonLifted (c : BranchCandidate) : Prop := c.scalarWilsonLifted = true
/-- The projected retained kernel is one-line. -/
def ProjectedKernelOneDim (c : BranchCandidate) : Prop := c.projectedKernelOneDim = true
/-- The projected kernel has aligned chirality (interface/projector *shape*). -/
def ProjectedChiralityAligned (c : BranchCandidate) : Prop := c.projectedChiralityAligned = true
/-- There is a genuine nonzero physical chiral index (the C1 *content*). -/
def ChiralIndexNonzero (c : BranchCandidate) : Prop := c.chiralIndexNonzero = true
/-- The retained physical sector is Krein-positive. -/
def ProjectedKreinPositive (c : BranchCandidate) : Prop := c.projectedKreinPositive = true
/-- Unwanted branches carry a true inverse-propagator mass gap. -/
def InversePropagatorGap (c : BranchCandidate) : Prop := c.inversePropagatorGap = true
/-- Unwanted branches are removed only by propagator zeros (the hazard route). -/
def PropagatorZeroRemoval (c : BranchCandidate) : Prop := c.propagatorZeroRemoval = true
/-- No gauge-charged branch is removed solely by a propagator zero. -/
def GhostSafe (c : BranchCandidate) : Prop := c.ghostSafe = true

instance (c : BranchCandidate) : Decidable (BranchLocusControlled c) := by
  unfold BranchLocusControlled; infer_instance
instance (c : BranchCandidate) : Decidable (ScalarWilsonLifted c) := by
  unfold ScalarWilsonLifted; infer_instance
instance (c : BranchCandidate) : Decidable (ProjectedKernelOneDim c) := by
  unfold ProjectedKernelOneDim; infer_instance
instance (c : BranchCandidate) : Decidable (ProjectedChiralityAligned c) := by
  unfold ProjectedChiralityAligned; infer_instance
instance (c : BranchCandidate) : Decidable (ChiralIndexNonzero c) := by
  unfold ChiralIndexNonzero; infer_instance
instance (c : BranchCandidate) : Decidable (ProjectedKreinPositive c) := by
  unfold ProjectedKreinPositive; infer_instance
instance (c : BranchCandidate) : Decidable (InversePropagatorGap c) := by
  unfold InversePropagatorGap; infer_instance
instance (c : BranchCandidate) : Decidable (PropagatorZeroRemoval c) := by
  unfold PropagatorZeroRemoval; infer_instance
instance (c : BranchCandidate) : Decidable (GhostSafe c) := by
  unfold GhostSafe; infer_instance

/-! ## §2  Requested guardrails: concrete non-implications

Each guardrail is witnessed by an explicit finite countermodel.  These are the
exact non-implications the task asked for. -/

/-- A C0 scalar lift with branch-locus control, projected one-line kernel,
aligned projected chirality and Krein positivity — but **no** physical chiral
index and **not** ghost-safe.  This is the "form without C1 content" trap. -/
def c0OnlyToy : BranchCandidate :=
  { branchLocusControlled := true
    scalarWilsonLifted := true
    projectedKernelOneDim := true
    projectedChiralityAligned := true
    chiralIndexNonzero := false
    projectedKreinPositive := true
    inversePropagatorGap := false
    propagatorZeroRemoval := true
    ghostSafe := false }

/-- A genuine C1-release candidate: all good bits set, the hazard route off. -/
def c1ReleaseToy : BranchCandidate :=
  { branchLocusControlled := true
    scalarWilsonLifted := true
    projectedKernelOneDim := true
    projectedChiralityAligned := true
    chiralIndexNonzero := true
    projectedKreinPositive := true
    inversePropagatorGap := true
    propagatorZeroRemoval := false
    ghostSafe := true }

/-- **Guardrail 1 — scalar branch lifting does not imply C1 chirality.**
There is a candidate with a scalar Wilson lift (C0 species health) that carries
no physical chiral index. -/
theorem scalarLift_not_chiralIndex :
    ∃ c : BranchCandidate, ScalarWilsonLifted c ∧ ¬ ChiralIndexNonzero c :=
  ⟨c0OnlyToy, by decide, by decide⟩

/-- **Guardrail 1 (universal form).**  Scalar Wilson lifting never entails a
nonzero physical chiral index. -/
theorem scalarLift_does_not_imply_chiralIndex :
    ¬ (∀ c : BranchCandidate, ScalarWilsonLifted c → ChiralIndexNonzero c) := by
  intro h; exact absurd (h c0OnlyToy (by decide)) (by decide)

/-- **Guardrail 2 — interface/projector shape does not imply a nonzero physical
index.**  A candidate can have a one-line projected kernel with aligned
projected chirality (the full "interface shape") yet zero physical index. -/
theorem projectorShape_not_physicalIndex :
    ∃ c : BranchCandidate,
      ProjectedKernelOneDim c ∧ ProjectedChiralityAligned c ∧ ¬ ChiralIndexNonzero c :=
  ⟨c0OnlyToy, by decide, by decide, by decide⟩

/-- **Guardrail 2 (universal form).** -/
theorem projectorShape_does_not_imply_physicalIndex :
    ¬ (∀ c : BranchCandidate,
        ProjectedKernelOneDim c ∧ ProjectedChiralityAligned c → ChiralIndexNonzero c) := by
  intro h; exact absurd (h c0OnlyToy ⟨by decide, by decide⟩) (by decide)

/-- **Guardrail 3 — projected chirality does not imply ghost safety.**
Aligned projected chirality is compatible with a ghost-zero-removal hazard. -/
theorem projectedChirality_not_ghostSafe :
    ∃ c : BranchCandidate, ProjectedChiralityAligned c ∧ ¬ GhostSafe c :=
  ⟨c0OnlyToy, by decide, by decide⟩

/-- **Guardrail 3 (universal form).** -/
theorem projectedChirality_does_not_imply_ghostSafe :
    ¬ (∀ c : BranchCandidate, ProjectedChiralityAligned c → GhostSafe c) := by
  intro h; exact absurd (h c0OnlyToy (by decide)) (by decide)

/-- A candidate exhibiting a true inverse-propagator gap **without** any
propagator-zero removal: the legal way to gap unwanted branches. -/
def gapNoRemovalToy : BranchCandidate :=
  { c1ReleaseToy with inversePropagatorGap := true, propagatorZeroRemoval := false }

/-- A candidate that removes branches by propagator zeros **without** a true
inverse-propagator gap: the illegal ghost-zero-filter route. -/
def removalNoGapToy : BranchCandidate :=
  { c0OnlyToy with inversePropagatorGap := false, propagatorZeroRemoval := true }

/-- **Guardrail 4 — a true inverse-propagator gap is distinct from
propagator-zero removal.**  The two notions are logically independent: each can
hold while the other fails. -/
theorem gap_distinct_from_propagatorZeroRemoval :
    (∃ c : BranchCandidate, InversePropagatorGap c ∧ ¬ PropagatorZeroRemoval c) ∧
    (∃ c : BranchCandidate, PropagatorZeroRemoval c ∧ ¬ InversePropagatorGap c) :=
  ⟨⟨gapNoRemovalToy, by decide, by decide⟩, ⟨removalNoGapToy, by decide, by decide⟩⟩

/-- **Guardrail 4 (non-equivalence form).**  `InversePropagatorGap` and
`PropagatorZeroRemoval` are not equivalent predicates. -/
theorem gap_ne_propagatorZeroRemoval :
    ¬ (∀ c : BranchCandidate, InversePropagatorGap c ↔ PropagatorZeroRemoval c) := by
  intro h; exact absurd ((h gapNoRemovalToy).mp (by decide)) (by decide)

/-! ## §3  The composite C1 release certificate

A *legal* C1 release proposal must hold **all six** separated bits jointly (and
must not lean on the propagator-zero-removal hazard route).  We define the
certificate, give a non-vacuity witness, and prove that **dropping any single
conjunct breaks it** — so none of the six is redundant and none alone suffices. -/

/-- The C1 release certificate: branch-locus control, a one-line projected
kernel, aligned projected chirality with a genuine nonzero physical index,
Krein positivity, a true inverse-propagator gap, ghost safety, and crucially
*no* reliance on propagator-zero removal. -/
structure C1ReleaseCertificate (c : BranchCandidate) : Prop where
  branch_locus_controlled : BranchLocusControlled c
  projected_kernel_one_dim : ProjectedKernelOneDim c
  projected_chirality_aligned : ProjectedChiralityAligned c
  chiral_index_nonzero : ChiralIndexNonzero c
  projected_krein_positive : ProjectedKreinPositive c
  inverse_propagator_gap : InversePropagatorGap c
  ghost_safe : GhostSafe c
  no_propagator_zero_removal : ¬ PropagatorZeroRemoval c

instance (c : BranchCandidate) : Decidable (C1ReleaseCertificate c) :=
  decidable_of_iff
    (BranchLocusControlled c ∧ ProjectedKernelOneDim c ∧ ProjectedChiralityAligned c ∧
     ChiralIndexNonzero c ∧ ProjectedKreinPositive c ∧ InversePropagatorGap c ∧
     GhostSafe c ∧ ¬ PropagatorZeroRemoval c)
    ⟨fun h => ⟨h.1, h.2.1, h.2.2.1, h.2.2.2.1, h.2.2.2.2.1, h.2.2.2.2.2.1,
               h.2.2.2.2.2.2.1, h.2.2.2.2.2.2.2⟩,
     fun h => ⟨h.branch_locus_controlled, h.projected_kernel_one_dim,
               h.projected_chirality_aligned, h.chiral_index_nonzero,
               h.projected_krein_positive, h.inverse_propagator_gap,
               h.ghost_safe, h.no_propagator_zero_removal⟩⟩

/-- **Non-vacuity.**  The certificate is satisfiable: `c1ReleaseToy` meets it. -/
theorem c1Release_nonvacuous : ∃ c : BranchCandidate, C1ReleaseCertificate c :=
  ⟨c1ReleaseToy, by decide⟩

/-- A C1 release implies a genuine physical chiral index (the content clause). -/
theorem c1Release_imp_chiralIndex {c : BranchCandidate}
    (h : C1ReleaseCertificate c) : ChiralIndexNonzero c := h.chiral_index_nonzero

/-- A C1 release implies ghost safety. -/
theorem c1Release_imp_ghostSafe {c : BranchCandidate}
    (h : C1ReleaseCertificate c) : GhostSafe c := h.ghost_safe

/-- A C1 release never rests on propagator-zero removal. -/
theorem c1Release_imp_noPropagatorZeroRemoval {c : BranchCandidate}
    (h : C1ReleaseCertificate c) : ¬ PropagatorZeroRemoval c := h.no_propagator_zero_removal

/-- **C0 species health is not a C1 release.**  `c0OnlyToy` has a scalar Wilson
lift (and several "shape" bits) but fails the C1 certificate.  This is the
explicit guard against relabelling C0 species health as Gate C release. -/
theorem c0_lift_not_c1_release :
    ∃ c : BranchCandidate, ScalarWilsonLifted c ∧ ¬ C1ReleaseCertificate c :=
  ⟨c0OnlyToy, by decide, by decide⟩

/-! ### Each conjunct of the certificate is load-bearing

For each of the eight clauses we exhibit a candidate that satisfies the other
seven but fails that one, hence fails the whole certificate.  This shows the
certificate has no redundant clause. -/

/-- Flip exactly one Boolean field of `c1ReleaseToy` so one clause fails. -/
theorem dropping_branchLocus_breaks :
    ∃ c, ¬ C1ReleaseCertificate c ∧ ¬ BranchLocusControlled c ∧
      ProjectedKernelOneDim c ∧ ChiralIndexNonzero c ∧ GhostSafe c :=
  ⟨{ c1ReleaseToy with branchLocusControlled := false }, by decide, by decide, by decide, by decide, by decide⟩

theorem dropping_oneLineKernel_breaks :
    ∃ c, ¬ C1ReleaseCertificate c ∧ ¬ ProjectedKernelOneDim c ∧ ChiralIndexNonzero c :=
  ⟨{ c1ReleaseToy with projectedKernelOneDim := false }, by decide, by decide, by decide⟩

theorem dropping_chiralIndex_breaks :
    ∃ c, ¬ C1ReleaseCertificate c ∧ ¬ ChiralIndexNonzero c ∧
      ProjectedChiralityAligned c ∧ ProjectedKernelOneDim c :=
  ⟨{ c1ReleaseToy with chiralIndexNonzero := false }, by decide, by decide, by decide, by decide⟩

theorem dropping_kreinPositive_breaks :
    ∃ c, ¬ C1ReleaseCertificate c ∧ ¬ ProjectedKreinPositive c ∧ ChiralIndexNonzero c :=
  ⟨{ c1ReleaseToy with projectedKreinPositive := false }, by decide, by decide, by decide⟩

theorem dropping_gap_breaks :
    ∃ c, ¬ C1ReleaseCertificate c ∧ ¬ InversePropagatorGap c ∧ ChiralIndexNonzero c :=
  ⟨{ c1ReleaseToy with inversePropagatorGap := false }, by decide, by decide, by decide⟩

theorem dropping_ghostSafe_breaks :
    ∃ c, ¬ C1ReleaseCertificate c ∧ ¬ GhostSafe c ∧ ChiralIndexNonzero c :=
  ⟨{ c1ReleaseToy with ghostSafe := false }, by decide, by decide, by decide⟩

/-- Turning *on* the propagator-zero-removal hazard route also breaks the
certificate, even with every other clause satisfied. -/
theorem turning_on_propagatorZeroRemoval_breaks :
    ∃ c, ¬ C1ReleaseCertificate c ∧ PropagatorZeroRemoval c ∧ ChiralIndexNonzero c ∧ GhostSafe c :=
  ⟨{ c1ReleaseToy with propagatorZeroRemoval := true }, by decide, by decide, by decide, by decide⟩

/-! ## §4  Matrix-valued spinor-line Wilson lift / branch involution slot

The lateral analysis lists, as one of the only legal C1 release routes, a
**matrix-valued spinor-line Wilson mass** / **explicit branch involution**
`T_br`.  Here we give that route an explicit, finite design slot and state the
**exact finite certificate** it must meet: it must *polarize* the
chirality-balanced branch lines (give them opposite, nonzero masses) while *not*
acting as a ghost-zero filter (it must leave a true inverse-propagator gap on
the bad branch `Π_bad`, rather than removing it by a propagator zero).

We model the two chirality-balanced branch lines by `Fin 2` (line `0 = +`,
line `1 = −`).  `T_br : Fin 2 → ℤ` is the diagonal of the matrix-valued
spinor-line Wilson mass on those lines; `piBadMass : ℤ` is the induced inverse
propagator (mass²-like) residue on the bad branch `Π_bad`.  Integers suffice to
separate "zero" from "nonzero" and to carry a sign. -/

/-- Finite design slot for a matrix-valued spinor-line Wilson lift / branch
involution `T_br`.  `tBr` is its action (a sign/mass) on each of the two
chirality-balanced branch lines; `piBadMass` is the resulting inverse-propagator
residue on the bad branch `Π_bad`. -/
structure SpinorLineWilsonLift where
  tBr : Fin 2 → Int
  piBadMass : Int

/-- `T_br` **polarizes** the branch lines: it gives the `+` and `−` lines
opposite, nonzero masses.  This is exactly the chirality-balance-breaking a bare
`D_+` lacks. -/
def PolarizesBranchLines (L : SpinorLineWilsonLift) : Prop :=
  L.tBr 0 = - L.tBr 1 ∧ L.tBr 0 ≠ 0

/-- `T_br` acts as a **ghost-zero filter**: it removes the bad branch by sending
its inverse propagator to zero (a propagator/determinant zero), the
Golterman–Shamir hazard. -/
def IsGhostZeroFilter (L : SpinorLineWilsonLift) : Prop := L.piBadMass = 0

/-- `T_br` leaves a **true inverse-propagator gap** on the bad branch: a nonzero
residue, i.e. it is *not* a ghost-zero filter. -/
def TrueGapOnBad (L : SpinorLineWilsonLift) : Prop := L.piBadMass ≠ 0

instance (L : SpinorLineWilsonLift) : Decidable (PolarizesBranchLines L) := by
  unfold PolarizesBranchLines; infer_instance
instance (L : SpinorLineWilsonLift) : Decidable (IsGhostZeroFilter L) := by
  unfold IsGhostZeroFilter; infer_instance
instance (L : SpinorLineWilsonLift) : Decidable (TrueGapOnBad L) := by
  unfold TrueGapOnBad; infer_instance

/-- **The exact finite certificate the C1 Wilson route must meet.**

A matrix-valued spinor-line Wilson lift `T_br` is a *legal branch polarizer* iff
it polarizes the chirality-balanced branch lines **and** gaps the bad branch by
a true inverse-propagator gap rather than a ghost-zero filter.  This is the
finite theorem a future operator-level module must discharge for the actual
`T_br`/`Π_bad` of the null-edge symbol. -/
def LegalBranchPolarizer (L : SpinorLineWilsonLift) : Prop :=
  PolarizesBranchLines L ∧ TrueGapOnBad L

instance (L : SpinorLineWilsonLift) : Decidable (LegalBranchPolarizer L) := by
  unfold LegalBranchPolarizer; infer_instance

/-- Concrete legal polarizer: opposite unit masses on the two lines and a
nonzero residue on `Π_bad`. -/
def legalPolarizerWitness : SpinorLineWilsonLift :=
  { tBr := fun i => if i = 0 then 1 else -1, piBadMass := 2 }

/-- An illegal ghost-zero filter: it still polarizes the two lines, but kills
the bad branch by a propagator zero (`piBadMass = 0`). -/
def ghostFilterWitness : SpinorLineWilsonLift :=
  { tBr := fun i => if i = 0 then 1 else -1, piBadMass := 0 }

/-- **The Wilson route is non-vacuous.**  A legal branch polarizer exists. -/
theorem legalBranchPolarizer_nonvacuous :
    ∃ L : SpinorLineWilsonLift, LegalBranchPolarizer L :=
  ⟨legalPolarizerWitness, by decide⟩

/-- **Polarization does not imply legality / is distinct from ghost filtering.**
A lift can polarize the branch lines yet still be a ghost-zero filter — so
"polarizes branch lines" is *not* by itself a safe C1 ingredient. -/
theorem polarization_not_ghostSafe :
    ∃ L : SpinorLineWilsonLift, PolarizesBranchLines L ∧ IsGhostZeroFilter L :=
  ⟨ghostFilterWitness, by decide, by decide⟩

/-- A legal branch polarizer is, by definition, **not** a ghost-zero filter:
this is the precise sense in which `T_br` "polarizes branch lines without being a
ghost-zero filter". -/
theorem legalPolarizer_not_ghostFilter {L : SpinorLineWilsonLift}
    (h : LegalBranchPolarizer L) : ¬ IsGhostZeroFilter L := by
  intro hf; exact h.2 hf

/-- Polarization and ghost-zero filtering are logically independent: there is a
polarizing legal lift (gap, no filter) and a polarizing illegal lift (filter,
no gap). -/
theorem polarization_independent_of_ghostFilter :
    (∃ L : SpinorLineWilsonLift, PolarizesBranchLines L ∧ ¬ IsGhostZeroFilter L) ∧
    (∃ L : SpinorLineWilsonLift, PolarizesBranchLines L ∧ IsGhostZeroFilter L) :=
  ⟨⟨legalPolarizerWitness, by decide, by decide⟩, ⟨ghostFilterWitness, by decide, by decide⟩⟩

/-! ## §5  Alternatives table and prioritized next-theorem list

This is the required closing summary.  It is **C1-facing**: every row is about
chiral release, not C0 species health.

### Alternatives table (legal C1 release routes, per the lateral analysis)

```text
| route                              | encoded slot in this file              | finite certificate to discharge                    | open operator-level obligation                          |
|------------------------------------|----------------------------------------|----------------------------------------------------|---------------------------------------------------------|
| boundary inflow                    | C1ReleaseCertificate (index clause)    | ChiralIndexNonzero from boundary index inflow      | inflow index = bulk branch imbalance (Stokes-type)      |
| overlap / sign projection          | ProjectedChiralityAligned + index      | projector gives one-line kernel + nonzero index    | locality of the sign/overlap kernel (NOT assumed here)  |
| controlled non-ultralocality       | InversePropagatorGap                   | true gap on unwanted branches, no propagator zero  | bounded non-ultralocal tail preserves covariance        |
| matrix-valued spinor-line Wilson   | LegalBranchPolarizer (§4)              | PolarizesBranchLines ∧ TrueGapOnBad                | actual T_br/Π_bad of null-edge symbol meets it          |
| explicit branch involution         | LegalBranchPolarizer (§4, T_br)        | involution polarizes lines, leaves Krein-pos sector| involution is covariant + ghost-safe on gauge branches  |
```

### What is proved here (guardrails), and what is deliberately *not*

Proved: the six data bits are independent (`scalarLift_*`, `projectorShape_*`,
`projectedChirality_*`, `gap_*`); the C1 certificate is non-vacuous with no
redundant clause (`c1Release_nonvacuous`, `dropping_*`, `turning_on_*`); C0
species health is not a C1 release (`c0_lift_not_c1_release`); and the
matrix-valued Wilson / branch-involution slot has an exact legality certificate
that separates polarization from ghost-zero filtering (`§4`).

Not claimed (explicit non-goals): full Gate C release; physical
overlap/domain-wall success; anomaly cancellation; locality of any nonlocal sign
function (the overlap row above *names* this as an unassumed obligation).

### Prioritized next-theorem list (C1)

1. **`LegalBranchPolarizer` for the actual symbol.**  Replace the toy
   `SpinorLineWilsonLift` with the real matrix-valued spinor-line Wilson mass
   `T_br` and the real `Π_bad(q)` of the null-edge Dirac symbol, and prove
   `PolarizesBranchLines ∧ TrueGapOnBad`.  Highest leverage, most self-contained.
2. **Operator-supplied `ChiralIndexNonzero`.**  Show the retained one-line
   kernel carries a nonzero physical chiral index, computed from the operator
   (the C19 `OperatorForcesAlignment`-style obligation, but for the *physical*
   projected sector).
3. **`ProjectedKreinPositive` for the retained sector.**  Prove the polarized
   physical sector is Krein-positive (ties to `NullEdgeBranchKreinSignatures`).
4. **Covariance + ghost safety of `T_br`.**  Show the branch involution is
   gauge-covariant and removes no gauge-charged branch by a propagator zero
   (ties to `NullEdgeGateCGhostZeroSafety`).
5. **Overlap-route locality (only if pursued).**  If the sign/overlap route is
   chosen instead, the named, currently-unassumed obligation is locality of the
   sign kernel; state and quarantine it explicitly before use.
-/

end PhysicsSM.Draft.NullEdgeBranchLocusPhysicalSectorAPI
