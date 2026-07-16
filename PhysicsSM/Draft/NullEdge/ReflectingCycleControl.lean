import PhysicsSM.Draft.NullEdge.OpenBoundaryReflectingShift

/-!
# Exact cycle structure of the reflecting open-boundary shift

The finite reflecting update is conjugate to addition by one on a cycle of
length `2 * (N + 1)`. This is a nonchiral control for the anomalous-Floquet
3+1 route: boundary memory restores a local reversible update, but reflection
alone supplies no net boundary anomaly.

Provenance: Aristotle job `847494db-4bfe-4d09-adcb-e6a78a721c8a`, adapted to
reuse `OpenBoundaryReflectingShift` rather than duplicate its definitions.
No Weyl, winding, or bulk-boundary correspondence is asserted here.
-/

namespace PhysicsSM.Draft.NullEdge.ReflectingCycleControl

open OpenBoundaryReflectingShift

/-- Coordinate around the reflected orbit: first rightward, then leftward. -/
def orbitIndex {N : Nat} (s : State N) : Fin (2 * (N + 1)) :=
  match s with
  | (true, x) => ⟨x.val, by omega⟩
  | (false, x) => ⟨2 * N + 1 - x.val, by omega⟩

/-- One reflecting step advances exactly once around the orbit coordinate. -/
theorem orbitIndex_step {N : Nat} (s : State N) :
    orbitIndex (step s) = orbitIndex s + 1 := by
  rcases s with ⟨b, x⟩
  rcases b with (_ | _) <;> simp_all +decide [orbitIndex]
  · rcases x with ⟨_ | x, hx⟩ <;> simp_all +decide [Fin.ext_iff, step]
    · norm_num [Fin.val_add]
    · norm_num [Fin.val_add, Fin.val_one, decClamp]
      rw [Nat.mod_eq_of_lt] <;> omega
  · unfold step
    rcases eq_or_ne x.val N <;> simp_all +decide [Fin.ext_iff, Fin.val_add]
    · rw [Nat.mod_eq_of_lt] <;> omega
    · rw [Nat.mod_eq_of_lt] <;> simp +arith +decide [*, incClamp]
      · grind
      · grind +splitIndPred

/-- The orbit coordinate loses no state information. -/
theorem orbitIndex_bijective (N : Nat) :
    Function.Bijective (orbitIndex (N := N)) := by
  have h_card : Fintype.card (State N) = Fintype.card (Fin (2 * (N + 1))) := by
    simp +arith +decide [State]
  have h_inj : Function.Injective (orbitIndex : State N → Fin (2 * (N + 1))) := by
    intro s t
    rcases s with ⟨b1, x1⟩
    rcases t with ⟨b2, x2⟩
    simp_all +decide [State]
    cases b1 <;> cases b2 <;> simp_all +decide [orbitIndex]
    · exact fun h => Fin.ext <| by
        rw [tsub_right_inj] at h <;> linarith [Fin.is_lt x1, Fin.is_lt x2]
    · omega
    · omega
    · exact fun h => Fin.ext h
  refine ⟨h_inj, ?_⟩
  exact ((Fintype.bijective_iff_injective_and_card orbitIndex).mpr ⟨h_inj, h_card⟩).2

/-- Iterating `step` advances the orbit coordinate by the same number of ticks. -/
theorem orbitIndex_iterate {N : Nat} (s : State N) (k : Nat) :
    (orbitIndex (step^[k] s)).val = ((orbitIndex s).val + k) % (2 * (N + 1)) := by
  induction' k with k ih
  · norm_num [Nat.mod_eq_of_lt]
  · rw [Function.iterate_succ_apply', orbitIndex_step]
    simp +decide [← add_assoc, ih, Fin.val_add]

/-- Every reflecting state reaches every other state under iteration. -/
theorem step_transitive {N : Nat} (s t : State N) :
    ∃ k : Nat, step^[k] s = t := by
  obtain ⟨k, hk⟩ :
      ∃ k : Nat, ((orbitIndex s) + k) % (2 * (N + 1)) = (orbitIndex t).val := by
    use (orbitIndex t).val + 2 * (N + 1) - (orbitIndex s).val
    rw [add_tsub_cancel_of_le]
    · norm_num [Fin.val_add, Nat.mod_eq_of_lt]
    · exact le_add_of_nonneg_of_le (Nat.zero_le _) (Nat.le_of_lt (Fin.is_lt _))
  use k
  exact Function.Injective.eq_iff (orbitIndex_bijective N).1 |>.1
    (by simp +decide [Fin.ext_iff, hk, orbitIndex_iterate])

/-- The explicit full orbit length returns every state to itself. -/
theorem step_full_period {N : Nat} (s : State N) :
    step^[2 * (N + 1)] s = s := by
  convert (Function.Injective.eq_iff
    (show Function.Injective (orbitIndex : State N → Fin (2 * (N + 1))) from
      (orbitIndex_bijective N).injective)).1 _ using 1
  convert orbitIndex_iterate s (2 * (N + 1)) using 1
  simp +decide [Fin.ext_iff, Nat.mod_eq_of_lt]

/-- The control is nonvacuous already on a two-site interval. -/
theorem two_site_orbit_witness :
    step^[4] (true, (0 : Fin 2)) = (true, (0 : Fin 2)) ∧
    step^[2] (true, (0 : Fin 2)) ≠ (true, (0 : Fin 2)) := by
  decide

/-! ### Build-enforced standard-axiom guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.ReflectingCycleControl.orbitIndex_bijective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms orbitIndex_bijective

/-- info: 'PhysicsSM.Draft.NullEdge.ReflectingCycleControl.step_transitive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms step_transitive

end PhysicsSM.Draft.NullEdge.ReflectingCycleControl
