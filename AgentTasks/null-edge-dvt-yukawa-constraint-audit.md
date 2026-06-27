# FUR-H6: DVT/Jordan cubic and triality constraints on legal `Phi_H` textures

**Type:** strategy / audit (report-only; no Lean changes).
**Scope:** adversarial audit of whether the existing DVT / exceptional-Jordan /
Furey–Hughes triality formalizations constrain legal Yukawa / `Phi_H` maps.

> **Headline verdict (adversarial).** As currently formalized, the DVT /
> Jordan / triality data **do not constrain legal `Phi_H` textures.** They
> reconstruct the *gauge group* acting on the `h₃(ℂ)`-complement, transport
> charge tables under role permutations, and provide scaffolds whose Standard
> Model action fields are documentation-only `Prop := True` placeholders. The
> single genuine codimension/forcing result in the package
> (`forbidden_counterterm_codimension`) comes from the **spacetime chirality
> grading `Γ_s`**, *not* from any DVT/Jordan/triality datum, and it constrains
> only the *block structure* of `Phi_H` (it must be off-diagonal /
> chirality-flipping). The actual Yukawa texture — the entries of the
> off-diagonal block — remains **completely free**. This confirms and refines
> F15: the EFT-relevant `Phi_H` sector is full-rank as formalized, and Gate F
> prediction language must stay off.

---

## 1. Files inspected

DVT / exceptional-Jordan island (`PhysicsSM/Algebra/Jordan/`):

- `DVTAction.lean`, `DVTBlockActionMonoid.lean`, `DVTComplementBridge.lean`,
  `DVTComplement{Central,TwoSided}*.lean`,
  `DVTTwoSided{ImageEquiv,StabilizerMoonshot,SU3QuotientStabilizer}.lean`,
  `DVTFullStabilizerCharacterization.lean`, `DVTZ3Central*.lean`,
  `DVTMatrixLeftRightKernel.lean`, `DVTStabilizer{Prelude,Restriction}.lean`,
  `DVTQuotientBlockActionBridge.lean`.
- `H3O*.lean` (exceptional Jordan algebra coordinate model + Jordan product),
  `Complement*.lean`, `InnerDerivation*.lean`, `Stabilizer*.lean`,
  `Derivation*.lean`, `TraceForm*.lean`, `Automorphism.lean`,
  `ProjectiveGeometry.lean`, `SpinFactor.lean`, `CayleyPlaneD5Chart.lean`,
  `BioctonionicPlane.lean`.

Furey–Hughes triality island (`PhysicsSM/Algebra/Furey/`):

- `TrialityTriple.lean`, `TrialityTripleModule.lean`,
  `TrialityAlgebraScaffold.lean`, `TrialityFamilyNaturality.lean`,
  `TrialityElectroweakTransport.lean`.

Null-edge internal sector (`PhysicsSM/Draft/`):

- `NullEdgeInternalSpectrum.lean`, `NullEdgeForbiddenCountertermCodim.lean`.

