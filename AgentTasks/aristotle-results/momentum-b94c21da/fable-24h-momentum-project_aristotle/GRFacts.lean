import GRCore

/-!
# Gaussian-rational identities (decided by one disclosed `native_decide`)

This file imports the precompiled `GRCore` so the single `native_decide` below only
compiles the (small) decision term, reusing `GRCore`'s native code.
-/

open Matrix

/-! ## Gaussian-rational identities decided by a single (disclosed) `native_decide`. -/


set_option maxHeartbeats 1000000 in
theorem grFacts :
    (T2q4 = 1) ∧ (T2m * U2m = U2m * T2m) ∧ (Pg0m * Pg0m = Pg0m) ∧ (Pg1m * Pg1m = Pg1m) ∧ (Pg2m * Pg2m = Pg2m) ∧ (Pg3m * Pg3m = Pg3m) ∧ (Pg0m + Pg1m + Pg2m + Pg3m = 1) ∧ (Pg0m * U2m = U2m * Pg0m) ∧ (Pg1m * U2m = U2m * Pg1m) ∧ (Pg2m * U2m = U2m * Pg2m) ∧ (Pg3m * U2m = U2m * Pg3m) ∧ ((Pg0m).trace = ⟨6,0⟩) ∧ ((Pg1m).trace = ⟨8,0⟩) ∧ ((Pg2m).trace = ⟨6,0⟩) ∧ ((Pg3m).trace = ⟨8,0⟩) ∧ (Rmid * Pg0m = 0) ∧ ((5 • U2sq - 6 • U2m + 5 • (1:N28)) * (5 • U2sq + 6 • U2m + 5 • (1:N28)) * Pg1m = 0) ∧ (Rmid * q2m * Pg2m = 0) ∧ ((5 • U2sq - 6 • U2m + 5 • (1:N28)) * (5 • U2sq + 6 • U2m + 5 • (1:N28)) * Pg3m = 0) ∧ (((1 + U2m) * Pg0m).trace = ⟨8,0⟩) ∧ (((1 - U2m) * Pg0m).trace = ⟨4,0⟩) ∧ ((Rplusm * Pg2m).trace = ⟨2,0⟩) ∧ ((Rminusm * Pg2m).trace = ⟨2,0⟩) ∧ (((1 - Rplusm - Rminusm) * Pg2m).trace = ⟨2,0⟩) ∧ (RP2 * RP2 = RP2) ∧ ((T2m * K2g - K2g * T2m) 0 0 = ⟨0,3/5⟩) ∧ ((T2m * Vgm - Vgm * T2m) 9 13 = ⟨0,3/5⟩) ∧ ((∑ i, conjG ((Pg0m *ᵥ egv) i) * (Pg0m *ᵥ egv) i) = ⟨1/4,0⟩) ∧ ((∑ i, conjG ((Pg1m *ᵥ egv) i) * (Pg1m *ᵥ egv) i) = ⟨1/4,0⟩) ∧ ((∑ i, conjG ((Pg2m *ᵥ egv) i) * (Pg2m *ᵥ egv) i) = ⟨1/4,0⟩) ∧ ((∑ i, conjG ((Pg3m *ᵥ egv) i) * (Pg3m *ᵥ egv) i) = ⟨1/4,0⟩) := by native_decide

