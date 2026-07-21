import PhysicsSM.Draft.NullEdge.CompositionCl10Probe

/-!
# The triality seed `rho3` on the XOR-basis octonions (P5 stage C opening)

**Status: DRAFT probe module** (design: the P5 grounding note, stage-C
section; lit source: Gresnigt 2601.07857 - the family `S_3` is the
sedenion-automorphism/triality discrete group, order-3 generator + order-2
generator, acting on the octonion basis and trivially on the weak factor).

The order-3 candidate on OUR XOR-basis convention is INDEX DOUBLING
`i -> 2i mod 7`: `e1 -> e2 -> e4 -> e1`, `e3 -> e6 -> e5 -> e3`, `1` and
`e7` fixed. Probes (kernel decides; the automorphism property is
Fano-orientation-sensitive and may need a sign-twisted variant - a
refutation with a displayed sign pattern is the pre-registered outcome to
record, not force):

1. `rho3o_cube`: the map has order three (free `x`).
2. `rho3o_mul`: multiplicativity `rho3 (x y) = (rho3 x)(rho3 y)` (free
   `x, y` - the automorphism claim).
3. Head-plane fixing: `c0`/`c7` are fixed, so the idempotents `vIdem`,
   `vIdemStar` are fixed (the family action preserves the vacuum).
4. Colour-ladder permutation discovery: `rho3c (alpha1 * z)` against
   `alpha_j * rho3c z` candidates.

Interpretation discipline (pre-registered): on this single-generation
carrier `rho3` permutes the COLOUR pairs; the Gresnigt generation reading
lives in the Cl(8) re-packaging - kernel facts first, bridge question
recorded in the P5 note.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.OctonionTrialitySeed

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Algebra.Octonion.ComplexOctonion
open PhysicsSM.Algebra.Furey.LadderOperators
open PhysicsSM.Draft.NullEdge.DixonWeakCARTau3 (vIdem vIdemStar)

set_option maxHeartbeats 64000000

/-- Index doubling `i -> 2i mod 7` on the XOR-basis octonions:
`(rho3 x)` has the coefficient of `e_{2i}` equal to `x`'s coefficient of
`e_i` (`1`, `e7` fixed). -/
def rho3o (x : Octonion) : Octonion :=
  ⟨x.c0, x.c4, x.c1, x.c5, x.c2, x.c6, x.c3, x.c7⟩

/-- **`rho3` has order three** (free `x`). -/
theorem rho3o_cube (x : Octonion) : rho3o (rho3o (rho3o x)) = x := rfl

/-- **Probe: multiplicativity on our Fano orientation** (free `x y`). A
refutation displays the sign pattern for the twisted variant. -/
theorem rho3o_mul (x y : Octonion) :
    rho3o (x * y) = rho3o x * rho3o y := by
  ext <;> simp [rho3o] <;> ring

/-- The complexified triality seed (coordinatewise on `re`/`im`). -/
def rho3c (z : ComplexOctonion) : ComplexOctonion :=
  ⟨rho3o z.re, rho3o z.im⟩

/-- The family action fixes the weak vacuum `vIdem`. -/
theorem rho3c_vIdem : rho3c vIdem = vIdem := rfl

/-- ... and the conjugate idempotent. -/
theorem rho3c_vIdemStar : rho3c vIdemStar = vIdemStar := rfl

/-- The complexified seed is multiplicative (from `rho3o_mul` and the
coordinatewise definition). -/
theorem rho3c_mul (x y : ComplexOctonion) :
    rho3c (x * y) = rho3c x * rho3c y := by
  ext <;>
    simp [rho3c, rho3o, ComplexOctonion.mul_re,
      ComplexOctonion.mul_im] <;> ring

/-- **The triality seed acts on the colour ladders as a PHASED 3-cycle:**
`rho3(alpha_1) = -i alpha_2`. (With multiplicativity this determines the
conjugation action on every ladder composite.) -/
theorem rho3c_alpha1 : rho3c alpha1 = -(Complex.I • alpha2) := by
  ext <;> simp [rho3c, rho3o, alpha1, alpha2] <;> norm_num

/-- `rho3(alpha_2) = alpha_3` (phase-free leg). -/
theorem rho3c_alpha2 : rho3c alpha2 = alpha3 := by
  ext <;> simp [rho3c, rho3o, alpha2, alpha3] <;> norm_num

