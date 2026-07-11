# Hostile semantic audit — `SpinorTenfoldWeakQuotient.lean`

**Scope of audit.** Verbatim source of `SpinorTenfoldWeakQuotient.lean` plus its
sole upstream `SpinorTenfoldColorAxis.lean`. No new theorems were proved. The
`PhysicsSM.*` sources are not present in this project tree, so the audit is a
close reading of the pasted kernel text and its docstrings; kernel *validity* of
the proofs is assessed structurally, not re-run.

---

## 0. Verdict

**PASS WITH REQUIRED SCOPE EDITS.**

The mathematics is valid and non-vacuous. Every "must-not-be-inferred" physics
claim (SU(2)_L, hypercharge, chirality, generations, SM representation, descended
stabilizer action) is **absent** from the theorem statements, and the target
file contains an explicit, honest claim-boundary paragraph. No HIGH issue. The
required edits are manuscript-facing: (a) suggestive "weak" nomenclature
pre-loads the SU(2)_L reading; (b) the `C^2` identification is coordinate/basis
dependent and this is not flagged where "no choice of a complementary subspace"
is asserted; (c) the upstream prose asserts a stabilizer action that no theorem
formalizes.

---

## 1. Do all theorem statements support the intended reading? — YES

Intended reading: *from the fixed ordered pair, `N1/(N1 ∩ N2)` is a derived
2-dim complex space with an explicit linear equivalence to `C^2` and a concrete
nonzero class.* The statements deliver exactly this and nothing more:

- `colorAxisInVacuum` = comap of `colorAxisSubmodule` (= `N1 ⊓ N2`) along the
  inclusion `N1 ↪ V10`: the copy of `N1 ∩ N2` **inside** `N1`. Correct object.
- `finrank_colorAxisInVacuum = 3`, `finrank_annihilator_vacuumSpinor = 5`
  (upstream), `finrank_weakQuotient = 2` via
  `Submodule.finrank_quotient_add_finrank` (5 − 3 = 2). Sound dimension count.
- `weakQuotient := N1 ⧸ colorAxisInVacuum`. Genuine quotient, not a complement.
- `weakDirection3_class_ne_zero`: concrete nonzero class. Real (see §2).
- `weakQuotientLinearEquivC2`: explicit `≃ₗ[Complex]` to `Fin 2 → Complex`.

No statement mentions a group, an action, hypercharge, chirality, a generation,
or an SM representation. The intended reading is supported and **not exceeded**
at the kernel level.

## 2. Is the quotient equivalence valid and non-vacuous? — YES

- **Nonzero class.** `weakDirection3 = (0, e_3)` lies in `N1` (creation half
  zero ⇒ `mem_annihilator_vacuumSpinor_iff`). `weakDirection3_not_mem_colorAxis`
  uses `mem_colorAxis_iff` whose `IsColorAxisVector` forces coordinate `3 = 0`,
  contradicting the value `1`. Hence `Quotient.mk weakDirection3 ≠ 0`. The
  quotient is genuinely nontrivial — **not vacuous**.
- **Surjectivity.** `weakCoordinates : N1 → (Fin 2 → C)`, `v ↦ (v.2 3, v.2 4)`,
  is split by `weakCoordinatesInv`; `fin_cases` discharges both fibers. Honest
  surjection onto `C^2`.
- **Kernel.** `weakCoordinates_ker : ker = colorAxisInVacuum`. This is the load-
  bearing step and it is correct: for `v ∈ N1` the creation half is already `0`
  (annihilator characterization), so `IsColorAxisVector` reduces to
  `coord3 = coord4 = 0`, which is exactly the kernel condition. No hidden gap —
  the `v.1 = 0` clause of `IsColorAxisVector` is supplied automatically by
  membership in `N1`, not assumed away.
- **Assembly.** `weakQuotientLinearEquivC2 = quotEquivOfEq ∘ quotKerEquivOfSurjective`
  is the standard first-isomorphism composite. Valid.

