import Mathlib

/-!
# NullEdgeDiamondSourceVisibilityRoadmap  (P9 source-visibility API scaffold)

NON-IMPORTED DESIGN SCAFFOLD. This file is a clearly-labelled roadmap for the
P9 source-visibility branch. It is **not** wired into any default build target.
Its purpose is to pin the smallest finite API that keeps three notions rigidly
separate:

1. visible (rest-frame) closure of a null-edge fan, `C = Σ_i w_i u_i = 0`;
2. BF / Gauss-law surface closure of a diamond screen, `Σ_f B_f = 0`;
3. observer-channel invisibility / recoverability.

Companion design note:
`AgentTasks/null-edge-p9-source-visibility-api-output.md`.

## Status of each declaration in this file

* `[CHECKED]`  proved here; verified to compile in isolation.
* `[JOB]`      stated with ` s o r r y `; intended Aristotle proof job.
* `[DEFN]`     a definition-design placeholder for a later structure pass.

The visible-fan layer below intentionally mirrors the banked module
`NullEdgeSpinorNetworkClosure` (anchor `LeanContext/SpinorNetworkClosure/Finite.lean`).
In the real integration these should be *re-exports* of that trusted module, not
re-definitions; they are inlined here only to keep this scaffold standalone.

This file does NOT claim to prove Sorkin everpresent-Λ, Benincasa-Dowker
curvature, Jacobson/Clausius balance, ANEC/QNEC, or Sorkin-Johnston entropy.
Those are motivation and source constraints only.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeDiamondSourceVisibilityRoadmap

open BigOperators

/-! ## Visible null-edge fan layer (mirror of `NullEdgeSpinorNetworkClosure`) -/

/-- A real three-vector in coordinates (celestial direction carrier). -/
abbrev Vec3 := Fin 3 → ℝ

/-- Euclidean dot product on coordinate three-vectors. -/
def dot (a b : Vec3) : ℝ := Finset.univ.sum fun k : Fin 3 => a k * b k

/-- A visible weighted null-edge fan localised on a screen:
weights `w i` (visible null energies) and unit celestial directions `u i`. -/
structure VisibleFanOnScreen (n : ℕ) where
  w : Fin n → ℝ
  u : Fin n → Vec3

/-- Total visible null energy of the fan. -/
def VisibleFanOnScreen.energy {n : ℕ} (F : VisibleFanOnScreen n) : ℝ :=
  Finset.univ.sum fun i : Fin n => F.w i

/-- Closure / total spatial momentum vector `C = Σ_i w_i u_i`. -/
def VisibleFanOnScreen.closureVector {n : ℕ} (F : VisibleFanOnScreen n) : Vec3 :=
  fun k : Fin 3 => Finset.univ.sum fun i : Fin n => F.w i * F.u i k

/-- Visible-mass channel: pairwise angular spread
`Σ_{i<j} w_i w_j (1 - u_i·u_j)/2`.  By the banked identity this equals
`(E² - |C|²)/4`. -/
def VisibleFanOnScreen.visibleMass {n : ℕ} (F : VisibleFanOnScreen n) : ℝ :=
  ((Finset.univ : Finset (Fin n × Fin n)).filter fun p => p.1 < p.2).sum
    fun p => (F.w p.1 * F.w p.2 * (1 - dot (F.u p.1) (F.u p.2))) / 2

/-- **visible closure** : the rest-frame condition `C = 0`.
This is *not* masslessness and *not* source invisibility. -/
def VisibleFanOnScreen.IsVisiblyClosed {n : ℕ} (F : VisibleFanOnScreen n) : Prop :=
  F.closureVector = 0

/-! ## BF / surface (Gauss-law) layer -/

/-- Toy self-dual / `su(2)_L` face label (the `Λ²₊ ≅ Sym²S` component).
In a hardened version this carries the linear-simplicity sector data. -/
abbrev Bivector := Fin 3 → ℝ

/-- The boundary 2-surface of a diamond: a finite face set carrying BF data. -/
structure Screen (ι : Type*) where
  faces : Finset ι
  B : ι → Bivector

/-- BF / Gauss-law closure defect `Σ_{f∈faces} B_f`. -/
def closureDefect {ι} (S : Screen ι) : Bivector :=
  fun k => S.faces.sum fun f => S.B f k

/-- Squared norm of a bivector face label. -/
def normSq3 (a : Bivector) : ℝ := Finset.univ.sum fun k : Fin 3 => a k ^ 2

