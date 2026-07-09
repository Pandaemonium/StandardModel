import Mathlib

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 8000000
set_option relaxedAutoImplicit false
set_option autoImplicit false

/-!
# The longitudinal mode of a massive vector IS the mass (the eaten null Goldstone)

This file is a finite, kernel-checked **degree-of-freedom counting** statement, the
gauge/Higgs-channel avatar of "mass from massless":

* a MASSLESS vector (null momentum `k`, `k·k = 0`) has **2** physical polarizations
  (transverse), because the transverse space `{ε : ε·k = 0}` is `3`-dimensional but the
  gauge direction `k` itself lies inside it and must be quotiented out;
* a MASSIVE vector (timelike momentum `k`, `k·k = m² > 0`) has **3** physical
  polarizations, because the gauge direction `k` no longer lies in the transverse space
  (`k·k ≠ 0`), so there is no gauge quotient and the extra **longitudinal** mode survives.

Thus `2 (transverse) + 1 (longitudinal / eaten Goldstone) = 3 (massive)`, dropping to
`2` when massless: the vector-boson mass is exactly the extra longitudinal null mode.

Everything is explicit finite linear algebra over `ℚ` with the Minkowski metric
`η = diag(1,-1,-1,-1)`.  Honest scope: this is a DOF-counting statement, **not** the
dynamical Higgs mechanism.
-/

namespace HiggsLongitudinalMode

/-- The Minkowski metric signature `η = diag(1, -1, -1, -1)`. -/
def eta : Fin 4 → ℚ := ![1, -1, -1, -1]

/-- The Minkowski "dot with `k`" as a linear functional `ε ↦ ∑ᵢ ηᵢ εᵢ kᵢ` on `ℚ⁴`.
Transversality of a polarization `ε` to momentum `k` means `dotK k ε = 0`. -/
def dotK (k : Fin 4 → ℚ) : (Fin 4 → ℚ) →ₗ[ℚ] ℚ where
  toFun eps := ∑ i, eta i * eps i * k i
  map_add' a b := by
    simp only [Pi.add_apply]
    rw [← Finset.sum_add_distrib]
    exact Finset.sum_congr rfl (by intro i _; ring)
  map_smul' c a := by
    simp only [Pi.smul_apply, smul_eq_mul, RingHom.id_apply, Finset.mul_sum]
    exact Finset.sum_congr rfl (by intro i _; ring)

/-- Explicit four-term expansion of the Minkowski dot. -/
lemma dotK_apply (k eps : Fin 4 → ℚ) :
    dotK k eps = eta 0 * eps 0 * k 0 + eta 1 * eps 1 * k 1
      + eta 2 * eps 2 * k 2 + eta 3 * eps 3 * k 3 := by
  simp [dotK, Fin.sum_univ_four]

/-- The transverse space of any momentum `k` with a nonzero dot functional is
`3`-dimensional (rank–nullity: `dim ℚ⁴ = 4`, image `= ℚ` is `1`-dimensional). -/
lemma finrank_ker_eq_three (k : Fin 4 → ℚ) (h : dotK k ≠ 0) :
    Module.finrank ℚ (LinearMap.ker (dotK k)) = 3 := by
  have hsurj : Function.Surjective (dotK k) := LinearMap.surjective h
  have hrange : Module.finrank ℚ (LinearMap.range (dotK k)) = 1 := by
    rw [LinearMap.range_eq_top.mpr hsurj]; simp
  have hrn := LinearMap.finrank_range_add_finrank_ker (dotK k)
  rw [hrange] at hrn
  have h4 : Module.finrank ℚ (Fin 4 → ℚ) = 4 := by simp
  rw [h4] at hrn; omega

/-! ## Explicit rational witnesses -/

/-- A **null** momentum: `k·k = 1 - 1 = 0` (massless / photon). -/
def k_null : Fin 4 → ℚ := ![1, 1, 0, 0]

/-- A **timelike** momentum: `k·k = 25 - 9 = 16 = 4²  > 0` (massive / W,Z). -/
def k_time : Fin 4 → ℚ := ![5, 3, 0, 0]

/-- First transverse polarization (spatial `x²`-direction). -/
def epsT1 : Fin 4 → ℚ := ![0, 0, 1, 0]

/-- Second transverse polarization (spatial `x³`-direction). -/
def epsT2 : Fin 4 → ℚ := ![0, 0, 0, 1]

/-- The **longitudinal** polarization for `k_time`, made transverse:
`dotK k_time epsL = 15 - 15 = 0`.  This is the extra ("eaten Goldstone") mode. -/
def epsL : Fin 4 → ℚ := ![3, 5, 0, 0]

