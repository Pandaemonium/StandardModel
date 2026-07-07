# Correction: finite one-form center-symmetry shadow (GateYM lane)

Status: strategy/audit correction. No code was edited. This supersedes §0 and §5
of the prior `REPORT.md` and revises §3; the substantive audit (§1, §2, §4)
stands. All Lean below are *proposals*, not landed code.

Files re-inspected in this package:

- `PhysicsSM/Draft/NullEdge/GateYM/CenterFluxSector.lean` — self-contained
  (imports only Mathlib); compiles.
- `PhysicsSM/Draft/NullEdge/GateYM/FluxSectorGeneral.lean` — self-contained;
  compiles.
- `PhysicsSM/Draft/NullEdge/GateYM/TYAreaLawSUN.lean` — abstract `TwistSystem N`,
  ratios, `pN`, `tyBaseSUN`, `tyAreaLawSUN`, `tyBaseSUN_two_landed`.
- `PhysicsSM/Draft/NullEdge/GateYM/TYTwistSystemZ2.lean` — concrete
  `z2TwistSystem : TwistSystem 2` with `Z_le` **derived**, `z2AreaLaw`,
  `z2_tyBaseSUN_eq_tyBase`.
- `TYAreaLaw.lean` (now supplied) — abstract `tyBaseOf`/`tyStringTensionOf`
  layer, concrete one-plaquette `Zplus`/`Zminus`, `partitionRatio_eq_tanh`,
  `tyBase`, and the spectral-gap tie-back.

---

## 0. Retraction of the "missing `TYAreaLaw` / build blocker" finding

**Retracted.** The prior report's decisive §0 claim — that
`PhysicsSM/Draft/NullEdge/GateYM/TYAreaLaw.lean` was *absent from the repository*
and therefore the whole TY sub-lane (`z2AreaLaw`, `tyBaseSUN_two_landed`,
`z2_tyBaseSUN_eq_tyBase`, …) was not kernel-checked — was an artifact of an
incomplete staged package handed to the prior run, **not a repository fact**.

Correction, per the uploader's local verification in the real tree:

- `Test-Path …/GateYM/TYAreaLaw.lean` ⇒ `True`;
- `lake env lean …/TYAreaLawSUN.lean` and `…/TYTwistSystemZ2.lean` ⇒ pass;
- `lake build` ⇒ pass.

Accordingly, the `import PhysicsSM.Draft.NullEdge.GateYM.TYAreaLaw` lines in
`TYAreaLawSUN.lean` and `TYTwistSystemZ2.lean` resolve, and the TY area-law
results **are** kernel-checked in the real repository. Any downstream planning
that was gated on "restore `TYAreaLaw.lean`" is dropped as spurious.

Honest caveat about *this* package (does not affect the retraction): the file was
re-staged at the repo *root* (`./TYAreaLaw.lean`), not inside the `GateYM`
directory, and `TYAreaLaw.lean` itself further imports
`PhysicsSM.Draft.NullEdge.GateYM.OSReconstruction`, which is still not staged
here. So I could not independently re-run `lake build` inside this snapshot; the
retraction rests on the uploader's real-tree verification, which I accept. The
prior stale-check should have flagged "package incomplete — cannot build" rather
than asserting "file absent from the repository." Lesson for the run ledger:
distinguish *staging omission* from *repository fact* before promoting a
build-blocker to a decisive finding.

---

## 1-2. Substantive one-form strategy (preserved, with one sketch correction)

The truth audit is unchanged and was never coupled to the TY files: it sits
entirely on `CenterFluxSector.lean`, which compiles standalone.

**Verdict (unchanged):** it is honest to call the center-shift/electric-sector
layer a *finite shadow of the electric one-form center symmetry*, scoped to the
operator/action side. Faithfully modeled: the center-shift permutations as the
one-form operators on the two 1-cycles of the finite 2-torus and their manifest
invariance of every plaquette (Wilson) holonomy (`plaquetteHol_xFluxShift`,
`plaquetteHol_yFluxShift`), plus abstract superselection bookkeeping. Still NOT
modeled (must not be claimed): the charged line object, the `Z(G)` group law on
the operators, homology/deformation invariance, a populated (non-vacuous) sector
label, `H^2(K,Z(G))`/background gauging, and all dynamics.

**Correction to the prior §2a sketch (important).** The prior report wrote the
Wilson/Polyakov line as a `Finset.prod`, `∏ i : Fin Lx, U.hLink i j`. That does
**not** type-check for the intended nonabelian `G`: `Finset.prod` needs
`CommMonoid`. A Wilson line is an **ordered** product and must be a `List.prod`
over `List.finRange`. The charge identity still holds (a *central* factor pulls
out of an ordered product regardless of position and appears exactly once,
because `List.finRange Lx` is `Nodup` and contains `i0` once). The corrected,
validated statements are in §4 below.