So the `C^2` equivalence is mathematically valid, and the 2-dimensionality is
witnessed by an actual surjection with an actual nonzero class — non-hollow.

## 3. Canonicality claimed beyond the fixed pair / chosen coordinates? — PARTIAL OVERREACH (MEDIUM)

- **Correct claim:** the *quotient object* `weakQuotient = N1/(N1 ∩ N2)` is
  canonical once the ordered pair is fixed (no complement chosen). The module
  docstring's "the quotient is canonical once the ordered marked spinor pair is
  fixed" is accurate.
- **Overreach:** the *identification with `C^2`* (`weakQuotientLinearEquivC2`)
  is **not** canonical — `weakCoordinates` reads the specific ambient indices
  `{3,4}`, a basis/labeling choice inherited from the normal form
  `ψ₂ = e_3 ∧ e_4`. Its docstring — "linearly equivalent to `C^2`, **with no
  choice of a complementary subspace**" — is literally true (a quotient, not a
  complement) but invites the reader to conclude the `C^2` iso is basis-free. It
  is not: it is canonical only up to `GL(2)` change of the weak coordinates. See
  §7 for the required edit.

## 4. Do docstrings outrun the kernel? — MOSTLY NO, WITH NAMING CAVEAT (MEDIUM)

- The **claim-boundary paragraph** is exemplary and correctly disclaims: no
  descended stabilizer action, no SU(2)_L identification, no hypercharge, no full
  SM stabilizer theorem. Docstrings do **not** assert any of the forbidden
  physics conclusions.
- **Nomenclature leak (MEDIUM):** every derived name — `weakQuotient`,
  `weakDirection3`, `weakCoordinates`, `weakCoordinatesInv`, "canonical weak
  candidate", "weak direction", "two residual annihilation coordinates" — encodes
  the *conclusion* (this 2-space is the SU(2)_L weak doublet space) that the file
  explicitly says it has **not** proved. In a publication, readers cite names and
  section headings, not disclaimer paragraphs. "weak" is doing interpretive work
  the kernel does not license. It is guarded ("candidate", boundary paragraph),
  so this is MEDIUM, not HIGH — but it must be re-scoped in prose (see §7).

## 5. Hidden assumptions / convention drift / vacuity / hollow telescoping / false shape

- **Convention pin (LOW, disclosed):** the whole construction is tied to the
  Krasnov normal-form pair (`ψ₁ = 1`, `ψ₂ = e_3 ∧ e_4`), so "color = `{0,1,2}`",
  "weak = `{3,4}`" are conventions, not invariants. Disclosed upstream; acceptable
  if §7 edits are applied.
- **Ordering dependence (LOW, disclosed):** `N1` is `vacuumSpinor`'s annihilator;
  swapping the ordered pair changes the quotient. Docstrings say "ordered", good.
- **Vacuity:** none. Nonzero class + surjection rule out a vacuous `C^2`.
- **Hollow telescoping:** `colorAxisInVacuumEquiv` is a trivial subtype re-wrap,
  but it is legitimately used only to transport `finrank`. Not hollow.
- **False shape:** none. Names say "weak" (interpretive), but the *shapes* of the
  statements (finrank = 2, `≃ₗ C^2`, nonzero class) match their proofs exactly.
- **Upstream docstring outruns its kernel (MEDIUM, upstream):**
  `SpinorTenfoldColorAxis` prose says the color axis is the 3-plane "on which the
  Standard Model stabilizer acts by its color factor." No stabilizer, group
  action, or "acts by color" theorem exists in the pasted code — this is an
  interpretive assertion in a "trusted" module. It feeds the intended reading of
  the target and should be marked as motivation, not result.

## 6. Issue classification