/-! ## Self-dots (the mass²) -/

/-- The null momentum is null: `k_null · k_null = 0`. -/
lemma dotK_null_self : dotK k_null k_null = 0 := by
  rw [dotK_apply]; simp [eta, k_null]

/-- The timelike momentum has `k_time · k_time = 16 = 4² > 0` (mass² `= 16`). -/
lemma dotK_time_self : dotK k_time k_time = 16 := by
  rw [dotK_apply]; simp [eta, k_time]; norm_num

/-! ## Nonvanishing of the dot functionals -/

lemma dotK_null_ne : dotK k_null ≠ 0 := by
  intro h
  have := LinearMap.congr_fun h (![1, 0, 0, 0])
  rw [dotK_apply] at this
  simp [eta, k_null] at this

lemma dotK_time_ne : dotK k_time ≠ 0 := by
  intro h
  have := LinearMap.congr_fun h (![1, 0, 0, 0])
  rw [dotK_apply] at this
  simp [eta, k_time] at this

/-! ## Transversality (membership in the polarization/kernel space) -/

lemma null_mem_ker : k_null ∈ LinearMap.ker (dotK k_null) := by
  rw [LinearMap.mem_ker, dotK_apply]; simp [eta, k_null]

lemma epsT1_mem_ker_null : epsT1 ∈ LinearMap.ker (dotK k_null) := by
  rw [LinearMap.mem_ker, dotK_apply]; simp [eta, epsT1, k_null]

lemma epsT2_mem_ker_null : epsT2 ∈ LinearMap.ker (dotK k_null) := by
  rw [LinearMap.mem_ker, dotK_apply]; simp [eta, epsT2, k_null]

lemma epsT1_mem_ker_time : epsT1 ∈ LinearMap.ker (dotK k_time) := by
  rw [LinearMap.mem_ker, dotK_apply]; simp [eta, epsT1, k_time]

lemma epsT2_mem_ker_time : epsT2 ∈ LinearMap.ker (dotK k_time) := by
  rw [LinearMap.mem_ker, dotK_apply]; simp [eta, epsT2, k_time]

lemma epsL_mem_ker_time : epsL ∈ LinearMap.ker (dotK k_time) := by
  rw [LinearMap.mem_ker, dotK_apply]; simp [eta, epsL, k_time]; norm_num

/-! ## Linear independence of the exhibited polarizations -/

lemma indep_transverse : LinearIndependent ℚ ![epsT1, epsT2] := by
  rw [Fintype.linearIndependent_iff]
  intro g hg
  have h2 := congrFun hg 2
  have h3 := congrFun hg 3
  simp [epsT1, epsT2, Fin.sum_univ_two] at h2 h3
  intro i; fin_cases i <;> simp_all

lemma indep_massive : LinearIndependent ℚ ![epsT1, epsT2, epsL] := by
  rw [Fintype.linearIndependent_iff]
  intro g hg
  have h0 := congrFun hg 0
  have h2 := congrFun hg 2
  have h3 := congrFun hg 3
  simp [epsT1, epsT2, epsL, Fin.sum_univ_three] at h0 h2 h3
  intro i; fin_cases i <;> simp_all

/-! ## Unified physical polarization count

`physDim k = dim(transverse) − [gauge direction inside transverse]`.  For null `k`
the gauge direction `k` lies in the transverse space (`k·k = 0`) so it is subtracted;
for timelike `k` it does not (`k·k ≠ 0`) so nothing is subtracted. -/
noncomputable def physDim (k : Fin 4 → ℚ) : ℕ :=
  Module.finrank ℚ (LinearMap.ker (dotK k)) - (if dotK k k = 0 then 1 else 0)

/-! ## Headline theorems -/