Everything else in the prior §2 (group-law lemmas `xFluxShift_mul`/`_one`,
cycle commutation, the opposite-pair deformation lemma, the deferred non-vacuous
sector witness) stands, with `xLineHol`/`yLineHol` reinterpreted as `List.prod`.

Non-claim docstring language (prior §4): keep verbatim.

---

## 3. TY connection (revised, now that the TY files are known to build)

Two things change relative to the prior report:

1. **The build blocker is gone**, so the TY area-law API is live provenance, not
   a broken import.
2. **A concrete finite `TwistSystem` constructor already exists.**
   `TYTwistSystemZ2.z2TwistSystem : TwistSystem 2` is a *derived* instance:
   `Z_nonneg`, `Z_zero_pos`, and the RP-monotonicity `Z_le` are all proved
   (`Z2Twist_le`), and `z2_tyBaseSUN_eq_tyBase` shows it reproduces exactly the
   `TYAreaLaw.tyBase β`. So the prior claim "the connecting object does not
   exist" was too strong: the *value-level* finite twist system exists and is
   kernel-checked.

**What is still genuinely missing** is the bridge from the *configuration/operator*
layer (`TorusLinkFieldG`, `xFluxShift`) to the *partition-function* layer
(`TwistSystem`). `z2TwistSystem` is built from the one-plaquette Boltzmann
scalars `Zplus β = e^β + e^{-β}`, `Zminus β = e^β − e^{-β}` — **not** from a sum
over `TorusLinkFieldG` configurations with a center-twisted boundary condition.
Nothing yet identifies `Z k` with a Boltzmann sum over the very configurations
the center shifts act on. Until that constructor exists, "the TY area-law base
*is* the center-symmetry layer" remains a slogan, not a theorem.

**Recommendation:** keep the `TwistSystem`/area-law API as a *separate provenance
bridge for now*, but the honest tie-in is smaller than previously stated: it is a
single missing definition plus two identifications (see §4, Job B). Do not assert
the tie until that object is built.

The exact missing object:

```lean
/-- Center-twisted Boltzmann partition function over the finite torus link
fields: `Z^{[k]}` sums `exp(-β · plaquetteAction)` over configurations carrying a
`k`-fold center twist on one cycle. Building this and proving `Z 0` = periodic
sum and the RP-monotonicity `Z k ≤ Z 0` is what turns `z2TwistSystem` into an
object *derived from the center shifts*, not one bundling one-plaquette scalars. -/
noncomputable def torusTwistedPartition
    (β : ℝ) (act : G → ℝ) (k : Fin N) : ℝ := sorry
```

Nonabelian SU(N) `Z_le` from an actual Haar-measure reflection-positivity
argument remains the documented open C-gate in `TYAreaLawSUN.lean`; that is
unchanged.

---

## Ranked next jobs (revised)

Job 1 of the prior report ("restore `TYAreaLaw.lean`") is **deleted** as
spurious. Revised ranking:

1. **[Prove now — smallest honest finite identity] Charged Wilson/Polyakov line
   lemmas.** `xLineHol`/`yLineHol` as ordered `List.prod`s and the
   charge/neutrality lemmas. Upgrades "symmetry of the action" to "one-form
   symmetry with a charged object" and pins the abstract `character` to a genuine
   center character. Self-contained on `CenterFluxSector.lean` (Mathlib-only).
   Statement and proof validated below. **This stays the first proof target.**

2. **[Prove now — cheap] Center-group action + deformation lemmas.**
   `xFluxShift_mul`, `xFluxShift_one`, x/y cycle commutation, and the
   opposite-column deformation triviality. Establishes the `Z(G)` group structure
   and the homology-triviality shadow. Self-contained.

3. **[Then] Non-vacuous electric-sector witness.** Constrain `character` to a
   genuine center character and exhibit a state with nontrivial electric flux via
   `xLineHol`. Prevents the vacuous-`character ≡ 1` scope trap. Depends on Job 1.

4. **[Deferred — the real tie, now smaller than before] Configuration↔partition
   bridge `torusTwistedPartition` (§3).** Define the center-twisted Boltzmann sum
   over `TorusLinkFieldG` and prove it yields a `TwistSystem` whose `Z` is that
   sum (Z2/Zn first), with `Z 0` = periodic and `Z_le`. Only this makes "TY base
   ≡ center-symmetry layer" a theorem. Note: the *value-level* `TwistSystem`
   already exists (`z2TwistSystem`), so this job is now purely the bridge, not a
   from-scratch twist system. Nonabelian SU(N) `Z_le` stays the open C-gate.