theorem f_T2q4 : T2q4 = 1 := grFacts.1
theorem f_comm : T2m * U2m = U2m * T2m := grFacts.2.1
theorem f_idem0 : Pg0m * Pg0m = Pg0m := grFacts.2.2.1
theorem f_idem1 : Pg1m * Pg1m = Pg1m := grFacts.2.2.2.1
theorem f_idem2 : Pg2m * Pg2m = Pg2m := grFacts.2.2.2.2.1
theorem f_idem3 : Pg3m * Pg3m = Pg3m := grFacts.2.2.2.2.2.1
theorem f_complete : Pg0m + Pg1m + Pg2m + Pg3m = 1 := grFacts.2.2.2.2.2.2.1
theorem f_pc0 : Pg0m * U2m = U2m * Pg0m := grFacts.2.2.2.2.2.2.2.1
theorem f_pc1 : Pg1m * U2m = U2m * Pg1m := grFacts.2.2.2.2.2.2.2.2.1
theorem f_pc2 : Pg2m * U2m = U2m * Pg2m := grFacts.2.2.2.2.2.2.2.2.2.1
theorem f_pc3 : Pg3m * U2m = U2m * Pg3m := grFacts.2.2.2.2.2.2.2.2.2.2.1
theorem f_tr0 : (Pg0m).trace = ⟨6,0⟩ := grFacts.2.2.2.2.2.2.2.2.2.2.2.1
theorem f_tr1 : (Pg1m).trace = ⟨8,0⟩ := grFacts.2.2.2.2.2.2.2.2.2.2.2.2.1
theorem f_tr2 : (Pg2m).trace = ⟨6,0⟩ := grFacts.2.2.2.2.2.2.2.2.2.2.2.2.2.1
theorem f_tr3 : (Pg3m).trace = ⟨8,0⟩ := grFacts.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1
theorem f_ann0 : Rmid * Pg0m = 0 := grFacts.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1
theorem f_ann1 : (5 • U2sq - 6 • U2m + 5 • (1:N28)) * (5 • U2sq + 6 • U2m + 5 • (1:N28)) * Pg1m = 0 := grFacts.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1
theorem f_ann2 : Rmid * q2m * Pg2m = 0 := grFacts.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1
theorem f_ann3 : (5 • U2sq - 6 • U2m + 5 • (1:N28)) * (5 • U2sq + 6 • U2m + 5 • (1:N28)) * Pg3m = 0 := grFacts.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1
theorem f_pm0a : ((1 + U2m) * Pg0m).trace = ⟨8,0⟩ := grFacts.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1
theorem f_pm0b : ((1 - U2m) * Pg0m).trace = ⟨4,0⟩ := grFacts.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1
theorem f_rp : (Rplusm * Pg2m).trace = ⟨2,0⟩ := grFacts.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1
theorem f_rm : (Rminusm * Pg2m).trace = ⟨2,0⟩ := grFacts.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1
theorem f_rpair : ((1 - Rplusm - Rminusm) * Pg2m).trace = ⟨2,0⟩ := grFacts.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1
theorem f_rp2idem : RP2 * RP2 = RP2 := grFacts.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1
theorem f_kick1 : (T2m * K2g - K2g * T2m) 0 0 = ⟨0,3/5⟩ := grFacts.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1
theorem f_kick2 : (T2m * Vgm - Vgm * T2m) 9 13 = ⟨0,3/5⟩ := grFacts.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1
theorem f_neutral0 : (∑ i, conjG ((Pg0m *ᵥ egv) i) * (Pg0m *ᵥ egv) i) = ⟨1/4,0⟩ := grFacts.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1
theorem f_neutral1 : (∑ i, conjG ((Pg1m *ᵥ egv) i) * (Pg1m *ᵥ egv) i) = ⟨1/4,0⟩ := grFacts.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1
theorem f_neutral2 : (∑ i, conjG ((Pg2m *ᵥ egv) i) * (Pg2m *ᵥ egv) i) = ⟨1/4,0⟩ := grFacts.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1
theorem f_neutral3 : (∑ i, conjG ((Pg3m *ᵥ egv) i) * (Pg3m *ᵥ egv) i) = ⟨1/4,0⟩ := grFacts.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2

/-! ## Clean Gaussian-rational identities (in terms of the original definitions). -/

theorem gr_T2pow4 : T2g ^ 4 = 1 := by rw [← T2q4_eq]; exact f_T2q4
theorem gr_comm : T2g * U2g = U2g * T2g := by
  have h := f_comm; rwa [T2m_eq, U2m_eq] at h
theorem gr_idem (K : Fin 4) : Pg K * Pg K = Pg K := by
  fin_cases K
  · have h := f_idem0; rwa [Pg0m_eq] at h
  · have h := f_idem1; rwa [Pg1m_eq] at h
  · have h := f_idem2; rwa [Pg2m_eq] at h
  · have h := f_idem3; rwa [Pg3m_eq] at h
theorem gr_complete : Pg 0 + Pg 1 + Pg 2 + Pg 3 = 1 := by
  have h := f_complete; rwa [Pg0m_eq, Pg1m_eq, Pg2m_eq, Pg3m_eq] at h
