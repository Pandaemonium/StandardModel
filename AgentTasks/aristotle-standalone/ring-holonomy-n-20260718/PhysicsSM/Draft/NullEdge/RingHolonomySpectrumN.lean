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

/-- The ring Hamiltonian is Hermitian by construction. -/
theorem HRing_isHermitian (n : ℕ) [NeZero n] (hn : 2 < n) (u : ZMod n → ℂ) :
    (HRing n u).IsHermitian := by
  sorry

/-- Site-wise gauge transformation of the link field. -/
def gaugedLinks (n : ℕ) [NeZero n] (g u : ZMod n → ℂ) : ZMod n → ℂ :=
  fun i => g i * u i * starRingEnd ℂ (g (i + 1))

/-- Gauge conjugacy: gauging the links conjugates the Hamiltonian by the
diagonal phase matrix. -/
theorem HRing_gauge_conjugacy (n : ℕ) [NeZero n] (hn : 2 < n)
    (g u : ZMod n → ℂ) (hg : ∀ i, g i * starRingEnd ℂ (g i) = 1) :
    HRing n (gaugedLinks n g u) =
      Matrix.diagonal g * HRing n u * (Matrix.diagonal g)ᴴ := by
  sorry

/-- The holonomy is gauge-invariant. -/
theorem holonomy_gauge_invariant (n : ℕ) [NeZero n]
    (g u : ZMod n → ℂ) (hg : ∀ i, g i * starRingEnd ℂ (g i) = 1) :
    holonomy n (gaugedLinks n g u) = holonomy n u := by
  sorry

/-- **Main target: the odd-`n` trace-power holonomy formula.**  For odd
`n > 2` and unit links, the trace of the `n`-th power of the ring
Hamiltonian is `n` times twice the real part of the holonomy.  (Parity:
a closed length-`n` walk on the `n`-cycle with steps `±1` has net
displacement `≡ n (mod 2)`, so for odd `n` every contributing walk winds
exactly once, forward or backward.) -/
theorem trace_pow_odd (n : ℕ) [NeZero n] (hodd : Odd n) (hn : 2 < n)
    (u : ZMod n → ℂ) (hu : UnitLinks n u) :
    ((HRing n u) ^ n).trace =
      (n : ℂ) * (holonomy n u + starRingEnd ℂ (holonomy n u)) := by
  sorry

/-- **Spectral discriminator at every odd `n`.**  Unit-link ring
Hamiltonians with different holonomy real parts are not unitarily
conjugate. -/
theorem not_unitarily_conjugate_of_holonomy_re_ne (n : ℕ) [NeZero n]
    (hodd : Odd n) (hn : 2 < n) (u v : ZMod n → ℂ)
    (hu : UnitLinks n u) (hv : UnitLinks n v)
    (hre : (holonomy n u).re ≠ (holonomy n v).re) :
    ¬ ∃ W : Matrix (ZMod n) (ZMod n) ℂ, W ∈ Matrix.unitaryGroup (ZMod n) ℂ ∧
      W * HRing n u * Wᴴ = HRing n v := by
  sorry

/-- Winding-one bridge corollary: at every odd `n > 2`, a `-1`-holonomy
unit-link ring (the half-link image of total turning `2π`) is not unitarily
conjugate to the trivial `+1`-holonomy ring. -/
theorem winding_one_not_conjugate_trivial (n : ℕ) [NeZero n]
    (hodd : Odd n) (hn : 2 < n) (u v : ZMod n → ℂ)
    (hu : UnitLinks n u) (hv : UnitLinks n v)
    (hwu : holonomy n u = -1) (hwv : holonomy n v = 1) :
    ¬ ∃ W : Matrix (ZMod n) (ZMod n) ℂ, W ∈ Matrix.unitaryGroup (ZMod n) ℂ ∧
      W * HRing n u * Wᴴ = HRing n v := by
  sorry

end PhysicsSM.Draft.NullEdge.RingHolonomySpectrumN