### Decision on the prompt's specific question

> Should the first proof target still be the charged Wilson/Polyakov line
> transformation, or should a finite `TwistSystem` constructor/tie-in move up?

**Keep the charged Wilson/Polyakov line lemmas as the first target.** Reasons:
(a) a finite `TwistSystem` *constructor* already exists (`z2TwistSystem`), so
there is nothing to "move up" on that front; (b) the remaining TwistSystem work
is the configuration↔partition *bridge*, which is strictly larger and depends on
choosing a plaquette action on `TorusLinkFieldG`; (c) the charged-line lemmas are
self-contained, low-risk, validated (below), and they are precisely what makes
the word "one-form" accurate rather than aspirational. Do Job 1, then Job 2, then
schedule Job 4 as its own effort.

---

## 4. Exact Lean statement sketches for the top 2 jobs

File: `PhysicsSM/Draft/NullEdge/GateYM/CenterOneFormLine.lean`
(`import Mathlib` + `import PhysicsSM.Draft.NullEdge.GateYM.CenterFluxSector`),
namespace `PhysicsSM.Draft.NullEdge.GateYM.CenterFluxSector`.

### Job 1 — charged noncontractible line operators (validated)

The line is an **ordered** product (`List.prod` over `List.finRange`), not a
`Finset.prod`. The following statements and proofs were checked to compile
against Mathlib (nonabelian `G`).

```lean
variable {G : Type*} [Group G] {Lx Ly : Nat}

/-- Ordered Polyakov/Wilson line wrapping the x-cycle at row `j`. -/
def xLineHol (U : TorusLinkFieldG G Lx Ly) (j : Fin Ly) : G :=
  ((List.finRange Lx).map (fun i => U.hLink i j)).prod

/-- Ordered Wilson line wrapping the y-cycle at column `i`. -/
def yLineHol (U : TorusLinkFieldG G Lx Ly) (i : Fin Lx) : G :=
  ((List.finRange Ly).map (fun j => U.vLink i j)).prod

/-- General helper: a central factor tagged onto the `i0` entry of an ordered
mapped product pulls out as `z ^ (count i0)`.  (Proved by list induction using
`Commute g (z^m)` for central `z`.) -/
theorem prod_central_tag {α : Type*} [DecidableEq α]
    (z : Subgroup.center G) (i0 : α) (l : List α) (f : α → G) :
    ((l.map (fun i => if i = i0 then (z : G) * f i else f i)).prod)
      = (z : G) ^ (l.count i0) * (l.map f).prod := by sorry

/-- **Charge identity.**  The x-line picks up exactly one central factor `z`
under the transverse x-flux shift (`count i0 (finRange Lx) = 1`). -/
theorem xLineHol_xFluxShift (z : Subgroup.center G) (i0 : Fin Lx)
    (U : TorusLinkFieldG G Lx Ly) (j : Fin Ly) :
    xLineHol (xFluxShift z i0 U) j = (z : G) * xLineHol U j := by sorry

/-- **Neutrality.**  The x-line is invariant under the parallel (y-row) shift,
which touches only vertical links. -/
theorem xLineHol_yFluxShift (z : Subgroup.center G) (j0 : Fin Ly)
    (U : TorusLinkFieldG G Lx Ly) (j : Fin Ly) :
    xLineHol (yFluxShift z j0 U) j = xLineHol U j := by sorry  -- `rfl`

/-- Symmetric pair for the y-line. -/
theorem yLineHol_yFluxShift (z : Subgroup.center G) (j0 : Fin Ly)
    (U : TorusLinkFieldG G Lx Ly) (i : Fin Lx) :
    yLineHol (yFluxShift z j0 U) i = (z : G) * yLineHol U i := by sorry

theorem yLineHol_xFluxShift (z : Subgroup.center G) (i0 : Fin Lx)
    (U : TorusLinkFieldG G Lx Ly) (i : Fin Lx) :
    yLineHol (xFluxShift z i0 U) i = yLineHol U i := by sorry  -- `rfl`
```

Validated proof of `prod_central_tag` (the load-bearing lemma), for the prover to
reuse verbatim:

```lean
  have hcz : ∀ (g : G) (m : ℕ), Commute g ((z : G) ^ m) := fun g m =>
    (Commute.pow_right (Subgroup.mem_center_iff.mp z.2 g) m)
  induction l with
  | nil => simp
  | cons a t ih =>
    simp only [List.map_cons, List.prod_cons, ih, List.count_cons]
    by_cases ha : a = i0
    · subst ha
      simp only [beq_self_eq_true, if_true]
      rw [← mul_assoc, mul_assoc (z : G) (f a), (hcz (f a) (t.count a)).eq,
        ← mul_assoc, ← mul_assoc, ← pow_succ']
    · have hb : (a == i0) = false := by simpa [beq_iff_eq] using ha
      simp only [if_neg ha, hb, Bool.false_eq_true, if_false, add_zero]
      rw [← mul_assoc, (hcz (f a) (t.count i0)).eq, mul_assoc]
```

