import PhysicsSM.Draft.NullEdge.CommutatorRegulator

/-!
# Corner invisibility of zero-offset commutator regulators

The exact group-commutator primitive is attractive because its first jet
vanishes.  This target records a severe boundary: if either phase angle has
zero sine, the commutator is already trivial (under the corresponding
involution hypothesis).  Consequently a product whose angles are integer
linear forms in cubic lattice momenta is invisible at every `0/pi` corner and
cannot remove the live walk's corner aliases.

Provenance: theorem statements prepared locally; all seven proofs completed
without signature changes by Aristotle project
`8936c334-fe51-48a0-8fdc-1a1a6613ad37`, task
`97a83d9e-04a2-4983-af01-2827b367a443`.
-/

namespace PhysicsSM.Draft.NullEdge.CommutatorCornerInvisibility

open CommutatorRegulator

theorem phaseStep_sine_zero (c : Real) (A : M4) :
    phaseStep c 0 A = (c : Complex) • 1 := by
  simp [phaseStep]

theorem regulator_first_sine_zero
    (cp cq sq : Real) (A G : M4)
    (hG : G * G = 1) (hp : cp ^ 2 = 1)
    (hq : cq ^ 2 + sq ^ 2 = 1) :
    regulator cp 0 cq sq A G = 1 := by
  unfold regulator
  have e0 : phaseStep cp 0 A = (cp : Complex) • 1 := by simp [phaseStep]
  have e0' : phaseStep cp (-0) A = (cp : Complex) • 1 := by simp [phaseStep]
  rw [e0, e0']
  have h1 : phaseStep cq sq G * phaseStep cq (-sq) G = 1 :=
    phaseStep_mul_reverse cq sq G hG hq
  have hcast : (cp : Complex) ^ 2 = 1 := by exact_mod_cast hp
  simp only [smul_mul_assoc, mul_smul_comm, one_mul, mul_one, smul_smul]
  rw [h1, ← pow_two, hcast, one_smul]

theorem regulator_second_sine_zero
    (cp sp cq : Real) (A G : M4)
    (hA : A * A = 1) (hp : cp ^ 2 + sp ^ 2 = 1)
    (hq : cq ^ 2 = 1) :
    regulator cp sp cq 0 A G = 1 := by
  unfold regulator
  have e0 : phaseStep cq 0 G = (cq : Complex) • 1 := by simp [phaseStep]
  have e0' : phaseStep cq (-0) G = (cq : Complex) • 1 := by simp [phaseStep]
  rw [e0, e0']
  have h1 : phaseStep cp sp A * phaseStep cp (-sp) A = 1 :=
    phaseStep_mul_reverse cp sp A hA hp
  have hcast : (cq : Complex) ^ 2 = 1 := by exact_mod_cast hq
  simp only [smul_mul_assoc, mul_smul_comm, mul_one, smul_smul]
  rw [h1, ← pow_two, hcast, one_smul]

def cornerSign (b : Bool) : Real := if b then -1 else 1

theorem cornerSign_sq (b : Bool) : cornerSign b ^ 2 = 1 := by
  cases b <;> norm_num [cornerSign]

/-- At a cubic corner every integer-frequency phase step is central, so the
commutator loop is exactly invisible. -/
theorem regulator_corner_trivial (bp bq : Bool) (A G : M4) :
    regulator (cornerSign bp) 0 (cornerSign bq) 0 A G = 1 := by
  unfold regulator
  simp only [phaseStep, neg_zero, Complex.ofReal_zero, mul_zero, zero_smul,
    sub_zero]
  have hp : (cornerSign bp : Complex) ^ 2 = 1 := by
    exact_mod_cast cornerSign_sq bp
  have hq : (cornerSign bq : Complex) ^ 2 = 1 := by
    exact_mod_cast cornerSign_sq bq
  simp only [mul_smul_comm, mul_one, smul_smul]
  have key : ((cornerSign bq : Complex) * ((cornerSign bp : Complex) *
      ((cornerSign bq : Complex) * (cornerSign bp : Complex)))) =
      (cornerSign bp : Complex) ^ 2 * (cornerSign bq : Complex) ^ 2 := by ring
  rw [key, hp, hq, mul_one, one_smul]

/-- Finite products of corner-invisible regulators remain invisible. -/
theorem product_corner_trivial (n : Nat) (R : Fin n -> M4)
    (hR : forall i, R i = 1) :
    (List.ofFn R).foldl (fun acc r => acc * r) 1 = 1 := by
  have key : ∀ (l : List M4) (acc : M4), (∀ x ∈ l, x = 1) →
      l.foldl (fun acc r => acc * r) acc = acc := by
    intro l
    induction l with
    | nil => intro acc _; simp
    | cons hd tl ih =>
      intro acc h
      simp only [List.foldl_cons]
      rw [h hd (by simp), mul_one]
      exact ih acc (fun x hx => h x (by simp [hx]))
  apply key
  intro x hx
  simp only [List.mem_ofFn] at hx
  obtain ⟨i, rfl⟩ := hx
  exact hR i

/-- Negative control: the rational noncentral quarter-turn fixture proves that
the same primitive is not globally trivial away from the corner locus. -/
theorem exists_nontrivial_away_from_corners :
    Exists fun A : M4 => Exists fun G : M4 =>
      regulator 0 1 0 1 A G ≠ 1 := by
  obtain ⟨A, G, _, _, _, _, h, _⟩ := exists_noncentral_quarterTurn
  exact ⟨A, G, h⟩

end PhysicsSM.Draft.NullEdge.CommutatorCornerInvisibility