Strategy sources: `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
(esp. §33 "Furey/Baez/DVT as the finite internal spectral-triple half"),
`AgentTasks/null-edge-f15-genuine-prediction-candidate-ledger.md`.

Cross-cutting search result (decisive): the tokens `Phi_H` / `phiH` / `Yukawa`
occur in the entire `PhysicsSM/` tree **only** in the two `Draft/` files, and
the tokens `covariant` / `equivariant` / `Schur` occur **nowhere**. The
DVT/Jordan/triality modules contain no reference to `Phi_H`, to Yukawa maps, or
to any gauge-equivariance predicate. The two islands are, at the formal level,
**disconnected**.

---

## 2. What each island actually proves

### 2.1 DVT / exceptional Jordan — a *gauge-group* reconstruction, not a `Phi_H` constraint

The DVT stack is a coordinate-algebraic stabilizer theorem for the **complement
of `h₃(ℂ)` in `h₃(𝕆)`**. The high-water marks are:

- `DVTTwoSidedStabilizerMoonshot`: the two-sided action `X ↦ A·X·B` of
  `SU(3) × SU(3)ᵐᵒᵖ` descends to an **injective** homomorphism from
  `(SU(3) × SU(3)ᵐᵒᵖ)/ℤ₃` into `AddAut H3OComplement`; the identity fiber is
  exactly the central `ℤ₃`.
- `DVTFullStabilizerCharacterization`: the image is *characterized* as exactly
  the additive automorphisms of the form `X ↦ A·X·B` with `det A = det B = 1`
  (`IsDVTTwoSidedCompatible`), giving a genuine iff and the equality
  `dvtCompatibleComplementStabilizer = dvtQuotientImageSubgroup`.
- `InnerDerivation*` / `Stabilizer*`: a Lie-algebraic shadow — eight
  Gell-Mann-built inner-derivation generators stabilizing `h₃(ℂ)` (linear
  independence and the `≅ su(3)` isomorphism are *explicitly left open*).

**What this is.** A faithful realization of a Standard-Model-shaped group
`(SU(3)×SU(3))/ℤ₃` acting on a 9-complex-dimensional module. It reconstructs the
*symmetry that any legal internal operator would have to respect*.

**What it is not.** It says nothing about `Phi_H`. There is no map `J → J*`, no
internal Dirac/Yukawa operator, and no statement that any such operator must
commute or transform covariantly under this action. The action acts on the
*complement module itself*, not on a Yukawa coupling. To turn the stabilizer
into a `Phi_H` constraint one would need a separate, currently-absent theorem of
the form "`Phi_H` is gauge-covariant for this action" (see §4).

### 2.2 Triality — naturality of charge tables and `True`-valued action scaffolds

- `TrialityTriple` / `TrialityTripleModule` / `TrialityAlgebraScaffold`:
  a typed `(Ψ₊, Ψ₋, V)` triple with a componentwise module structure and a
  `TrialityActionData` record (three independent endomorphisms `actC, actH,
  actO`) that lifts to a linear endomorphism. This is generic linear algebra:
  there is **no** `tri(ℂ) ⊕ tri(ℍ) ⊕ tri(𝕆)` Lie algebra, and **no** embedding
  of `su(3) ⊕ su(2) ⊕ u(1)`. Those are recorded as
  `FureyHughesProgramTargets` / `SMActionData` fields with default value
  `Prop := True` — i.e. explicitly *unformalized*.
- `TrialityFamilyNaturality` / `TrialityElectroweakTransport`: for a
  *role-constant* charge table satisfying Gell-Mann–Nishijima, the GMN relation
  is invariant under the triality cycle. This is a one-line naturality fact
  (`hconst` makes all three roles carry identical charges, so cycling is the
  identity on charges). It is a **consistency/transport** statement; it forces
  nothing about Yukawa entries.

**Adversarial reading.** The triality files contain no theorem that would
constrain `Phi_H`. The "three roles ↦ three generations" content is a
`True`-valued target, and the only non-trivial lemmas are invariance statements
that hold *because* their hypothesis (`RoleConstant`) trivializes the action.

### 2.3 Null-edge internal spectrum — `legalYukawa` is bookkeeping, by the file's own admission

`NullEdgeInternalSpectrum` carries `multiplets`, a `chi_E` `grading`, and a
`legalYukawa : ChiralMultiplet → ChiralMultiplet → Bool`. The docstring states
plainly that `grading` and `legalYukawa` are **"structural bookkeeping … they
play no role in (and are not constrained by) the anomaly theorems."** The Furey
witness `fureyStyleRealization` hard-codes the three SM pairings by *string
label* (`smLegalYukawa`). Nothing derives these pairings from DVT/Jordan/triality
data; they are posited. The anomaly inheritance theorems depend only on the
multiplet list, not on `legalYukawa` at all.

### 2.4 Forbidden-counterterm codimension — the *only* genuine forcing, and it is **not** DVT/Jordan/triality

`NullEdgeForbiddenCountertermCodim` is the one place with a real
rank/codimension statement:

- `isOdd_iff_offDiagonal`: an operator anticommutes with the chirality grading
  `Γ_s` iff both diagonal blocks vanish.
- `forbidden_counterterm_codimension`: the admissible (odd) operators sit at
  codimension `(card L)² + (card R)²` inside the ambient operator space.
- `ambient_eq_admissible_add_codimension`:
  `(L+R)² = 2·L·R + (L² + R²)`.

This is a bona fide "`rank(dF) < dim M_EFT`" ingredient — but its mechanism is
the **spacetime chirality grading `Γ_s`** (the NCG "Dirac operator must be odd"
axiom), which is logically independent of the DVT stabilizer, the Jordan cubic,
and triality. It forces only that `Phi_H` is **off-diagonal / chirality-flipping**
(`L ↔ R`). Critically, the kernel of `diagBlocks` — the admissible space — is the
**full** `2·card L·card R`-dimensional off-diagonal block
(`admissible_odd_finrank`). The entries of that block (the actual Yukawa
texture) are entirely free: no zero pattern, no rank bound, no relation among
entries is imposed.

---

## 3. Classification (the four buckets requested)

| Result | Bucket | Comes from DVT/Jordan/triality? | Constrains `Phi_H` texture? |
|---|---|---|---|
| `(SU(3)×SU(3))/ℤ₃` faithful stabilizer (`DVTTwoSidedStabilizerMoonshot`, `DVTFullStabilizerCharacterization`) | **structural reconstruction** (gauge group) | yes | **no** (acts on the complement module, not on a Yukawa map) |
| Inner-derivation `su(3)` generators (`InnerDerivationStandardB*`) | **structural reconstruction** (Lie shadow; `dim=8`/`≅ su(3)` open) | yes | **no** |
| Anomaly inheritance (`NullEdgeInternalSpectrum`) | **structural reconstruction** (consistency) | no (depends only on the SM multiplet list) | **no** (`legalYukawa` is inert) |
| Triality role-constant GMN transport (`TrialityFamilyNaturality`, `…ElectroweakTransport`) | **structural reconstruction** (naturality/consistency) | partially (role-permutation API) | **no** (hypothesis trivializes the action) |
| Off-diagonal forcing + codimension `(L²+R²)` (`NullEdgeForbiddenCountertermCodim`) | **forbidden-texture / zero constraint** *and* **rank/codimension** | **no** (chirality grading `Γ_s`) | **partial only**: forces `Phi_H` off-diagonal; off-diagonal block stays full-rank |
| "three triality roles = three generations"; `su(3)⊂tri(𝕆)`, `su(2)⊂tri(ℍ)`, `u(1)⊂tri(ℂ)` | would be **unsupported numerology** if asserted | — | currently honest `Prop := True` placeholders, asserted nowhere |

**Net:** every formalized DVT/Jordan/triality result is *reconstruction* or
*consistency*. The lone forbidden-texture/codimension result is a chirality-grading
fact, not a DVT/Jordan/triality fact, and it does not reach inside the Yukawa
block. No result in any bucket constrains the legal `Phi_H` *texture* (zero
pattern, rank, or entry relations).

---

## 4. Concrete Lean theorem targets that *could* become genuine prediction candidates

A real DVT/Jordan/triality constraint on `Phi_H` requires bridging the two
disconnected islands with an **equivariance** statement, then extracting a
**Schur-type zero/rank** consequence. The targets below are ordered by how
close the prerequisites are; **none** is provable today because the gauge action
on the internal Hilbert space is still a `True` placeholder. Each is a falsifiable
`sorry` handoff, not an axiom.

### Target A — gauge action on the internal Hilbert space (prerequisite, no prediction)
Replace the `SMActionData` / `TrialityActionData` `True` fields with an *actual*
representation:
```text
def internalGaugeRep : DVTTwoSidedSU3Pair →* Module.End ℂ H_F
```
landing the reconstructed `(SU(3)×SU(3))/ℤ₃` (or the Furey `G2≅SU(3)`,
`su(2)`, `u(1)`) action on the internal space `H_F = J ⊕ J*`.
*Acceptance:* it is a monoid/group hom and reproduces the
`standardModelOneGeneration` charges already in `NullEdgeInternalSpectrum`.
*Status:* **reconstruction only** — proves no prediction by itself, but is the
mandatory input for B and C.

### Target B — forbidden Yukawa texture from gauge covariance (forbidden-texture candidate)
```text
def GaugeCovariant (Phi : H_F →ₗ[ℂ] H_F) : Prop :=
  ∀ g, Phi ∘ₗ internalGaugeRep g = internalGaugeRep g ∘ₗ Phi