`xLineHol_xFluxShift` then follows by `rw [xLineHol, xFluxShift]; rw
[prod_central_tag]; rw [List.count_finRange]; simp` (checked). The neutrality
lemmas are `rfl` because the shifted field's `hLink`/`vLink` component is
definitionally unchanged.

### Job 2 — center-group action + deformation lemmas

```lean
/-- Center shifts on one column compose according to `Z(G)`. -/
theorem xFluxShift_mul (z z' : Subgroup.center G) (i0 : Fin Lx)
    (U : TorusLinkFieldG G Lx Ly) :
    xFluxShift z i0 (xFluxShift z' i0 U) = xFluxShift (z * z') i0 U := by sorry

theorem xFluxShift_one (i0 : Fin Lx) (U : TorusLinkFieldG G Lx Ly) :
    xFluxShift (1 : Subgroup.center G) i0 U = U := by sorry

/-- x- and y-cycle operators commute. -/
theorem xFluxShift_yFluxShift_comm (z w : Subgroup.center G)
    (i0 : Fin Lx) (j0 : Fin Ly) (U : TorusLinkFieldG G Lx Ly) :
    xFluxShift z i0 (yFluxShift w j0 U) = yFluxShift w j0 (xFluxShift z i0 U) := by sorry

/-- **Deformation triviality.**  Two opposite center shifts on distinct columns
leave every x-line unchanged (`z · z⁻¹ = 1`): the finite shadow of "a
homologically trivial support acts trivially on charged lines". -/
theorem xLineHol_xFluxShift_pair (z : Subgroup.center G) (i0 i1 : Fin Lx)
    (U : TorusLinkFieldG G Lx Ly) (j : Fin Ly) :
    xLineHol (xFluxShift z i0 (xFluxShift z⁻¹ i1 U)) j = xLineHol U j := by sorry
```

Provability: `xFluxShift_mul`/`_one`/`comm` are `ext`-plus-`by_cases` field
identities (the group-law versions reduce to `mul_assoc` on the tagged
component). `xLineHol_xFluxShift_pair` follows from Job 1: two applications of
`xLineHol_xFluxShift` give `z * (z⁻¹ * xLineHol U j)`, then `mul_inv_cancel`.
(Note: `xFluxShift z i0 ∘ xFluxShift z⁻¹ i1` with `i0 = i1` collapses to
`xFluxShift (z * z⁻¹) i0 = xFluxShift 1 i0 = id` via Job 2's `_mul`/`_one`; with
`i0 ≠ i1` it is the genuine two-support cancellation. Both give the identity on
`xLineHol`, so no `i0 ≠ i1` hypothesis is needed.)

Optionally, once `xFluxShift_mul`/`_one` are proven, package
`z ↦ xFluxShiftEquiv z i0` as a `MonoidHom (Subgroup.center G)
(Equiv.Perm (TorusLinkFieldG G Lx Ly))`.

---

## 5. Non-claim discipline (unchanged, still binding)

Every file in this layer must keep the prior §4 phrases. In particular, do not
claim, unless the named object is explicitly constructed: continuum confinement;
a continuum one-form symmetry; spontaneous symmetry breaking or an
area-vs-perimeter order-parameter dichotomy; Ward identities / correlation-function
selection rules; 't Hooft anomaly or anomaly inflow; or an `H^2(K, Z(G))`
cohomology class / classical 2-form background field / gauging. "Flux" denotes
only the finite center-shift label; provenance references (GKSW arXiv:1412.5148;
Tomboulis–Yaffe 1985 [N7SIEMAC]; Kanazawa [K9FIBTZC]) are framing/notation, not
proof inputs. The nonabelian SU(N) Haar-measure twisted partition function and
its RP-monotonicity remain hypotheses / open.

---

## Bottom line

- The "missing `TYAreaLaw` / build blocker" finding is retracted; the TY files
  build in the real repository.
- The one-form strategy is unchanged in substance; the only correction is that
  the charged line must be an ordered `List.prod`, not a `Finset.prod`.
- First proof target is unchanged: the charged Wilson/Polyakov line lemmas
  (Job 1), validated above. A finite `TwistSystem` constructor already exists
  (`z2TwistSystem`); what remains on that side is the configuration↔partition
  bridge (Job 4, deferred), not a new twist system.
