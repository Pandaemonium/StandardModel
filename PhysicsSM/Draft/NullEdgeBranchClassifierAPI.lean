import Mathlib
import PhysicsSM.Draft.NullEdgeTasteOnlyOriginNoGo

/-!
# Draft.NullEdgeBranchClassifierAPI

Aristotle task C104 (Wave 26): the branch-classifier / branch-projector design
API and the associated no-go fork
(`AgentTasks/context-packs/null-edge-wave26-gate-c-branch-release-20260627-121710.md`,
`AgentTasks/null-edge-gate-c-neo4j-lit-lateral-analysis-2026-06-27.md`).

## What this module is, and what it is NOT

This is an **API / guardrail scaffold**, *not* a Gate C release. It fixes the
language for the most null-edge-native C1 route — a branch *classifier*
involution `T_br` with `T_br² = 1` and its branch *projector*
`Π_br = (1 + T_br)/2` — and proves the finite linear-algebra guardrails that any
such object must respect. None of the theorems below assert that a *physical*,
*local*, *gauge-safe*, *Krein-safe* branch classifier exists for the actual
tetrahedral null-edge symbol `D_+`; that is precisely the open Gate C1
obligation. The names are chosen so this scaffold cannot be mistaken for a
release: nothing here is named `*Release` and the witness theorem is explicitly
restricted to the abstract algebraic predicates with a trivial gauge set.

## Relation to the taste-only no-go (C88)

`PhysicsSM.Draft.NullEdgeTasteOnlyOriginNoGo` proved that a *taste-only* (scalar
on the origin corner) involution cannot polarize the balanced two-line origin
kernel. Here we re-phrase the same balanced-origin model in `T_br` language and
reuse that no-go verbatim for the third guardrail. The new content is the
classifier/projector predicate layer, the projector idempotency, the
non-scalar ⇒ not-taste-only and germ-separation guardrails, a realizability
witness, and the explicit C1 no-go fork.

## API predicates

* `TbrInvolution` — `T_br² = 1`.
* `PiBr` / `PiBrProjector` — `Π_br = (1 + T_br)/2` is idempotent.
* `TbrGaugeNeutral` — `T_br` commutes with the gauge action.
* `TbrTasteOnly` / `TbrTasteOnlyOnOrigin` — `T_br` is a single scalar (globally /
  on the origin kernel): a "taste label only" classifier.
* `TbrNonScalarOnOriginKernel` — `T_br` carries two origin lines with distinct
  eigenvalues: it is genuinely non-scalar on the balanced origin kernel.
* `TbrSeparatesBranchGerms` — `T_br` gives the retained and mirror branch germs
  distinct labels.
* `BranchClassifier` — the bundled object (involution + gauge-neutral +
  non-scalar on origin + separates germs).

## Finite guardrails

* `PiBr_isProjector_of_involution` — `T_br² = 1 ⇒ Π_br² = Π_br`.
* `PiBr_gaugeNeutral` — a gauge-neutral classifier has a gauge-neutral projector.
* `nonScalarOnOrigin_not_tasteOnlyOnOrigin` — non-scalar on the origin kernel ⇒
  not taste-only there.
* `separatesGerms_labels_distinct` / `separatesGerms_involution_labels_pm` /
  `PiBr_retains_plus_kills_minus` — separation gives distinct labels; for an
  involution they are `+1` and `-1`, and `Π_br` retains the `+1` germ and
  annihilates the `-1` germ.
* `tasteOnlyOnOrigin_cannot_polarize` — a taste-only involution cannot polarize
  the balanced origin kernel (reuses C88).

## The no-go fork

`c1_route_nogo_fork` states the program-level fork in the form the context pack
requires: if no local/gauge-safe branch classifier route is viable, then any
viable C1 route must be one of the alternatives — domain-wall, projected-overlap,
or controlled quasi-local field-space construction.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeBranchClassifierAPI

open Matrix

/-- Square complex matrices of size `n` (the finite carrier of the model). -/
abbrev CMat (n : ℕ) := Matrix (Fin n) (Fin n) ℂ

/-! ## The branch classifier involution `T_br` and the projector `Π_br` -/

/-- `T_br² = 1`: the defining branch-classifier involution relation. -/
def TbrInvolution {n : ℕ} (T : CMat n) : Prop := T * T = 1

/-- The branch projector `Π_br = (1 + T_br)/2`. -/
def PiBr {n : ℕ} (T : CMat n) : CMat n := (2⁻¹ : ℂ) • (1 + T)