/-- `rho3(alpha_3) = i alpha_1` (closing phase; cube = identity). -/
theorem rho3c_alpha3 : rho3c alpha3 = Complex.I • alpha1 := by
  ext <;> simp [rho3c, rho3o, alpha3, alpha1] <;> norm_num

/-! ## The order-2 companion `sigma`: the S3 completion

Search result (oracle: exhaustive sign search over the XOR table, recorded
in the task ledger): the bit-swap collineation `(12)(56)` admits exactly two
sign vectors making it an octonion automorphism satisfying BOTH the braid
relation `sigma rho3 = rho3^2 sigma` and `sigma^2 = id`. We land the
VACUUM-FIXING one (`e7 -> +e7`):
`sigma(e1) = -e2, sigma(e2) = -e1, sigma(e3) = -e3, sigma(e4) = -e4,
 sigma(e5) = -e6, sigma(e6) = -e5, sigma(e7) = e7`.
(The other solution flips `e7`, i.e. swaps the idempotents - the
vacuum-conjugating variant; noted, not landed.) Together with `rho3` this
generates an `S_3` of automorphisms fixing the head plane and permuting the
colour ladders with phases - the family-symmetry seed in full. -/

/-- The signed bit-swap `sigma`: order-2 companion of the triality seed. -/
def sigmao (x : Octonion) : Octonion :=
  ⟨x.c0, -x.c2, -x.c1, -x.c3, -x.c4, -x.c6, -x.c5, x.c7⟩

theorem sigmao_sq (x : Octonion) : sigmao (sigmao x) = x := by
  ext <;> simp [sigmao]

/-- **`sigma` is an automorphism** (free `x y`; sign-twisted bit swap). -/
theorem sigmao_mul (x y : Octonion) :
    sigmao (x * y) = sigmao x * sigmao y := by
  ext <;> simp [sigmao] <;> ring

/-- **The braid relation** `sigma rho3 = rho3^2 sigma` - together with
`rho3o_cube` and `sigmao_sq` this exhibits the full `S_3`. -/
theorem sigma_rho3_braid (x : Octonion) :
    sigmao (rho3o x) = rho3o (rho3o (sigmao x)) := by
  ext <;> simp [sigmao, rho3o]

/-- The complexified companion. -/
def sigmac (z : ComplexOctonion) : ComplexOctonion :=
  ⟨sigmao z.re, sigmao z.im⟩

/-- `sigma` fixes the weak vacuum (vacuum-fixing solution chosen). -/
theorem sigmac_vIdem : sigmac vIdem = vIdem := by
  ext <;> simp [sigmac, sigmao, PhysicsSM.Draft.NullEdge.DixonWeakCARTau3.vIdem]

/-- **`sigma` acts on the colour ladders as the signed transposition**
`alpha_1 -> -alpha_1`. -/
theorem sigmac_alpha1 : sigmac alpha1 = -alpha1 := by
  ext <;> simp [sigmac, sigmao, alpha1]

/-- `alpha_2 -> -alpha_3`. -/
theorem sigmac_alpha2 : sigmac alpha2 = -alpha3 := by
  ext <;> simp [sigmac, sigmao, alpha2, alpha3]

/-- `alpha_3 -> -alpha_2` (transposition closes). -/
theorem sigmac_alpha3 : sigmac alpha3 = -alpha2 := by
  ext <;> simp [sigmac, sigmao, alpha3, alpha2]

/-- info: 'PhysicsSM.Draft.NullEdge.OctonionTrialitySeed.sigmao_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.OctonionTrialitySeed.sigmao_mul

/-- info: 'PhysicsSM.Draft.NullEdge.OctonionTrialitySeed.sigma_rho3_braid' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.OctonionTrialitySeed.sigma_rho3_braid

/-- info: 'PhysicsSM.Draft.NullEdge.OctonionTrialitySeed.rho3o_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.OctonionTrialitySeed.rho3o_mul

/-- info: 'PhysicsSM.Draft.NullEdge.OctonionTrialitySeed.rho3c_alpha1' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.OctonionTrialitySeed.rho3c_alpha1

end PhysicsSM.Draft.NullEdge.OctonionTrialitySeed
