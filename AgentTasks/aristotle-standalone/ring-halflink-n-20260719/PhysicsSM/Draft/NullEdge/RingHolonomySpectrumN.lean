import PhysicsSM.Draft.NullEdge.RingHolonomySpectrum

/-!
# General odd-length ring holonomy: the spectral witness at every odd n

Target statements for the Aristotle job `ring-holonomy-n-20260718`.

Context (Paper A upgrade gate). `RingHolonomySpectrum` proves the three-site
case: gauge conjugacy, holonomy gauge-invariance, the cubic-trace witness
`trace_cube_H3`, and the `+1`/`-1` holonomy spectral separation.
`PlueckerRingHolonomyBridge` feeds it the derived winding-one half-link
field.  The portfolio's flagship gate asks to promote the two-site
transported-phase identity to a GENUINE ring-holonomy spectral witness; the
honest general form is the arbitrary odd-length ring.

Mathematical content.  For the directed `n`-site ring Hamiltonian with link
phases `u : ZMod n → ℂ` (Hermitian by construction), every closed length-`n`
walk on the cycle has net winding `+1` or `-1` when `n` is ODD (a
zero-winding closed walk of length `n` needs `n` even, by parity), so

  `trace ((HRing n u) ^ n) = n * (holonomy u + conj (holonomy u))`

for unit-phase links.  Since the trace of a fixed matrix power is a unitary
conjugacy invariant, rings with different `Re (holonomy)` are spectrally
distinguishable at every odd `n` - the general-`n` witness.

Consistency anchor: at `n = 3`, `holonomy = -1` gives `3 * (-2) = -6`,
matching the landed `trace_cube_H3` witness.

Pre-registered honesty license: if the trace formula needs a different
normalization (e.g. an extra factor from the chosen matrix convention),
prove the true formula, rename, record the mismatch prominently, and still
derive the strongest true discriminator.  Every `s o r r y` below is a
documented Aristotle handoff hole.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.RingHolonomySpectrumN

open Matrix Complex

/-- Directed `n`-site ring Hamiltonian with link phases `u`: hop `i → i+1`
carries `u i`, and the reverse hop carries the conjugate phase. -/
def HRing (n : ℕ) [NeZero n] (u : ZMod n → ℂ) : Matrix (ZMod n) (ZMod n) ℂ :=
  Matrix.of fun i j =>
    (if j = i + 1 then u i else 0) + (if i = j + 1 then starRingEnd ℂ (u j) else 0)

/-- The ring holonomy: the product of all link phases. -/
def holonomy (n : ℕ) [NeZero n] (u : ZMod n → ℂ) : ℂ := ∏ i, u i

/-- All links are unit phases. -/
def UnitLinks (n : ℕ) [NeZero n] (u : ZMod n → ℂ) : Prop :=
  ∀ i, u i * starRingEnd ℂ (u i) = 1

/-
The ring Hamiltonian is Hermitian by construction.
-/
theorem HRing_isHermitian (n : ℕ) [NeZero n] (hn : 2 < n) (u : ZMod n → ℂ) :
    (HRing n u).IsHermitian := by
  ext i j; simp +decide [ HRing ] ; ring;
  split_ifs <;> ring;
  · simp_all +singlePass [ add_comm ];
  · norm_num;
  · norm_num;
  · norm_num

/-- Site-wise gauge transformation of the link field. -/
def gaugedLinks (n : ℕ) [NeZero n] (g u : ZMod n → ℂ) : ZMod n → ℂ :=
  fun i => g i * u i * starRingEnd ℂ (g (i + 1))

/-
Gauge conjugacy: gauging the links conjugates the Hamiltonian by the
diagonal phase matrix.
-/
theorem HRing_gauge_conjugacy (n : ℕ) [NeZero n] (hn : 2 < n)
    (g u : ZMod n → ℂ) (hg : ∀ i, g i * starRingEnd ℂ (g i) = 1) :
    HRing n (gaugedLinks n g u) =
      Matrix.diagonal g * HRing n u * (Matrix.diagonal g)ᴴ := by
  ext i j; simp +decide [ HRing, gaugedLinks ] ;
  grind