/-- `Π_br` is idempotent: `Π_br² = Π_br`. -/
def PiBrProjector {n : ℕ} (T : CMat n) : Prop := PiBr T * PiBr T = PiBr T

/--
**Projector guardrail.** If `T_br` is an involution then `Π_br = (1+T_br)/2`
is a genuine projector.
-/
theorem PiBr_isProjector_of_involution {n : ℕ} (T : CMat n)
    (h : TbrInvolution T) : PiBrProjector T := by
  unfold TbrInvolution PiBrProjector at *;
  unfold PiBr; simp +decide [ mul_add, add_mul, h ] ;
  ext i j ; norm_num ; ring

/-! ## Gauge neutrality -/

/-- `T_br` is **gauge-neutral** for a gauge action `G` (a set of carrier
matrices) when it commutes with every gauge generator. -/
def TbrGaugeNeutral {n : ℕ} (T : CMat n) (G : Set (CMat n)) : Prop :=
  ∀ g ∈ G, Commute T g

/--
**Gauge guardrail.** A gauge-neutral classifier has a gauge-neutral
projector: `Π_br` commutes with every gauge generator that `T_br` commutes
with.
-/
theorem PiBr_gaugeNeutral {n : ℕ} (T : CMat n) (G : Set (CMat n))
    (h : TbrGaugeNeutral T G) : ∀ g ∈ G, Commute (PiBr T) g := by
  intro g hg
  simp [PiBr, Commute];
  simp_all +decide [ SemiconjBy, mul_add, add_mul ];
  exact h g hg

/-! ## Taste-only vs. non-scalar on the origin kernel -/

/-- `T_br` is **taste-only** (globally) if it is a single scalar `c • I`: it
carries a taste label but no branch-line structure. -/
def TbrTasteOnly {n : ℕ} (T : CMat n) : Prop := ∃ c : ℂ, T = c • (1 : CMat n)

/-- `T_br` is **taste-only on the origin kernel** if it acts as a single scalar
`c` on every line `k i` of the balanced origin kernel. -/
def TbrTasteOnlyOnOrigin {n : ℕ} {ι : Type*} (T : CMat n)
    (k : ι → (Fin n → ℂ)) : Prop :=
  ∃ c : ℂ, ∀ i, T *ᵥ k i = c • k i

/--
A globally taste-only classifier is taste-only on any origin kernel.
-/
theorem tasteOnly_imp_tasteOnlyOnOrigin {n : ℕ} {ι : Type*} (T : CMat n)
    (k : ι → (Fin n → ℂ)) (h : TbrTasteOnly T) : TbrTasteOnlyOnOrigin T k := by
  obtain ⟨ c, rfl ⟩ := h;
  exact ⟨ c, fun i => by simp +decide [ Matrix.smul_eq_diagonal_mul ] ⟩

/-- `T_br` is **non-scalar on the origin kernel** if the kernel contains two
nonzero lines that are eigenvectors with *distinct* eigenvalues. This is the
genuine branch-line (not taste-only) condition on the balanced origin kernel. -/
def TbrNonScalarOnOriginKernel {n : ℕ} {ι : Type*} (T : CMat n)
    (k : ι → (Fin n → ℂ)) : Prop :=
  ∃ i j, k i ≠ 0 ∧ k j ≠ 0 ∧ ∃ ci cj : ℂ, ci ≠ cj ∧
    T *ᵥ k i = ci • k i ∧ T *ᵥ k j = cj • k j

/--
Helper: on `Fin n → ℂ`, a nonzero vector cancels from a scalar action.
-/
theorem smul_vec_left_cancel {n : ℕ} {v : Fin n → ℂ} (hv : v ≠ 0) {c d : ℂ}
    (h : c • v = d • v) : c = d := by
  exact smul_left_injective _ hv h

/--
**Guardrail 1 (`TbrNonScalarOnOriginKernel → ¬ TbrTasteOnlyOnOrigin`).** If
`T_br` is genuinely non-scalar on the balanced origin kernel, it cannot also be
taste-only there.
-/
theorem nonScalarOnOrigin_not_tasteOnlyOnOrigin {n : ℕ} {ι : Type*} (T : CMat n)
    (k : ι → (Fin n → ℂ)) (h : TbrNonScalarOnOriginKernel T k) :
    ¬ TbrTasteOnlyOnOrigin T k := by
  obtain ⟨ i, j, hki, hkj, ci, cj, hne, hi, hj ⟩ := h;
  rintro ⟨ c, hc ⟩;
  exact hne ( smul_vec_left_cancel hki ( by aesop ) )

