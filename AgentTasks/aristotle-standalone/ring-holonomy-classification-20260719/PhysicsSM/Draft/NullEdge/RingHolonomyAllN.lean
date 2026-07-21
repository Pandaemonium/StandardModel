import PhysicsSM.Draft.NullEdge.RingHolonomyHalfLinkN

/-!
# Ring-holonomy spectral witness at EVERY length: dropping the parity hypothesis

Target statements for the Aristotle job `ring-holonomy-alln-20260719`.

Context.  The landed chain (`RingHolonomySpectrumN`, `RingHolonomyHalfLinkN`)
proves the trace-power holonomy formula, the spectral discriminator, and the
composed half-link witness at every ODD ring length `n > 2`.  The odd
hypothesis entered ONLY through the trace formula: for odd `n` no closed
length-`n` walk is balanced, so `trace (H^n) = n (w + conj w)` exactly.

For EVEN `n` the balanced walks contribute a holonomy-INDEPENDENT
combinatorial constant.  Key collapse: with unit links the hops satisfy
`F * B = B * F = 1` (landed: `forward_backward_mul`, `backward_forward_mul`),
so in the binomial expansion `(F + B)^n = ∑ C(n,k) • F^k B^(n-k)` each term
telescopes to a pure power `F^(2k-n)` (or `B^(n-2k)`), whose trace vanishes
unless the exponent is `0` or `n`.  Hence for even `n`:

  `trace (H^n) = n * C(n, n/2) + n * (w + conj w)`.

The constant cancels in any trace comparison, so the spectral discriminator
- and therefore the composed half-link witness, whose holonomy input
`holonomy_halfLinkField` is already parity-free - holds at EVERY `n > 2`.
This removes the parity hypothesis from the Paper A chain end-to-end.

Conventions: exactly those of `RingHolonomySpectrumN` (directed ring,
`HRing = forwardHop + backwardHop`, holonomy = product of link phases).
Every `s o r r y` below is a documented Aristotle handoff hole.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.RingHolonomyAllN

open PhysicsSM.Draft.NullEdge.RingHolonomySpectrumN
open PhysicsSM.Draft.NullEdge.RingHolonomyHalfLinkN

/-
Powers of the forward hop below the ring length are traceless (the
shifted diagonal never returns: `i = i + m` in `ZMod n` forces `n ∣ m`).
-/
theorem trace_forwardHop_pow_of_lt (n m : ℕ) [NeZero n] (u : ZMod n → ℂ)
    (hm0 : 0 < m) (hmn : m < n) :
    ((forwardHop n u) ^ m).trace = 0 := by
  -- By definition of `forwardHop`, we know that its `m`-th power has a specific form.
  have h_forwardHop_pow : ∀ m : ℕ, ∀ i j : ZMod n, ((forwardHop n u) ^ m) i j = if j = i + m then (∏ k ∈ Finset.range m, u (i + k)) else 0 := by
    intro m i j; induction' m with m ih generalizing i j <;> simp_all +decide [ pow_succ, Matrix.mul_apply ] ;
    · simp +decide [ Matrix.one_apply, eq_comm ];
    · unfold forwardHop; simp +decide [ Finset.prod_range_succ, add_assoc ] ;
  simp_all +decide [ Matrix.trace ];
  exact fun h => absurd h ( by rw [ ZMod.natCast_eq_zero_iff ] ; exact Nat.not_dvd_of_pos_of_lt hm0 hmn )