/-
The holonomy is gauge-invariant.
-/
theorem holonomy_gauge_invariant (n : ℕ) [NeZero n]
    (g u : ZMod n → ℂ) (hg : ∀ i, g i * starRingEnd ℂ (g i) = 1) :
    holonomy n (gaugedLinks n g u) = holonomy n u := by
  unfold holonomy gaugedLinks;
  simp +decide [ mul_assoc, mul_comm, mul_left_comm, Finset.prod_mul_distrib ];
  rw [ ← Equiv.prod_comp ( Equiv.addRight 1 ) ] ; simp_all +decide [ mul_assoc, mul_comm, mul_left_comm ];
  simp +decide [ ← Finset.prod_mul_distrib, hg ]

/-- The forward weighted cyclic shift. -/
def forwardHop (n : ℕ) [NeZero n] (u : ZMod n → ℂ) : Matrix (ZMod n) (ZMod n) ℂ :=
  Matrix.of fun i j => if j = i + 1 then u i else 0

/-- The backward weighted cyclic shift. -/
def backwardHop (n : ℕ) [NeZero n] (u : ZMod n → ℂ) : Matrix (ZMod n) (ZMod n) ℂ :=
  Matrix.of fun i j => if i = j + 1 then starRingEnd ℂ (u j) else 0

lemma HRing_eq_forward_add_backward (n : ℕ) [NeZero n] (u : ZMod n → ℂ) :
    HRing n u = forwardHop n u + backwardHop n u := by
  ext i j; simp +decide [ HRing, forwardHop, backwardHop ] ;

lemma forward_backward_mul (n : ℕ) [NeZero n] (u : ZMod n → ℂ)
    (hu : UnitLinks n u) :
    forwardHop n u * backwardHop n u = 1 := by
  ext i j; simp +decide [ *, Matrix.mul_apply ] ; (
  rw [ Finset.sum_eq_single ( i + 1 ) ] <;> simp_all +decide [ forwardHop, backwardHop ];
  rw [ Matrix.one_apply ] ; aesop);

lemma backward_forward_mul (n : ℕ) [NeZero n] (u : ZMod n → ℂ)
    (hu : UnitLinks n u) :
    backwardHop n u * forwardHop n u = 1 := by
  convert mul_eq_one_comm.mp ( forward_backward_mul n u hu ) using 1

lemma trace_forward_pow_length (n : ℕ) [NeZero n] (u : ZMod n → ℂ) :
    ((forwardHop n u) ^ n).trace = (n : ℂ) * holonomy n u := by
  -- By definition of $F$, we know that $(F^k)_{ij} = \prod_{r=0}^{k-1} u_{i+r}$ if $j = i + k$ and $0$ otherwise.
  have hFk : ∀ k : ℕ, ∀ i j : ZMod n, (forwardHop n u ^ k) i j = if j = i + k then (∏ r ∈ Finset.range k, u (i + r)) else 0 := by
    intro k i j; induction' k with k ih generalizing i j <;> simp_all +decide [ pow_succ, Matrix.mul_apply ] ;
    · simp +decide [ Matrix.one_apply, eq_comm ];
    · simp +decide [ ← add_assoc, Finset.prod_range_succ, forwardHop ];
  simp_all +decide [ Matrix.trace ];
  -- By definition of $holonomy$, we know that $\prod_{r=0}^{n-1} u_{i+r} = \prod_{r=0}^{n-1} u_r$ for any $i$.
  have h_prod_eq : ∀ i : ZMod n, ∏ r ∈ Finset.range n, u (i + r) = ∏ r ∈ Finset.univ, u r := by
    intro i;
    rcases n with ( _ | _ | n ) <;> simp_all +decide [ Finset.prod_range, ZMod ];
    · exact False.elim <| NeZero.ne 0 rfl;
    · fin_cases i ; rfl;
    · exact Equiv.prod_comp ( Equiv.addLeft i ) u;
  simp_all +decide [ holonomy ]