/-! ## Branch-germ separation -/

/-- `T_br` **separates branch germs** `vR` (retained) and `vM` (mirror) if they
are eigenvectors carrying distinct labels `lR ≠ lM`. -/
def TbrSeparatesBranchGerms {n : ℕ} (T : CMat n) (vR vM : Fin n → ℂ) : Prop :=
  ∃ lR lM : ℂ, lR ≠ lM ∧ T *ᵥ vR = lR • vR ∧ T *ᵥ vM = lM • vM

/--
**Guardrail 2a (`TbrSeparatesBranchGerms → labels distinct`).** Separation
exhibits explicit retained/mirror labels that are distinct.
-/
theorem separatesGerms_labels_distinct {n : ℕ} (T : CMat n) (vR vM : Fin n → ℂ)
    (h : TbrSeparatesBranchGerms T vR vM) :
    ∃ lR lM : ℂ, T *ᵥ vR = lR • vR ∧ T *ᵥ vM = lM • vM ∧ lR ≠ lM :=
  by
    exact ⟨ _, _, h.choose_spec.choose_spec.2.1, h.choose_spec.choose_spec.2.2, h.choose_spec.choose_spec.1 ⟩

/--
**Guardrail 2b.** For an *involution* `T_br`, separated germs carry the
opposite labels `+1` and `-1` (in one order or the other).
-/
theorem separatesGerms_involution_labels_pm {n : ℕ} (T : CMat n)
    (vR vM : Fin n → ℂ) (hvR : vR ≠ 0) (hvM : vM ≠ 0)
    (hInv : TbrInvolution T) (hSep : TbrSeparatesBranchGerms T vR vM) :
    ∃ lR lM : ℂ, T *ᵥ vR = lR • vR ∧ T *ᵥ vM = lM • vM ∧
      ((lR = 1 ∧ lM = -1) ∨ (lR = -1 ∧ lM = 1)) := by
  obtain ⟨ lR, lM, hne, hR, hM ⟩ := hSep;
  -- Apply the involution property to the eigenvectors.
  have h_lR : lR^2 = 1 := by
    have h_lR_sq : T *ᵥ (T *ᵥ vR) = (1 : ℂ) • vR := by
      simp +decide [ ← Matrix.mul_assoc, hInv ];
      rw [ hInv, Matrix.one_mulVec ];
    simp_all +decide [ sq, Matrix.mulVec_smul ];
    exact smul_vec_left_cancel hvR <| by simpa [ mul_assoc, smul_smul ] using h_lR_sq;
  have h_lM : lM^2 = 1 := by
    have h_lM : T *ᵥ (T *ᵥ vM) = (1 : CMat n) *ᵥ vM := by
      exact hInv.symm ▸ by norm_num;
    simp_all +decide [ sq, Matrix.mulVec_smul ];
    exact smul_vec_left_cancel hvM <| by simpa [ mul_assoc, smul_smul ] using h_lM;
  aesop

/--
**Guardrail 2c.** When the retained germ has label `+1` and the mirror germ
has label `-1`, the projector `Π_br` retains the retained germ and annihilates
the mirror germ.
-/
theorem PiBr_retains_plus_kills_minus {n : ℕ} (T : CMat n) (vR vM : Fin n → ℂ)
    (hR : T *ᵥ vR = (1 : ℂ) • vR) (hM : T *ᵥ vM = (-1 : ℂ) • vM) :
    PiBr T *ᵥ vR = vR ∧ PiBr T *ᵥ vM = 0 := by
  unfold PiBr; simp_all +decide [ Matrix.add_mulVec, Matrix.smul_eq_diagonal_mul ] ;
  simp_all +decide [ ← Matrix.mulVec_mulVec, Matrix.mulVec_diagonal ];
  ext; norm_num; ring;

/-! ## Guardrail 3: a taste-only involution cannot polarize the origin kernel

We reuse the C88 balanced-origin model and its no-go verbatim. There
`ePlus`, `eMinus` are the two `Γ_s = ±1` origin lines, `GammaS` is the chirality
grading, and `OriginPolarized M` means both origin lines share a *single*
eigenvalue of `M` (one chirality). A taste-only classifier `T_br = c • I`
produces `Γ_s · T_br = c • Γ_s`, which is again balanced. -/

open PhysicsSM.Draft.NullEdgeTasteOnlyOriginNoGo