theorem phiH_schur_zero (Phi) (hcov : GaugeCovariant Phi)
    (i j : InternalIrrep) (hij : i ≠ j ∧ ¬ Equiv i j) :
    block i j Phi = 0
```
i.e. gauge covariance forces the inter-irrep blocks of `Phi_H` between
inequivalent internal irreps to vanish (Schur). *Acceptance:* a real zero
pattern on `Phi_H` derived from the reconstructed action — the first **genuine**
forbidden-texture result attributable to DVT/Jordan/triality. *Falsifier:* if
the SM Yukawa pairings live entirely inside Hom-spaces that covariance leaves
free, the theorem is vacuous and the claim collapses back to F15 full-rank.

### Target C — covariant-Yukawa codimension (the actual Gate-F gate)
```text
theorem phiH_covariant_codimension :
    Module.finrank ℂ
      (admissibleOffDiagonal ⧸ gaugeCovariantSubspace) = c   -- c > 0
```
the gauge-covariant Yukawa maps are a *proper* subspace of the off-diagonal
block, of positive codimension `c`. *Acceptance:* this is the genuine
`rank(dF) < dim M_EFT` statement that F15 says is currently missing — and only
*this* (with `c > 0` and a count tied to the reconstructed action) licenses Gate F
prediction language. *Falsifier:* `c = 0` (covariance imposes nothing beyond
off-diagonality) ⇒ no prediction; report `Phi_H` full-rank and keep Gate F off.

### Target D — Jordan-cubic / triality rigidity (speculative; guard against numerology)
If a future `cubicNorm`-preservation or `tri`-equivariance hypothesis is imposed
on `Phi_H`, state it as an explicit hypothesis and prove the resulting texture
constraint; do **not** assert "three roles = three generations" as a theorem.
*Acceptance:* a kernel/rank statement conditional on a named, falsifiable
hypothesis. *Failure mode to avoid:* importing the Furey "three generations from
the octonions" slogan as if settled — the repo's own files mark it `True`-valued
and `FureyRightHandedSectorOpen`.

---

## 5. Adversarial verdict

1. **Does the DVT data constrain `Phi_H`?** No. The DVT stabilizer reconstructs
   a gauge *group* acting on the `h₃(ℂ)`-complement; it never touches a Yukawa
   map. There is no `Phi_H`, no `J → J*`, and no covariance predicate anywhere
   in the Jordan tree.
2. **Does triality constrain `Phi_H`?** No. The triality modules are a generic
   triple-module scaffold plus charge-table naturality whose only non-trivial
   lemmas hold because their `RoleConstant` hypothesis trivializes the action.
   The SM-action and three-generation content is `Prop := True`.
3. **Does the Jordan cubic constrain `Phi_H`?** No cubic-norm constraint on any
   Yukawa map is formalized. The cubic norm appears only in the Cayley-plane
   rank-one geometry (`CayleyPlaneD5Chart`), unconnected to `Phi_H`.
4. **What *does* constrain `Phi_H`?** Only the chirality grading `Γ_s`
   (`NullEdgeForbiddenCountertermCodim`): it forces `Phi_H` off-diagonal and
   gives a real codimension `(L²+R²)`. This is independent of DVT/Jordan/triality
   and leaves the off-diagonal Yukawa block full-rank.
5. **Gate F status.** Unchanged from F15. The EFT-rich `Phi_H` sector is
   full-rank as formalized; there is no rank/codimension/forcing theorem that
   ties a `Phi_H` texture to DVT/Jordan/triality. **Gate F prediction language
   must remain off.** It becomes admissible only after Targets A→B→C above are
   proved with a strictly positive covariant-Yukawa codimension.

**One-line summary:** the DVT/Jordan/triality formalizations are a *gauge-group
and charge reconstruction island* sitting next to, but not yet docked to, the
`Phi_H` slot; the only operative constraint on `Phi_H` today is chirality
off-diagonality, which does not constrain its texture — so no genuine prediction
candidate exists until an explicit gauge-covariance (Schur) theorem and a
positive-codimension count are formalized.