lemma trace_backward_pow_length (n : ℕ) [NeZero n] (u : ZMod n → ℂ) :
    ((backwardHop n u) ^ n).trace =
      (n : ℂ) * starRingEnd ℂ (holonomy n u) := by
  -- Let's denote the backward shift operator as $B$ and the forward shift operator as $F$.
  set B : Matrix (ZMod n) (ZMod n) ℂ := backwardHop (n := n) u
  set F : Matrix (ZMod n) (ZMod n) ℂ := forwardHop (n := n) u
  generalize_proofs at *; (
  -- Since $B$ is the conjugate transpose of $F$, we have $B = F^*$.
  have hB_conj : B = F.conjTranspose := by
    ext i j; simp [B, F, backwardHop, forwardHop];
    split_ifs <;> simp +decide [ * ];
  -- Since $B$ is the conjugate transpose of $F$, we have $B^n = (F^n)^*$.
  have hB_pow : B ^ n = (F ^ n).conjTranspose := by
    rw [ hB_conj, Matrix.conjTranspose_pow ]
  generalize_proofs at *; (
  rw [ hB_pow, Matrix.trace_conjTranspose ];
  rw [ trace_forward_pow_length ] ; norm_num [ mul_comm ]))

lemma trace_mixed_hops_zero (n k : ℕ) [NeZero n] (hodd : Odd n)
    (hk0 : 0 < k) (hkn : k < n) (u : ZMod n → ℂ) :
    ((forwardHop n u) ^ k * (backwardHop n u) ^ (n - k)).trace = 0 := by
  -- By definition of forwardHop and backwardHop, we know that (forwardHop n u)^k i j is nonzero only if j = i + k.
  have h_forwardHop_pow : ∀ k : ℕ, ∀ i j : ZMod n, ((forwardHop n u) ^ k) i j = if j = i + k then (∏ m ∈ Finset.range k, u (i + m)) else 0 := by
    intro k i j; induction' k with k ih generalizing i j <;> simp_all +decide [ pow_succ, Matrix.mul_apply ] ;
    · simp +decide [ Matrix.one_apply, eq_comm ];
    · simp +decide [ ← add_assoc, Finset.prod_range_succ, forwardHop ];
  -- By definition of forwardHop and backwardHop, we know that (backwardHop n u)^(n-k) i j is nonzero only if j = i - (n-k).
  have h_backwardHop_pow : ∀ k : ℕ, ∀ i j : ZMod n, ((backwardHop n u) ^ k) i j = if i = j + k then (∏ m ∈ Finset.range k, starRingEnd ℂ (u (j + m))) else 0 := by
    intro k;
    induction' k with k ih;
    · simp +decide [ Matrix.one_apply ];
    · simp +decide [ *, pow_succ', Matrix.mul_apply, Finset.prod_range_succ ];
      intro i j; rw [ backwardHop ] ; simp +decide [ add_assoc, mul_comm ] ;
  simp_all +decide [ Matrix.trace, Matrix.mul_apply ];
  intro h; rw [ Nat.cast_sub hkn.le ] at h; simp_all +decide [ ZMod.natCast_eq_natCast_iff' ] ;
  rw [ neg_eq_iff_add_eq_zero ] at h ; norm_cast at h ; simp_all +decide [ ← two_mul ];
  norm_cast at h;
  rw [ ZMod.natCast_eq_zero_iff ] at h ; exact absurd ( Nat.Coprime.dvd_of_dvd_mul_left ( show Nat.Coprime n 2 from by rcases hodd with ⟨ m, rfl ⟩ ; norm_num ) h ) ( Nat.not_dvd_of_pos_of_lt hk0 hkn )

/-
**Main target: the odd-`n` trace-power holonomy formula.**  For odd
`n > 2` and unit links, the trace of the `n`-th power of the ring
Hamiltonian is `n` times twice the real part of the holonomy.  (Parity:
a closed length-`n` walk on the `n`-cycle with steps `±1` has net
displacement `≡ n (mod 2)`, so for odd `n` every contributing walk winds
exactly once, forward or backward.)
-/
theorem trace_pow_odd (n : ℕ) [NeZero n] (hodd : Odd n) (hn : 2 < n)
    (u : ZMod n → ℂ) (hu : UnitLinks n u) :
    ((HRing n u) ^ n).trace =
      (n : ℂ) * (holonomy n u + starRingEnd ℂ (holonomy n u)) := by
  -- Expand using binomial theorem:
  have h_expand : (HRing n u) ^ n = ∑ k ∈ Finset.range (n + 1), (Nat.choose n k : ℂ) • (forwardHop n u) ^ k * (backwardHop n u) ^ (n - k) := by
    convert Commute.add_pow ( show Commute ( forwardHop n u ) ( backwardHop n u ) from ?_ ) n using 1;
    · simp +decide [ mul_assoc, mul_comm, mul_left_comm, Algebra.smul_def ];
      simp +decide [ ← mul_assoc, ← Nat.cast_comm ];
    · ext i j; simp +decide [ forwardHop, backwardHop ] ;
      simp +decide [ Matrix.mul_apply ];
      rw [ Finset.sum_eq_single ( j - 1 ) ] <;> simp +decide [ mul_comm ];
      · have := hu i; have := hu ( j - 1 ) ; simp_all +decide [ mul_comm, UnitLinks ] ;
        grind;
      · aesop;
  by_cases h : n = 0 <;> simp_all +decide [ Finset.sum_range_succ ];
  rw [ Finset.sum_eq_single 0 ] <;> simp_all +decide [ Finset.sum_range_succ' ];
  · rw [ trace_forward_pow_length, trace_backward_pow_length ] ; ring;
  · exact fun k hk₁ hk₂ => Or.inr <| trace_mixed_hops_zero n k hodd ( Nat.pos_of_ne_zero hk₂ ) hk₁ u

/-
**Spectral discriminator at every odd `n`.**  Unit-link ring
Hamiltonians with different holonomy real parts are not unitarily
conjugate.
-/
theorem not_unitarily_conjugate_of_holonomy_re_ne (n : ℕ) [NeZero n]
    (hodd : Odd n) (hn : 2 < n) (u v : ZMod n → ℂ)
    (hu : UnitLinks n u) (hv : UnitLinks n v)
    (hre : (holonomy n u).re ≠ (holonomy n v).re) :
    ¬ ∃ W : Matrix (ZMod n) (ZMod n) ℂ, W ∈ Matrix.unitaryGroup (ZMod n) ℂ ∧
      W * HRing n u * Wᴴ = HRing n v := by
  contrapose! hre; simp_all +decide [ Matrix.mem_unitaryGroup_iff ] ;
  -- Assume there exists a unitary matrix $W$ such that $W^{-1} H_u W = H_v$.
  obtain ⟨W, hW_unitary, hW_conj⟩ := hre
  have hW_inv : Wᴴ * W = 1 := by
    convert mul_eq_one_comm.mp hW_unitary using 1;
  -- By induction or conjugation algebra, we have $H_v^n = W * H_u^n * Wᴴ$.
  have h_pow_conj : (HRing n v) ^ n = W * (HRing n u) ^ n * Wᴴ := by
    have h_pow : ∀ k : ℕ, (HRing n v) ^ k = W * (HRing n u) ^ k * Wᴴ := by
      intro k; induction k <;> simp_all +decide [ pow_succ, mul_assoc ] ;
      · convert hW_unitary.symm using 1;
      · simp +decide [ ← hW_conj, ← mul_assoc, hW_inv ];
    exact h_pow n;
  -- By trace cyclicity and Wᴴ*W=1, traces are equal.
  have h_trace_eq : (HRing n v ^ n).trace = (HRing n u ^ n).trace := by
    rw [ h_pow_conj, Matrix.trace_mul_comm ];
    rw [ ← Matrix.mul_assoc, hW_inv, Matrix.one_mul ];
  rw [ trace_pow_odd n hodd hn u hu, trace_pow_odd n hodd hn v hv ] at h_trace_eq;
  simp_all +decide [ Complex.ext_iff, NeZero.ne ];
  linarith

/-
Winding-one bridge corollary: at every odd `n > 2`, a `-1`-holonomy
unit-link ring (the half-link image of total turning `2π`) is not unitarily
conjugate to the trivial `+1`-holonomy ring.
-/
theorem winding_one_not_conjugate_trivial (n : ℕ) [NeZero n]
    (hodd : Odd n) (hn : 2 < n) (u v : ZMod n → ℂ)
    (hu : UnitLinks n u) (hv : UnitLinks n v)
    (hwu : holonomy n u = -1) (hwv : holonomy n v = 1) :
    ¬ ∃ W : Matrix (ZMod n) (ZMod n) ℂ, W ∈ Matrix.unitaryGroup (ZMod n) ℂ ∧
      W * HRing n u * Wᴴ = HRing n v := by
  apply not_unitarily_conjugate_of_holonomy_re_ne n hodd hn u v hu hv;
  norm_num [ hwu, hwv ]

end PhysicsSM.Draft.NullEdge.RingHolonomySpectrumN