/--
**Guardrail 3 (`TbrTasteOnlyOnOrigin → cannot polarize balanced origin`).**
A taste-only branch classifier `T_br = c • I` with `c ∈ {+1, -1}` (an involution)
cannot polarize the balanced origin kernel: the induced chirality operator
`Γ_s · T_br` is not origin-polarized.
-/
theorem tasteOnlyOnOrigin_cannot_polarize (c : ℂ) (hc : c = 1 ∨ c = -1) :
    ¬ OriginPolarized
        (GammaS * (c • (1 : Matrix (Fin 2) (Fin 2) ℂ))) := by
  convert tasteOnly_not_originPolarized c hc using 1

/-! ## The bundled branch classifier object and a realizability witness -/

/-- A **branch classifier** object on carrier size `n`, for gauge action `G`,
balanced origin kernel `k`, and retained/mirror germs `vR`, `vM`: the involution
`T_br` together with gauge-neutrality, non-scalarity on the origin kernel, and
germ separation. This is the *algebraic* template; physical locality, Krein
safety, and ghost-zero safety are NOT part of it and are the open Gate C1 data. -/
structure BranchClassifier (n : ℕ) (G : Set (CMat n)) {ι : Type*}
    (k : ι → (Fin n → ℂ)) (vR vM : Fin n → ℂ) where
  /-- The classifier involution `T_br`. -/
  T : CMat n
  /-- `T_br² = 1`. -/
  involution : TbrInvolution T
  /-- `T_br` commutes with the gauge action. -/
  gaugeNeutral : TbrGaugeNeutral T G
  /-- `T_br` is genuinely non-scalar on the balanced origin kernel. -/
  nonScalarOnOrigin : TbrNonScalarOnOriginKernel T k
  /-- `T_br` separates the retained and mirror branch germs. -/
  separatesGerms : TbrSeparatesBranchGerms T vR vM

/--
**Realizability witness (algebraic only).** The chirality grading `Γ_s` on
the C88 balanced-origin model is a branch classifier in the abstract algebraic
sense, for the trivial gauge set `{1}`, with origin kernel `![ePlus, eMinus]`
and germs `ePlus` (retained) / `eMinus` (mirror). This shows the predicate layer
is *not vacuous*. It does NOT discharge Gate C1: locality, a nontrivial gauge
action, Krein safety, and ghost-zero safety are outside this structure and remain
open.
-/
theorem branchClassifier_witness :
    Nonempty (BranchClassifier 2 {(1 : CMat 2)}
      (![ePlus, eMinus] : Fin 2 → (Fin 2 → ℂ)) ePlus eMinus) := by
  use GammaS;
  · ext i j; fin_cases i <;> fin_cases j <;> norm_num [ GammaS ] ;
  · exact fun g hg => by rw [ Set.mem_singleton_iff.mp hg ] ; exact Commute.one_right _;
  · use 0, 1
    simp [ePlus, eMinus, GammaS];
    exact ⟨ 1, -1, by norm_num, by ext i; fin_cases i <;> rfl, by ext i; fin_cases i <;> rfl ⟩;
  · exact ⟨ 1, -1, by norm_num, by simp +decide [ tasteOnly_origin_balanced ], by simp +decide [ tasteOnly_origin_balanced ] ⟩

/-! ## The C1 no-go fork -/

/-- The candidate routes for the Gate C1 (physical chiral release) construction. -/
inductive C1Route
  /-- A genuinely local, gauge-safe branch classifier / projector `T_br`/`Π_br`. -/
  | localBranchClassifier
  /-- A domain-wall construction. -/
  | domainWall
  /-- A projected-overlap construction. -/
  | projectedOverlap
  /-- A controlled quasi-local field-space construction. -/
  | quasiLocalFieldSpace
  deriving DecidableEq

/-- A route counts as an *alternative* to the local branch classifier. -/
def C1Route.isAlternative : C1Route → Prop
  | .localBranchClassifier => False
  | _ => True

/--
**The C1 no-go fork.** If some viable C1 route exists but the local,
gauge-safe branch-classifier route is *not* viable, then a viable route must be
one of the alternatives: domain-wall, projected-overlap, or controlled
quasi-local field-space construction. This is the program-level fork the context
pack records: a local/gauge-safe `T_br` no-go forces the alternatives.
-/
theorem c1_route_nogo_fork (viable : C1Route → Prop)
    (hsome : ∃ r, viable r)
    (hno_local : ¬ viable C1Route.localBranchClassifier) :
    ∃ r, viable r ∧ r.isAlternative := by
  rcases hsome with ⟨ r, hr ⟩ ; use r; rcases r with ( _ | _ | _ | _ ) <;> tauto;

end PhysicsSM.Draft.NullEdgeBranchClassifierAPI