/-- **Diamond source functional** (BF bulk channel):
the candidate bulk source `‖Σ_f B_f‖²`. -/
def diamondSource {ι} (S : Screen ι) : ℝ := normSq3 (closureDefect S)

/-- **BF closure (Gauss-law closure)** : `Σ_f B_f = 0`.
The coherent / internal-vacuum-bookkeeping candidate for source invisibility. -/
def IsBFClosed {ι} (S : Screen ι) : Prop := closureDefect S = 0

/-- **bulk source** : the screen genuinely sources in the bulk. -/
def IsBulkSource {ι} (S : Screen ι) : Prop := diamondSource S ≠ 0

/-- **boundary-exact** : `B` is a discrete coboundary, modelled by a
fixed-point-free orientation-reversing pairing `τ` of faces with
`B (τ f) = - B f`.  This is the finite shadow of `B = δ a` / `d∘d = 0`
(anchor `cochainCoboundary_comp_self_eq_zero`).  It is **strictly stronger**
than `IsBFClosed`: nontrivial homology (closed-not-exact) is possible. -/
def IsBoundaryExact {ι} [DecidableEq ι] (S : Screen ι) : Prop :=
  ∃ τ : ι → ι, Function.Involutive τ ∧ (∀ f, τ f ≠ f) ∧
    (∀ f, f ∈ S.faces ↔ τ f ∈ S.faces) ∧ (∀ f, S.B (τ f) = - S.B f)

/-! ## Layer-1 theorems -/

/-- `[CHECKED]` finite `d∘d = 0`: a boundary-exact screen is BF-closed.
This is the substantive content behind `boundaryExact_source_eq_zero`. -/
theorem boundaryExact_implies_bfClosed {ι} [DecidableEq ι] (S : Screen ι)
    (h : IsBoundaryExact S) : IsBFClosed S := by
  obtain ⟨τ, hinv, hne, hmem, hB⟩ := h
  unfold IsBFClosed closureDefect
  funext k
  apply Finset.sum_involution (fun f _ => τ f)
  · intro f _; have := hB f; simp [this]
  · intro f _ _; exact hne f
  · intro f hf; exact (hmem f).mp hf
  · intro f _; exact hinv f

/-- `[CHECKED]` tautological plumbing: BF closure ⇒ no bulk source.
True by construction (`diamondSource = ‖closureDefect‖²`); it carries
essentially no physics content on its own. -/
theorem bfClosed_source_zero {ι} (S : Screen ι) (h : IsBFClosed S) :
    diamondSource S = 0 := by
  unfold diamondSource normSq3
  rw [show closureDefect S = 0 from h]
  simp

/-- `[CHECKED]` corollary: boundary-exact ⇒ no bulk source. -/
theorem boundaryExact_source_eq_zero {ι} [DecidableEq ι] (S : Screen ι)
    (h : IsBoundaryExact S) : diamondSource S = 0 :=
  bfClosed_source_zero S (boundaryExact_implies_bfClosed S h)

/-! ### Gluing: the *defect* is additive, the *squared source* is not -/

/-- Disjoint gluing of two screens over a sum index. -/
def glue {ι κ} [DecidableEq ι] [DecidableEq κ]
    (S : Screen ι) (T : Screen κ) : Screen (ι ⊕ κ) where
  faces := S.faces.map ⟨Sum.inl, Sum.inl_injective⟩ ∪
           T.faces.map ⟨Sum.inr, Sum.inr_injective⟩
  B := Sum.elim S.B T.B

/-- `[CHECKED]` the BF closure **defect** is additive under disjoint gluing
(the abelian analogue of the holonomy gluing law
`pathPairDefect_verticalCompose_comm`). -/
theorem closureDefect_glue {ι κ} [DecidableEq ι] [DecidableEq κ]
    (S : Screen ι) (T : Screen κ) :
    closureDefect (glue S T) = fun k => closureDefect S k + closureDefect T k := by
  funext k
  unfold closureDefect glue
  rw [Finset.sum_union (by
    rw [Finset.disjoint_left]
    rintro x hx hx2
    simp only [Finset.mem_map, Function.Embedding.coeFn_mk] at hx hx2
    obtain ⟨a, _, rfl⟩ := hx
    obtain ⟨b, _, hb⟩ := hx2
    exact Sum.inr_ne_inl hb)]
  rw [Finset.sum_map, Finset.sum_map]
  simp