/-
Powers of the backward hop below the ring length are traceless.
-/
theorem trace_backwardHop_pow_of_lt (n m : ℕ) [NeZero n] (u : ZMod n → ℂ)
    (hm0 : 0 < m) (hmn : m < n) :
    ((backwardHop n u) ^ m).trace = 0 := by
  -- By definition of $backwardHop$, we know that its entries are zero except when $i = j + 1$.
  have h_backwardHop_entries : ∀ m : ℕ, ∀ i j : ZMod n, (backwardHop n u ^ m) i j = if i = j + m then (∏ k ∈ Finset.range m, (starRingEnd ℂ) (u (j + k))) else 0 := by
    intro m i j; induction' m with m ih generalizing i j <;> simp_all +decide [ pow_succ, Matrix.mul_apply ] ;
    · simp +decide [ Matrix.one_apply ];
    · simp +decide [ ← add_assoc, Finset.sum_ite, Finset.filter_eq', Finset.filter_ne', backwardHop ];
      simp +decide [ add_comm, add_left_comm, add_assoc, Finset.prod_range_succ' ];
  simp_all +decide [ Matrix.trace ];
  rw [ ZMod.natCast_eq_zero_iff ] ; exact fun h => absurd h ( Nat.not_dvd_of_pos_of_lt hm0 hmn )

/-
**Even-`n` trace-power holonomy formula.**  For even `n > 2` and unit
links, the balanced walks contribute the combinatorial constant
`n * C(n, n/2)` and the winding walks contribute `n * (w + conj w)`.
-/
set_option maxHeartbeats 3200000 in
theorem trace_pow_even (n : ℕ) [NeZero n] (heven : Even n) (hn : 2 < n)
    (u : ZMod n → ℂ) (hu : UnitLinks n u) :
    ((HRing n u) ^ n).trace =
      (n : ℂ) * (n.choose (n / 2) : ℂ)
        + (n : ℂ) * (holonomy n u + starRingEnd ℂ (holonomy n u)) := by
  -- By the binomial theorem, we can expand $(F + B)^n$ as $\sum_{k=0}^{n} \binom{n}{k} F^k B^{n-k}$.
  have h_binom : (HRing n u)^n = ∑ k ∈ Finset.range (n + 1), (Nat.choose n k : ℂ) • (forwardHop n u)^k * (backwardHop n u)^(n - k) := by
    rw [ show HRing n u = forwardHop n u + backwardHop n u from ?_ ];
    · have h_comm : Commute (forwardHop n u) (backwardHop n u) := by
        have := forward_backward_mul n u hu; have := backward_forward_mul n u hu; simp_all +decide [ Commute ] ;
        simp_all +decide [ SemiconjBy, mul_assoc ];
      rw [ h_comm.add_pow ];
      simp +decide [ mul_assoc, mul_comm, mul_left_comm, Algebra.smul_def ];
      simp +decide [ ← mul_assoc, ← Nat.cast_comm ];
    · exact HRing_eq_forward_add_backward n u;
  -- For each $k$, the term $\binom{n}{k} F^k B^{n-k}$ simplifies using $F B = B F = 1$.
  have h_simplify : ∀ k ∈ Finset.range (n + 1), (forwardHop n u)^k * (backwardHop n u)^(n - k) = if k ≤ n - k then (backwardHop n u)^(n - 2 * k) else (forwardHop n u)^(2 * k - n) := by
    intro k hk
    have h_comm : ∀ m : ℕ, (forwardHop n u)^m * (backwardHop n u)^m = 1 := by
      intro m; induction m <;> simp_all +decide [ pow_succ, ← mul_assoc ] ;
      simp_all +decide [ mul_assoc, mul_eq_one_comm ];
      simp_all +decide [ ← mul_assoc, backward_forward_mul ];
      simp_all +decide [ mul_assoc, ← pow_succ ];
      simp_all +decide [ pow_succ', ← mul_assoc, forward_backward_mul ];
    split_ifs;
    · rw [ show n - k = k + ( n - 2 * k ) by omega, pow_add ];
      simp +decide [ ← mul_assoc, h_comm ];
    · convert congr_arg ( fun x => forwardHop n u ^ ( k - ( n - k ) ) * x ) ( h_comm ( n - k ) ) using 1;
      · rw [ ← mul_assoc, ← pow_add, Nat.sub_add_cancel ( by linarith ) ];
      · grind;
  -- The trace of a matrix is the sum of its diagonal elements.
  have h_trace : ∀ k ∈ Finset.range (n + 1), Matrix.trace ((Nat.choose n k : ℂ) • (forwardHop n u)^k * (backwardHop n u)^(n - k)) = if k = n / 2 then (Nat.choose n (n / 2) : ℂ) * n else if k = 0 then (Nat.choose n 0 : ℂ) * n * starRingEnd ℂ (holonomy n u) else if k = n then (Nat.choose n n : ℂ) * n * holonomy n u else 0 := by
    intro k hk; split_ifs <;> simp_all +decide [ mul_assoc, mul_comm, mul_left_comm ] ;
    · rw [ if_pos ];
      · rw [ show n - 2 * ( n / 2 ) = 0 by rw [ Nat.sub_eq_zero_of_le ] ; linarith [ Nat.div_mul_cancel ( even_iff_two_dvd.mp heven ) ] ] ; norm_num [ mul_comm ];
      · omega;
    · convert trace_backward_pow_length n u using 1;
    · convert trace_forward_pow_length n u using 1;
    · split_ifs <;> simp_all +decide [ mul_comm ];
      · exact Or.inr ( trace_backwardHop_pow_of_lt n ( n - k * 2 ) u ( Nat.sub_pos_of_lt ( by omega ) ) ( by omega ) );
      · exact Or.inr ( trace_forwardHop_pow_of_lt n ( k * 2 - n ) u ( Nat.sub_pos_of_lt ( by omega ) ) ( by omega ) );
  convert Finset.sum_congr rfl h_trace using 1;
  · rw [ h_binom, Matrix.trace_sum ];
  · norm_num [ Finset.sum_ite, Finset.filter_eq', Finset.filter_ne' ];
    rw [ if_pos ( Nat.div_le_self _ _ ), if_neg ( by linarith [ Nat.div_mul_cancel ( even_iff_two_dvd.mp heven ) ] ), if_pos ( by omega ) ] ; norm_num ; ring

/-- **Spectral discriminator at every even `n`.**  The combinatorial
constant is holonomy-independent, so it cancels in the trace comparison. -/
theorem not_unitarily_conjugate_of_holonomy_re_ne_even (n : ℕ) [NeZero n]
    (heven : Even n) (hn : 2 < n) (u v : ZMod n → ℂ)
    (hu : UnitLinks n u) (hv : UnitLinks n v)
    (hre : (holonomy n u).re ≠ (holonomy n v).re) :
    ¬ ∃ W : Matrix (ZMod n) (ZMod n) ℂ, W ∈ Matrix.unitaryGroup (ZMod n) ℂ ∧
      W * HRing n u * Wᴴ = HRing n v := by
  -- Mirror of the landed odd-case discriminator proof
  -- (`RingHolonomySpectrumN.not_unitarily_conjugate_of_holonomy_re_ne`),
  -- with `trace_pow_even` in place of `trace_pow_odd`; the combinatorial
  -- constant appears on both sides of the trace equation and cancels.
  contrapose! hre; simp_all +decide [ Matrix.mem_unitaryGroup_iff ] ;
  obtain ⟨W, hW_unitary, hW_conj⟩ := hre
  have hW_inv : Wᴴ * W = 1 := by
    convert mul_eq_one_comm.mp hW_unitary using 1;
  have h_pow_conj : (HRing n v) ^ n = W * (HRing n u) ^ n * Wᴴ := by
    have h_pow : ∀ k : ℕ, (HRing n v) ^ k = W * (HRing n u) ^ k * Wᴴ := by
      intro k; induction k <;> simp_all +decide [ pow_succ, mul_assoc ] ;
      · convert hW_unitary.symm using 1;
      · simp +decide [ ← hW_conj, ← mul_assoc, hW_inv ];
    exact h_pow n;
  have h_trace_eq : (HRing n v ^ n).trace = (HRing n u ^ n).trace := by
    rw [ h_pow_conj, Matrix.trace_mul_comm ];
    rw [ ← Matrix.mul_assoc, hW_inv, Matrix.one_mul ];
  rw [ trace_pow_even n heven hn u hu, trace_pow_even n heven hn v hv ] at h_trace_eq;
  simp_all +decide [ Complex.ext_iff, NeZero.ne ];
  linarith

/-- **Spectral discriminator at EVERY `n > 2` - the parity hypothesis is
gone.**  Composes the landed odd case with the new even case. -/
theorem not_unitarily_conjugate_of_holonomy_re_ne_all (n : ℕ) [NeZero n]
    (hn : 2 < n) (u v : ZMod n → ℂ)
    (hu : UnitLinks n u) (hv : UnitLinks n v)
    (hre : (holonomy n u).re ≠ (holonomy n v).re) :
    ¬ ∃ W : Matrix (ZMod n) (ZMod n) ℂ, W ∈ Matrix.unitaryGroup (ZMod n) ℂ ∧
      W * HRing n u * Wᴴ = HRing n v := by
  rcases Nat.even_or_odd n with heven | hodd
  · exact not_unitarily_conjugate_of_holonomy_re_ne_even n heven hn u v hu hv hre
  · exact not_unitarily_conjugate_of_holonomy_re_ne n hodd hn u v hu hv hre

/-- **Composed half-link spectral witness at EVERY length `n > 2`.**  Total
turning `2π` (holonomy `-1`, parity-free by `holonomy_halfLinkField`) is not
unitarily conjugate to the trivial ring - at every ring length. -/
theorem halfLink_ring_not_conjugate_trivial_all (n : ℕ) [NeZero n]
    (hn : 2 < n) (delta : ZMod n → ℝ)
    (hsum : ∑ p, delta p = 2 * Real.pi) :
    ¬ ∃ W : Matrix (ZMod n) (ZMod n) ℂ, W ∈ Matrix.unitaryGroup (ZMod n) ℂ ∧
      W * HRing n (halfLinkField n delta) * Wᴴ = HRing n (fun _ => 1) := by
  -- Mirror of the landed odd-case composition
  -- (`RingHolonomyHalfLinkN.halfLink_ring_not_conjugate_trivial`), fed by
  -- the all-`n` discriminator: turning `2π` gives holonomy `-1` with real
  -- part `-1 ≠ 1`, the real part of the trivial ring's holonomy.
  apply not_unitarily_conjugate_of_holonomy_re_ne_all n hn
    (halfLinkField n delta) (fun _ => 1)
    (unitLinks_halfLinkField n delta) (fun _ => by norm_num)
  rw [ holonomy_halfLinkField n delta hsum ]
  unfold holonomy
  norm_num

end PhysicsSM.Draft.NullEdge.RingHolonomyAllN