/-- **Target 1 — `massless_two_polarizations`.**  For the null momentum `k_null`
(`k·k = 0`, `k ≠ 0`), the transverse-mod-gauge space (`{ε : ε·k = 0}` quotiented by the
gauge direction `k`, which lies in the kernel) has dimension exactly `2`.  The two
transverse polarizations `epsT1, epsT2` are exhibited: both transverse and linearly
independent. -/
theorem massless_two_polarizations :
    dotK k_null k_null = 0 ∧ k_null ≠ 0 ∧
    Module.finrank ℚ (↥(LinearMap.ker (dotK k_null)) ⧸
      Submodule.span ℚ {(⟨k_null, null_mem_ker⟩ : ↥(LinearMap.ker (dotK k_null)))}) = 2 ∧
    epsT1 ∈ LinearMap.ker (dotK k_null) ∧ epsT2 ∈ LinearMap.ker (dotK k_null) ∧
    LinearIndependent ℚ ![epsT1, epsT2] := by
  refine ⟨dotK_null_self, ?_, ?_, epsT1_mem_ker_null, epsT2_mem_ker_null, indep_transverse⟩
  · intro h; have := congrFun h 0; simp [k_null] at this
  · have hkv : (⟨k_null, null_mem_ker⟩ : ↥(LinearMap.ker (dotK k_null))) ≠ 0 := by
      simp only [ne_eq, Submodule.mk_eq_zero]
      intro h; have := congrFun h 0; simp [k_null] at this
    rw [Submodule.finrank_quotient, finrank_span_singleton hkv,
      finrank_ker_eq_three k_null dotK_null_ne]

/-- **Target 2 — `massive_three_polarizations`.**  For the timelike momentum `k_time`
(`k·k = 16 = 4² > 0`) the transverse space `{ε : ε·k = 0}` has dimension exactly `3`
(no gauge quotient, since the gauge direction `k` is not transverse).  Two transverse
polarizations `epsT1, epsT2` plus the **longitudinal** `epsL` are exhibited: all
transverse and linearly independent (hence a basis of the `3`-dimensional space). -/
theorem massive_three_polarizations :
    dotK k_time k_time = 16 ∧
    Module.finrank ℚ (LinearMap.ker (dotK k_time)) = 3 ∧
    epsT1 ∈ LinearMap.ker (dotK k_time) ∧ epsT2 ∈ LinearMap.ker (dotK k_time) ∧
    epsL ∈ LinearMap.ker (dotK k_time) ∧
    LinearIndependent ℚ ![epsT1, epsT2, epsL] :=
  ⟨dotK_time_self, finrank_ker_eq_three k_time dotK_time_ne,
    epsT1_mem_ker_time, epsT2_mem_ker_time, epsL_mem_ker_time, indep_massive⟩

/-- **Target 3 — `longitudinal_is_mass` (payload).**  The exact count law: the physical
polarization count is `2 + [m ≠ 0]`.  The extra (third / longitudinal) polarization
exists **iff** `m ≠ 0` (i.e. `k·k ≠ 0`): as `m → 0` the gauge direction re-enters the
kernel and the count drops `3 → 2`.  So the longitudinal polarization *is* the mass. -/
theorem longitudinal_is_mass (k : Fin 4 → ℚ) (h : dotK k ≠ 0) :
    physDim k = 2 + (if dotK k k = 0 then 0 else 1) ∧
    (physDim k = 3 ↔ dotK k k ≠ 0) := by
  have hker := finrank_ker_eq_three k h
  constructor
  · unfold physDim; rw [hker]; by_cases hk : dotK k k = 0 <;> simp [hk]
  · unfold physDim; rw [hker]; by_cases hk : dotK k k = 0 <;> simp [hk]

/-- **Target 4 — `higgs_counting_verdict` (package).**  `2 (transverse) +
1 (longitudinal / eaten Goldstone) = 3` for a massive vector, dropping to `2` when
massless: the vector-boson mass is the extra longitudinal null mode.  The
gauge/Higgs-channel avatar of "mass from massless".

Honest scope: a finite DOF-counting statement, not the dynamical Higgs mechanism. -/
theorem higgs_counting_verdict :
    physDim k_null = 2 ∧ physDim k_time = 3 ∧
    physDim k_time = physDim k_null + 1 ∧
    dotK k_null k_null = 0 ∧ dotK k_time k_time = 16 := by
  have hn : physDim k_null = 2 := by
    unfold physDim
    rw [finrank_ker_eq_three k_null dotK_null_ne, dotK_null_self]; simp
  have ht : physDim k_time = 3 := by
    unfold physDim
    rw [finrank_ker_eq_three k_time dotK_time_ne, dotK_time_self]; norm_num
  exact ⟨hn, ht, by rw [hn, ht], dotK_null_self, dotK_time_self⟩

/-! ## Axiom footprint: exactly `[propext, Classical.choice, Quot.sound]` -/

/-- info: 'HiggsLongitudinalMode.massless_two_polarizations' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massless_two_polarizations

/-- info: 'HiggsLongitudinalMode.massive_three_polarizations' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massive_three_polarizations

/-- info: 'HiggsLongitudinalMode.longitudinal_is_mass' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms longitudinal_is_mass

/-- info: 'HiggsLongitudinalMode.higgs_counting_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms higgs_counting_verdict

end HiggsLongitudinalMode