/-
`[JOB]` the **squared** source is additive iff the two defects are
orthogonal.  REJECT any unconditional `diamondSource`-additivity claim:
`‖d_S + d_T‖² = ‖d_S‖² + ‖d_T‖² + 2⟨d_S, d_T⟩`.
-/
theorem diamondSource_additive_iff_orthogonal {ι κ} [DecidableEq ι] [DecidableEq κ]
    (S : Screen ι) (T : Screen κ) :
    diamondSource (glue S T) = diamondSource S + diamondSource T ↔
      (Finset.univ.sum fun k : Fin 3 => closureDefect S k * closureDefect T k) = 0 := by
  unfold diamondSource normSq3;
  simp +decide only [closureDefect_glue, add_sq, Finset.sum_add_distrib];
  simp +decide [ mul_assoc, ← Finset.mul_sum _ _ _ ]

/-- Key algebraic identity: `4 · visibleMass = E² - |C|²` for a unit-direction
fan.  Both visible-channel theorems below are corollaries. -/
lemma visibleMass_four_mul_identity {n : ℕ} (F : VisibleFanOnScreen n)
    (hunit : ∀ i : Fin n, dot (F.u i) (F.u i) = 1) :
    4 * F.visibleMass = F.energy ^ 2 - dot F.closureVector F.closureVector := by
  have h_double_sum : (Finset.univ : Finset (Fin n × Fin n)).sum (fun p => F.w p.1 * F.w p.2 * (1 - dot (F.u p.1) (F.u p.2))) = 4 * F.visibleMass := by
    have h_double_sum : (Finset.univ : Finset (Fin n × Fin n)).sum (fun p => F.w p.1 * F.w p.2 * (1 - dot (F.u p.1) (F.u p.2))) = 2 * (Finset.univ.filter (fun p : Fin n × Fin n => p.1 < p.2)).sum (fun p => F.w p.1 * F.w p.2 * (1 - dot (F.u p.1) (F.u p.2))) := by
      have h_split : ∑ p : Fin n × Fin n, F.w p.1 * F.w p.2 * (1 - dot (F.u p.1) (F.u p.2)) = (∑ p ∈ Finset.filter (fun p => p.1 < p.2) (Finset.univ : Finset (Fin n × Fin n)), F.w p.1 * F.w p.2 * (1 - dot (F.u p.1) (F.u p.2))) + (∑ p ∈ Finset.filter (fun p => p.1 > p.2) (Finset.univ : Finset (Fin n × Fin n)), F.w p.1 * F.w p.2 * (1 - dot (F.u p.1) (F.u p.2))) := by
        rw [ ← Finset.sum_union ];
        · rw [ ← Finset.sum_subset ];
          · exact Finset.subset_univ _;
          · grind +qlia;
        · exact Finset.disjoint_filter.mpr fun _ _ _ _ => lt_asymm ‹_› ‹_›;
      rw [ h_split, two_mul ];
      simp +decide [ Finset.sum_filter, dot ];
      rw [ ← Equiv.sum_comp ( Equiv.prodComm _ _ ) ] ; simp +decide [ mul_comm ];
    rw [ h_double_sum, VisibleFanOnScreen.visibleMass ] ; ring;
    rw [ Finset.sum_mul _ _ _ ] ; rw [ Finset.sum_mul _ _ _ ] ; exact Finset.sum_congr rfl fun _ _ => by ring;
  convert h_double_sum.symm using 1;
  unfold VisibleFanOnScreen.energy dot VisibleFanOnScreen.closureVector; simp +decide [ Finset.sum_mul _ _ _, Finset.mul_sum, Finset.sum_sub_distrib, mul_sub, pow_two ] ; ring;
  simp +decide only [← Finset.sum_product'];
  refine' congrArg₂ _ rfl ( Finset.sum_bij ( fun x _ => ( ( x.2.1, x.2.2 ), x.1 ) ) _ _ _ _ ) <;> simp +decide [ mul_assoc, mul_comm, mul_left_comm ]

/-! ### Visible channel: closure is rest-frame, NOT source invisibility -/

/-- `[JOB / re-export]` visible closure gives the rest-frame mass `E²/4`.
Already banked as
`NullEdgeSpinorNetworkClosure.closed_spinorFan_is_restFrame`; should be a
re-export.  This is the guardrail theorem. -/
theorem closed_visibleFan_mass_eq_restEnergy {n : ℕ} (F : VisibleFanOnScreen n)
    (hunit : ∀ i : Fin n, dot (F.u i) (F.u i) = 1)
    (hclosed : F.IsVisiblyClosed) :
    F.visibleMass = F.energy ^ 2 / 4 := by
  have hid := visibleMass_four_mul_identity F hunit
  rw [VisibleFanOnScreen.IsVisiblyClosed] at hclosed
  rw [hclosed] at hid
  have hz : dot (0 : Vec3) (0 : Vec3) = 0 := by simp [dot]
  rw [hz] at hid
  linarith

/-- The toy separating model: two antipodal unit null edges of equal weight. -/
def toyAntipodalFan : VisibleFanOnScreen 2 where
  w := ![1, 1]
  u := ![![1, 0, 0], ![-1, 0, 0]]

/-- `[CHECKED]` the toy fan is visibly closed: `C = 0`. -/
theorem toyAntipodalFan_isVisiblyClosed : toyAntipodalFan.IsVisiblyClosed := by
  unfold VisibleFanOnScreen.IsVisiblyClosed VisibleFanOnScreen.closureVector toyAntipodalFan
  funext k
  fin_cases k <;> simp [Fin.sum_univ_two]

/-- `[CHECKED]` the toy fan has nonzero visible mass (`= 1`). -/
theorem toyAntipodalFan_visibleMass_eq_one : toyAntipodalFan.visibleMass = 1 := by
  have hfilter : ((Finset.univ : Finset (Fin 2 × Fin 2)).filter fun p => p.1 < p.2)
      = {((0 : Fin 2), (1 : Fin 2))} := by decide
  unfold VisibleFanOnScreen.visibleMass toyAntipodalFan
  rw [hfilter]
  simp [dot, Fin.sum_univ_three]

/-- `[CHECKED]` **flagship separation lemma**: visible closure does NOT imply
source invisibility.  There is a fan that is visibly closed (`C = 0`) yet has
nonzero visible mass — hence is a genuine source by the mass channel. -/
theorem visibleClosure_not_sourceInvisibility_counterexample :
    ∃ (F : VisibleFanOnScreen 2), F.IsVisiblyClosed ∧ F.visibleMass ≠ 0 :=
  ⟨toyAntipodalFan, toyAntipodalFan_isVisiblyClosed, by
    rw [toyAntipodalFan_visibleMass_eq_one]; norm_num⟩

/-- `[JOB]` positive companion: a visible Plücker excitation is seen by the
visible-mass channel (state on `visibleMass`, NOT on `diamondSource`).
Reuses `Spinor.PluckerMass.two_edge_mass_zero_iff_wedge_zero`. -/
theorem visiblePluckerMass_sources_bulkTerm {n : ℕ} (F : VisibleFanOnScreen n)
    (hunit : ∀ i : Fin n, dot (F.u i) (F.u i) = 1)
    (hmass : F.visibleMass ≠ 0) :
    F.energy ^ 2 - dot F.closureVector F.closureVector ≠ 0 := by
  have hid := visibleMass_four_mul_identity F hunit
  intro hzero
  rw [hzero] at hid
  apply hmass
  linarith

/-! ## Layer 2: observer / recoverability  `[DEFN]` placeholders

These require their own definition-design pass
(`RelativeEntropyObserverChannel`) before any proof job is submitted.  The
shapes below are intent markers only.

```text
structure ObserverChannel (ρ : Type*) where
  map       : ρ → ρ          -- finite coarse-graining (CPTP) map
  reference : ρ              -- observer reference state ρ₀

def observerRelEntropyLoss (Φ : ObserverChannel ρ) (state : ρ) : ℝ := ...
def IsObserverInvisible    (Φ : ObserverChannel ρ) (state : ρ) : Prop :=
  observerRelEntropyLoss Φ state = 0
def IsRecoverable          (Φ : ObserverChannel ρ) (state : ρ) : Prop :=
  ∃ R : ρ → ρ, R (Φ.map state) = state

-- [JOB, hard] quantitative invisibility ⇔ exact recoverability (Petz)
theorem relativeEntropyLoss_zero_iff_exactObserverRecovery
    (Φ : ObserverChannel ρ) (state : ρ) :
    IsObserverInvisible Φ state ↔ IsRecoverable Φ state := s o r r y
```
-/

end PhysicsSM.Draft.NullEdgeDiamondSourceVisibilityRoadmap

end