theorem gr_commutes (K : Fin 4) : Pg K * U2g = U2g * Pg K := by
  fin_cases K
  · have h := f_pc0; rwa [Pg0m_eq, U2m_eq] at h
  · have h := f_pc1; rwa [Pg1m_eq, U2m_eq] at h
  · have h := f_pc2; rwa [Pg2m_eq, U2m_eq] at h
  · have h := f_pc3; rwa [Pg3m_eq, U2m_eq] at h
theorem gr_tr0 : (Pg 0).trace = ⟨6,0⟩ := by rw [← Pg0m_eq]; exact f_tr0
theorem gr_tr1 : (Pg 1).trace = ⟨8,0⟩ := by rw [← Pg1m_eq]; exact f_tr1
theorem gr_tr2 : (Pg 2).trace = ⟨6,0⟩ := by rw [← Pg2m_eq]; exact f_tr2
theorem gr_tr3 : (Pg 3).trace = ⟨8,0⟩ := by rw [← Pg3m_eq]; exact f_tr3
theorem gr_ann0 : (U2g - 1) * (U2g + 1) * Pg 0 = 0 := by
  have h := f_ann0; rwa [Rmid_eq, Pg0m_eq] at h
theorem gr_ann1 :
    (5 • U2g ^ 2 - 6 • U2g + 5 • (1:N28)) * (5 • U2g ^ 2 + 6 • U2g + 5 • (1:N28)) * Pg 1 = 0 := by
  have h := f_ann1; rw [U2sq_eq, U2m_eq, Pg1m_eq] at h; exact h
theorem gr_ann2 :
    (U2g - 1) * (U2g + 1) * (25 • U2g ^ 2 + 14 • U2g + 25 • (1:N28)) * Pg 2 = 0 := by
  have h := f_ann2; rw [Rmid_eq, q2m_eq, Pg2m_eq] at h; exact h
theorem gr_ann3 :
    (5 • U2g ^ 2 - 6 • U2g + 5 • (1:N28)) * (5 • U2g ^ 2 + 6 • U2g + 5 • (1:N28)) * Pg 3 = 0 := by
  have h := f_ann3; rw [U2sq_eq, U2m_eq, Pg3m_eq] at h; exact h
theorem gr_pm0a : ((1 + U2g) * Pg 0).trace = ⟨8,0⟩ := by
  have h := f_pm0a; rwa [U2m_eq, Pg0m_eq] at h
theorem gr_pm0b : ((1 - U2g) * Pg 0).trace = ⟨4,0⟩ := by
  have h := f_pm0b; rwa [U2m_eq, Pg0m_eq] at h
theorem gr_rp : (Rplus_g * Pg 2).trace = ⟨2,0⟩ := by
  have h := f_rp; rwa [Rplusm_eq, Pg2m_eq] at h
theorem gr_rm : (Rminus_g * Pg 2).trace = ⟨2,0⟩ := by
  have h := f_rm; rwa [Rminusm_eq, Pg2m_eq] at h
theorem gr_rpair : ((1 - Rplus_g - Rminus_g) * Pg 2).trace = ⟨2,0⟩ := by
  have h := f_rpair; rwa [Rplusm_eq, Rminusm_eq, Pg2m_eq] at h
theorem gr_rp2idem : (Rplus_g * Pg 2) * (Rplus_g * Pg 2) = Rplus_g * Pg 2 := by
  have h := f_rp2idem; rwa [RP2_eq] at h
theorem gr_kick1 : (T2g * K2g - K2g * T2g) 0 0 = ⟨0,3/5⟩ := by
  have h := f_kick1; rwa [T2m_eq] at h
theorem gr_kick2 : (T2g * Vg - Vg * T2g) 9 13 = ⟨0,3/5⟩ := by
  have h := f_kick2; rwa [T2m_eq, Vgm_eq] at h
theorem gr_neutral (K : Fin 4) :
    (∑ i, conjG ((Pg K *ᵥ egv) i) * (Pg K *ᵥ egv) i) = ⟨1/4,0⟩ := by
  fin_cases K
  · have h := f_neutral0; rwa [Pg0m_eq] at h
  · have h := f_neutral1; rwa [Pg1m_eq] at h
  · have h := f_neutral2; rwa [Pg2m_eq] at h
  · have h := f_neutral3; rwa [Pg3m_eq] at h