| # | Issue | Where | Severity |
|---|-------|-------|----------|
| 1 | "weak" nomenclature throughout pre-loads the unproved SU(2)_L identification | target, all names/headings | MEDIUM |
| 2 | `C^2` identification is coordinate/basis dependent; "no choice of a complementary subspace" invites a false canonicality read | target, `weakQuotientLinearEquivC2` docstring | MEDIUM |
| 3 | "Standard Model stabilizer acts by its color factor" asserted with no formalized action | upstream `SpinorTenfoldColorAxis` docstring | MEDIUM |
| 4 | Normal-form / index conventions ({0,1,2} color, {3,4} weak) are conventions, not invariants | both, disclosed | LOW |
| 5 | Ordered-pair dependence of the quotient | target, disclosed | LOW |

No HIGH issues: no theorem statement or docstring in the target *asserts* a
descended action, SU(2)_L, hypercharge, chirality, generation, or SM
representation as proved.

## 7. Exact replacement prose for overbroad statements

**(a) `weakQuotientLinearEquivC2` docstring — replace:**
> The weak quotient derived from the marked pair is linearly equivalent to `C^2`,
> with no choice of a complementary subspace.

**with:**
> The quotient `N1 / (N1 ∩ N2)` is linearly equivalent to `C^2`. The quotient
> *object* is canonical given the ordered pair (no complement is chosen), but
> this particular equivalence is **not** canonical: it is the coordinate map
> reading the ambient annihilation indices `{3,4}` fixed by the normal form
> `ψ₂ = e_3 ∧ e_4`, and is defined only up to `GL(2,C)` change of those two
> coordinates. No basis-free identification with `C^2` is claimed.

**(b) `weakQuotient` docstring — replace "The canonical weak candidate ... " with:**
> The 2-dimensional quotient `N1 / (N1 ∩ N2)` derived from the ordered marked
> pair. The label "weak" is a **motivational** name only: nothing here endows it
> with an SU(2)_L action or identifies it with the physical weak doublet space.

**(c) Add to the module-level claim boundary (target), one line:**
> Naming caveat: the tokens "weak" in `weakQuotient`, `weakDirection3`,
> `weakCoordinates` are physics-motivated labels, not proved identifications;
> the results below are statements about the vector-space quotient alone.

**(d) Upstream `SpinorTenfoldColorAxis` docstring — replace:**
> the isotropic 3-plane `N₁ ∩ N₂`, on which the Standard Model stabilizer acts
> by its color factor.

**with:**
> the isotropic 3-plane `N₁ ∩ N₂`. (The interpretation of this 3-plane as the
> `SU(3)` color factor of a Standard Model stabilizer is **motivation**; no
> stabilizer group, action, or "acts by color" statement is formalized in this
> module.)

## 8. Smallest next theorem for an honest SU(2)_L claim

The gap between what is proved (a 2-dim quotient `≃ C^2`) and an SU(2)_L claim is
an *action that descends and is identified*. The smallest honest next step is
**not** SU(2) yet — it is the well-definedness of a descended action:

> **Next theorem (stabilizer preserves the color axis, enabling descent).**
> Let `G` be the stabilizer in `Spin(10)` (or its Lie algebra `so(10)`) of the
> ordered pair `(vacuumSpinor, weakSpinor)`, acting on `V10` and hence on
> `N1 = annihilator vacuumSpinor`. Prove
> `∀ g ∈ G, g • colorAxisInVacuum ⊆ colorAxisInVacuum`
> (equivalently, the induced map on `N1` maps `N1 ∩ N2` into itself). This is
> exactly what `Submodule.mapQ` / `Quotient.map` needs to define an action on
> `weakQuotient`.

Only after that can one state the genuine SU(2)_L theorem (a *later* step): the
induced representation of `G` on `weakQuotient ≃ C^2` factors through a
surjection `G → SU(2)` whose action is the fundamental/doublet representation.
The current file is a legitimate, correctly scoped *prerequisite* to that chain,
not the chain itself.
